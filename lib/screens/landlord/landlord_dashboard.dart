import 'package:flutter/material.dart';
import '../../widgets/stat_card.dart';
import 'property_screen.dart';
import 'booking_approval_screen.dart';
import 'maintenance_screen.dart';

class LandlordDashboard extends StatefulWidget {
  const LandlordDashboard({super.key});

  @override
  State<LandlordDashboard> createState() => _LandlordDashboardState();
}

class _LandlordDashboardState extends State<LandlordDashboard> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PropertyScreen(),
    BookingApprovalScreen(),
    MaintenanceScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      // 🔹 APP BAR
      appBar: AppBar(
        title: const Text('Landlord Dashboard'),
        centerTitle: true,
        elevation: 0,
      ),

      // 🔹 SIDEBAR DRAWER
      drawer: _buildDrawer(context),

      // 🔹 BODY
      body: Column(
        children: [
          _buildStatsSection(), // Smaller stats
          const Divider(height: 1),
          Expanded(child: _screens[_currentIndex]),
        ],
      ),

      // 🔹 BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_work), label: 'Properties'),
          BottomNavigationBarItem(
              icon: Icon(Icons.book_online), label: 'Bookings'),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), label: 'Maintenance'),
        ],
      ),
    );
  }

  // 🔹 SMALL PROFESSIONAL STATS SECTION
  Widget _buildStatsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        children: const [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Hostels',
                  value: '8',
                  icon: Icons.apartment,
                  color: Colors.blue,
                  small: true,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  title: 'Rooms',
                  value: '120',
                  icon: Icons.meeting_room,
                  color: Colors.green,
                  small: true,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: StatCard(
                  title: 'Occupied',
                  value: '92',
                  icon: Icons.people,
                  color: Colors.orange,
                  small: true,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: StatCard(
                  title: 'Pending',
                  value: '5',
                  icon: Icons.pending_actions,
                  color: Colors.red,
                  small: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 🔹 DRAWER (SIDEBAR)
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            accountName: const Text("Landlord Name"),
            accountEmail: const Text("landlord@email.com"),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.blue),
            ),
          ),

          _drawerItem(Icons.dashboard, "Dashboard", () {
            Navigator.pop(context);
          }),
          _drawerItem(Icons.home_work, "My Properties", () {
            Navigator.pop(context);
            setState(() => _currentIndex = 0);
          }),
          _drawerItem(Icons.book_online, "Bookings", () {
            Navigator.pop(context);
            setState(() => _currentIndex = 1);
          }),
          _drawerItem(Icons.build, "Maintenance", () {
            Navigator.pop(context);
            setState(() => _currentIndex = 2);
          }),
          const Divider(),
          _drawerItem(Icons.person, "Profile", () {
            // Navigate to profile screen later
          }),
          _drawerItem(Icons.settings, "Settings", () {
            // Navigate to settings later
          }),
          const Spacer(),
          _drawerItem(Icons.logout, "Logout", () {
            // Add logout logic
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // 🔹 REUSABLE DRAWER ITEM
  ListTile _drawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }
}
