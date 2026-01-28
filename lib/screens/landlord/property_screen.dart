import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/hostel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/hostel_model.dart';
import '../../widgets/hostels_cards.dart';


class PropertyScreen extends StatelessWidget {
  const PropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final landlordId = user.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      // ❌ NO drawer here
      // ❌ NO appBar here (comes from dashboard)

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-hostel'),
        icon: const Icon(Icons.add),
        label: const Text("Add Property"),
      ),

      body: StreamBuilder<List<HostelModel>>(
        stream: hostelProvider.getLandlordHostels(landlordId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final hostels = snapshot.data!;

          return CustomScrollView(
            slivers: [
              /// 🔹 DASHBOARD SUMMARY CARDS
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _dashboardCard(
                          icon: Icons.home_work,
                          title: "Properties",
                          value: hostels.length.toString(),
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _dashboardCard(
                          icon: Icons.meeting_room,
                          title: "Total Rooms",
                          value: hostels
                              .fold<int>(0, (sum, h) => sum + h.availableRooms)
                              .toString(),
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// 🔹 LIST TITLE
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Text(
                    "Your Listings",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              /// 🔹 PROPERTIES LIST
              hostels.isEmpty
                  ? const SliverFillRemaining(
                      child: Center(child: Text("No properties added yet")),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final hostel = hostels[index];

                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: StyledHostelCard(
                              hostel: hostel,
                              onEdit: () {
                                Navigator.pushNamed(
                                  context,
                                  '/add-hostel',
                                  arguments: hostel,
                                );
                              },
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete Property'),
                                    content: const Text(
                                        'Are you sure you want to delete this property?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await hostelProvider.deleteHostel(hostel.id);
                                }
                              },
                            ),
                          );
                        },
                        childCount: hostels.length,
                      ),
                    ),
            ],
          );
        },
      ),
    );
  }

  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(title,
              style: const TextStyle(fontSize: 13, color: Colors.white70)),
        ],
      ),
    );
  }
}
