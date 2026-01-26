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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final landlordId = user.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      // 🔹 APP BAR
      appBar: AppBar(
        title: const Text("Landlord Dashboard"),
        elevation: 0,
      ),

      // 🔹 SIDE BAR
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              accountName: const Text("Landlord"),
              accountEmail: Text(user.email ?? ""),
              currentAccountPicture: const CircleAvatar(
                child: Icon(Icons.person, size: 30),
              ),
            ),
            _drawerItem(Icons.home, "My Properties", () {
              Navigator.pop(context);
            }),
            _drawerItem(Icons.analytics, "Reports", () {}),
            _drawerItem(Icons.book_online, "Bookings", () {}),
            _drawerItem(Icons.settings, "Settings", () {}),
            const Divider(),
            _drawerItem(Icons.logout, "Logout", () {
              authProvider.logout();
            }),
          ],
        ),
      ),

      // 🔹 ADD PROPERTY BUTTON
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/add-hostel'),
        icon: const Icon(Icons.add),
        label: const Text("Add Property"),
      ),

      // 🔹 BODY
      body: StreamBuilder<List<HostelModel>>(
        stream: hostelProvider.getLandlordHostels(landlordId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final hostels = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔹 DASHBOARD TITLE
                const Text(
                  "Overview",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // 🔹 SUMMARY CARDS
                Row(
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

                const SizedBox(height: 24),

                // 🔹 PROPERTY SECTION TITLE
                const Text(
                  "Your Listings",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                // 🔹 PROPERTIES LIST
                if (hostels.isEmpty)
                  const Center(child: Text("No properties added yet"))
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: hostels.length,
                    itemBuilder: (context, index) {
                      final hostel = hostels[index];

                      return StyledHostelCard(
                        hostel: hostel,
                        onEdit: () {
                          Navigator.pushNamed(
                            context,
                            '/add-hostel',
                            arguments: hostel,
                          );
                        },
                        onDelete: () async {
                          await hostelProvider.deleteHostel(hostel.id);
                        },
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

  // 🔹 DASHBOARD CARD
  Widget _dashboardCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(value,
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white)),
          Text(title, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }

  // 🔹 DRAWER ITEM
  Widget _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
