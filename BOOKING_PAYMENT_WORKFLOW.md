# Complete Booking & Payment Workflow Implementation Guide

## Updated Workflow: Booking → Approval → Checkout → Payment

This guide outlines the complete end-to-end workflow with the newly implemented checkout payment screen.

## Workflow Steps

### 1. Student Creates Booking
**File**: [lib/screens/student/booking_screen.dart](lib/screens/student/booking_screen.dart)

- Student selects room type, check-in date, and duration
- Booking is created with status = `'pending'` and `isPaid = false`
- Booking is submitted to Firestore

```dart
final booking = Booking(
  id: bookingId,
  studentId: authProvider.user!.uid,
  landlordId: widget.hostel!.landlordId,
  hostelId: widget.hostel!.id,
  roomId: 'room_$bookingId',
  roomType: _selectedRoomType,
  amount: totalPrice,
  status: 'pending',  // ← Initial status
  isPaid: false,       // ← Not paid yet
  createdAt: DateTime.now(),
  checkInDate: _checkInDate!,
  durationMonths: _durationMonths,
);
```

### 2. Landlord Reviews & Approves Booking
**File**: [lib/screens/landlord/booking_approval_screen.dart](lib/screens/landlord/booking_approval_screen.dart) (or similar)

- Landlord sees pending bookings
- Landlord reviews booking details
- Landlord clicks "Approve" to change status to `'approved'`

```dart
// Landlord action
await bookingProvider.approveBooking(bookingId);
// This updates: booking.status = 'approved'
```

### 3. Student Views Approved Bookings & Proceeds to Checkout
**File**: [lib/screens/student/payment_history_screen.dart](lib/screens/student/payment_history_screen.dart)

- Student can see all their bookings
- For bookings with `status == 'approved'` and `isPaid == false`:
  - A green "Proceed to Payment" button appears
  - Student clicks the button to navigate to checkout screen

```dart
// Only shown for approved, unpaid bookings
if (booking.status == 'approved' && !booking.isPaid) {
  ElevatedButton(
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutPaymentScreen(booking: booking),
        ),
      );
    },
    child: const Text('Proceed to Payment'),
  );
}
```

### 4. Student Enters Phone & Initiates STK Push
**File**: [lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart) (NEW)

- Student enters their M-Pesa registered phone number
- System displays payment summary (room type, duration, total amount)
- Student clicks "Proceed to Payment"
- STK push is initiated via the payment service

```dart
// In checkout_payment_screen.dart
final result = await _paymentService.initiateSTKPush(
  bookingId: widget.booking.id,
  phoneNumber: _phoneController.text,
  amount: widget.booking.amount,
  description: 'Room booking for ${widget.booking.roomType}',
);
```

### 5. M-Pesa Processing
**Flow**: Phone → M-Pesa Network → Server Callback

- Customer receives STK prompt on phone
- Customer enters their M-Pesa PIN
- M-Pesa processes the transaction
- M-Pesa sends webhook callback to server

### 6. Server Processes Payment Callback
**File**: [server/mpesa/index.js](server/mpesa/index.js) - `/mpesa/callback` endpoint

The server:
1. Receives callback from M-Pesa
2. Validates payment success
3. Updates booking in Firestore:
   - `isPaid = true`
   - `paidAt = now`
   - `paymentStatus = 'completed'`
4. Decrements hostel's `availableRooms`

```javascript
// Payment successful in callback
tx.update(bookingRef, {
  isPaid: true,
  paymentStatus: 'completed',
  mpesaReceiptNumber: mpesaCode,
  paidAt: admin.firestore.FieldValue.serverTimestamp(),
  updatedAt: admin.firestore.FieldValue.serverTimestamp(),
});

// Also decrement available rooms
tx.update(hostelRef, {
  availableRooms: currentRooms - 1,
});
```

### 7. Student Confirmation
**Back in Flutter App**:

- Payment success dialog shown
- Student returned to bookings list
- Booking now shows:
  - Status: `'approved'`
  - Payment: `'Paid'` with checkmark
  - Receipt date displayed

## Files Created & Modified

### NEW FILES CREATED

1. **[lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart)**
   - New checkout payment screen
   - Phone number input
   - Payment summary display
   - STK push initiation
   - Payment success/error handling

### MODIFIED FILES

1. **[lib/screens/student/payment_history_screen.dart](lib/screens/student/payment_history_screen.dart)**
   - Added import for `CheckoutPaymentScreen`
   - Added "Proceed to Payment" button for approved, unpaid bookings
   - Button only appears when: `booking.status == 'approved' && !booking.isPaid`

2. **[server/.env](server/.env)** & **[server/.env.example](server/.env.example)**
   - Updated with provided M-Pesa credentials:
     - `MPESA_CONSUMER_KEY`
     - `MPESA_CONSUMER_SECRET`
     - `MPESA_SHORTCODE`
     - `MPESA_PASSKEY`
     - `CALLBACK_URL`

### EXISTING FILES (No changes needed)

