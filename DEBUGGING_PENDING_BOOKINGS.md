# Debugging Pending Bookings Issue

## Problem
Landlord's pending bookings appear briefly then disappear immediately in the "Manage Bookings" screen.

## Root Cause Investigation

The updated code now provides diagnostic information to identify the issue. Here's what to check:

### Step 1: Run the App with Console Visible
1. Open the Flutter console/terminal
2. Run: `flutter run`
3. Keep the console visible to see debug output

### Step 2: Test as Landlord
1. Log in as a landlord account
2. Go to "Manage Bookings"
3. Click the "Pending" tab
4. **Watch the Flutter console for debug messages**

### Step 3: Look for These Debug Messages

#### In Flutter Console (logcat/debugger):
```
_PendingBookingsTab building with landlordId: <UUID>
Pending bookings snapshot state: ConnectionState.waiting
Pending bookings data: <number or null>
Pending bookings error: <error or null>
```

#### Possible Outcomes:

**CASE A: Empty landlordId**
```
_PendingBookingsTab building with landlordId: 
```
- **Cause**: Auth provider not retrieving user ID correctly
- **Fix**: Need to verify `authProvider.user?.uid` is populated after login
- **Action**: Check if user is properly authenticated

**CASE B: Stream connection state = waiting (stuck)**
```
Pending bookings snapshot state: ConnectionState.waiting
```
- **Cause**: Stream is not connecting or Firestore query is timing out
- **Fix**: May need to check Firestore security rules or network connection
- **Action**: Verify Firestore has permission to read landlord's bookings

**CASE C: Stream returns empty data**
```
Pending bookings data: 0
Pending bookings error: null
```
- **Cause**: Either no pending bookings exist OR query filtering is too strict
- **Fix**: Check Firestore to verify pending bookings exist for this landlord
- **Action**: Go to Firebase Console → Firestore → bookings collection → verify data

**CASE D: Stream has error**
```
Pending bookings error: permission-denied or <other error>
```
- **Cause**: Firestore security rules not allowing access
- **Fix**: Rules need to allow landlords to read their bookings
- **Action**: Already fixed in firestore.rules - verify deployment succeeded

**CASE E: Normal operation**
```
Pending bookings data: 2
Pending bookings error: null
```
- **Cause**: Working correctly!
- **Action**: None - bookings should display properly

### Step 4: Create Test Data

If you see "No pending bookings":

1. **Open an incognito/private window**
2. **Create a student account**
3. **Log in as student**
4. **Create a booking** for this landlord's hostel
5. **Log back in as landlord**
6. **Check pending bookings again**

The new booking should appear as pending and NOT disappear.

### Step 5: Check Firestore Console

Go to Firebase Console → Firestore → bookings collection:

1. Find a pending booking
2. Verify it has:
   - `landlordId`: matches your landlord account's UID
   - `status`: "pending"
   - `studentId`: matches the student who created it
   - `hostelId`: valid hostel ID

### Step 6: Verify Firestore Rules

In Firebase Console → Firestore → Rules tab:

Look for this section:
```
match /bookings/{bookingId} {
  allow read: if request.auth != null && (
    request.auth.uid == resource.data.studentId ||
    request.auth.uid == resource.data.landlordId
  );
```

This allows landlords to read their own bookings.

## Expected Behavior After Fix

1. Landlord logs in
2. Goes to "Manage Bookings" → "Pending" tab
3. Sees pending bookings from student(s) **persistently** (not disappearing)
4. Can see "Approve" and "Reject" buttons
5. Bookings stay in list until action is taken

## If Still Not Working

**Share this information:**
1. Full debug output from Flutter console
2. Your landlord account UID
3. Screenshot of Firestore bookings collection
4. Whether you see any permission-denied errors

## Quick Fixes to Try

### Fix A: Force Logout/Login
1. Log out from app
2. Completely close the app
3. Reopen and log in again
4. Test pending bookings

### Fix B: Check Network
1. Verify internet connection is stable
2. Try on WiFi vs mobile data
3. Check if Firebase Console loads (connection test)

### Fix C: Clear Cache
1. Stop the app
2. Run: `flutter clean`
3. Run: `flutter pub get`
4. Run: `flutter run` again

### Fix D: Update Firestore Rules
1. Open `firestore.rules`
2. Run deployment:
```bash
firebase deploy --only firestore:rules
```
3. Verify in Firebase Console that rules updated timestamp changed

## Code Changes Made

All three tabs in `booking_approval_screen.dart` now have:
- ✅ Landlord ID validation
- ✅ Debug print statements for stream state
- ✅ Debug print statements for data received
- ✅ Debug print statements for errors
- ✅ Error UI display if Firestore returns error
- ✅ Connection state checking
- ✅ Empty data handling

This should provide complete visibility into what's happening when you view bookings.
