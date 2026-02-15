# Setup & Testing Checklist

## Pre-Implementation Checklist ✅

- [x] M-Pesa credentials obtained from Safaricom Daraja
- [x] Firebase project configured and Firestore database created
- [x] Flutter app with required dependencies installed
- [x] Node.js 16+ installed on development machine
- [x] ngrok installed (for local development with real M-Pesa)

---

## Implementation Checklist ✅

### Configuration
- [x] M-Pesa credentials added to `server/.env`
- [x] M-Pesa credentials added to `server/.env.example`
- [x] Callback URL configured
- [x] Environment set to 'sandbox' for testing

### Code Changes
- [x] Created `lib/screens/student/checkout_payment_screen.dart`
- [x] Modified `lib/screens/student/payment_history_screen.dart`
- [x] Added "Proceed to Payment" button for approved bookings
- [x] Payment summary display implemented
- [x] Phone number input field added
- [x] STK push initiation integrated
- [x] Error handling implemented

### Backend Ready
- [x] `server/mpesa/index.js` has all endpoints
- [x] Firestore transaction logic implemented
- [x] Payment callback handler ready
- [x] Simulate endpoint available for testing

### Documentation
- [x] `QUICK_START.md` - Quick setup guide created
- [x] `BOOKING_PAYMENT_WORKFLOW.md` - Detailed workflow documented
- [x] `IMPLEMENTATION_SUMMARY.md` - Summary of all changes
- [x] `ARCHITECTURE.md` - System architecture diagrams
- [x] This checklist - Complete verification guide

---

## Local Development Setup

### Step 1: Install Dependencies ✅

```bash
# Backend dependencies
cd server
npm install

# Frontend already has required packages
# Verify in pubspec.yaml:
# - provider
# - http
# - firebase_core
# - cloud_firestore
```

### Step 2: Configure Environment ✅

```bash
# The .env file is already created with your credentials
cd server
cat .env  # Verify credentials are there
```

Should contain:
```env
MPESA_CONSUMER_KEY=MdO5x7PDxlWZNwGcZA4xjGa3pjL0TJZFfFzaYfZUYLtQh8Dx
MPESA_CONSUMER_SECRET=p0npGLbEcNyJ8O3Sa1Dppn6UJLK6JMmJH21qOZxY2yRuKikBqPxhf4ZADMXXcnwF
MPESA_SHORTCODE=174379
MPESA_PASSKEY=bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919
MPESA_ENV=sandbox
CALLBACK_URL=https://654c592eb722.ngrok-free.app/api/mpesa/callback
```

### Step 3: Start Backend Server ✅

```bash
cd server
npm start
# Server running on http://localhost:8080
```

### Step 4: Start Flutter App ✅

```bash
# In another terminal
flutter run
```

---

## Test Cases

### Test 1: Complete Flow with Sandbox ✅

**Prerequisites**
- [ ] Server running (`npm start`)
- [ ] Flutter app running (`flutter run`)
- [ ] Logged in as student

**Steps**
1. [ ] Navigate to hostel
2. [ ] Click "Book Now"
3. [ ] Select room type (e.g., Single Room)
4. [ ] Select check-in date (today or later)
5. [ ] Select duration (e.g., 1 month)
6. [ ] Accept terms
7. [ ] Click "Book"
   - [ ] Success dialog shown
   - [ ] Booking created in Firestore
   - [ ] Status: "pending"

**Expected Result**
- [ ] Booking created with status = 'pending'
- [ ] Dialog confirms "Booking submitted"

---

### Test 2: Landlord Approval ✅

**Prerequisites**
- [ ] Booking created from Test 1
- [ ] Logged in as landlord

**Steps**
1. [ ] Navigate to landlord dashboard/pending bookings
2. [ ] Find the booking just created
3. [ ] Review booking details
4. [ ] Click "Approve"
   - [ ] Status changes to "approved"
   - [ ] Firestore updated

**Expected Result**
- [ ] Booking status = 'approved'
- [ ] `isPaid` = false (still)

---

### Test 3: Payment Initiation (Sandbox) ✅

**Prerequisites**
- [ ] Booking approved from Test 2
- [ ] Logged in as student

