# File Directory & What to Look At

## Documentation Files (Start Here)

### Quick References
- 📄 **[QUICK_START.md](QUICK_START.md)** - Start here! 5-minute setup guide
- 📄 **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - What was implemented
- 📄 **[TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)** - How to test everything

### Detailed Documentation
- 📄 **[BOOKING_PAYMENT_WORKFLOW.md](BOOKING_PAYMENT_WORKFLOW.md)** - Complete workflow details
- 📄 **[ARCHITECTURE.md](ARCHITECTURE.md)** - System diagrams and architecture
- 📄 **[PAYMENT_SETUP.md](PAYMENT_SETUP.md)** - Detailed setup and API reference

---

## Code Files - What Changed

### 🆕 NEW FILES

#### Flutter UI
- **[lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart)**
  - ✅ NEW checkout payment screen
  - ✅ Phone number input
  - ✅ Payment summary display
  - ✅ STK push initiation
  - 🔧 Main file for payment UX

### 📝 MODIFIED FILES

#### Flutter UI Updates
- **[lib/screens/student/payment_history_screen.dart](lib/screens/student/payment_history_screen.dart)**
  - Modified: Added import for `CheckoutPaymentScreen`
  - Modified: Added "Proceed to Payment" button (lines ~280-310)
  - Shows only for: `booking.status == 'approved' && !booking.isPaid`
  - 🔧 Where students see "Proceed to Payment" button

#### Configuration
- **[server/.env](server/.env)**
  - ✅ NEW file created with your credentials
  - Contains: All M-Pesa credentials and configuration
  - Location: Root of server directory
  - 🔧 Used by: `npm start` to connect to M-Pesa

- **[server/.env.example](server/.env.example)**
  - Modified: Updated with your credentials
  - Purpose: Template/reference file
  - 🔧 Shows what goes in `.env`

### ✅ EXISTING FILES (No changes, but important)

#### Services & Providers
- **[lib/services/payment_service.dart](lib/services/payment_service.dart)**
  - Used by: `checkout_payment_screen.dart`
  - Has: `initiateSTKPush()` method
  - 🔧 Don't modify - already working

- **[lib/services/booking_service.dart](lib/services/booking_service.dart)**
  - Has: `updatePaymentStatus()` method
  - 🔧 Used for marking bookings as paid

- **[lib/providers/booking_provider.dart](lib/providers/booking_provider.dart)**
  - Has: Payment status update logic
  - 🔧 Provides state management for bookings

#### Models
- **[lib/models/booking_model.dart](lib/models/booking_model.dart)**
  - Fields: `isPaid`, `paidAt`, `status`
  - 🔧 Data structure for bookings

#### Backend Server
- **[server/mpesa/index.js](server/mpesa/index.js)**
  - Has: All endpoints and M-Pesa logic
  - Endpoints:
    - `/mpesa/initiate-payment` - Start STK push
    - `/mpesa/callback` - Webhook from M-Pesa
    - `/mpesa/check-payment-status` - Query status
    - `/mpesa/simulate` - Test endpoint
  - 🔧 The payment server - run with `npm start`

---

## Project Structure

