# System Architecture & Data Flow Diagrams

## Complete Payment Flow Architecture

```
┌──────────────────────────────────────────────────────────────────────────┐
│                         STUDENTS ACCOMMODATION                            │
│                       BOOKING & PAYMENT SYSTEM                           │
└──────────────────────────────────────────────────────────────────────────┘

                            ┌─────────────────┐
                            │   FLUTTER APP   │
                            └────────┬────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
            ┌───────▼─────────┐  ┌──▼────────┐   ┌──▼────────┐
            │ Student Module  │  │ Landlord  │   │ Admin     │
            │                 │  │ Module    │   │ Module    │
            └───────┬─────────┘  └──┬────────┘   └──┬────────┘
                    │               │               │
           ┌────────▼───────────────▼───────────────▼────────┐
           │              FIREBASE FIRESTORE                 │
           │  ┌──────────────────────────────────────────┐  │
           │  │ Collections:                             │  │
           │  │ - bookings (status, isPaid, paidAt)     │  │
           │  │ - hostels (availableRooms)              │  │
           │  │ - users (profile info)                  │  │
           │  │ - paymentRequests (tracking)            │  │
           │  └──────────────────────────────────────────┘  │
           └──────────────────┬─────────────────────────────┘
                              │
                              │ (HTTP/REST)
                              │
                    ┌─────────▼──────────┐
                    │  PAYMENT SERVER    │
                    │   (Node.js/Express)│
                    │                    │
                    │  /mpesa endpoints: │
                    │  - initiate        │
                    │  - callback        │
                    │  - status check    │
                    │  - simulate        │
                    └─────────┬──────────┘
                              │
                    ┌─────────▼──────────────┐
                    │   SAFARICOM DARAJA    │
                    │   (M-Pesa API)        │
                    │                       │
                    │  - Generate token    │
                    │  - STK push          │
                    │  - Query status      │
                    └─────────┬──────────────┘
                              │
                    ┌─────────▼──────────┐
                    │   M-PESA NETWORK   │
                    │   & SIM TOOLKIT    │
                    │                    │
                    │  Send prompt to    │
                    │  customer phone    │
                    └────────────────────┘
```

---

## Booking State Machine

```
┌──────────────┐
│  NOT BOOKED  │  (Initial state)
└──────┬───────┘
       │ Student creates booking
       ▼
┌──────────────────┐
│ PENDING APPROVAL │  (Waiting for landlord)
│ isPaid: false    │
└────────┬─────────┘
         │
         │ Landlord reviews
         ├─────────────────────────────────┐
         │                                 │
    (approve)                         (reject)
         │                                 │
         ▼                                 ▼
┌──────────────────┐              ┌──────────────┐
│    APPROVED      │              │  REJECTED    │
│ isPaid: false    │              │              │
└────────┬─────────┘              └──────────────┘
         │
         │ Student pays (clicks "Proceed to Payment")
         │ ↓ Enters phone number
         │ ↓ STK prompt sent
         │ ↓ Customer enters PIN
         │
         ▼
┌──────────────────────┐
│  PAYMENT IN PROGRESS │
│ isPaid: false        │  (STK prompt on phone)
│ paymentStatus: ...   │
└──────────┬───────────┘
           │
      (M-Pesa processes)
           │
           ├──────────────────────┐
           │                      │
        (success)            (failure)
           │                      │
           ▼                      ▼
┌──────────────────┐    ┌──────────────────┐
│  PAID & APPROVED │    │  PAYMENT FAILED  │
│ isPaid: true     │    │ isPaid: false    │
│ paidAt: timestamp│    │ Status: approved │
│ Status: approved │    │ Can retry        │
└──────┬───────────┘    └──────────────────┘
       │
       │ Booking confirmed
       │ Hostel available rooms decreased
       │ Check-in date approaches
       │
       ▼
┌──────────────────────┐
│  ACTIVE BOOKING      │
│ (Student checking in)│
└──────────────────────┘
```

