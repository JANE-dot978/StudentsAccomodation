# Students Accommodation - Payment Integration Guide

## Payment Flow Overview

The application supports M-Pesa payments through STK (SIM Toolkit) push, allowing students to pay for room bookings directly from their M-Pesa account.

### Complete Payment Flow:

1. **Student Initiates Booking** → `booking_screen.dart`
   - Student selects room type, check-in date, duration
   - Confirms booking (creates booking with status='pending')
   - Booking is submitted to landlord for approval

2. **Landlord Reviews & Approves** → `booking_approval_screen.dart`
   - Landlord reviews pending booking
   - Landlord clicks "Approve" button
   - Booking status changes to 'approved'

3. **Student Proceeds to Payment** → `student_home_screen.dart` or booking details
   - Student sees "Pay Now" button for approved bookings
   - Enters M-Pesa phone number
   - System initiates STK push payment

4. **M-Pesa Payment Processing** → `server/mpesa/index.js`
   - Customer receives STK prompt on phone
   - Customer enters M-Pesa PIN
   - M-Pesa processes payment

5. **Webhook Callback** → `server/mpesa/index.js` - `/mpesa/callback`
   - M-Pesa sends payment confirmation
   - Server updates booking (isPaid = true)
   - Server decrements hostel availableRooms
   - Booking status becomes 'completed'

---

## Setup Instructions

### Prerequisites

- Node.js 16+ installed
- Firebase project with Firestore database
- M-Pesa Daraja developer account (for API credentials)
- `http` package in Flutter (for API calls)

### Step 1: Get M-Pesa Credentials

