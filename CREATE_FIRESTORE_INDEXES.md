# Creating Firestore Indexes for Bookings Queries

## Problem
Your bookings query requires composite indexes because it filters by multiple fields. Firestore needs these indexes to work efficiently.

## Solution: Create Indexes in Firebase Console

### Index 1: For getPendingBookings Query
This index is needed for: `landlordId + status + createdAt`

1. Go to: https://console.firebase.google.com
2. Select your project: **studentsaccomodations**
3. Navigate to: **Firestore Database** → **Indexes** tab
4. Click **Create Index**
5. Fill in these details:
   - **Collection ID**: `bookings`
   - **Query scope**: Collection
   - **Fields**: 
     - Field: `landlordId` | Order: Ascending ⬆️
     - Field: `status` | Order: Ascending ⬆️
     - Field: `createdAt` | Order: Descending ⬇️
6. Click **Create Index**

---

### Index 2: For getApprovedBookings (Landlord) Query
This index is needed for: `landlordId + status + createdAt`

Same as Index 1 (will be reused)

---

### Index 3: For getApprovedBookings (Student) Query
This index is needed for: `studentId + status + createdAt`

1. Go to Firebase Console → **Firestore Database** → **Indexes**
2. Click **Create Index**
3. Fill in these details:
   - **Collection ID**: `bookings`
   - **Query scope**: Collection
   - **Fields**: 
     - Field: `studentId` | Order: Ascending ⬆️
     - Field: `status` | Order: Ascending ⬆️
     - Field: `createdAt` | Order: Descending ⬇️
4. Click **Create Index**

---

### Index 4: For getLandlordBookings Query
This index is needed for: `landlordId + createdAt`

1. Go to Firebase Console → **Firestore Database** → **Indexes**
2. Click **Create Index**
3. Fill in these details:
   - **Collection ID**: `bookings`
   - **Query scope**: Collection
   - **Fields**: 
     - Field: `landlordId` | Order: Ascending ⬆️
     - Field: `createdAt` | Order: Descending ⬇️
4. Click **Create Index**

---

### Index 5: For getStudentBookings Query
This index is needed for: `studentId + createdAt`

1. Go to Firebase Console → **Firestore Database** → **Indexes**
2. Click **Create Index**
3. Fill in these details:
   - **Collection ID**: `bookings`
   - **Query scope**: Collection
   - **Fields**: 
     - Field: `studentId` | Order: Ascending ⬆️
     - Field: `createdAt` | Order: Descending ⬇️
4. Click **Create Index**

---

## Checking Index Status

After creating indexes:

1. Go to Firebase Console → **Firestore Database** → **Indexes**
2. You should see your indexes listed
3. Status should show:
   - 🟢 **Enabled** = Ready to use (may take 5-15 minutes)
   - 🟡 **Building** = Still indexing data (wait for it to complete)
   - ❌ **Error** = Something went wrong (check the error message)

---

## After Indexes Are Created

1. Return to the app
2. Do a **Hot Restart** in Flutter:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```
3. Log in as landlord
4. Go to **Manage Bookings** → **Pending** tab
5. Bookings should now load without errors!

---

## Alternative: Deploy via Command Line

If you need to bypass the PowerShell execution policy:

### Option A: Use Command Prompt (CMD)
```cmd
cd c:\Users\Test\Flutter_projects\studentsaccomodations
firebase deploy --only firestore:indexes
```

### Option B: Enable PowerShell Script Execution
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
firebase deploy --only firestore:indexes
```

Then disable it back (optional security):
```powershell
Set-ExecutionPolicy -ExecutionPolicy Restricted -Scope CurrentUser
```

### Option C: Use Node.js Script
Create `deploy-indexes.js` in project root:
```javascript
const admin = require('firebase-admin');

admin.initializeApp();

// The firestore.indexes.json will be deployed when you run:
// firebase deploy --only firestore:indexes
```

Then run:
```cmd
firebase deploy --only firestore:indexes
```

---

## What Each Index Does

| Index | Used By | Filters |
|-------|---------|---------|
| Index 1 | `getPendingBookings()` | `landlordId + status` |
| Index 2 | `getApprovedBookings()` (landlord) | `landlordId + status` |
| Index 3 | `getApprovedBookings()` (student) | `studentId + status` |
| Index 4 | `getLandlordBookings()` | `landlordId` only |
| Index 5 | `getStudentBookings()` | `studentId` only |

---

## Why Multiple Indexes?

Firestore needs separate indexes for:
- Different field combinations
- Different filter combinations
- Different ordering needs

This ensures fast query performance across all your booking queries.

---

## Troubleshooting

**Q: Why am I getting this error?**
A: Firestore requires composite indexes for queries with 2+ filter fields + ordering.

**Q: How long do indexes take to build?**
A: Usually 5-15 minutes for small datasets, longer for large collections.

**Q: Can I test without indexes?**
A: No - Firestore will reject the query if indexes don't exist for composite queries.

**Q: Do I need all 5 indexes?**
A: Yes - each query uses different filter combinations, so each needs its own index.

---

## Next Steps

1. ✅ Create the 5 indexes in Firebase Console
2. ⏳ Wait for indexes to show "Enabled" status
3. 🚀 Test the app - pending bookings should now load!
