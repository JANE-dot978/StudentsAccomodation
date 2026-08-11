import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/landlord_provider.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  late LandlordProvider _landlordProvider;

  @override
  void initState() {
    super.initState();
    _landlordProvider = Provider.of<LandlordProvider>(context, listen: false);
    Future.microtask(() => _landlordProvider.fetchLandlords());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Landlord Management'),
        elevation: 0,
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        foregroundColor: isDark ? Colors.white : const Color(0xFF1A2138),
      ),
      body: Consumer<LandlordProvider>(
        builder: (context, landlordProvider, _) {
          if (landlordProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Cards
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.3,
                  children: [
                    _buildStatCard(
                      'Total Landlords',
                      '${landlordProvider.getStatistics()['total']}',
                      Icons.apartment,
                      const Color(0xFF2D5BFF),
                      isDark,
                    ),
                    _buildStatCard(
                      'Verified',
                      '${landlordProvider.getStatistics()['verified']}',
                      Icons.check_circle,
                      const Color(0xFF00C48C),
                      isDark,
                    ),
                    _buildStatCard(
                      'Pending',
                      '${landlordProvider.getStatistics()['pending']}',
                      Icons.pending_actions,
                      const Color(0xFFFF9500),
                      isDark,
                    ),
                    _buildStatCard(
                      'Rejected',
                      '${landlordProvider.getStatistics()['rejected']}',
                      Icons.cancel,
                      const Color(0xFFFF3B30),
                      isDark,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Filter Buttons
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', 'all', landlordProvider, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Pending', 'pending', landlordProvider, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Verified', 'verified', landlordProvider, isDark),
                      const SizedBox(width: 8),
                      _buildFilterChip('Rejected', 'rejected', landlordProvider, isDark),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Landlord List
                Text(
                  'Landlords (${landlordProvider.filteredLandlords.length})',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF1A2138),
                  ),
                ),
                const SizedBox(height: 12),

                if (landlordProvider.filteredLandlords.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.person_off,
                            size: 64,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No landlords found',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: landlordProvider.filteredLandlords.length,
                    itemBuilder: (context, index) {
                      final landlord = landlordProvider.filteredLandlords[index];
                      return _buildLandlordCard(
                        context,
                        landlord,
                        landlordProvider,
                        isDark,
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2138),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    String filter,
    LandlordProvider provider,
    bool isDark,
  ) {
    final isActive = provider.filterStatus == filter;
    return GestureDetector(
      onTap: () => provider.setFilterStatus(filter),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF2D5BFF)
              : (isDark ? const Color(0xFF2A2A2A) : Colors.white),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? const Color(0xFF2D5BFF) : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: const Color(0xFF2D5BFF).withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isActive
                ? Colors.white
                : (isDark ? Colors.white70 : const Color(0xFF1A2138)),
          ),
        ),
      ),
    );
  }

  Widget _buildLandlordCard(
    BuildContext context,
    Landlord landlord,
    LandlordProvider provider,
    bool isDark,
  ) {
    final statusColor = _getStatusColor(landlord.verificationStatus);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: const Color(0xFF2D5BFF).withOpacity(0.2),
                      backgroundImage: landlord.profileImageUrl.isNotEmpty
                          ? NetworkImage(landlord.profileImageUrl)
                          : null,
                      child: landlord.profileImageUrl.isEmpty
                          ? const Icon(
                              Icons.person,
                              size: 28,
                              color: Color(0xFF2D5BFF),
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            landlord.name,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : const Color(0xFF1A2138),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            landlord.businessName,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? Colors.grey[400] : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        landlord.verificationStatus.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoTile(
                        Icons.email,
                        landlord.email,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildInfoTile(
                        Icons.phone,
                        landlord.phone,
                        isDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricTile(
                        'Properties',
                        '${landlord.totalProperties}',
                        Icons.home,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricTile(
                        'Bookings',
                        '${landlord.totalBookings}',
                        Icons.calendar_today,
                        isDark,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricTile(
                        'Rating',
                        landlord.rating.toStringAsFixed(1),
                        Icons.star,
                        isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(
            height: 1,
            color: isDark ? Colors.grey[800] : Colors.grey[200],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (landlord.verificationStatus == 'pending') ...[
                  Expanded(
                    child: _buildActionButton(
                      'Verify',
                      const Color(0xFF00C48C),
                      () => _verifyLandlord(context, landlord.id, provider, isDark),
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Reject',
                      const Color(0xFFFF3B30),
                      () => _rejectLandlord(
                        context,
                        landlord.id,
                        provider,
                        isDark,
                      ),
                      isDark,
                    ),
                  ),
                ] else if (landlord.verificationStatus == 'verified') ...[
                  Expanded(
                    child: _buildActionButton(
                      'View Details',
                      const Color(0xFF2D5BFF),
                      () => _showLandlordDetails(context, landlord, isDark),
                      isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildActionButton(
                      'Suspend',
                      const Color(0xFFFF9500),
                      () => _suspendLandlord(context, landlord.id, provider, isDark),
                      isDark,
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: _buildActionButton(
                      'View Details',
                      const Color(0xFF2D5BFF),
                      () => _showLandlordDetails(context, landlord, isDark),
                      isDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF2D5BFF)),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile(
    String label,
    String value,
    IconData icon,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF2A2A2A)
            : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 14, color: const Color(0xFF2D5BFF)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1A2138),
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    String label,
    Color color,
    VoidCallback onPressed,
    bool isDark,
  ) {
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'verified':
        return const Color(0xFF00C48C);
      case 'pending':
        return const Color(0xFFFF9500);
      case 'rejected':
        return const Color(0xFFFF3B30);
      case 'suspended':
        return const Color(0xFF8F9BB3);
      default:
        return const Color(0xFF2D5BFF);
    }
  }

  void _verifyLandlord(
    BuildContext context,
    String landlordId,
    LandlordProvider provider,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Verify Landlord',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A2138),
          ),
        ),
        content: Text(
          'Are you sure you want to verify this landlord?',
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await provider.verifyLandlord(landlordId);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Landlord verified successfully!'),
                      backgroundColor: const Color(0xFF00C48C),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: const Color(0xFFFF3B30),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C48C),
            ),
            child: const Text('Verify'),
          ),
        ],
      ),
    );
  }

  void _rejectLandlord(
    BuildContext context,
    String landlordId,
    LandlordProvider provider,
    bool isDark,
  ) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Reject Landlord',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A2138),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Please provide a reason for rejection:',
              style: TextStyle(
                color: isDark ? Colors.grey[300] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              maxLines: 3,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black,
              ),
              decoration: InputDecoration(
                hintText: 'Enter rejection reason...',
                hintStyle: TextStyle(
                  color: isDark ? Colors.grey[500] : Colors.grey[400],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: isDark
                    ? const Color(0xFF2A2A2A)
                    : const Color(0xFFF5F7FA),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason'),
                    backgroundColor: Color(0xFFFF3B30),
                  ),
                );
                return;
              }
              try {
                await provider.rejectLandlord(landlordId, reasonController.text);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Landlord rejected!'),
                      backgroundColor: const Color(0xFFFF3B30),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: const Color(0xFFFF3B30),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _suspendLandlord(
    BuildContext context,
    String landlordId,
    LandlordProvider provider,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          'Suspend Landlord',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A2138),
          ),
        ),
        content: Text(
          'Are you sure you want to suspend this landlord?',
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[600],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await provider.suspendLandlord(landlordId);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Landlord suspended!'),
                      backgroundColor: const Color(0xFFFF9500),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: const Color(0xFFFF3B30),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9500),
            ),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );
  }

  void _showLandlordDetails(
    BuildContext context,
    Landlord landlord,
    bool isDark,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        title: Text(
          landlord.name,
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A2138),
          ),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Business Name', landlord.businessName, isDark),
              _buildDetailRow('Email', landlord.email, isDark),
              _buildDetailRow('Phone', landlord.phone, isDark),
              _buildDetailRow('Status', landlord.verificationStatus, isDark),
              _buildDetailRow(
                'Total Properties',
                '${landlord.totalProperties}',
                isDark,
              ),
              _buildDetailRow(
                'Total Bookings',
                '${landlord.totalBookings}',
                isDark,
              ),
              _buildDetailRow(
                'Rating',
                '${landlord.rating.toStringAsFixed(2)}/5',
                isDark,
              ),
              _buildDetailRow(
                'Joined',
                landlord.createdAt.toString().split(' ')[0],
                isDark,
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

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.grey[400] : Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: isDark ? Colors.white : const Color(0xFF1A2138),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
