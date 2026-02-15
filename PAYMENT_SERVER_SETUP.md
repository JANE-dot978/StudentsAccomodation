# Payment Server Setup & Configuration

## Problem
You're getting: **"Payment error: client exemption: failed to fetch url=http://localhost:8080/m..."**

## Root Cause
- The Flutter app is trying to reach `http://localhost:8080` which only works on your computer
- Mobile devices/emulators can't access localhost - they need your actual IP address
- Your computer's IP is: **192.168.1.66**
- The backend server is NOT running on port 8080

## Solution: 3 Steps

### Step 1: Prepare the Backend Server

1. Open PowerShell as Administrator
2. Run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```
(This temporarily allows running scripts - needed for npm)

3. Navigate to server folder:
```powershell
cd c:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa
```

4. Install dependencies:
```powershell
npm install
```

This installs: express, axios, dotenv, firebase-admin, body-parser

### Step 2: Start the Backend Server

**Option A: Using Command Prompt (Easiest)**
```cmd
cd c:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa
node index.js
```

**Option B: Using the Batch File**
1. Double-click: `START_SERVER.bat` (in project root)
2. A command window will open with the server running

**Option C: Using VS Code Terminal**
1. Open Terminal in VS Code
2. Run:
```bash
cd server/mpesa
node index.js
```

### Step 3: Flutter App Already Updated

✅ **Done!** The checkout payment screen is now configured to use: `http://192.168.1.66:8080`

This means:
- Your mobile device/emulator can now reach the backend server
- Payment requests will go to your computer
- M-Pesa STK push will work

---

## Testing the Setup

### Check 1: Server is Running
You should see output like:
```
M-Pesa Server running on port 8080
All dependencies loaded successfully
```

### Check 2: Network Connection
From your mobile device/emulator:
1. Try opening: `http://192.168.1.66:8080/health` (if endpoint exists)
2. Or just test by attempting payment

### Check 3: M-Pesa Connection
The server logs should show:
```
Initiating STK Push...
Authorization: Bearer [token]
Phone: [number]
Amount: [amount]
```

---

## If Server Doesn't Start

### Error 1: Module not found
```
Error: Cannot find module 'express'
```
**Fix**: Run `npm install` first

### Error 2: Port 8080 already in use
```
Error: listen EADDRINUSE: address already in use :::8080
```
**Fix**: 
- Close other apps using port 8080
- Or change port in `.env` file to `8081` (then update Flutter app too)

### Error 3: Firebase credentials not found
```
Error: ENOENT: no such file or directory, open 'serviceAccountKey.json'
```
**Fix**: 
- Download Firebase service account JSON
- Place it in `server/mpesa/serviceAccountKey.json`
- Or set `GOOGLE_APPLICATION_CREDENTIALS` environment variable

### Error 4: Missing .env file
```
Error: PORT not defined
```
**Fix**: Copy `.env.example` to `.env` and fill in M-Pesa credentials

---

## Configuration Details

### Your M-Pesa Setup
All credentials are in `server/.env`:
- **Consumer Key**: ✅ Configured
- **Consumer Secret**: ✅ Configured  
- **Short Code**: 174379 (Test)
- **Pass Key**: ✅ Configured
- **Environment**: Sandbox (testing)

### Server Configuration
- **Port**: 8080
- **IP**: 192.168.1.66
- **URL Base**: `http://192.168.1.66:8080`
- **Endpoints**:
  - POST `/mpesa/initiate-payment` - Start STK push
  - POST `/mpesa/check-payment-status` - Check if paid
  - POST `/mpesa/callback` - Receives payment confirmation from M-Pesa

### Flutter App Configuration
- **Payment Service**: ✅ Updated to use 192.168.1.66:8080
- **File**: `lib/screens/student/checkout_payment_screen.dart`
- **BaseURL**: `http://192.168.1.66:8080`

---

## Complete Payment Flow

```
1. Student logs in ✅
2. Student books a hostel room ✅
3. Landlord approves booking ✅
4. Student goes to Payment History ✅
5. Student clicks "Proceed to Payment" ✅
6. Student enters M-Pesa phone number ✅
7. Student clicks "Send STK Prompt"
   ↓
8. Flutter app sends request to: http://192.168.1.66:8080/mpesa/initiate-payment
9. Backend server processes request
10. Backend gets M-Pesa access token
11. Backend sends STK push to M-Pesa
12. M-Pesa sends prompt to student's phone
13. Student enters PIN on phone
14. M-Pesa sends callback to backend
15. Backend updates booking.isPaid = true
16. Student sees "Payment Successful" ✅
```

---

## Testing Checklist

Before testing payment:

- [ ] Backend server is running (`node index.js`)
- [ ] Server shows "listening on port 8080"
- [ ] Flutter app has correct IP: 192.168.1.66
- [ ] Student account has logged in
- [ ] Booking is approved by landlord
- [ ] Payment history shows "Proceed to Payment" button
- [ ] Valid M-Pesa phone number entered (0712345678 or 254712345678)
- [ ] Internet connection is stable

---

## Troubleshooting Payment Flow

**"Failed to fetch" Error**
→ Check if server is running on correct port
→ Verify IP address 192.168.1.66 is correct (run `ipconfig`)
→ Check firewall isn't blocking port 8080

**"Invalid phone number" Error**
→ Use format: 0712345678 or 254712345678
→ Phone must be registered with M-Pesa

**"STK push not received" Error**
→ Check M-Pesa sandbox credentials in .env
→ Verify M-Pesa account has balance
→ Check callback URL in .env is correct

**"Payment successful but booking not updated" Error**
→ Check server logs for callback processing
→ Verify Firebase permissions for updating bookings
→ Check if callback URL is reachable by M-Pesa

---

## Important Notes

1. **Localhost vs IP**: 
   - Localhost (127.0.0.1) only works on same computer
   - 192.168.1.66 works from any device on the network
   - Replace 192.168.1.66 if your IP changes

2. **Firewall**: 
   - Windows Firewall may block port 8080
   - Allow Node.js in firewall if prompted

3. **Router**: 
   - Mobile device must be on same WiFi network
   - Or use USB tethering

4. **Testing on Physical Device**:
   - Device must be on same network as your computer
   - Use WiFi, not mobile data
   - Test with: `ping 192.168.1.66` from device

5. **M-Pesa Sandbox**:
   - Sandbox is for testing only
   - Real money is not deducted
   - Switch to production when ready

---

## Next Steps

1. ✅ Start the backend server
2. ✅ Keep it running while testing
3. ✅ Test payment flow from start to finish
4. ✅ Check server logs for any errors
5. ✅ Share server output if payment fails

Server should show successful payment requests like:
```
[PAYMENT] Phone: 0712345678
[PAYMENT] Amount: 5000
[TOKEN] Authorization successful
[STK] Pushing to 0712345678
[CALLBACK] Payment received: SUCCESS
```
