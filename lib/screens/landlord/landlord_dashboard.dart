import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hostel_provider.dart';
import '../../providers/booking_provider.dart';
import 'property_screen.dart';
import 'booking_approval_screen.dart';
import 'add_hostel_screen.dart';

class LandlordDashboard extends StatelessWidget {
  const LandlordDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final landlordId = authProvider.user?.uid ?? '';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Property Dashboard',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== WELCOME BANNER =====
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.3),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: const Icon(
                        Icons.home_work_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Manage your properties & bookings',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withValues(alpha: 0.9),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // ===== OVERVIEW SECTION TITLE =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Your Overview',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ===== STATS GRID =====
            // StreamBuilders are used independently so a slow stream won't block the UI
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                // Active Properties
                StreamBuilder<List<dynamic>>(
                  stream: Provider.of<HostelProvider>(context, listen: false)
                      .getLandlordHostels(landlordId),
                  builder: (context, snap) {
                    final hostels = snap.data ?? [];
                        return _buildStatCard(
                          context,
                          'Active Properties',
                          hostels.length.toString(),
                          Icons.apartment_outlined,
                          const Color(0xFF0066CC),
                        );
                  },
                ),

                // Pending Approvals
                StreamBuilder<List<dynamic>>(
                  stream: Provider.of<BookingProvider>(context, listen: false)
                      .getPendingBookings(landlordId),
                  builder: (context, snap) {
                    final pending = snap.data ?? [];
                    return _buildStatCard(
                      context,
                      'Pending Approvals',
                      pending.length.toString(),
                      Icons.pending_actions_outlined,
                      const Color(0xFFFF8C00),
                    );
                  },
                ),

                // Available Rooms
                StreamBuilder<List<dynamic>>(
                  stream: Provider.of<HostelProvider>(context, listen: false)
                      .getLandlordHostels(landlordId),
                  builder: (context, snap) {
                    final hostels = snap.data ?? [];
                    final available = hostels.fold<int>(
                        0, (sum, h) => sum + (h.availableRooms as int? ?? 0));
                    return _buildStatCard(
                      context,
                      'Available Rooms',
                      available.toString(),
                      Icons.meeting_room_outlined,
                      const Color(0xFF28A745),
                    );
                  },
                ),

                // Total Bookings
                StreamBuilder<List<dynamic>>(
                  stream: Provider.of<BookingProvider>(context, listen: false)
                      .getLandlordBookings(landlordId),
                  builder: (context, snap) {
                    final all = snap.data ?? [];
                    return _buildStatCard(
                      context,
                      'Total Bookings',
                      all.length.toString(),
                      Icons.assignment_outlined,
                      const Color(0xFF8B5CF6),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ===== QUICK ACTIONS SECTION =====
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 16),

            // Action buttons with better styling
            Column(
              children: [
                _buildActionButton(
                  context,
                  'View All Properties',
                  Icons.store_outlined,
                  const Color(0xFF0066CC),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const PropertyScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  'Review Booking Requests',
                  Icons.approval_outlined,
                  const Color(0xFFFF8C00),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const BookingApprovalScreen()),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  context,
                  'Add New Property',
                  Icons.add_location_outlined,
                  const Color(0xFF28A745),
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddHostelScreen()),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ===== STAT CARD WIDGET =====
  Widget _buildStatCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon background
            Container(
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(10),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            // Value and title
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===== ACTION BUTTON WIDGET =====
  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_outlined,
                  size: 18,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.6) ?? Colors.grey.shade400,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
