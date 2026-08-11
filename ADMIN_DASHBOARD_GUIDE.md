# Admin Dashboard & Landlord Management System

## Overview

A comprehensive admin system for managing landlords, verifying their accounts, and generating detailed reports. The system includes professional-grade analytics, verification workflows, and export functionality.

## Features

### 1. **Dashboard Screen**
- **Key Metrics**: Display statistics for properties, landlords, tenants, and payments
- **Revenue Overview**: Visual representation of revenue trends
- **Quick Actions**: Fast access to common administrative tasks
- **Notifications**: System notifications and alerts
- **Theme Toggle**: Light/Dark mode support

### 2. **Landlord Management (User Management Screen)**
- **View All Landlords**: Complete list of registered landlords
- **Filter by Status**: 
  - All
  - Pending (awaiting verification)
  - Verified (approved)
  - Rejected (declined)
- **Statistics Cards**: Total, pending, verified, and rejected counts
- **Landlord Details**:
  - Profile information (name, email, phone)
  - Business details
  - Property and booking statistics
  - Rating system
  - Verification status
- **Quick Actions**:
  - Verify landlords (pending ones)
  - Reject landlords with reason
  - Suspend verified landlords
  - View detailed information

### 3. **Verification Screen**
- **Pending Review**: Display all landlords awaiting verification
- **Document Review**: View submitted documents and details
- **Verification Workflow**:
  - Review landlord details
  - View submitted documents
  - Approve with one click
  - Reject with custom reason
- **Time Tracking**: Shows when each application was submitted

### 4. **Reports & Analytics**
Three comprehensive report types:

#### a) **Landlords Report**
- Detailed list of all landlords
- Name, email, status, properties, rating
- CSV export functionality
- Sortable data

#### b) **Verification Report**
- Statistics on verification status
- Total, verified, pending, and rejected counts
- Visual stat cards
- Exportable data

#### c) **Summary Report**
- Overview metrics
- Verification rate percentage
- Quick statistics
- Generated timestamp

**Report Features**:
- Date range filtering
- CSV export
- Professional formatting
- Data validation

## Architecture

### Providers

#### `LandlordProvider`
Manages landlord data and operations:

```dart
class LandlordProvider extends ChangeNotifier {
  // Properties
  List<Landlord> landlords
  List<Landlord> filteredLandlords
  String filterStatus
  bool isLoading

  // Methods
  Future<void> fetchLandlords()
  void setFilterStatus(String status)
  Future<void> verifyLandlord(String landlordId)
  Future<void> rejectLandlord(String landlordId, String reason)
  Future<void> suspendLandlord(String landlordId)
  Map<String, int> getStatistics()
  List<Map<String, dynamic>> generateReport()
}
```

### Models

#### `Landlord`
```dart
class Landlord {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String verificationStatus;
  final DateTime createdAt;
  final int totalProperties;
  final int totalBookings;
  final double rating;
  final String profileImageUrl;
  final Map<String, dynamic> documents;
}
```

## File Structure

```
lib/
├── providers/
│   └── landlord_provider.dart          # Landlord data management
├── screens/
│   └── admin/
│       ├── admin_dashboard.dart        # Main admin navigation
│       ├── user_management_screen.dart # Landlord management
│       ├── verify_landlords_screens.dart # Verification workflow
│       └── reports_screen.dart         # Analytics & reports
```

## Usage

### Accessing the Admin Dashboard

The admin dashboard is integrated into the app's navigation:

```dart
// From your routes
route: '/admin',
builder: (context) => const AdminDashboard(),
```

### Bottom Navigation Tabs
1. **Dashboard** - Main overview and quick stats
2. **Users** - Manage all landlords
3. **Verify** - Verify pending landlords
4. **Reports** - View and export reports

## UI/UX Design

### Color Scheme
- **Primary**: `#2D5BFF` (Blue)
- **Success**: `#00C48C` (Green)
- **Warning**: `#FF9500` (Orange)
- **Error**: `#FF3B30` (Red)
- **Neutral**: `#8F9BB3` (Gray)

### Dark Mode Support
All screens support both light and dark themes with:
- Automatic color adjustment
- Professional contrast ratios
- Smooth transitions

### Typography
- **Headlines**: Bold 18-24px
- **Body**: Regular 12-16px
- **Labels**: Bold 11-13px

## Integration Steps

1. **Add LandlordProvider to main.dart**:
```dart
ChangeNotifierProvider(create: (_) => LandlordProvider()),
```

2. **Import in your routes**:
```dart
import 'screens/admin/admin_dashboard.dart';
```

3. **Add to your navigation routes**:
```dart
'/admin': (context) => const AdminDashboard(),
```

## Firebase Integration

The system uses Firestore for data persistence:

**Collection**: `users`
**Query**: Where `role == 'landlord'`

**Document fields**:
- `name`: String
- `email`: String
- `phone`: String
- `businessName`: String
- `verificationStatus`: String (pending/verified/rejected/suspended)
- `profileImageUrl`: String
- `totalProperties`: Int
- `totalBookings`: Int
- `rating`: Double
- `documents`: Map (submitted documents)
- `createdAt`: Timestamp

## API Methods

### Verify a Landlord
```dart
await landlordProvider.verifyLandlord(landlordId);
```

### Reject a Landlord
```dart
await landlordProvider.rejectLandlord(landlordId, reason);
```

### Suspend a Landlord
```dart
await landlordProvider.suspendLandlord(landlordId);
```

### Get Statistics
```dart
Map<String, int> stats = landlordProvider.getStatistics();
// Returns: {total, pending, verified, rejected}
```

### Generate Report
```dart
List<Map<String, dynamic>> report = landlordProvider.generateReport();
```

## Export Functionality

Reports can be exported as CSV format with:
- Professional formatting
- Data validation
- Timestamp information
- Complete information

Example CSV headers:
```
Name,Email,Business Name,Status,Properties,Bookings,Rating,Joined
```

## Future Enhancements

- [ ] PDF export functionality
- [ ] Advanced filtering options
- [ ] Custom date range analytics
- [ ] Bulk operations
- [ ] Email notifications
- [ ] Activity logs
- [ ] Role-based permissions
- [ ] API key management

## Best Practices

1. **Always fetch data** before displaying:
```dart
@override
void initState() {
  super.initState();
  _landlordProvider.fetchLandlords();
}
```

2. **Listen to provider changes**:
```dart
Consumer<LandlordProvider>(
  builder: (context, provider, _) {
    // Use provider.landlords
  },
)
```

3. **Handle errors gracefully**:
```dart
try {
  await provider.verifyLandlord(id);
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: $e')),
  );
}
```

## Performance Tips

- Use `Consumer` instead of `Provider.of` for better performance
- Implement pagination for large landlord lists
- Cache report data when possible
- Use `shrinkWrap: true` for nested lists

## Troubleshooting

**Landlords not loading?**
- Check Firebase connection
- Verify Firestore security rules allow reading from 'users' collection
- Ensure 'role' field is set correctly

**Export not working?**
- Verify date range is selected
- Check data exists in selected filters
- Verify CSV formatting

**Verification not updating?**
- Force refresh: `landlordProvider.fetchLandlords()`
- Check Firestore update permissions
- Verify landlord ID is correct

## Support

For issues or questions regarding the admin dashboard:
1. Check Firebase console for data
2. Review Firestore security rules
3. Verify provider integration in main.dart
4. Check console logs for error messages

---

**Last Updated**: February 16, 2026
**Version**: 1.0.0
