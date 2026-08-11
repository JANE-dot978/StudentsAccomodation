require('dotenv').config();
const express = require('express');
const admin = require('firebase-admin');
const axios = require('axios');
const fs = require('fs');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 8080;

// ---- VERY IMPORTANT ----
// Safaricom sends JSON. If this is wrong, callback never works.
app.use(express.json());
app.use(express.urlencoded({ extended: false }));

// ================= ENHANCED CORS =================
app.use(cors({
  origin: '*', // Allow all origins for development
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Accept', 'Authorization', 'ngrok-skip-browser-warning'],
  credentials: false
}));

// Handle preflight OPTIONS requests
app.options('*', cors());

// ================= MPESA CONFIG =================
const MPESA_CONSUMER_KEY = process.env.MPESA_CONSUMER_KEY;
const MPESA_CONSUMER_SECRET = process.env.MPESA_CONSUMER_SECRET;
const MPESA_SHORTCODE = process.env.MPESA_SHORTCODE;
const MPESA_PASSKEY = process.env.MPESA_PASSKEY;
const MPESA_ENV = process.env.MPESA_ENV || 'sandbox';
const CALLBACK_URL = process.env.CALLBACK_URL;

const MPESA_BASE_URL =
  MPESA_ENV === 'production'
    ? 'https://api.safaricom.co.ke'
    : 'https://sandbox.safaricom.co.ke';

// ================= FIREBASE =================
const SERVICE_ACCOUNT_PATH = process.env.SERVICE_ACCOUNT_PATH || './serviceAccountKey.json';

if (fs.existsSync(SERVICE_ACCOUNT_PATH)) {
  const serviceAccount = require(SERVICE_ACCOUNT_PATH);
  admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
  console.log('🔥 Firebase initialized');
} else {
  console.log('⚠️ serviceAccountKey.json missing');
  process.exit(1);
}

const db = admin.firestore();

// ================= UTILITIES =================

// Safaricom requires Nairobi time, not ISO
function getTimestamp() {
  const now = new Date();

  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  const day = String(now.getDate()).padStart(2, '0');
  const hours = String(now.getHours()).padStart(2, '0');
  const minutes = String(now.getMinutes()).padStart(2, '0');
  const seconds = String(now.getSeconds()).padStart(2, '0');

  return `${year}${month}${day}${hours}${minutes}${seconds}`;
}

function formatPhone(phone) {
  phone = phone.replace(/\s+/g, '');

  if (phone.startsWith('+254')) return phone.substring(1);
  if (phone.startsWith('254')) return phone;
  if (phone.startsWith('07')) return '254' + phone.substring(1);
  if (phone.startsWith('01')) return '254' + phone.substring(1);

  throw new Error('Invalid Kenyan phone number');
}

// ================= ACCESS TOKEN =================
async function getAccessToken() {
  try {
    const auth = Buffer.from(`${MPESA_CONSUMER_KEY}:${MPESA_CONSUMER_SECRET}`).toString('base64');

    const res = await axios.get(
      `${MPESA_BASE_URL}/oauth/v1/generate?grant_type=client_credentials`,
      { headers: { Authorization: `Basic ${auth}` } }
    );

    return res.data.access_token;
  } catch (error) {
    console.error('❌ Token generation failed:', error.response?.data || error.message);
    throw new Error('Failed to get MPesa access token');
  }
}

// ================= HEALTH CHECK =================
app.get('/', (req, res) => {
  res.json({ 
    ok: true, 
    status: 'Server is running',
    timestamp: new Date().toISOString(),
    environment: MPESA_ENV
  });
});