```
studentsaccomodations/
│
├── 📚 Documentation Files
│   ├── QUICK_START.md ..................... ⭐ Start here
│   ├── IMPLEMENTATION_SUMMARY.md
│   ├── TESTING_CHECKLIST.md
│   ├── BOOKING_PAYMENT_WORKFLOW.md
│   ├── ARCHITECTURE.md
│   ├── PAYMENT_SETUP.md
│   └── FILES_INDEX.md (this file)
│
├── 📱 Flutter App
│   ├── lib/
│   │   ├── screens/
│   │   │   ├── student/
│   │   │   │   ├── checkout_payment_screen.dart ........... 🆕 NEW
│   │   │   │   ├── payment_history_screen.dart ............ 📝 MODIFIED
│   │   │   │   └── booking_screen.dart
│   │   │   ├── landlord/
│   │   │   └── admin/
│   │   │
│   │   ├── services/
│   │   │   ├── payment_service.dart ✅ (no changes needed)
│   │   │   ├── booking_service.dart ✅ (has updatePaymentStatus)
│   │   │   └── ...
│   │   │
│   │   ├── providers/
│   │   │   ├── booking_provider.dart ✅ (has payment methods)
│   │   │   └── ...
│   │   │
│   │   ├── models/
│   │   │   ├── booking_model.dart ✅ (has isPaid, paidAt)
│   │   │   └── ...
│   │   │
│   │   ├── main.dart
│   │   ├── app.dart
│   │   └── ...
│   │
│   ├── pubspec.yaml
│   ├── firebase.json
│   └── ...
│
├── 🖥️ Backend Server
│   ├── server/
│   │   ├── mpesa/
│   │   │   └── index.js ✅ (has all endpoints)
│   │   │
│   │   ├── .env ........................... 🆕 NEW - YOUR CREDENTIALS
│   │   ├── .env.example .................. 📝 UPDATED
│   │   ├── package.json
│   │   └── ...
│   │
│   └── mpesa/ (legacy, use server/)
│
├── 🔧 Configuration
│   ├── firestore.rules (Firestore security)
│   ├── analysis_options.yaml
│   └── ...
│
└── 📦 Build/Dependencies
    ├── build/
    ├── .dart_tool/
    ├── node_modules/ (in server/)
    └── ...
```

---

## Reading Order (for Understanding)

### 1️⃣ First Time? Start Here
1. Read: **[QUICK_START.md](QUICK_START.md)** (5 min)
2. Read: **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** (10 min)
3. Run: `cd server && npm start`

### 2️⃣ Understanding the Flow
1. Review: **[ARCHITECTURE.md](ARCHITECTURE.md)** - See the diagrams
2. Read: **[BOOKING_PAYMENT_WORKFLOW.md](BOOKING_PAYMENT_WORKFLOW.md)** - Detailed workflow

### 3️⃣ Testing & Troubleshooting
1. Follow: **[TESTING_CHECKLIST.md](TESTING_CHECKLIST.md)** - Step-by-step tests
2. Refer: **[PAYMENT_SETUP.md](PAYMENT_SETUP.md)** - If issues arise

### 4️⃣ Code Deep Dive
1. Open: **[lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart)** (282 lines)
   - Understand: UI layout, phone input, STK push initiation
   
2. Open: **[lib/screens/student/payment_history_screen.dart](lib/screens/student/payment_history_screen.dart)**
   - Understand: Where "Proceed to Payment" button appears
   - Find: Lines with `if (booking.status == 'approved' && !booking.isPaid)`

3. Open: **[server/mpesa/index.js](server/mpesa/index.js)** (467 lines)
   - Understand: `/mpesa/initiate-payment` endpoint (line ~158)
   - Understand: `/mpesa/callback` endpoint (line ~247)

---

## Key Code Snippets - Where to Look

### STK Push Initiation
**File**: [lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart) - Line ~75
```dart
final result = await _paymentService.initiateSTKPush(
  bookingId: widget.booking.id,
  phoneNumber: _phoneController.text,
  amount: widget.booking.amount,
);
```

### Show Payment Button
**File**: [lib/screens/student/payment_history_screen.dart](lib/screens/student/payment_history_screen.dart) - Line ~280
```dart
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
    // ...
  );
}
```

### Payment Callback
**File**: [server/mpesa/index.js](server/mpesa/index.js) - Line ~247
```javascript
app.post('/mpesa/callback', async (req, res) => {
  // Extract callback data
  // Validate ResultCode
  // Update Firestore atomically
  // Decrement available rooms
});
```

### Server Start
**File**: [server/mpesa/index.js](server/mpesa/index.js) - Line ~450
```javascript
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
```

---

## Files to Edit for Customization