---

## API Call Sequence - Complete Payment

```
ACTOR           ACTION                    ENDPOINT                   RESPONSE
─────────────────────────────────────────────────────────────────────────────

┌─ Student ─────────────────────────────────────────────────────────────────┐
│  1. Create Booking                                                         │
│     └─→ [Firestore] Create booking doc (status: pending, isPaid: false)   │
│                                                                            │
│  2. View Payment History                                                  │
│     └─→ [Firestore] GET /bookings where status: approved AND isPaid: false
│                                                                            │
│  3. Click "Proceed to Payment"                                           │
│     └─→ [Navigate to CheckoutPaymentScreen]                             │
│                                                                            │
│  4. Enter Phone Number (e.g., 0712345678)                               │
│                                                                            │
│  5. Click "Proceed to Payment"                                           │
│     └─→ POST /mpesa/initiate-payment                                    │
│         {                                                                 │
│           bookingId: "1234567890",                                       │
│           phoneNumber: "0712345678",                                     │
│           amount: 15000,                                                 │
│           description: "Room Booking"                                    │
│         }                                                                 │
└────────────────────────────────────────────────────────────────────────┘

┌─ SERVER ──────────────────────────────────────────────────────────────────┐
│  6. Validate Request                                                       │
│     ├─ Phone number format OK?                                            │
│     ├─ Amount 1-150,000 KES?                                             │
│     └─ Booking exists?                                                    │
│                                                                            │
│  7. Get M-Pesa Access Token                                              │
│     └─→ POST /oauth/v1/generate                                          │
│         Headers: Authorization: Basic [base64(key:secret)]               │
│         ✓ Returns: access_token                                          │
│                                                                            │
│  8. Initiate STK Push                                                    │
│     └─→ POST /mpesa/stkpush/v1/processrequest                           │
│         {                                                                 │
│           BusinessShortCode: 174379,                                     │
│           Password: [base64(shortcode+passkey+timestamp)],               │
│           Timestamp: [YYYYMMDDHHMMSS],                                  │
│           TransactionType: "CustomerPayBillOnline",                     │
│           Amount: 15000,                                                │
│           PartyA: 254712345678,                                         │
│           PartyB: 174379,                                               │
│           PhoneNumber: 254712345678,                                    │
│           CallBackURL: "https://654c592eb722.ngrok-free.app/api/...",  │
│           AccountReference: "Booking12345678",                          │
│           TransactionDesc: "Room Booking Payment"                       │
│         }                                                                 │
│                                                                            │
│         ✓ M-Pesa Returns:                                               │
│         {                                                                 │
│           ResponseCode: "0",                                             │
│           ResponseMessage: "Success",                                   │
│           CheckoutRequestID: "ws_CO_191219175356737",                   │
│           CustomerMessage: "Enter your M-Pesa PIN"                      │
│         }                                                                 │
│                                                                            │
│  9. Store Payment Request                                                │
│     └─→ [Firestore] Create paymentRequests doc                          │
│         {                                                                 │
│           bookingId: "1234567890",                                       │
│           checkoutRequestId: "ws_CO_191219175356737",                   │
│           phoneNumber: "254712345678",                                  │
│           amount: 15000,                                                │
│           status: "initiated"                                            │
│         }                                                                 │
│                                                                            │
│  10. Send Response to Flutter                                            │
│      {                                                                    │
│        success: true,                                                    │
│        checkoutRequestId: "ws_CO_191219175356737",                      │
│        message: "STK push initiated",                                   │
│        customerMessage: "Check your phone for M-Pesa prompt"           │
│      }                                                                    │
└────────────────────────────────────────────────────────────────────────┘

┌─ Customer ────────────────────────────────────────────────────────────────┐
│  11. Receive STK Prompt on Phone                                          │
│      [SIM Toolkit displays M-Pesa payment window]                         │
│                                                                            │
│  12. Enter M-Pesa PIN                                                    │
│      [SIM toolkit processes transaction]                                  │
│                                                                            │
│  13. Payment Success/Failure                                             │
│      [Customer sees result on phone]                                      │
└────────────────────────────────────────────────────────────────────────┘

┌─ M-PESA NETWORK ──────────────────────────────────────────────────────────┐
│  14. Send Webhook Callback (after 2-5 seconds)                           │
│      └─→ POST /mpesa/callback                                            │
│          {                                                                │
│            Body: {                                                       │
│              stkCallback: {                                              │
│                MerchantRequestID: "...",                                │
│                CheckoutRequestID: "ws_CO_191219175356737",             │
│                ResultCode: 0,     // 0 = success                       │
│                ResultDesc: "Success",                                  │
│                CallbackMetadata: {                                     │
│                  Item: [                                               │
│                    {Name: "Amount", Value: 15000},                    │
│                    {Name: "MpesaReceiptNumber", Value: "ABC123"},     │
│                    {Name: "PhoneNumber", Value: "254712345678"}       │
│                  ]                                                     │
│                }                                                       │
│              }                                                         │
│            }                                                            │
│          }                                                               │
└────────────────────────────────────────────────────────────────────────┘

┌─ SERVER (Processing Callback) ─────────────────────────────────────────────┐
│  15. Verify Callback                                                       │
│      ├─ Find paymentRequest by checkoutRequestId                          │
│      ├─ Check if ResultCode == 0 (success)                                │
│      └─ Extract amount, receipt number, phone                             │
│                                                                            │
│  16. Atomic Transaction - Update Firestore                                │
│      ├─ [Firestore] Update bookings doc:                                 │
│      │  {                                                                 │
│      │    isPaid: true,                                                  │
│      │    paidAt: serverTimestamp(),                                     │
│      │    mpesaReceiptNumber: "ABC123",                                  │
│      │    paymentStatus: "completed"                                     │
│      │  }                                                                 │
│      │                                                                    │
│      └─ [Firestore] Update hostels doc:                                 │
│         {                                                                 │
│           availableRooms: currentRooms - 1  // Decrement                │
│         }                                                                 │
│                                                                            │
│  17. Update Payment Request                                              │
│      └─→ [Firestore] Update paymentRequests doc:                         │
│          {                                                                │
│            status: "completed",                                          │
│            mpesaReceiptNumber: "ABC123",                                │
│            completedAt: serverTimestamp()                               │
│          }                                                                │
│                                                                            │
│  18. Send OK Response to M-Pesa                                          │
│      {ok: true}  // Prevents M-Pesa retry                                │
└────────────────────────────────────────────────────────────────────────┘

┌─ Flutter App (Real-time Update) ───────────────────────────────────────────┐
│  19. Firestore Listener Detects Change                                    │
│      └─ booking.isPaid changed to true                                   │
│      └─ booking.paidAt has timestamp                                     │
│                                                                            │
│  20. UI Updates Automatically                                             │
│      ├─ Payment History shows booking as PAID ✓                          │
│      ├─ Receipt date displayed                                           │
│      ├─ "Proceed to Payment" button disappears                          │
│      └─ Checkmark shows payment complete                                │
│                                                                            │
│  21. Student Confirmation                                                │
│      └─ Dialog: "Payment Successful!"                                   │
│      └─ Booking confirmed and ready for check-in                        │
└────────────────────────────────────────────────────────────────────────┘
```

