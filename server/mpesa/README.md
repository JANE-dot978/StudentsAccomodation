MPesa webhook server (minimal)

This is a small Express server that accepts MPesa callbacks and updates Firestore bookings.

Setup

1. Copy `.env.example` to `.env` and set values.
2. Place your Firebase service account JSON at the path configured in `SERVICE_ACCOUNT_PATH`.
3. From this folder, run:

```bash
npm install
npm start
```

Endpoints

- `GET /` health check
- `POST /mpesa/callback` MPesa provider callback. The handler expects a JSON body that includes `bookingId` (or `transaction.metadata.bookingId`). It will:
  - mark the booking's `isPaid` to `true` and set `paidAt`
  - if booking `status` is `approved` and booking wasn't already paid, decrement `hostels.availableRooms` atomically

- `POST /mpesa/simulate` simulate a successful callback for testing. JSON: `{ "bookingId": "<id>" }`

Notes

- Adapt `index.js` to match your MPesa provider's callback shape. Ensure you attach the `bookingId` when initiating the STK push (so the callback can identify the booking).
- This server uses `firebase-admin`. Use a service account or set `GOOGLE_APPLICATION_CREDENTIALS`.
- For production, validate callbacks (IP allowlist or HMAC using `MPESA_CALLBACK_SECRET`).

Next steps

- Add STK push initiation endpoint that calls the MPesa API and stores transaction metadata (e.g., checkoutRequestID) on the booking document.
- Secure the callback and add retries/monitoring.