**Steps**
1. [ ] Go to Payment History
2. [ ] Find approved booking
3. [ ] Click "Proceed to Payment" button
   - [ ] Checkout screen opens
   - [ ] Payment summary shows
   - [ ] Amount displays correctly
4. [ ] Enter phone number (0712345678)
5. [ ] Click "Proceed to Payment"
6. [ ] Watch for STK prompt (if using real phone)
   - Or wait for server response

**Expected Result**
- [ ] Success dialog shown: "Payment Initiated"
- [ ] Server logs show: "STK push initiation..."
- [ ] Payment request created in Firestore

---

### Test 4: Simulate Payment Success ✅

**Prerequisites**
- [ ] Payment initiated from Test 3
- [ ] Get the BOOKING_ID

**Steps**
1. [ ] Open terminal
2. [ ] Run:
   ```bash
   curl -X POST http://localhost:8080/mpesa/simulate \
     -H "Content-Type: application/json" \
     -d '{"bookingId": "REPLACE_WITH_BOOKING_ID", "success": true}'
   ```
3. [ ] Check response: `{"ok": true}`
4. [ ] Check Firestore console:
   - [ ] Booking.isPaid = true
   - [ ] Booking.paidAt has timestamp
   - [ ] Hostel.availableRooms decreased by 1

**Expected Result**
- [ ] Booking marked as paid
- [ ] Booking.paymentStatus = "completed"
- [ ] Receipt number stored
- [ ] Available rooms decremented

---

### Test 5: Verify UI Update ✅

**Prerequisites**
- [ ] Payment simulated successfully from Test 4
- [ ] Flutter app still open

**Steps**
1. [ ] Go back to Payment History
2. [ ] Look for paid booking
3. [ ] Check:
   - [ ] Status shows "Approved"
   - [ ] Payment status shows "Paid" with checkmark
   - [ ] Receipt date displayed
   - [ ] "Proceed to Payment" button GONE

**Expected Result**
- [ ] UI shows booking as paid
- [ ] No payment button visible
- [ ] All payment details correct

---

### Test 6: Simulate Payment Failure ✅

**Create a new booking and get to payment initiation**

**Steps**
1. [ ] Go through Tests 1-3 again (create new booking/approval/initiate)
2. [ ] Get the BOOKING_ID
3. [ ] Run failure simulation:
   ```bash
   curl -X POST http://localhost:8080/mpesa/simulate \
     -H "Content-Type: application/json" \
     -d '{"bookingId": "NEW_BOOKING_ID", "success": false}'
   ```
4. [ ] Check Firestore:
   - [ ] Booking.isPaid = false (still)
   - [ ] paymentRequests status = "failed"

**Expected Result**
- [ ] Booking stays unpaid
- [ ] "Proceed to Payment" button still visible
- [ ] Can retry payment

---

### Test 7: Error Handling - Invalid Phone Number ✅

**Steps**
1. [ ] Create and approve a booking
2. [ ] Go to checkout screen
3. [ ] Enter invalid phone:
   - [ ] Empty field
   - [ ] Invalid format (abc123)
   - [ ] Too short (123)
4. [ ] Click "Proceed to Payment"

**Expected Result**
- [ ] Error message shown
- [ ] Request not sent to server
- [ ] Validation message clear

---

### Test 8: Error Handling - Server Offline ✅

**Steps**
1. [ ] Create and approve booking
2. [ ] Stop server: `Ctrl+C` in server terminal
3. [ ] Go to checkout screen
4. [ ] Enter valid phone
5. [ ] Click "Proceed to Payment"

**Expected Result**
- [ ] Error dialog shown: "Server unreachable" or similar
- [ ] No crash
- [ ] Can try again when server is back

---

### Test 9: Multiple Bookings - Room Decrement ✅

**Prerequisites**
- [ ] Hostel has say 10 available rooms
- [ ] Create 3 bookings total

**Steps**
1. [ ] Create Booking 1 → Approve → Pay (simulate success)
   - [ ] Available rooms: 9
2. [ ] Create Booking 2 → Approve → Pay (simulate success)
   - [ ] Available rooms: 8
3. [ ] Create Booking 3 → Approve → Pay (simulate success)
   - [ ] Available rooms: 7