---

## Data Model Relationships

```
┌─────────────────────┐
│      USERS          │
├─────────────────────┤
│ uid (PK)            │
│ name                │
│ email               │
│ phone               │
│ role (student/...)  │
└────────┬────────────┘
         │
         │ 1 student : many bookings
         │
         ▼
┌─────────────────────────────────┐       ┌─────────────────┐
│        BOOKINGS                 │◄──────┤    HOSTELS      │
├─────────────────────────────────┤       ├─────────────────┤
│ id (PK)                         │       │ id (PK)         │
│ studentId (FK → users)          │       │ name            │
│ landlordId (FK → users)         │       │ landlordId      │
│ hostelId (FK → hostels)         │───────►│ location        │
│ roomId                          │       │ availableRooms  │
│ roomType                        │       │ description     │
│ amount                          │       └─────────────────┘
│ status (pending/approved/...)   │
│ isPaid ◄──── (Payment Status)   │
│ paidAt                          │       ┌─────────────────────┐
│ paymentStatus                   │       │ PAYMENT_REQUESTS    │
│ mpesaReceiptNumber              │◄──────├─────────────────────┤
│ createdAt                       │       │ id (PK)             │
│ updatedAt                       │       │ bookingId (FK)      │
│ checkInDate                     │       │ checkoutRequestId   │
│ durationMonths                  │       │ status              │
│ rejectionReason                 │       │ amount              │
└─────────────────────────────────┘       │ mpesaReceiptNumber  │
                                          │ completedAt         │
                                          └─────────────────────┘
```

