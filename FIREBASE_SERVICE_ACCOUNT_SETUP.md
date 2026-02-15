# Firebase Setup for M-Pesa Backend Server

## The Issue

Your backend server needs to authenticate with Firebase to:
1. Accept payment callbacks from M-Pesa
2. Update booking status to "paid"
3. Decrement available rooms

**Missing file**: `server/mpesa/serviceAccountKey.json`

This file contains Firebase credentials that the backend server uses.

---

## Solution: Download Firebase Service Account Key

### Step 1: Go to Firebase Console
1. Open: https://console.firebase.google.com
2. Select your project: **studentsaccomodations**
3. Click the **⚙️ Settings icon** (top left)
4. Select **Project settings**

### Step 2: Navigate to Service Accounts
1. Click the **Service Accounts** tab
2. You should see three tabs: General, Service Accounts, **Your apps**
3. Make sure you're on **Service Accounts** tab

### Step 3: Generate New Private Key
1. Click the language dropdown and select **Node.js** (it should already be selected)
2. Click the blue button: **Generate New Private Key**
3. A JSON file will download to your computer
4. Name it: `serviceAccountKey.json`

### Step 4: Place the File
1. Move/copy the downloaded file to:
   ```
   c:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa\serviceAccountKey.json
   ```

2. The path should look like:
   ```
   server/
   └── mpesa/
       ├── serviceAccountKey.json    ← Put it here
       ├── index.js
       ├── package.json
       └── .env
   ```

### Step 5: Verify File Exists
Open File Explorer and navigate to `studentsaccomodations\server\mpesa\`
You should see `serviceAccountKey.json` in the folder.

---

## What's in the Service Account Key?

The JSON file contains:
```json
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "...",
  "private_key": "...",
  "client_email": "firebase-adminsdk-xxxx@your-project-id.iam.gserviceaccount.com",
  "client_id": "...",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "...",
  "client_x509_cert_url": "..."
}
```

This allows the backend to:
- ✅ Read from Firestore
- ✅ Write to Firestore
- ✅ Update booking documents
- ✅ Process payment callbacks

---

## Firebase Permissions (Already Configured)

Your Firestore security rules allow the backend to update bookings:

```firestore
match /bookings/{bookingId} {
  allow update: if request.auth != null;
  // Backend server (authenticated via service account) can update
}
```

---

## Complete Backend Setup Checklist

After downloading the service account key:

- [ ] File exists: `server/mpesa/serviceAccountKey.json`
- [ ] M-Pesa credentials configured in `.env`
- [ ] Backend dependencies installed: `npm install`
- [ ] Backend server starts without errors: `node index.js`
- [ ] Server shows: "Firebase initialized successfully"

---

## Starting the Backend Now

Once you have the service account key:

1. **Open Command Prompt**:
   ```cmd
   cd c:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa
   npm install
   node index.js
   ```

2. **You should see**:
   ```
   Firebase initialized successfully
   M-Pesa Server listening on port 8080
   ```

3. **Leave it running** while you test payments

---

## Testing Payment Flow with Firebase

Once server is running:

1. **Log in as student** in Flutter app
2. **Create a booking** for a hostel
3. **Landlord approves** the booking
4. **Student goes to Payment History**
5. **Click "Proceed to Payment"**
6. **Enter M-Pesa phone number**
7. **Click "Send STK Prompt"**

**What happens**:
- Flutter app sends request to: `http://192.168.1.66:8080/mpesa/initiate-payment`
- Backend server processes the request
- Backend calls M-Pesa API
- M-Pesa sends STK push to your phone
- You enter PIN
- M-Pesa calls backend callback: `/mpesa/callback`
- Backend updates Firebase booking: `status = "approved"`, `isPaid = true`
- Backend decrements hostel: `availableRooms -= 1`
- You see "Payment Successful" in app

---

## Firebase Configuration Required

Your Firebase project already has:
✅ Firestore database
✅ Bookings collection
✅ Users collection
✅ Security rules allowing updates

**What you're adding now**:
✅ Service account credentials for backend authentication

---

## If It Still Doesn't Work

### Error 1: "Cannot find module 'firebase-admin'"
```
npm ERR! ERR! code ERESOLVE
```
**Fix**: Run `npm install` in `server/mpesa` folder

### Error 2: "ENOENT: no such file or directory, open 'serviceAccountKey.json'"
```
Error: ENOENT: no such file or directory
```
**Fix**: Download and place the service account key file (this section)

### Error 3: "Credentials are not available"
```
Error: Credentials are not available, please check the validity of the ...
```
**Fix**: Check service account JSON file is valid and has correct permissions

### Error 4: "Permission denied" when updating booking
```
Error: 7 PERMISSION_DENIED: Missing or insufficient permissions
```
**Fix**: Check Firestore rules in Firebase Console → Firestore → Rules tab

---

## Quick Reference

| Component | Status | Action |
|-----------|--------|--------|
| Firebase Project | ✅ Created | None |
| Firestore Database | ✅ Created | None |
| Firestore Rules | ✅ Deployed | None |
| Service Account Key | ❌ Missing | **Download it now** |
| Backend Server | ❌ Not running | Run after key is placed |
| Flutter App URL | ✅ Configured | None |
| M-Pesa Credentials | ✅ In .env | None |

---

## Next Steps

1. **Download the service account key** from Firebase Console
2. **Place it** in `server/mpesa/serviceAccountKey.json`
3. **Start the backend**:
   ```cmd
   cd server/mpesa
   npm install
   node index.js
   ```
4. **Test payment** in Flutter app
5. **Check server logs** for any errors

Once you have the service account key and the server running, payments should work!
