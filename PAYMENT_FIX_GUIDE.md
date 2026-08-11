# Payment Server Issue - Diagnosis & Solution

## Issue Summary
❌ **Payment fails with**: `client exception: failed to fetch url: http://192.168.1.66:8080/mpesa-initiate`

**Root Cause Found**: The Node.js payment server is running but **NOT accepting HTTP connections** on port 8080.

---

##  Problem Details

1. ✅ Server **starts successfully** and prints startup messages
2. ✅ Firebase initialization completes  
3. ✅ Express app is created
4. ❌ **Port 8080 is NOT listening** (confirmed by netstat)
5. ❌ HTTP requests timeout when trying to connect

---

## Possible Causes

1. **Firewall blocking port 8080**
   - Windows Defender Firewall may be blocking incoming connections
   
2. **Server binding issue**
   - Express may be binding but connections are being rejected

3. **Network connectivity**
   - Network adapter issues preventing connections

4. **Application code issue**
   - Something in the server initialization is preventing proper binding

---

## Immediate Solution: Use Alternative Port

Since the current setup has connectivity issues, use a **different port** that might not be blocked.

### Changes Required:

#### 1. Update [server_config.json](server_config.json)
Change from:
```json
{
  "serverUrl": "http://192.168.1.66:8080",
  "serverPort": 8080,
}
```

To:
```json
{
  "serverUrl": "http://192.168.1.66:3000",
  "serverPort": 3000,
}
```

#### 2. Update [server/.env](server/.env)
Change:
```env
CALLBACK_URL=http://192.168.1.66:8080/mpesa/callback
```

To:
```env
CALLBACK_URL=http://192.168.1.66:3000/mpesa/callback
PORT=3000
```

#### 3. Update [lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart) - Line 18
Change from:
```dart
final PaymentService _paymentService = PaymentService(baseUrl: 'http://192.168.1.66:8080');
```

To:
```dart
final PaymentService _paymentService = PaymentService(baseUrl: 'http://192.168.1.66:3000');
```

#### 4. Add PORT to [server/mpesa/index.js](server/mpesa/index.js)
Add near line 8:
```javascript
process.env.PORT = process.env.PORT || 3000;
```

---

## Testing Alternative Port

After making changes:

```powershell
# Kill old server
Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force

# Start server
cd "C:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa"
node index.js

# In another terminal, test:
curl http://127.0.0.1:3000/test
```

---

## If Problem Persists: Firewall Configuration

### Option 1: Add Firewall Exception
```powershell
# Add Node.js to firewall whitelist
New-NetFirewallRule -DisplayName "Node.js Payment Server" `
  -Direction Inbound -Program "C:\Program Files\nodejs\node.exe" `
  -Action Allow
```

### Option 2: Temporarily Disable Firewall (Testing Only)
```powershell
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled $false
```

Enable after testing:
```powershell
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled $true
```

---

## Step-by-Step Fix

1. **Stop the server**
   ```powershell
   Get-Process node -ErrorAction SilentlyContinue | Stop-Process -Force
   ```

2. **Update the 4 files** (listed above) to use port 3000

3. **Restart the server**
   ```powershell
   cd "C:\Users\Test\Flutter_projects\studentsaccomodations\server\mpesa"
   node index.js
   ```

4. **Test connectivity**
   ```powershell
   curl http://192.168.1.66:3000/test
   ```

5. **Try payment in Flutter app**
   - The app should now connect successfully

---

## Troubleshooting Commands

```powershell
# Check if server is running
Get-Process node

# Check listening ports
netstat -ano | Select-String "LISTENING"

# Test specific port
curl http://127.0.0.1:3000/test

# View server logs (if started in terminal)
# Look for lines starting with [PAYMENT] or [ERROR]
```

---

## Files to Modify

- [server_config.json](server_config.json) - Change port 8080 → 3000
- [server/.env](server/.env) - Change CALLBACK_URL port, add PORT=3000
- [lib/screens/student/checkout_payment_screen.dart](lib/screens/student/checkout_payment_screen.dart#L18) - Change baseUrl port
- [server/mpesa/index.js](server/mpesa/index.js) - Ensure PORT env var is set

---

## Alternative: Use localhost

If the issue is network-specific, temporarily use localhost for testing:

Change all references from `http://192.168.1.66:PORT` to `http://localhost:PORT`

This will work if:
- You're testing on the same computer
- NOT testing from physical device or emulator

---

Let me know the results after making these changes!
