# Quick Start Guide - M-Pesa Payment System

## Prerequisites
- Node.js 16+ installed
- Firebase project configured
- Flutter SDK with app running
- M-Pesa credentials configured in `.env`

## Quick Start (5 minutes)

### 1. Start the Payment Server
```bash
cd server
npm install  # First time only
npm start
```
✅ Server running on `http://localhost:8080`

### 2. Test M-Pesa Integration

**Scenario A: Test with STK Push (Real or Sandbox Phone)**
```bash
# 1. Create a booking in the app (as student)
# 2. Approve the booking (as landlord)
# 3. Go to Payment History
# 4. Click "Proceed to Payment" button
# 5. Enter phone: 0712345678
# 6. Click "Proceed to Payment"
# 7. M-Pesa prompt appears on phone
# 8. Enter M-Pesa PIN
# 9. Payment processes ✓
```

**Scenario B: Test Without Real Payment (Sandbox)**
```bash
# After initiating payment, simulate success:
curl -X POST http://localhost:8080/mpesa/simulate \
  -H "Content-Type: application/json" \
  -d '{"bookingId": "YOUR_BOOKING_ID", "success": true}'

# Booking should now show as "Paid" ✓
```

### 3. Local Testing with Physical Phone

If you want real M-Pesa prompts on your phone during development:

```bash
# Terminal 1: Start ngrok
ngrok http 8080

# Terminal 2: Update your .env with ngrok URL
# CALLBACK_URL=https://your-ngrok-url.ngrok-free.app/mpesa/callback

# Terminal 3: Restart server
npm start
```

## Files You Modified

1. ✅ `server/.env` - Added your M-Pesa credentials
2. ✅ `server/.env.example` - Updated template with credentials
3. ✅ `lib/screens/student/checkout_payment_screen.dart` - NEW checkout screen
4. ✅ `lib/screens/student/payment_history_screen.dart` - Added "Proceed to Payment" button

## Complete Workflow

```
1. Student Books Room
   ↓
2. Landlord Approves
   ↓
3. Student Goes to Payment History
   ↓
4. Student Clicks "Proceed to Payment" (NEW)
   ↓
5. Student Enters Phone Number (NEW)
   ↓
6. STK Push Sent to Phone
   ↓
7. Customer Enters M-Pesa PIN
   ↓
8. Payment Processed
   ↓
9. Booking Marked as Paid ✓
```

## Your M-Pesa Credentials

The following credentials are now configured:
- **Short Code**: 174379
- **Consumer Key**: MdO5x7PDxlWZNwGcZA4xjGa3pjL0TJZFfFzaYfZUYLtQh8Dx
- **Consumer Secret**: p0npGLbEcNyJ8O3Sa1Dppn6UJLK6JMmJH21qOZxY2yRuKikBqPxhf4ZADMXXcnwF
- **Pass Key**: bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919
- **Callback URL**: https://654c592eb722.ngrok-free.app/api/mpesa/callback

## Checklist

- [ ] Server is running: `npm start` (Terminal 1)
- [ ] Firebase is configured
- [ ] Flutter app is running
- [ ] Student creates booking
- [ ] Landlord approves booking
- [ ] "Proceed to Payment" button appears
- [ ] Phone number can be entered
- [ ] STK push is initiated
- [ ] Payment can be completed
- [ ] Booking shows as paid ✓

## Troubleshooting

**Button doesn't appear?**
```
→ Check: Is booking.status == 'approved' AND booking.isPaid == false?
→ Go to Firestore and verify booking fields
```

**STK push fails?**
```
→ Check server is running
→ Check phone format is correct (0712345678)
→ Check server logs: npm shows errors
```

**Payment not updating?**
```
→ Try: curl -X POST http://localhost:8080/mpesa/simulate ...
→ Check: Is Firestore accessible? Firebase configured?
```

## Support Files

For more details, see:
- [`BOOKING_PAYMENT_WORKFLOW.md`](BOOKING_PAYMENT_WORKFLOW.md) - Complete workflow documentation
- [`PAYMENT_SETUP.md`](PAYMENT_SETUP.md) - Detailed setup & API reference
- [`lib/screens/student/checkout_payment_screen.dart`](lib/screens/student/checkout_payment_screen.dart) - Checkout screen code
- [`server/mpesa/index.js`](server/mpesa/index.js) - Payment server code

## Next Steps

1. ✅ Set up is complete!
2. Run the server: `npm start`
3. Test the complete flow
4. For production: Update `MPESA_ENV=production` and use production credentials
5. Deploy server to cloud (Heroku, Google Cloud, AWS)
6. Update Flutter app callback URL
7. Deploy Flutter app to App Store/Play Store

---

**Your system is ready! Start the server and test the payment flow.** 🚀
