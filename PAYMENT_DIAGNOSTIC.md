# Payment System Diagnostic Guide

## ⚠️ Issue: "Failed to fetch URL: http://192.168.1.66:8080/mpesa-initiate"

This error means the Flutter app **cannot connect to your payment server**. Follow these steps:

---

## Step 1: Verify Server is Running

### Option A: Check via Terminal
```powershell
# Test if server is listening on port 8080
netstat -ano | findstr :8080
```
- If you see a process listening on 8080, the server is running ✅
- If nothing appears, the server is **NOT running** ❌

### Option B: Start the Server
```powershell
# Navigate to server directory
cd "C:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa"

# Start the server
node index.js
```

You should see:
```
=== M-Pesa Webhook Server ===
Running on port 8080
Environment: sandbox
Callback URL: http://192.168.1.66:8080/mpesa/callback
```

---

## Step 2: Verify Network Connectivity

### A. Server can accept connections
Open a terminal and test:
```powershell
# Test if server responds (Windows)
curl http://192.168.1.66:8080/test -v

# OR using Invoke-WebRequest (PowerShell)
Invoke-WebRequest -Uri http://192.168.1.66:8080/test -Verbose
```

**Expected Response:**
```json
{
  "status": "ok",
  "message": "Server is reachable",
  "serverUrl": "http://192.168.1.66:8080"
}
```

### B. Verify IP Address
Make sure `192.168.1.66` is correct:
```powershell
# Get your computer's IP address
ipconfig | findstr "IPv4"
```

If your IP is **different**, you need to:
1. Update [server_config.json](server_config.json) with the correct IP
2. Update [lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart) line 18
3. Update [server/.env](server/.env) CALLBACK_URL

---

## Step 3: Check Flutter App Configuration

### Verify PaymentService URL (Line 18)
[lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart#L18)
```dart
final PaymentService _paymentService = PaymentService(baseUrl: 'http://192.168.1.66:8080');
```

✅ This is correct - it uses `http://192.168.1.66:8080` not `localhost`

---

## Step 4: Common Issues & Solutions

### ❌ "Connection Refused"
**Causes:**
1. Server is not running
2. Server crashed during startup
3. Wrong port number

**Fix:**
```powershell
# Start server with debug output
cd server\mpesa
node index.js
```

### ❌ "Connection Timeout"
**Causes:**
1. Wrong IP address
2. Firewall blocking port 8080
3. Network connectivity issue

**Fix:**
```powershell
# Check if port 8080 is blocked by firewall
# Temporarily disable firewall OR add exception for port 8080

# Verify IP is correct
ipconfig
```

### ❌ "404 Not Found"
**Causes:**
1. Server is running but endpoint doesn't exist
2. URL path is wrong

**Fix:**
- Verify endpoint: `POST /mpesa/initiate-payment`
- Check server logs for error messages

### ❌ "M-Pesa Credentials Error"
**Causes:**
1. `.env` file not loaded
2. Invalid credentials in `.env`

**Fix:**
```powershell
# Check server logs - look for auth errors
# Verify .env file exists at: server\mpesa\.env
```

---

## Step 5: Debug Mode - Add Logging

### In Flutter App
Add this to [checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart#L40) in `_initiatePayment()`:

```dart
print('[DEBUG] Initiating payment to: http://192.168.1.66:8080/mpesa/initiate-payment');
print('[DEBUG] Phone: ${_phoneController.text}');
print('[DEBUG] Amount: ${widget.booking.amount}');
print('[DEBUG] Booking ID: ${widget.booking.id}');

try {
  final result = await _paymentService.initiateSTKPush(
    bookingId: widget.booking.id,
    phoneNumber: _phoneController.text,
    amount: widget.booking.amount,
    description: 'Room booking for ${widget.booking.roomType}',
  );
  print('[DEBUG] Payment result: $result');
  // ...
} catch (e) {
  print('[ERROR] Payment failed: $e');
  print('[ERROR] Stack trace: ${e.toString()}');
}
```

### In Node.js Server
Look for logs starting with `[PAYMENT]`:
```
[PAYMENT] New payment request received
[PAYMENT] Request body: {...}
[PAYMENT] Validation passed - Initiating STK push...
```

---

## Quick Checklist

- [ ] Server is running on `http://192.168.1.66:8080`
- [ ] `curl http://192.168.1.66:8080/test` returns 200 OK
- [ ] IP address `192.168.1.66` is correct (run `ipconfig`)
- [ ] `.env` file exists at `server\mpesa\.env`
- [ ] Flutter app URL is `http://192.168.1.66:8080` (not localhost)
- [ ] Node.js dependencies installed (`node_modules` folder exists)
- [ ] Firewall allows port 8080
- [ ] Phone number format is valid (0712345678 or 254712345678)

---

## Next Steps

1. **Is the server running?** → Run: `cd server\mpesa && node index.js`
2. **Can you ping the server?** → Run: `curl http://192.168.1.66:8080/test`
3. **Is the IP correct?** → Run: `ipconfig`
4. **Still failing?** → Share the error message from server logs