- `lib/services/payment_service.dart` - Already handles STK push initiation
- `lib/services/booking_service.dart` - Already has `updatePaymentStatus()`
- `lib/providers/booking_provider.dart` - Already has payment status update methods
- `lib/models/booking_model.dart` - Already has `isPaid` and `paidAt` fields
- `server/mpesa/index.js` - Already handles callbacks correctly

## Configuration Required

### Step 1: Start the M-Pesa Server

```bash
cd server
npm install  # If not already done
npm start
```

The server will run on `http://localhost:8080`

### Step 2: Update Flutter App Base URL (if needed)

In [lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart):

```dart
final PaymentService _paymentService = PaymentService(
  baseUrl: 'http://localhost:8080'  // or your production URL
);
```

### Step 3: For Local Testing with ngrok

If testing locally with a physical phone:

```bash
# In a new terminal
ngrok http 8080
```

Update the callback URL in `server/.env`:
```env
CALLBACK_URL=https://your-ngrok-url.ngrok-free.app/mpesa/callback
```

## Testing the Complete Flow

### Test Scenario 1: Sandbox Testing (No Real Payment)

1. Create a booking as a student
2. Approve the booking as a landlord
3. Go to Payment History
4. Click "Proceed to Payment" on approved booking
5. Enter phone number: `0712345678`
6. Click "Proceed to Payment"
7. Check server logs for STK push initiation
8. Simulate payment success:
   ```bash
   curl -X POST http://localhost:8080/mpesa/simulate \
     -H "Content-Type: application/json" \
     -d '{"bookingId": "your_booking_id", "success": true}'
   ```
9. Verify booking shows as paid in Payment History

### Test Scenario 2: Real M-Pesa Payment (Production)

1. Ensure `MPESA_ENV=sandbox` in `.env` (if using sandbox credentials)
2. Create booking as student
3. Approve as landlord
4. Proceed to payment with real M-Pesa number
5. Enter M-Pesa PIN when prompted
6. Payment processes and callback updates booking

## Troubleshooting

### Payment Button Not Appearing
- **Check**: Is booking status exactly `'approved'`?
- **Check**: Is `isPaid` exactly `false`?
- **Solution**: Open Firestore console and verify booking fields

### STK Push Not Initiated
- **Check**: Is server running? (`npm start` in server directory)
- **Check**: Is phone number in correct format? (0712345678 or 254712345678)
- **Check**: Is amount > 0 and < 150,000?
- **Solution**: Check server logs for detailed error

### Payment Callback Not Received
- **For local testing**: Ensure ngrok is running and URL updated
- **For production**: Ensure CALLBACK_URL is HTTPS and accessible
- **Solution**: Check server logs at `/mpesa/callback`

### Booking Not Updated After Payment
- **Check**: Is transaction succeeding? (Check ResultCode in callback)
- **Check**: Are Firestore rules correct? (`firebase deploy --only firestore:rules`)
- **Solution**: Check server logs for transaction errors

## Security Notes

1. **Phone Number Validation**: Server validates phone format before API call
2. **Amount Validation**: Verified to be between 1-150,000 KES
3. **Transaction Atomicity**: Firestore transaction ensures rooms aren't double-decremented
4. **Status Checking**: Only approved bookings can proceed to payment
5. **Callback Verification**: Server validates M-Pesa callback before processing

## Database Schema

### Booking Document

```javascript
{
  id: string,
  studentId: string,
  landlordId: string,
  hostelId: string,
  roomId: string,
  roomType: string,        // "Single Room", "Bedsitter", "Shared Room"
  amount: number,          // Total price in KES
  status: string,          // "pending", "approved", "rejected", "cancelled"
  isPaid: boolean,         // false → true after successful payment
  paymentStatus: string,   // "pending", "completed", "failed" (added by callback)
  createdAt: timestamp,
  updatedAt: timestamp,
  paidAt: timestamp,       // Set when isPaid becomes true
  checkInDate: date,
  durationMonths: number,
  rejectionReason?: string,
  mpesaReceiptNumber?: string  // Set by callback
}
```

### Payment Request Document (Tracking)

```javascript
{
  bookingId: string,
  checkoutRequestId: string,
  phoneNumber: string,
  amount: number,
  status: string,          // "initiated", "completed", "failed"
  createdAt: timestamp,
  completedAt?: timestamp,
  mpesaReceiptNumber?: string
}
```

## Summary

You now have a complete booking and payment system:

✅ **Booking Creation**: Students create bookings → Status: `pending`
✅ **Approval**: Landlords approve bookings → Status: `approved`
✅ **Checkout Screen**: NEW - Students proceed to payment with phone number entry
✅ **STK Push**: STK prompt sent to customer phone
✅ **Payment Processing**: M-Pesa processes payment and sends callback
✅ **Confirmation**: Booking marked as paid, available rooms decremented
✅ **History**: Students see payment history with receipt information

All with proper error handling, security validation, and atomic database transactions!
