# Backend Server Ready - Quick Start Guide

## ✅ Firebase Credentials Fixed

Your `serviceAccountKey.json` is now in the correct location:
```
server/mpesa/serviceAccountKey.json
```

## Starting the Backend Server

### Option 1: Using the Batch File (EASIEST)

1. **Open File Explorer**
2. Navigate to: `c:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa\`
3. **Double-click**: `start_server.bat`
4. A command window will open
5. Wait for it to show: **"M-Pesa Server listening on port 8080"**
6. **Leave this window open** while testing payments

### Option 2: Using Command Prompt (CMD)

1. **Open Command Prompt** (Windows key + R, type `cmd`, press Enter)
2. Run these commands:
```cmd
cd c:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa
npm install
node index.js
```

3. You should see:
```
Firebase initialized successfully
M-Pesa Server listening on port 8080
```

4. **Leave open while testing**

### Option 3: Using VS Code Terminal

1. **Open VS Code**
2. **Open Terminal** (Ctrl + `)
3. Make sure you're in project root
4. Run:
```bash
cd server/mpesa
npm install
node index.js
```

---

## Verification Checklist

After server starts, verify:

- [ ] No error messages in terminal
- [ ] Shows: "Firebase initialized successfully"
- [ ] Shows: "M-Pesa Server listening on port 8080"
- [ ] No red error text

---

## Testing Payment End-to-End

Once server is running:

### Step 1: In Flutter App
1. **Log in as student** (if not already)
2. **Go to Payment History**
3. Find an approved booking (one that landlord already approved)
4. Click **"Proceed to Payment"**

### Step 2: Enter Payment Details
1. **Enter M-Pesa phone number** (format: 0712345678 or 254712345678)
2. **Enter amount** (should auto-fill from booking)
3. Click **"Send STK Prompt"**

### Step 3: Check Server Terminal
You should see output like:
```
[INFO] Initiating STK Push
[INFO] Phone: 0712345678
[INFO] Amount: 5000
[INFO] Booking ID: xxxxx
[REQUEST] POST /mpesa/initiate-payment
[SUCCESS] STK push sent
```

### Step 4: Check Your Phone
Within seconds, you should receive an **M-Pesa STK prompt** on your phone:
- Shows the amount
- Shows the merchant (Daraja Testing)
- Prompts for PIN

### Step 5: Complete Payment
1. **Enter your M-Pesa PIN** on the phone prompt
2. **Wait for confirmation** (may take 10-30 seconds)

### Step 6: Check App
You should see:
- **"Payment Successful"** message
- Booking shows **"Paid"** status
- Hostel **available rooms decreased by 1**

---

## Server Terminal Output Guide

### ✅ Success Indicators
```
Firebase initialized successfully
M-Pesa Server listening on port 8080

[REQUEST] POST /mpesa/initiate-payment
[INFO] Phone: 0712345678
[TOKEN] Authorization: Bearer eyJhbG...
[STK] Pushing to Safaricom sandbox
[SUCCESS] CheckoutRequestID: ws_CO_160120231234567
```

### ❌ Error Indicators
```
Error: Cannot find module 'dotenv'
→ Solution: Run 'npm install' first

Error: ENOENT: no such file or directory, open 'serviceAccountKey.json'
→ Solution: Verify serviceAccountKey.json is in server/mpesa/ folder

Error: Port 8080 already in use
→ Solution: Close other apps using port 8080

Error: credential failed
→ Solution: Verify serviceAccountKey.json credentials are correct
```

---

## Troubleshooting

### Issue 1: "npm: command not found"
**Cause**: Node.js not installed
**Fix**: Install Node.js from https://nodejs.org/ (LTS version)

### Issue 2: "Cannot find module 'express'"
**Cause**: Dependencies not installed
**Fix**: Run `npm install` in the server/mpesa folder

### Issue 3: "Port 8080 already in use"
**Cause**: Another program using the port
**Fix**: 
- Find what's using it: `netstat -ano | findstr :8080`
- Kill it or use different port

### Issue 4: "EACCES: permission denied"
**Cause**: Permission issue
**Fix**: 
- Run Command Prompt as Administrator
- Or change port in .env file

### Issue 5: Payment fails in app but server shows success
**Cause**: Firestore permissions or booking update issue
**Fix**: Check Firestore rules in Firebase Console

### Issue 6: STK not received on phone
**Cause**: 
- Phone number format wrong
- M-Pesa sandbox not activated
- Credentials expired
**Fix**:
- Use format: 0712345678 or 254712345678
- Verify M-Pesa sandbox account active
- Check credentials in .env

---

## File Locations Reference

| File | Location | Purpose |
|------|----------|---------|
| serviceAccountKey.json | `server/mpesa/` | Firebase credentials ✅ DONE |
| .env | `server/mpesa/` | M-Pesa credentials ✅ CONFIGURED |
| index.js | `server/mpesa/` | Backend server code ✅ READY |
| package.json | `server/mpesa/` | Dependencies list ✅ READY |
| start_server.bat | `server/mpesa/` | Easy startup script ✅ CREATED |

---

## Next Steps

1. **Double-click** `start_server.bat` (in server/mpesa folder)
2. **Wait** for "listening on port 8080" message
3. **Keep terminal open** while testing
4. **Test payment** from Flutter app
5. **Share any errors** if payment fails

---

## Quick Commands Reference

```cmd
# Install dependencies
npm install

# Start server
node index.js

# Check if port is in use
netstat -ano | findstr :8080

# Kill process on port (replace PID with actual PID)
taskkill /PID <PID> /F
```

---

## Important Notes

- ✅ serviceAccountKey.json is now in correct location
- ✅ M-Pesa credentials are configured in .env
- ✅ Flutter app is configured to use http://192.168.1.66:8080
- ✅ Firebase database is ready to accept updates
- ⏳ Next: Start the server and test payments

**You're ready to test payments!** 🚀