### Change UI
- **Payment button color**: [payment_history_screen.dart](lib/screens/student/payment_history_screen.dart#L290) - Change `Colors.green.shade600`
- **Phone placeholder**: [checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart#L95) - Change `hintText`
- **Success message**: [checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart#L70) - Change dialog text

### Change Behavior
- **Payment amount limits**: [server/mpesa/index.js](server/mpesa/index.js#L183) - Change validation range
- **Callback URL**: [server/.env](server/.env#L13) - Update to your URL
- **Server port**: [server/.env](server/.env#L19) - Change `PORT=8080`

### Add Features
- **Payment history export**: Add to [payment_history_screen.dart](lib/screens/student/payment_history_screen.dart)
- **Receipt printing**: Add to [checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart)
- **Payment notifications**: Modify [server/mpesa/index.js](server/mpesa/index.js) callback handler

---

## Testing Files

### Run Tests
```bash
# Terminal 1: Start server
cd server
npm start

# Terminal 2: Run Flutter app
flutter run

# Terminal 3: Simulate payment
curl -X POST http://localhost:8080/mpesa/simulate \
  -H "Content-Type: application/json" \
  -d '{"bookingId": "YOUR_ID", "success": true}'
```

### Firestore Inspection
- Go to: [Firebase Console](https://console.firebase.google.com)
- Navigate: Firestore Database
- Collections to check:
  - `bookings` - Check status, isPaid, paidAt
  - `paymentRequests` - Check payment tracking
  - `hostels` - Check availableRooms decreased

### Server Logs
```bash
# See real-time logs in terminal where you ran:
npm start

# Look for:
# - "STK push initiation..."
# - "MPesa callback received..."
# - "Payment processed successfully..."
```

---

## Support Quick Links

### Documentation
- 📖 [PAYMENT_SETUP.md](PAYMENT_SETUP.md) - Detailed setup guide
- 📖 [BOOKING_PAYMENT_WORKFLOW.md](BOOKING_PAYMENT_WORKFLOW.md) - Complete workflow
- 📖 [ARCHITECTURE.md](ARCHITECTURE.md) - System design

### Code References
- 💻 [checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart) - UI code
- 💻 [payment_service.dart](lib/services/payment_service.dart) - Payment client
- 💻 [server/mpesa/index.js](server/mpesa/index.js) - Payment backend

### Testing
- ✅ [TESTING_CHECKLIST.md](TESTING_CHECKLIST.md) - How to test
- ✅ [QUICK_START.md](QUICK_START.md) - Quick test steps

---

## Deployment Checklist

### Before Production
- [ ] Review: [PAYMENT_SETUP.md](PAYMENT_SETUP.md#production-deployment)
- [ ] Update: Production credentials in `.env`
- [ ] Change: `MPESA_ENV=production` in `.env`
- [ ] Deploy: Server to cloud (Heroku/Google Cloud)
- [ ] Update: `CALLBACK_URL` in `.env`
- [ ] Update: Flutter app baseUrl
- [ ] Test: With small real transaction
- [ ] Monitor: [Firebase Console](https://console.firebase.google.com)

---

## Quick Navigation

| Need Help With | Go To |
|---|---|
| **Getting Started** | [QUICK_START.md](QUICK_START.md) |
| **Complete Workflow** | [BOOKING_PAYMENT_WORKFLOW.md](BOOKING_PAYMENT_WORKFLOW.md) |
| **System Design** | [ARCHITECTURE.md](ARCHITECTURE.md) |
| **Testing** | [TESTING_CHECKLIST.md](TESTING_CHECKLIST.md) |
| **Detailed Setup** | [PAYMENT_SETUP.md](PAYMENT_SETUP.md) |
| **Checkout UI** | [checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart) |
| **Show Button** | [payment_history_screen.dart](lib/screens/student/payment_history_screen.dart) |
| **Server** | [server/mpesa/index.js](server/mpesa/index.js) |
| **What Changed** | [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md) |

---

**Start with [QUICK_START.md](QUICK_START.md) - you'll be running in 5 minutes!** 🚀
