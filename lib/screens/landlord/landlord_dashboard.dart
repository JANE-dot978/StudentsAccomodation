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
      appBar: AppBar(
        title: const Text('Landlord Dashboard'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 🔹 STATS SECTION
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: const [
                Row(
                  children: [
                    StatCard(
                      title: 'Total Hostels',
                      value: '8',
                      icon: Icons.apartment,
                      color: Colors.blue,
                    ),
                    StatCard(
                      title: 'Total Rooms',
                      value: '120',
                      icon: Icons.meeting_room,
                      color: Colors.green,
                    ),
                  ],
                ),
                Row(
                  children: [
                    StatCard(
                      title: 'Occupied',
                      value: '92',
                      icon: Icons.people,
                      color: Colors.orange,
                    ),
                    StatCard(
                      title: 'Pending Bookings',
                      value: '5',
                      icon: Icons.pending_actions,
                      color: Colors.red,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // 🔹 ACTIVE SCREEN CONTENT
          Expanded(child: _screens[_currentIndex]),
        ],
      ),

      // 🔹 PROFESSIONAL NAV BAR
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
}
