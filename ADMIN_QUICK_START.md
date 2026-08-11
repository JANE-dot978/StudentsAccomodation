# 👨‍💼 Admin Dashboard - Quick Start Guide

## Welcome to the Admin Dashboard

The admin dashboard provides complete control over landlord management, verification, and reporting.

---

## 🎯 Quick Navigation

### Bottom Tabs (Swipe or Tap)

**1. 📊 Dashboard**
- Overview of key metrics
- Revenue trends
- Quick statistics
- Download reports

**2. 👥 Users**
- Manage all landlords
- Filter by status
- View details
- Verify/Reject actions

**3. ✅ Verify**
- Review pending landlords
- View documents
- Approve or reject
- Add rejection reasons

**4. 📈 Reports**
- Generate reports
- View analytics
- Export to CSV
- Custom date ranges

---

## 📋 Common Tasks

### ✅ Verify a Landlord

1. Go to **Verify** tab
2. Find pending landlord in list
3. Review information and documents
4. Click **Verify** button
5. Confirm in dialog
6. ✓ Status updates to "Verified"

### ❌ Reject a Landlord

1. Go to **Users** tab
2. Filter to "Pending"
3. Click **Reject** button on landlord card
4. Enter rejection reason (required)
5. Click **Reject** to confirm
6. ✗ Status updates to "Rejected"

### ⏸️ Suspend a Landlord

1. Go to **Users** tab
2. Filter to "Verified"
3. Click **Suspend** button
4. Confirm suspension
5. ⏸ Landlord can no longer manage properties

### 📊 Download Reports

**Option 1: From Dashboard**
- Click 📥 Download icon (top right)
- Select report type
- Choose from options:
  - Monthly Revenue Report
  - User Activity Report
  - Property Analytics
  - Payment Summary

**Option 2: From Reports Tab**
- Select report type (Landlords, Verification, Summary)
- Set date range (optional)
- Click **Export as CSV**
- Report generates with timestamp

### 🔍 View Landlord Details

1. Go to **Users** tab
2. Click **View Details** button
3. Dialog shows:
   - Full contact information
   - Business details
   - Statistics
   - Verification date
4. Close dialog when done

---

## 🎨 Understanding the Interface

### Status Indicators

| Status | Color | Meaning |
|--------|-------|---------|
| **Verified** | 🟢 Green | Approved and active |
| **Pending** | 🟠 Orange | Awaiting verification |
| **Rejected** | 🔴 Red | Application declined |
| **Suspended** | ⚪ Gray | Temporarily disabled |

### Metric Cards

Each card shows:
- **Total Landlords**: All registered landlords
- **Verified**: Successfully verified landlords
- **Pending**: Awaiting verification
- **Rejected**: Declined applications

### Filter Chips

Click to filter by status:
- **All** - Show all landlords
- **Pending** - Only awaiting verification
- **Verified** - Approved landlords
- **Rejected** - Declined applications

---

## 💡 Pro Tips

### Sorting & Filtering
- Tap filter chips to quickly filter landlords
- Use status indicators to identify at a glance
- Click column headers in reports to sort

### Bulk Operations
- Check multiple status cards
- Export reports for batch processing
- Use date ranges for time-period analysis

### Export Best Practices
- Export monthly reports on the 1st
- Keep reports for audit trail
- Use for investor presentations
- Track verification metrics

### Dashboard Insights
- Monitor verification rate
- Track revenue trends
- Watch for pending backlog
- Check payment totals

---

## ⚙️ Settings & Options

### Theme Toggle
- Click 🌙 Moon icon (top right of Dashboard)
- Switch between Light/Dark modes
- Theme applies to all screens

### Logout
- Click user avatar (top right)
- Select **Logout**
- Confirm logout

### Notifications
- Click 🔔 Bell icon
- View system notifications
- Mark as read

---

## 📊 Report Types Explained

### Landlords Report
**What it includes**:
- Name and contact information
- Current verification status
- Number of properties
- Booking count
- Rating
- Join date

**Best for**: 
- Detailed landlord listings
- Export for records
- Communication lists

### Verification Report
**What it includes**:
- Total landlord count
- Verified count
- Pending count
- Rejected count
- Statistical breakdown

**Best for**:
- Performance tracking
- Trend analysis
- Management reports

### Summary Report
**What it includes**:
- Total landlords
- Verification rate (%)
- Pending count
- Performance metrics
- Generated date

**Best for**:
- Executive summaries
- Quick overview
- Status snapshots

---

## ⚠️ Important Notes

### Before Verifying
- ✓ Review all submitted documents
- ✓ Check business details
- ✓ Verify contact information
- ✓ Confirm identity documents

### Before Rejecting
- ✓ Document the reason
- ✓ Note what documents are missing
- ✓ Keep for audit trail
- ✓ Consider applicant can resubmit

### Before Suspending
- ✓ Have clear reason
- ✓ Consider impact on tenants
- ✓ May notify landlord first
- ✓ Document suspension reason

---

## 🔍 Dashboard Metrics Explained

**Total Properties**
- Number of properties listed by all landlords
- Increases with new listings
- Includes all status types

**Verified Landlords**
- Count of approved landlords
- Only verified can list properties
- Indicator of platform health

**Active Tenants**
- Current number of tenants
- Changes with bookings
- Occupancy metric

**Total Payments**
- Sum of all payment amounts
- In local currency (KES)
- Revenue indicator

---

## 🆘 Troubleshooting

### Landlords not showing?
- Wait for page to load (check spinner)
- Ensure you have internet connection
- Try refreshing the screen
- Check filter settings

### Can't verify landlord?
- Ensure they're in "Pending" status
- Check Firebase permissions
- Verify internet connection
- Try refreshing the list

### Reports not exporting?
- Ensure data exists for filters
- Check date range validity
- Verify file permissions
- Try different report type

### Changes not saving?
- Check internet connection
- Verify Firebase credentials
- Look for error messages
- Retry the action

---

## 📞 Support

**Issue with verification?**
- Check landlord's documents
- Verify their status
- Try refreshing
- Check logs for errors

**Report generation problems?**
- Select valid date range
- Ensure data exists
- Check file format
- Verify export permissions

**Performance issues?**
- Close unused tabs
- Clear app cache
- Reduce filter scope
- Check internet speed

---

## ✅ Daily Checklist

- [ ] Review pending verifications
- [ ] Verify approved landlords
- [ ] Reject incomplete applications
- [ ] Generate daily report
- [ ] Check dashboard metrics
- [ ] Monitor payment activity

---

## 📱 Mobile Tips

- **Portrait Mode**: Best for reading lists
- **Landscape Mode**: Better for tables and reports
- **Tap & Hold**: View additional options
- **Swipe**: Navigate between tabs
- **Pinch**: Zoom on detailed views

---

## 🎓 Learning More

For detailed documentation, see:
- `ADMIN_DASHBOARD_GUIDE.md` - Complete reference
- `ADMIN_IMPLEMENTATION_SUMMARY.md` - Technical details
- Firebase Console - Data verification

---

**Last Updated**: February 16, 2026
**Version**: 1.0.0

Happy managing! 🚀
