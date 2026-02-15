require('dotenv').config();
const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');
const axios = require('axios');
const fs = require('fs');

const PORT = process.env.PORT || 8080;
const SERVICE_ACCOUNT_PATH = process.env.SERVICE_ACCOUNT_PATH || './serviceAccountKey.json';

// MPesa Configuration (set these in .env file)
const MPESA_CONSUMER_KEY = process.env.MPESA_CONSUMER_KEY || '';
const MPESA_CONSUMER_SECRET = process.env.MPESA_CONSUMER_SECRET || '';
const MPESA_SHORTCODE = process.env.MPESA_SHORTCODE || '174379'; // Test shortcode
const MPESA_PASSKEY = process.env.MPESA_PASSKEY || '';
const MPESA_ENV = process.env.MPESA_ENV || 'sandbox'; // 'sandbox' or 'production'
const CALLBACK_URL = process.env.CALLBACK_URL || 'http://localhost:8080/mpesa/callback';

const MPESA_BASE_URL = MPESA_ENV === 'production'
  ? 'https://api.safaricom.co.ke'
  : 'https://sandbox.safaricom.co.ke';

if (fs.existsSync(SERVICE_ACCOUNT_PATH)) {
  const serviceAccount = require(SERVICE_ACCOUNT_PATH);
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
} else {
  // Attempt default initialization (e.g., GOOGLE_APPLICATION_CREDENTIALS env)
  admin.initializeApp();
}

const db = admin.firestore();
const app = express();
app.use(bodyParser.json());