---

## Server Endpoint Topology

```
┌──────────────────────────────────────────────────────────┐
│           PAYMENT SERVER (Node.js/Express)              │
└──────────────────────────────────────────────────────────┘

PUBLIC ENDPOINTS:
├── POST /mpesa/initiate-payment
│   └─→ Initiate STK push
│   ├─ Input: bookingId, phoneNumber, amount, description
│   └─ Output: checkoutRequestId, customerMessage
│
├── POST /mpesa/check-payment-status
│   └─→ Query payment status
│   ├─ Input: checkoutRequestId
│   └─ Output: ResultCode, ResultDesc
│
├── POST /mpesa/callback
│   └─→ M-Pesa Webhook (INTERNAL - M-Pesa only)
│   ├─ Input: M-Pesa callback payload
│   └─ Output: {ok: true}
│
└── POST /mpesa/simulate (Development only)
    └─→ Simulate payment (Sandbox mode)
    ├─ Input: bookingId, success
    └─ Output: {ok: true}

INTERNAL FUNCTIONS:
├── getMpesaAccessToken()
│   └─→ Get OAuth token from Safaricom
│
├── initiateSTKPush(phoneNumber, amount, bookingId)
│   └─→ Send STK push request to M-Pesa API
│
├── querySTKStatus(checkoutRequestId)
│   └─→ Query transaction status
│
└── processCallback(payload)
    └─→ Handle payment success/failure
    ├─ Update booking in Firestore
    ├─ Decrement available rooms
    └─ Store payment tracking
```

---

## Error Handling Flow

```
USER ACTION
    │
    ▼
[Validate Input]
    │
    ├─→ Invalid? → Show Error Message → Stop
    │
    ▼
[Call Payment Server]
    │
    ├─→ Network Error? → Show "Server Unreachable" → Allow Retry
    │
    ▼
[Server Processes]
    │
    ├─→ Invalid Credentials? → Log error → Show "Payment Failed"
    │
    ├─→ M-Pesa API Error? → Log error → Show specific error
    │
    ▼
[STK Prompt Sent]
    │
    ├─→ Customer Cancels? → paymentRequests status: failed
    │
    ├─→ Wrong PIN? → M-Pesa ResultCode: 1 → transaction failed
    │
    ├─→ Insufficient Balance? → M-Pesa ResultCode: 1 → transaction failed
    │
    ▼
[M-Pesa Callback]
    │
    ├─→ ResultCode: 0 → Success → Mark booking as paid
    │
    ├─→ ResultCode: != 0 → Failure → Keep booking as unpaid
    │
    └─→ No Callback → (Shouldn't happen) → Manual status check available
```

---

This comprehensive architecture ensures:
✅ Clear separation of concerns
✅ Atomic database transactions
✅ Proper error handling
✅ Real-time updates
✅ Secure payment processing