**Expected Result**
- [ ] Each payment decrements rooms by exactly 1
- [ ] No double-decrement
- [ ] Total decremented = 3

---

### Test 10: Concurrent Payments ✅

**Prerequisites**
- [ ] Multiple bookings approved

**Steps**
1. [ ] Start 2 payment simulations simultaneously:
   ```bash
   # Terminal 1
   curl -X POST http://localhost:8080/mpesa/simulate \
     -H "Content-Type: application/json" \
     -d '{"bookingId": "ID1", "success": true}'
   
   # Terminal 2 (at same time)
   curl -X POST http://localhost:8080/mpesa/simulate \
     -H "Content-Type: application/json" \
     -d '{"bookingId": "ID2", "success": true}'
   ```

**Expected Result**
- [ ] Both payments process correctly
- [ ] Rooms decremented by 2 total
- [ ] No conflicts or overwrites

---

## Production Checklist

### Before Going Live

- [ ] Switch to production M-Pesa credentials
- [ ] Update `.env` with production values:
  ```env
  MPESA_ENV=production
  MPESA_CONSUMER_KEY=production_key
  MPESA_CONSUMER_SECRET=production_secret
  ```
- [ ] Deploy server to production (Heroku/Google Cloud/AWS)
- [ ] Update callback URL to production domain (HTTPS required)
- [ ] Test with real M-Pesa account (small amount)
- [ ] Update Flutter app to point to production server
- [ ] Deploy Flutter app to Play Store/App Store
- [ ] Monitor first few transactions
- [ ] Set up error alerts/logging

---

## Troubleshooting Checklist

### Payment Button Not Showing

- [ ] Check Firestore: booking.status == 'approved' ?
- [ ] Check Firestore: booking.isPaid == false ?
- [ ] Restart Flutter app
- [ ] Check hot reload didn't miss changes

### STK Push Not Received

- [ ] Server running? Check: `npm start` in server directory
- [ ] Phone format valid? Check: 0712345678 or 254712345678
- [ ] Amount valid? Check: 1-150,000 KES
- [ ] M-Pesa credentials correct? Check `.env`
- [ ] Network connected? Check internet access
- [ ] Server logs for error message

### Callback Not Processing

- [ ] Callback URL accessible? Check URL is HTTPS
- [ ] Server running? (must be receiving callbacks)
- [ ] Firestore permissions? (must allow server to update)
- [ ] Check server logs: `/mpesa/callback` logs
- [ ] Firestore rules deployed? (`firebase deploy --only firestore:rules`)

### Database Not Updating

- [ ] Firestore rules correct? Check console
- [ ] Transaction error? Check server logs
- [ ] Booking already paid? (can't double-pay)
- [ ] Check Firestore directly for status

### Rooms Not Decrementing

- [ ] Booking status is 'approved' at time of payment?
- [ ] Payment callback succeeded? (ResultCode: 0)
- [ ] Hostel doc exists? (with availableRooms field)
- [ ] Transaction not failing? Check server logs
- [ ] Check Firestore for hostel.availableRooms value

---

## Success Indicators ✅

### When Everything Works:

1. ✅ Student can create booking
   - [ ] Booking visible in Firestore with status: pending

2. ✅ Landlord can approve
   - [ ] Booking status changes to: approved

3. ✅ "Proceed to Payment" button appears
   - [ ] Only for approved, unpaid bookings

4. ✅ Checkout screen opens
   - [ ] Shows booking details correctly
   - [ ] Phone input field works

5. ✅ STK push initiates
   - [ ] Server responds with checkoutRequestId
   - [ ] Payment request created in Firestore

6. ✅ Payment simulates successfully
   - [ ] Booking.isPaid becomes true
   - [ ] Booking.paidAt has timestamp
   - [ ] hostel.availableRooms decremented

7. ✅ UI updates in real-time
   - [ ] Booking shows as paid
   - [ ] Button disappears
   - [ ] Receipt shown

**If all 7 indicators pass, your system is working perfectly!** 🎉

---

## Sign-Off

- [ ] All tests pass
- [ ] Documentation reviewed
- [ ] Credentials configured
- [ ] Server running successfully
- [ ] Flutter app integrated
- [ ] Ready for production deployment

---

**System Ready! Start with: `cd server && npm start`** 🚀