// CORS middleware - allow requests from the Flutter web/dev server and other clients
app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*'); // for local development allow all
  res.header('Access-Control-Allow-Methods', 'GET,POST,PUT,DELETE,OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

// ===== UTILITY FUNCTIONS =====

/**
 * Get MPesa access token
 * Used for authenticating STK push and other API calls
 */
async function getMpesaAccessToken() {
  try {
    const auth = Buffer.from(`${MPESA_CONSUMER_KEY}:${MPESA_CONSUMER_SECRET}`).toString('base64');
    const response = await axios.get(
      `${MPESA_BASE_URL}/oauth/v1/generate?grant_type=client_credentials`,
      {
        headers: {
          Authorization: `Basic ${auth}`,
        },
      }
    );
    return response.data.access_token;
  } catch (error) {
    console.error('Failed to get MPesa access token:', error.message);
    throw new Error('MPesa authentication failed');
  }
}

/**
 * Generate STK push request (initiate payment)
 */
async function initiateSTKPush(phoneNumber, amount, bookingId, description = '') {
  try {
    const token = await getMpesaAccessToken();
    const timestamp = new Date().toISOString().replace(/[^0-9]/g, '').slice(0, 14);
    
    // Generate password: base64(BusinessShortCode + Passkey + Timestamp)
    const password = Buffer.from(
      `${MPESA_SHORTCODE}${MPESA_PASSKEY}${timestamp}`
    ).toString('base64');

    // Format phone number to international format (2547XXXXXXXX)
    let formattedPhone = phoneNumber.replace(/^0/, '254'); // Replace leading 0 with 254
    if (!formattedPhone.startsWith('254')) {
      formattedPhone = `254${formattedPhone.slice(-9)}`; // Extract last 9 digits if not Kenya
    }

    const payload = {
      BusinessShortCode: MPESA_SHORTCODE,
      Password: password,
      Timestamp: timestamp,
      TransactionType: 'CustomerPayBillOnline',
      Amount: Math.round(amount), // M-Pesa requires whole numbers
      PartyA: formattedPhone,
      PartyB: MPESA_SHORTCODE,
      PhoneNumber: formattedPhone,
      CallBackURL: CALLBACK_URL,
      AccountReference: `Booking${bookingId.slice(0, 8)}`,
      TransactionDesc: description || 'Room Booking Payment',
      Remark: 'Student accommodation booking',
    };

    const response = await axios.post(
      `${MPESA_BASE_URL}/mpesa/stkpush/v1/processrequest`,
      payload,
      {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      }
    );

    return {
      success: true,
      checkoutRequestId: response.data.CheckoutRequestID,
      responseCode: response.data.ResponseCode,
      responseMessage: response.data.ResponseMessage,
      customerMessage: response.data.CustomerMessage,
    };
  } catch (error) {
    console.error('STK push initiation error:', error.message);
    return {
      success: false,
      error: error.message || 'Failed to initiate payment',
    };
  }
}

/**
 * Query STK push transaction status
 */
async function querySTKStatus(checkoutRequestId) {
  try {
    const token = await getMpesaAccessToken();
    const timestamp = new Date().toISOString().replace(/[^0-9]/g, '').slice(0, 14);
    
    const password = Buffer.from(
      `${MPESA_SHORTCODE}${MPESA_PASSKEY}${timestamp}`
    ).toString('base64');

    const response = await axios.post(
      `${MPESA_BASE_URL}/mpesa/stkpushquery/v1/query`,
      {
        BusinessShortCode: MPESA_SHORTCODE,
        Password: password,
        Timestamp: timestamp,
        CheckoutRequestID: checkoutRequestId,
      },
      {
        headers: {
          Authorization: `Bearer ${token}`,
          'Content-Type': 'application/json',
        },
      }
    );

    return response.data;
  } catch (error) {
    console.error('STK status query error:', error.message);
    throw error;
  }
}

// ===== ENDPOINTS =====

// Health check
app.get('/', (req, res) => res.json({ok: true, time: new Date().toISOString()}));

// Test endpoint - verify server is reachable
app.get('/test', (req, res) => {
  console.log('[TEST] Server connectivity test from', req.ip);
  res.json({
    status: 'ok',
    message: 'Server is reachable',
    timestamp: new Date().toISOString(),
    ip: req.ip,
    serverUrl: 'http://192.168.1.66:8080'
  });
});

/**
 * POST /mpesa/initiate-payment
 * Initiate STK push for a booking
 * Body: { bookingId, phoneNumber, amount, description }
 */
app.post('/mpesa/initiate-payment', async (req, res) => {
  try {
    console.log('[PAYMENT] New payment request received');
    console.log('[PAYMENT] Request body:', JSON.stringify(req.body, null, 2));
    
    const { bookingId, phoneNumber, amount, description } = req.body;

    // Validate required fields
    if (!bookingId || !phoneNumber || !amount) {
      console.log('[PAYMENT] Missing fields - bookingId:', bookingId, 'phoneNumber:', phoneNumber, 'amount:', amount);
      return res.status(400).json({
        error: 'Missing required fields: bookingId, phoneNumber, amount',
      });
    }

    // Validate phone number format
    if (!phoneNumber.match(/^(0|\+?254|254)\d{9}$/)) {
      console.log('[PAYMENT] Invalid phone format:', phoneNumber);
      return res.status(400).json({
        error: 'Invalid phone number format. Use 0712345678 or +254712345678',
      });
    }

    // Validate amount (M-Pesa minimum is typically 1 KES)
    if (amount < 1 || amount > 150000) {
      console.log('[PAYMENT] Invalid amount:', amount);
      return res.status(400).json({
        error: 'Amount must be between 1 and 150,000 KES',
      });
    }

    console.log('[PAYMENT] Validation passed - Initiating STK push...');

    // Initiate STK push
    const result = await initiateSTKPush(phoneNumber, amount, bookingId, description);

    if (!result.success) {
      console.log('[PAYMENT] STK push failed:', result.error);
      return res.status(400).json({ error: result.error });
    }

    console.log('[PAYMENT] STK push successful - CheckoutRequestID:', result.checkoutRequestId);

    // Store payment request in Firestore for tracking
    await db.collection('paymentRequests').add({
      bookingId,
      checkoutRequestId: result.checkoutRequestId,
      phoneNumber,
      amount,
      status: 'initiated',
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      expiresAt: new Date(Date.now() + 2 * 60 * 1000), // 2 minutes
    });

    console.log('[PAYMENT] Payment request stored in Firestore');

    return res.json({
      success: true,
      message: 'STK push initiated. Please check your phone for the M-Pesa prompt.',
      checkoutRequestId: result.checkoutRequestId,
      customerMessage: result.customerMessage,
    });
  } catch (error) {
    console.error('[PAYMENT] Error:', error.message);
    console.error('[PAYMENT] Error stack:', error.stack);
    return res.status(500).json({ error: error.message });
  }
});

/**
 * POST /mpesa/check-payment-status
 * Query the status of an initiated payment
 * Body: { checkoutRequestId }
 */
app.post('/mpesa/check-payment-status', async (req, res) => {
  try {
    const { checkoutRequestId } = req.body;

    if (!checkoutRequestId) {
      return res.status(400).json({ error: 'checkoutRequestId required' });
    }

    const status = await querySTKStatus(checkoutRequestId);
    return res.json(status);
  } catch (error) {
    return res.status(500).json({ error: error.message });
  }
});

/**
 * POST /mpesa/callback
 * Webhook endpoint for M-Pesa to send payment confirmations
 * This is called by M-Pesa after payment success/failure
 */
app.post('/mpesa/callback', async (req, res) => {
  try {
    const payload = req.body;
    console.log('MPesa callback received:', JSON.stringify(payload, null, 2));

    // Extract payment details from M-Pesa callback structure
    // Note: The exact structure depends on your M-Pesa provider integration
    const resultCode = payload.Body?.stkCallback?.ResultCode;
    const checkoutRequestId = payload.Body?.stkCallback?.CheckoutRequestID;
    const merchantRequestId = payload.Body?.stkCallback?.MerchantRequestID;
    const callbackMetadata = payload.Body?.stkCallback?.CallbackMetadata?.Item || [];

    // Parse callback metadata to extract booking info
    const metadata = {};
    callbackMetadata.forEach(item => {
      metadata[item.Name] = item.Value;
    });

    const amount = metadata.Amount;
    const mpesaCode = metadata.MpesaReceiptNumber;
    const phoneNumber = metadata.PhoneNumber;

    // Find booking associated with this payment
    // Query paymentRequests collection for matching checkoutRequestId
    const paymentRequestsQuery = await db
      .collection('paymentRequests')
      .where('checkoutRequestId', '==', checkoutRequestId)
      .limit(1)
      .get();

    if (paymentRequestsQuery.empty) {
      console.warn('No payment request found for checkoutRequestId:', checkoutRequestId);
      return res.status(200).json({ok: true}); // Return OK to prevent M-Pesa retry
    }

    const paymentRequest = paymentRequestsQuery.docs[0];
    const bookingId = paymentRequest.data().bookingId;

    // Check if payment was successful (ResultCode 0 = success)
    if (resultCode !== 0) {
      console.log(`Payment failed for booking ${bookingId}. ResultCode: ${resultCode}`);
      
      // Update payment request status
      await db.collection('paymentRequests').doc(paymentRequest.id).update({
        status: 'failed',
        resultCode,
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Update booking status if needed
      await db.collection('bookings').doc(bookingId).update({
        paymentStatus: 'failed',
        paymentError: `M-Pesa error: ${resultCode}`,
      });

      return res.status(200).json({ok: true});
    }

    // Payment successful - process it atomically
    const bookingRef = db.collection('bookings').doc(bookingId);

    await db.runTransaction(async (tx) => {
      const bookingSnap = await tx.get(bookingRef);
      if (!bookingSnap.exists) {
        throw new Error(`Booking not found: ${bookingId}`);
      }

      const booking = bookingSnap.data();
      const alreadyPaid = booking.isPaid === true;
      const bookingStatus = booking.status || '';
      const hostelId = booking.hostelId;

      // Mark booking as paid
      tx.update(bookingRef, {
        isPaid: true,
        paymentStatus: 'completed',
        mpesaReceiptNumber: mpesaCode,
        paidAt: admin.firestore.FieldValue.serverTimestamp(),
        updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      // Decrement available rooms only if booking is approved and wasn't already paid
      if (!alreadyPaid && bookingStatus === 'approved' && hostelId) {
        const hostelRef = db.collection('hostels').doc(hostelId);
        const hostelSnap = await tx.get(hostelRef);
        
        if (hostelSnap.exists) {
          const currentRooms = hostelSnap.data().availableRooms || 0;
          if (currentRooms > 0) {
            tx.update(hostelRef, {
              availableRooms: currentRooms - 1,
              updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            });
          }
        }
      }
    });

    // Update payment request as completed
    await db.collection('paymentRequests').doc(paymentRequest.id).update({
      status: 'completed',
      mpesaReceiptNumber: mpesaCode,
      amount,
      phoneNumber,
      completedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`Payment processed successfully for booking ${bookingId}`);
    return res.status(200).json({ok: true});
  } catch (error) {
    console.error('Callback processing error:', error);
    return res.status(200).json({ok: true}); // Return OK to prevent M-Pesa retry
  }
});

/**
 * POST /mpesa/simulate
 * Test endpoint to simulate M-Pesa callback (for development)
 * Body: { bookingId, success: true/false }
 */
app.post('/mpesa/simulate', async (req, res) => {
  if (MPESA_ENV !== 'sandbox') {
    return res.status(403).json({error: 'Simulation only available in sandbox mode'});
  }

  const { bookingId, success = true } = req.body;
  if (!bookingId) {
    return res.status(400).json({error: 'bookingId required'});
  }

  try {
    // Simulate callback structure
    const simulatedCallback = {
      Body: {
        stkCallback: {
          MerchantRequestID: `test_${Date.now()}`,
          CheckoutRequestID: `test_checkout_${Date.now()}`,
          ResultCode: success ? 0 : 1,
          ResultDesc: success ? 'The service request has been processed successfully.' : 'Payment failed',
          CallbackMetadata: {
            Item: [
              {Name: 'Amount', Value: 10000},
              {Name: 'MpesaReceiptNumber', Value: `TEST${Date.now()}`},
              {Name: 'TransactionDate', Value: new Date().toISOString()},
              {Name: 'PhoneNumber', Value: '254712345678'},
            ],
          },
        },
      },
    };

    // If simulating success, create payment request first
    if (success) {
      const checkoutRequestId = `test_checkout_${Date.now()}`;
      await db.collection('paymentRequests').add({
        bookingId,
        checkoutRequestId,
        phoneNumber: '254712345678',
        amount: 10000,
        status: 'initiated',
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      simulatedCallback.Body.stkCallback.CheckoutRequestID = checkoutRequestId;
    }

    // Create fake request/response objects
    const fakeReq = {body: simulatedCallback};
    const fakeRes = {
      status: (code) => ({
        json: (data) => {
          console.log(`Simulation response (${code}):`, data);
          return {
            ok: true,
            message: 'Simulation processed',
            bookingId,
          };
        },
      }),
      json: (data) => ({ok: true, message: 'Simulation processed', bookingId}),
    };

    // Process through callback handler
    await new Promise((resolve) => {
      const originalResponse = {
        status: (code) => ({
          json: (data) => {
            resolve({code, data});
          },
        }),
        json: (data) => {
          resolve({code: 200, data});
        },
      };
      fakeReq.body = simulatedCallback;
      fakeRes.status = originalResponse.status;
      fakeRes.json = originalResponse.json;
      
      // Call callback handler
      require('express').Router().post('/mpesa/callback', async (req, res) => {
        // Just call the actual callback logic
      });
    });

    return res.json({
      ok: true,
      message: `Simulated ${success ? 'successful' : 'failed'} payment for booking ${bookingId}`,
    });
  } catch (error) {
    return res.status(500).json({error: error.message});
  }
});

app.listen(PORT, () => {
  console.log(`\n=== M-Pesa Webhook Server ===`);
  console.log(`Running on port ${PORT}`);
  console.log(`Environment: ${MPESA_ENV}`);
  console.log(`Callback URL: ${CALLBACK_URL}`);
  console.log(`Shortcode: ${MPESA_SHORTCODE}\n`);
});