1. Visit [Safaricom Daraja Developer Portal](https://developer.safaricom.co.ke)
2. Create a free account and log in
3. Go to **My Apps** > **Create New App**
4. Select app type: **Web Application**
5. In the app dashboard, you'll find:
   - **Consumer Key**
   - **Consumer Secret**
   - **Test Shortcode**: 174379
   - **Test Passkey** (in "Test Credentials" section)

### Step 2: Configure Server Environment

1. Navigate to the server directory:
```bash
cd server
```

2. Install dependencies:
```bash
npm install express body-parser firebase-admin axios dotenv
```

3. Copy `.env.example` to `.env`:
```bash
cp .env.example .env
```

4. Fill in your M-Pesa credentials in `.env`:
```env
MPESA_CONSUMER_KEY=your_consumer_key
MPESA_CONSUMER_SECRET=your_consumer_secret
MPESA_SHORTCODE=174379
MPESA_PASSKEY=your_test_passkey
MPESA_ENV=sandbox
CALLBACK_URL=http://localhost:8080/mpesa/callback
SERVICE_ACCOUNT_PATH=./serviceAccountKey.json
PORT=8080
```

5. Add your Firebase service account key:
```bash
# Copy your service account JSON from Firebase Console
cp /path/to/serviceAccountKey.json ./serviceAccountKey.json
```

### Step 3: Update Firestore Security Rules

Deploy the updated security rules that allow bookings:

```bash
firebase deploy --only firestore:rules
```

The rules are defined in `firestore.rules` and include:
- Students can create bookings
- Landlords can approve/reject bookings
- Payment webhook can update bookings

### Step 4: Start the Payment Server

```bash
npm start
# or for development with auto-reload:
npm install -g nodemon
nodemon server/mpesa/index.js
```

Server will start on `http://localhost:8080`

### Step 5: Update Flutter App (if using different server URL)

In `lib/services/payment_service.dart`, update the base URL if needed:

```dart
final paymentService = PaymentService(
  baseUrl: 'https://your-production-server.com'
);
```

---

## Testing the Integration

### Option 1: Manual Testing with Sandbox

1. Start the server (see Step 4)

2. In your Flutter app, test payment initiation:
```dart
final paymentService = PaymentService(baseUrl: 'http://localhost:8080');

// Test with a valid M-Pesa number in Kenya
final result = await paymentService.initiateSTKPush(
  bookingId: 'test_booking_123',
  phoneNumber: '0712345678', // Test number in sandbox
  amount: 1500,
);

if (result['success']) {
  print('STK push initiated: ${result['checkoutRequestId']}');
} else {
  print('Error: ${result['error']}');
}
```

3. You'll see M-Pesa STK prompt on test device (if using real phone with M-Pesa)

4. Simulate payment completion:
```dart
// For testing: simulate successful payment
final simResult = await paymentService.simulatePayment(
  bookingId: 'test_booking_123',
  success: true, // Set to false to test failure
);
```

### Option 2: Automated Testing

Use the `/mpesa/simulate` endpoint to test without real M-Pesa:

```bash
curl -X POST http://localhost:8080/mpesa/simulate \
  -H "Content-Type: application/json" \
  -d '{"bookingId": "test_123", "success": true}'
```

### Testing Checklist

- [ ] Student can create booking
- [ ] Landlord can approve booking
- [ ] Payment initiation returns checkoutRequestId
- [ ] STK prompt appears on phone (real device) or in console (sandbox)
- [ ] Payment success updates booking.isPaid = true
- [ ] Hostel.availableRooms decrements after payment
- [ ] Booking status changes to 'completed'
- [ ] Multiple payments don't double-decrement rooms

---

## Production Deployment

### Prerequisites for Production

1. **M-Pesa Live Account**
   - Register as M-Pesa API merchant
   - Get production API credentials
   - Set up tillnumber/shortcode

2. **HTTPS Required**
   - M-Pesa only accepts HTTPS callback URLs
   - Obtain SSL certificate (Let's Encrypt is free)

3. **Staging Testing**
   - Test thoroughly on staging server first
   - Ensure callback URL is accessible

### Production Setup

1. Update `.env` for production:
```env
MPESA_ENV=production
MPESA_CONSUMER_KEY=your_production_key
MPESA_CONSUMER_SECRET=your_production_secret
MPESA_SHORTCODE=your_till_number
MPESA_PASSKEY=your_production_passkey
CALLBACK_URL=https://your-domain.com/mpesa/callback
```

2. Deploy server with HTTPS:
   - Use Heroku, Google Cloud, AWS, or similar
   - Ensure environment variables are set
   - Test webhook with real transaction

3. Update Flutter app to use production server URL

4. Deploy Flutter app to app stores

---

## Troubleshooting

### "Permission Denied" Error

**Issue**: Booking creation fails with permission denied

**Solution**: 
- Ensure Firestore rules are deployed: `firebase deploy --only firestore:rules`
- Check that user is authenticated: `Provider.of<AuthProvider>(context).user != null`

### "Invalid Phone Number" Error

**Supported formats**:
- `0712345678` (local format)
- `254712345678` (international)
- `+254712345678` (international with +)

**Solution**: Use `PaymentService.formatPhoneNumber()` to normalize

### "STK Push Failed"

**Possible causes**:
1. Invalid credentials in `.env`
2. Network connectivity issues
3. Phone number not registered with M-Pesa
4. Amount outside allowed range (1-150,000 KES)

**Debug**: 
- Check server logs for detailed error message
- Verify credentials in [Daraja Portal](https://developer.safaricom.co.ke)
- Test with different phone number

### "Callback Not Received"

**Possible causes**:
1. Callback URL not accessible
2. Server not running/reachable
3. Firewall blocking requests
4. M-Pesa using wrong callback URL

**Solutions**:
- For local testing: Use ngrok to expose local server: `ngrok http 8080`
- Update callback URL in M-Pesa settings
- Check server logs: `tail -f logs/*.log`

### Database Not Updated After Payment

**Possible causes**:
1. Transaction conflict
2. Booking already marked as paid
3. Firestore rules blocking update

**Debug**:
- Check Firestore console for booking status
- Verify `isPaid` and `paymentStatus` fields
- Check server logs for transaction errors

---

## API Reference

### Endpoints

#### `POST /mpesa/initiate-payment`

Initiate STK push payment

**Request:**
```json
{
  "bookingId": "1234567890",
  "phoneNumber": "0712345678",
  "amount": 15000,
  "description": "Room Booking - Bedsitter"
}
```

**Response (Success):**
```json
{
  "success": true,
  "message": "STK push initiated. Please check your phone for the M-Pesa prompt.",
  "checkoutRequestId": "ws_CO_191219175356737",
  "customerMessage": "Please enter your M-Pesa PIN"
}
```

**Response (Error):**
```json
{
  "error": "Invalid phone number format"
}
```

---

#### `POST /mpesa/check-payment-status`

Query payment status

**Request:**
```json
{
  "checkoutRequestId": "ws_CO_191219175356737"
}
```

**Response:**
```json
{
  "ResultCode": 0,
  "ResultDesc": "The service request has been processed successfully",
  "CheckoutRequestID": "ws_CO_191219175356737"
}
```

---

#### `POST /mpesa/simulate` (Sandbox Only)

Simulate payment for testing

**Request:**
```json
{
  "bookingId": "test_123",
  "success": true
}
```

**Response:**
```json
{
  "ok": true,
  "message": "Simulated successful payment for booking test_123"
}
```

---

## Files Modified

- `lib/services/payment_service.dart` - New payment service
- `server/mpesa/index.js` - Enhanced with STK push
- `server/.env.example` - Configuration template
- `firestore.rules` - Updated security rules

---

## Support & Resources

- [M-Pesa API Documentation](https://developer.safaricom.co.ke/apis)
- [Daraja Portal](https://developer.safaricom.co.ke)
- [Firebase Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Flutter HTTP Package](https://pub.dev/packages/http)

---

**Last Updated**: 2024
**Version**: 1.0