// ================= STK PUSH =================
app.post('/mpesa/initiate-payment', async (req, res) => {
  try {
    const { bookingId, phoneNumber, amount } = req.body;

    // Validation
    if (!bookingId || !phoneNumber || !amount) {
      return res.status(400).json({ 
        success: false,
        error: 'Missing required fields: bookingId, phoneNumber, amount' 
      });
    }

    console.log('📥 Payment request received:', { bookingId, phoneNumber, amount });

    const token = await getAccessToken();

    const timestamp = getTimestamp();
    const password = Buffer.from(`${MPESA_SHORTCODE}${MPESA_PASSKEY}${timestamp}`).toString('base64');
    const phone = formatPhone(phoneNumber);

    const payload = {
      BusinessShortCode: MPESA_SHORTCODE,
      Password: password,
      Timestamp: timestamp,
      TransactionType: 'CustomerPayBillOnline',
      Amount: Number(amount),
      PartyA: phone,
      PartyB: MPESA_SHORTCODE,
      PhoneNumber: phone,
      CallBackURL: CALLBACK_URL,
      AccountReference: bookingId,
      TransactionDesc: 'Hostel Booking Payment',
    };

    console.log('📤 Sending STK Push to Safaricom...');

    const response = await axios.post(
      `${MPESA_BASE_URL}/mpesa/stkpush/v1/processrequest`,
      payload,
      { headers: { Authorization: `Bearer ${token}` } }
    );

    console.log('📥 Safaricom Response:', response.data);

    // Save payment request to Firestore
    await db.collection('paymentRequests').add({
      bookingId,
      phone,
      amount,
      checkoutRequestId: response.data.CheckoutRequestID,
      merchantRequestId: response.data.MerchantRequestID,
      status: 'pending',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    // ✅ Return normalized response for Flutter
    res.json({
      success: true,
      checkoutRequestId: response.data.CheckoutRequestID,
      merchantRequestId: response.data.MerchantRequestID,
      responseCode: response.data.ResponseCode,
      responseDescription: response.data.ResponseDescription,
      customerMessage: response.data.CustomerMessage,
      message: 'STK push sent successfully. Check your phone.'
    });

  } catch (err) {
    console.error('❌ STK ERROR:', err.response?.data || err.message);
    res.status(500).json({ 
      success: false,
      error: 'STK push failed', 
      details: err.response?.data || err.message 
    });
  }
});

// ================= CALLBACK =================
app.post('/mpesa/callback', async (req, res) => {
  console.log('📩 MPESA CALLBACK RECEIVED');
  console.log(JSON.stringify(req.body, null, 2));

  try {
    const stk = req.body.Body.stkCallback;
    const resultCode = stk.ResultCode;
    const checkoutRequestId = stk.CheckoutRequestID;

    const query = await db
      .collection('paymentRequests')
      .where('checkoutRequestId', '==', checkoutRequestId)
      .get();

    if (query.empty) {
      console.log('⚠️ No matching payment request found');
      return res.json({ ok: true });
    }

    const doc = query.docs[0];
    const paymentData = doc.data();

    if (resultCode !== 0) {
      // Payment failed
      await doc.ref.update({ 
        status: 'failed',
        resultCode,
        resultDescription: stk.ResultDesc,
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      
      console.log('❌ PAYMENT FAILED:', stk.ResultDesc);
      
      // Update booking status
      if (paymentData.bookingId) {
        await db.collection('bookings').doc(paymentData.bookingId).update({
          paymentStatus: 'failed',
          updatedAt: admin.firestore.FieldValue.serverTimestamp()
        });
      }
      
      return res.json({ ok: true });
    }

    // Payment successful
    const metadata = stk.CallbackMetadata.Item;
    const mpesaCode = metadata.find(i => i.Name === 'MpesaReceiptNumber')?.Value;
    const amountPaid = metadata.find(i => i.Name === 'Amount')?.Value;
    const phoneNumber = metadata.find(i => i.Name === 'PhoneNumber')?.Value;

    // Update payment request
    await doc.ref.update({
      status: 'paid',
      mpesaReceiptNumber: mpesaCode,
      amountPaid,
      phoneNumber,
      paidAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log('✅ PAYMENT SUCCESS:', mpesaCode);

    // Update booking status
    if (paymentData.bookingId) {
      await db.collection('bookings').doc(paymentData.bookingId).update({
        isPaid: true,
        paymentStatus: 'completed',
        mpesaReceiptNumber: mpesaCode,
        paidAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp()
      });
      
      console.log('✅ Booking updated:', paymentData.bookingId);
    }

    res.json({ ok: true });
  } catch (err) {
    console.error('❌ Callback error:', err);
    res.json({ ok: true }); // Always return 200 to Safaricom
  }
});

// ================= CHECK PAYMENT STATUS =================
app.post('/mpesa/check-payment-status', async (req, res) => {
  try {
    const { checkoutRequestId } = req.body;

    if (!checkoutRequestId) {
      return res.status(400).json({ 
        success: false,
        error: 'checkoutRequestId is required' 
      });
    }

    const query = await db
      .collection('paymentRequests')
      .where('checkoutRequestId', '==', checkoutRequestId)
      .limit(1)
      .get();

    if (query.empty) {
      return res.status(404).json({ 
        success: false,
        error: 'Payment request not found' 
      });
    }

    const paymentData = query.docs[0].data();
    
    res.json({
      success: true,
      status: paymentData.status,
      mpesaReceiptNumber: paymentData.mpesaReceiptNumber || null,
      amount: paymentData.amount,
      phoneNumber: paymentData.phone,
      paidAt: paymentData.paidAt || null
    });

  } catch (err) {
    console.error('❌ Status check error:', err);
    res.status(500).json({ 
      success: false,
      error: 'Failed to check payment status' 
    });
  }
});

// ================= ERROR HANDLER =================
app.use((err, req, res, next) => {
  console.error('❌ Unhandled error:', err);
  res.status(500).json({ 
    success: false,
    error: 'Internal server error',
    message: err.message 
  });
});

// ================= START SERVER =================
app.listen(PORT, '0.0.0.0', () => {
  console.log('═══════════════════════════════════════');
  console.log('🚀 Server running on port', PORT);
  console.log('🌍 Environment:', MPESA_ENV);
  console.log('📞 Callback URL:', CALLBACK_URL);
  console.log('═══════════════════════════════════════');
});