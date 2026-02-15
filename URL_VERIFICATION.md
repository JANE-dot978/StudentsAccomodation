# URL Verification Checklist

## Your Current Configuration

### ✅ CORRECT URL
```
http://192.168.1.66:8080
```

**Breakdown:**
- Protocol: `http://` (not https for local development)
- IP Address: `192.168.1.66` (your computer's network IP)
- Port: `8080` (where M-Pesa backend server runs)

### ❌ INCORRECT URLS (do NOT use these)
```
http://192.168.i.66.808    ← WRONG (has letter 'i' instead of '1', and '.808' instead of ':8080')
http://localhost:8080      ← WRONG (only works on same computer, not on phone/emulator)
http://127.0.0.1:8080      ← WRONG (same as localhost, doesn't work on phone)
https://192.168.1.66:8080  ← WRONG (should be http, not https for local dev)
```

---

## Current Status in Code

### File: `checkout_payment_screen.dart` (Line 18)
```dart
final PaymentService _paymentService = PaymentService(baseUrl: 'http://192.168.1.66:8080');
```

✅ **This is CORRECT**

---

## Troubleshooting Your Error

### Error Message
```
payment error: client exemption: failed to fetch url=http://192.168.i.66.808...
```

This suggests your URL got corrupted somewhere. Possible causes:

#### Cause 1: Copy-Paste Error
- You may have mistyped it when copying
- The number "1" looks like letter "i" in some fonts
- ".8080" might have been typed as ".808" with missing digit

#### Cause 2: The URL is Being Modified Somewhere
- Check if there's another place in code using a different URL
- The PaymentService might have multiple instances

#### Cause 3: Backend Server Not Running
- Even with correct URL, if server isn't running, you get "failed to fetch"
- The URL format error might be secondary issue

---

## How to Fix

### Step 1: Verify Your Computer's IP
Open Command Prompt and run:
```cmd
ipconfig
```

Look for line starting with "IPv4 Address" under your network adapter.
- **Expected**: 192.168.1.66 (or similar like 192.168.1.x)
- **Unexpected**: 127.0.0.1 (that's localhost, won't work)

### Step 2: Confirm Correct Code
The code in `checkout_payment_screen.dart` line 18 should be EXACTLY:
```dart
final PaymentService _paymentService = PaymentService(baseUrl: 'http://192.168.1.66:8080');
```

Character by character:
- `h t t p : / / 1 9 2 . 1 6 8 . 1 . 6 6 : 8 0 8 0`
- NOT: `h t t p : / / 1 9 2 . 1 6 8 . i . 6 6 . 8 0 8`

### Step 3: Start Backend Server
Open Command Prompt and run:
```cmd
cd c:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa
node index.js
```

You should see:
```
M-Pesa Server listening on port 8080
```

If you see "command not found" for node, install Node.js from nodejs.org

### Step 4: Run Flutter App
In VS Code terminal:
```bash
flutter clean
flutter pub get
flutter run
```

### Step 5: Test Payment
1. Log in as student
2. Go to Payment History
3. Click "Proceed to Payment"
4. Enter M-Pesa phone (0712345678)
5. Click "Send STK Prompt"

---

## If Still Getting Error

Share these details:
1. **Your IP from ipconfig**: What is it showing?
2. **Server status**: Is it running? Any error messages?
3. **Exact error message**: Copy-paste the full error text
4. **Where you see error**: In app toast? In console? In dialog?

---

## Testing Connection

### Test 1: Ping Server (from your computer)
```cmd
ping 192.168.1.66
```
Should respond (proves IP works)

### Test 2: Test URL (from phone/emulator)
Try opening in browser:
```
http://192.168.1.66:8080
```
Should show something (or 404 if endpoint doesn't exist)

### Test 3: Check Firewall
Windows might be blocking port 8080. If so:
1. Go to Windows Defender Firewall
2. Click "Allow an app through firewall"
3. Add Node.js to the allowed list

---

## Server Configuration

### File: `server/.env`
```
PORT=8080
MPESA_ENV=sandbox
MPESA_CONSUMER_KEY=MdO5x7PDxlWZNwGcZA4xjGa3pjL0TJZFfFzaYfZUYLtQh8Dx
MPESA_CONSUMER_SECRET=p0npGLbEcNyJ8O3Sa1Dppn6UJLK6JMmJH21qOZxY2yRuKikBqPxhf4ZADMXXcnwF
MPESA_SHORTCODE=174379
MPESA_PASSKEY=bfb279f9aa9bdbcf158e97dd71a467cd2e0c893059b10f78e6b72ada1ed2c919
```

All values are already configured ✅

---

## Summary

| Item | Status | Value |
|------|--------|-------|
| IP Address | ✅ Correct | 192.168.1.66 |
| Port | ✅ Correct | 8080 |
| Full URL | ✅ Correct | http://192.168.1.66:8080 |
| Code URL | ✅ Correct | checkout_payment_screen.dart line 18 |
| M-Pesa Credentials | ✅ Configured | server/.env |
| Backend Server | ❌ Need to verify | Not running? |

**Most likely issue**: Backend server is not running or Node.js is not installed.

Next step: **Start the server and share the output/error messages**
