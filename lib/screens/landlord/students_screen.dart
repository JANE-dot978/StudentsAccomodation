import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final landlordId = authProvider.user?.uid ?? '';

    if (landlordId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tenants')),
        body: const Center(child: Text('Please log in again')),
      );
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tenants'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active Tenants', icon: Icon(Icons.people)),
              Tab(text: 'All Bookings', icon: Icon(Icons.list)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ActiveTenantsTab(landlordId: landlordId),
            _AllBookingsTab(landlordId: landlordId),
          ],
        ),
      ),
    );
  }
}

class _ActiveTenantsTab extends StatelessWidget {
  final String landlordId;

  const _ActiveTenantsTab({required this.landlordId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Booking>>(
      stream: Provider.of<BookingProvider>(context, listen: false)
          .getApprovedBookings(landlordId, isLandlord: true),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.people_outline, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No active tenants',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tenants will appear here when they book your properties',
                  style: TextStyle(color: Colors.grey.shade500),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            return _TenantCard(booking: bookings[index]);
          },
        );
      },
    );
  }
}

class _TenantCard extends StatelessWidget {
  final Booking booking;

  const _TenantCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            Icons.person,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(
          'Booking #${booking.id.length >= 8 ? booking.id.substring(0, 8) : booking.id}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(booking.roomType),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _DetailRow(
                  icon: Icons.bed,
                  label: 'Room Type',
                  value: booking.roomType,
                ),
                _DetailRow(
                  icon: Icons.calendar_today,
                  label: 'Check-in Date',
                  value: '${booking.checkInDate.day}/${booking.checkInDate.month}/${booking.checkInDate.year}',
                ),
                _DetailRow(
                  icon: Icons.schedule,
                  label: 'Duration',
                  value: '${booking.durationMonths} months',
                ),
                _DetailRow(
                  icon: Icons.attach_money,
                  label: 'Amount',
                  value: 'KES ${booking.amount.toStringAsFixed(0)}',
                ),
                _DetailRow(
                  icon: booking.isPaid ? Icons.check_circle : Icons.warning,
                  label: 'Payment Status',
                  value: booking.isPaid ? 'Paid' : 'Pending',
                  valueColor: booking.isPaid ? Colors.green : Colors.orange,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showContactDialog(context),
                        icon: const Icon(Icons.message),
                        label: const Text('Contact'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _showDetailsDialog(context),
                        icon: const Icon(Icons.info_outline),
                        label: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Tenant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Student ID:'),
            const SizedBox(height: 8),
            SelectableText(
              booking.studentId,
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 16),
            const Text(
              'To contact the tenant, you can view their contact information in the booking details.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showDetailsDialog(BuildContext context) {
    // Calculate check-out date from checkInDate and durationMonths
    final checkOutDate = booking.checkInDate.add(Duration(days: booking.durationMonths * 30));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Booking Details'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DetailRow(
                icon: Icons.tag,
                label: 'Booking ID',
                value: booking.id.length >= 12 ? booking.id.substring(0, 12) : booking.id,
              ),
              _DetailRow(
                icon: Icons.bed,
                label: 'Room Type',
                value: booking.roomType,
              ),
              _DetailRow(
                icon: Icons.calendar_today,
                label: 'Check-in',
                value: '${booking.checkInDate.day}/${booking.checkInDate.month}/${booking.checkInDate.year}',
              ),
              _DetailRow(
                icon: Icons.calendar_month,
                label: 'Check-out',
                value: '${checkOutDate.day}/${checkOutDate.month}/${checkOutDate.year}',
              ),
              _DetailRow(
                icon: Icons.schedule,
                label: 'Duration',
                value: '${booking.durationMonths} months',
              ),
              _DetailRow(
                icon: Icons.attach_money,
                label: 'Amount',
                value: 'KES ${booking.amount.toStringAsFixed(0)}',
              ),
              _DetailRow(
                icon: booking.isPaid ? Icons.check_circle : Icons.warning,
                label: 'Status',
                value: booking.isPaid ? 'Paid' : 'Pending',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AllBookingsTab extends StatelessWidget {
  final String landlordId;

  const _AllBookingsTab({required this.landlordId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Booking>>(
      stream: Provider.of<BookingProvider>(context, listen: false)
          .getLandlordBookings(landlordId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final bookings = snapshot.data ?? [];

        if (bookings.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inbox_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text(
                  'No bookings yet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final booking = bookings[index];
            Color statusColor;
            switch (booking.status) {
              case 'approved':
                statusColor = Colors.green;
                break;
              case 'rejected':
                statusColor = Colors.red;
                break;
              default:
                statusColor = Colors.orange;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: statusColor.withOpacity(0.1),
                  child: Icon(
                    booking.status == 'approved'
                        ? Icons.check_circle
                        : booking.status == 'rejected'
                            ? Icons.cancel
                            : Icons.pending,
                    color: statusColor,
                  ),
                ),
                title: Text(booking.roomType),
                subtitle: Text(
                  'KES ${booking.amount.toStringAsFixed(0)} • ${booking.durationMonths} months',
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    booking.status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
