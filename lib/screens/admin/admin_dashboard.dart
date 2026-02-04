// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Admin Dashboard'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () async {
//               await authProvider.logout();
//               if (context.mounted) {
//                 Navigator.of(context).pushReplacementNamed('/login');
//               }
//             },
//           )
//         ],
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               'Admin Dashboard',
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 32),
//             _DashboardButton(
//               icon: Icons.people,
//               label: 'Manage Users',
//               onPressed: () {},
//             ),
//             const SizedBox(height: 16),
//             _DashboardButton(
//               icon: Icons.home,
//               label: 'Manage Properties',
//               onPressed: () {},
//             ),
//             const SizedBox(height: 16),
//             _DashboardButton(
//               icon: Icons.report,
//               label: 'Reports',
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _DashboardButton extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final VoidCallback onPressed;

//   const _DashboardButton({
//     required this.icon,
//     required this.label,
//     required this.onPressed,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: 200,
//       height: 60,
//       child: ElevatedButton.icon(
//         icon: Icon(icon),
//         label: Text(label),
//         onPressed: onPressed,
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';

// This is your AdminDashboard widget that integrates with your existing app
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  int _currentIndex = 0;
  bool _isDarkMode = false;

  List<Widget> get _screens => [
    DashboardScreen(
      isDarkMode: _isDarkMode,
      onToggleTheme: _toggleTheme,
    ),
    const UserManagementScreen(),
    const VerifyLandlordsScreen(),
  ];

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _isDarkMode;
    
    return Theme(
      data: isDark ? _buildDarkTheme() : _buildLightTheme(),
      child: Scaffold(
        body: _screens[_currentIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedItemColor: const Color(0xFF2D5BFF),
            unselectedItemColor: const Color(0xFF8F9BB3),
            selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_outlined),
                activeIcon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_outline),
                activeIcon: Icon(Icons.people),
                label: 'Users',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.verified_user_outlined),
                activeIcon: Icon(Icons.verified_user),
                label: 'Verify',
              ),
            ],
          ),
        ),
      ),
    );
  }

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFF5F7FA),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF1A2138),
        elevation: 0,
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardColor: const Color(0xFF1E1E1E),
    );
  }
}

// Dashboard Screen
class DashboardScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;
  
  const DashboardScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleTheme,
  }) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int totalProperties = 24;
  int verifiedLandlords = 18;
  int activeTenants = 56;
  int totalPayments = 650000;

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate back to login
              Navigator.pushReplacementNamed(context, '/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF3B30),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _downloadReport(String reportType) async {
    _showSnackBar('Downloading $reportType report...');
    
    // Simulate download delay
    await Future.delayed(const Duration(seconds: 2));
    
    _showSnackBar('$reportType report downloaded successfully!');
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showReportOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final isDark = widget.isDarkMode;
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Download Reports',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2138),
                ),
              ),
              const SizedBox(height: 20),
              _buildReportOption(
                'Monthly Revenue Report',
                Icons.attach_money,
                const Color(0xFF2D5BFF),
                () {
                  Navigator.pop(context);
                  _downloadReport('Monthly Revenue');
                },
              ),
              _buildReportOption(
                'User Activity Report',
                Icons.people,
                const Color(0xFF00C48C),
                () {
                  Navigator.pop(context);
                  _downloadReport('User Activity');
                },
              ),
              _buildReportOption(
                'Property Analytics',
                Icons.home,
                const Color(0xFFFF9500),
                () {
                  Navigator.pop(context);
                  _downloadReport('Property Analytics');
                },
              ),
              _buildReportOption(
                'Payment Summary',
                Icons.account_balance_wallet,
                const Color(0xFFAF52DE),
                () {
                  Navigator.pop(context);
                  _downloadReport('Payment Summary');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReportOption(String title, IconData icon, Color color, VoidCallback onTap) {
    final isDark = widget.isDarkMode;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1A2138),
                ),
              ),
            ),
            Icon(
              Icons.download,
              color: isDark ? Colors.white70 : const Color(0xFF8F9BB3),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A2138),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.white : const Color(0xFF1A2138),
            ),
            onPressed: () {
              widget.onToggleTheme();
              _showSnackBar(
                widget.isDarkMode 
                  ? 'Light mode enabled' 
                  : 'Dark mode enabled'
              );
            },
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: Icon(
              Icons.download_outlined,
              color: isDark ? Colors.white : const Color(0xFF1A2138),
            ),
            onPressed: _showReportOptions,
            tooltip: 'Download reports',
          ),
          IconButton(
            icon: Icon(
              Icons.notifications_outlined,
              color: isDark ? Colors.white : const Color(0xFF1A2138),
            ),
            onPressed: () => _showSnackBar('No new notifications'),
          ),
          PopupMenuButton<String>(
            icon: const CircleAvatar(
              backgroundColor: Color(0xFF2D5BFF),
              child: Text('A', style: TextStyle(color: Colors.white)),
            ),
            onSelected: (value) {
              if (value == 'profile') {
                _showSnackBar('Profile page coming soon');
              } else if (value == 'settings') {
                _showSnackBar('Settings page coming soon');
              } else if (value == 'logout') {
                _showLogoutDialog();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline),
                    SizedBox(width: 12),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Color(0xFFFF3B30)),
                    SizedBox(width: 12),
                    Text('Logout', style: TextStyle(color: Color(0xFFFF3B30))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: [
                _buildStatCard(
                  'Total Properties',
                  '$totalProperties',
                  Icons.home_outlined,
                  const Color(0xFF2D5BFF),
                  const Color(0xFFE8EDFF),
                  '+3 this month',
                  isDark,
                ),
                _buildStatCard(
                  'Verified Landlords',
                  '$verifiedLandlords',
                  Icons.verified_user,
                  const Color(0xFF00C48C),
                  const Color(0xFFD4F4E8),
                  '+2 this week',
                  isDark,
                ),
                _buildStatCard(
                  'Active Tenants',
                  '$activeTenants',
                  Icons.people,
                  const Color(0xFFFF9500),
                  const Color(0xFFFFEDD4),
                  '+8 this month',
                  isDark,
                ),
                _buildStatCard(
                  'Total Payments',
                  'KES ${(totalPayments / 1000).toStringAsFixed(0)}K',
                  Icons.account_balance_wallet,
                  const Color(0xFFAF52DE),
                  const Color(0xFFF3E5FF),
                  '+12% vs last month',
                  isDark,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Revenue Chart
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Revenue Overview',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : const Color(0xFF1A2138),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00C48C).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '+12%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00C48C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 150,
                    child: CustomPaint(
                      painter: ChartPainter(isDark: isDark),
                      child: Container(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Quick Actions
            Text(
              'Quick Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1A2138),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    'Add Property',
                    Icons.add_home,
                    const Color(0xFF2D5BFF),
                    () => _showSnackBar('Add Property page coming soon'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionButton(
                    'View Reports',
                    Icons.bar_chart,
                    const Color(0xFF00C48C),
                    _showReportOptions,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color bgColor,
    String subtitle,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? color.withOpacity(0.2) : bgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1A2138),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white70 : const Color(0xFF8F9BB3),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white54 : const Color(0xFF8F9BB3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// User Management Screen
class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        title: Text(
          'User Management',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A2138),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: isDark ? Colors.white : const Color(0xFF1A2138)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildUserCard('Alice', 'Landlord', true, isDark),
          _buildUserCard('Henry', 'Tenant', false, isDark),
          _buildUserCard('Peter Mwangi', 'Landlord', true, isDark),
          _buildUserCard('Greenspan Bahitire', 'Tenant', false, isDark),
        ],
      ),
    );
  }

  Widget _buildUserCard(String name, String role, bool isLandlord, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: isLandlord ? const Color(0xFFE8EDFF) : const Color(0xFFFFEDD4),
            child: Icon(
              isLandlord ? Icons.home : Icons.person,
              color: isLandlord ? const Color(0xFF2D5BFF) : const Color(0xFFFF9500),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : const Color(0xFF1A2138),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white70 : const Color(0xFF8F9BB3),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isLandlord ? const Color(0xFFD4F4E8) : const Color(0xFFFFE5E5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              isLandlord ? 'Verified' : 'Pending',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isLandlord ? const Color(0xFF00C48C) : const Color(0xFFFF3B30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Verify Landlords Screen
class VerifyLandlordsScreen extends StatefulWidget {
  const VerifyLandlordsScreen({Key? key}) : super(key: key);

  @override
  State<VerifyLandlordsScreen> createState() => _VerifyLandlordsScreenState();
}

class _VerifyLandlordsScreenState extends State<VerifyLandlordsScreen> {
  final List<Map<String, dynamic>> landlords = [
    {'name': 'Peter Mwangi', 'status': 'Pending', 'isPending': true},
    {'name': 'Greenspan Bahitire', 'status': 'Pending', 'isPending': true},
    {'name': 'Alice Kamande', 'status': 'Verified', 'isPending': false},
    {'name': 'Henry Mwenda', 'status': 'Verified', 'isPending': false},
  ];

  void _handleApprove(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Landlord'),
        content: Text('Are you sure you want to approve ${landlords[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                landlords[index]['status'] = 'Verified';
                landlords[index]['isPending'] = false;
              });
              _showSnackBar('${landlords[index]['name']} has been approved');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C48C),
            ),
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _handleReject(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Landlord'),
        content: Text('Are you sure you want to reject ${landlords[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                landlords[index]['status'] = 'Rejected';
                landlords[index]['isPending'] = false;
              });
              _showSnackBar('${landlords[index]['name']} has been rejected');
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

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0,
        title: Text(
          'Verify Landlords',
          style: TextStyle(
            color: isDark ? Colors.white : const Color(0xFF1A2138),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: landlords.length,
        itemBuilder: (context, index) {
          return _buildLandlordCard(
            landlords[index]['name'],
            landlords[index]['status'],
            landlords[index]['isPending'],
            isDark,
            index,
          );
        },
      ),
    );
  }

  Widget _buildLandlordCard(String name, String status, bool isPending, bool isDark, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: const Color(0xFFE8EDFF),
                child: Text(
                  name[0],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D5BFF),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white : const Color(0xFF1A2138),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: status == 'Verified' 
                            ? const Color(0xFFD4F4E8) 
                            : status == 'Rejected'
                            ? const Color(0xFFFFE5E5)
                            : const Color(0xFFFFEDD4),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: status == 'Verified' 
                              ? const Color(0xFF00C48C) 
                              : status == 'Rejected'
                              ? const Color(0xFFFF3B30)
                              : const Color(0xFFFF9500),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isPending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _handleApprove(index),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00C48C),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Approve',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _handleReject(index),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFFF3B30),
                      side: const BorderSide(color: Color(0xFFFF3B30)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Reject',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// Custom Chart Painter
class ChartPainter extends CustomPainter {
  final bool isDark;

  ChartPainter({this.isDark = false});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF2D5BFF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF2D5BFF).withOpacity(0.2),
          const Color(0xFF2D5BFF).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final fillPath = Path();

    // Sample data points
    final points = [
      Offset(0, size.height * 0.7),
      Offset(size.width * 0.2, size.height * 0.5),
      Offset(size.width * 0.4, size.height * 0.6),
      Offset(size.width * 0.6, size.height * 0.3),
      Offset(size.width * 0.8, size.height * 0.4),
      Offset(size.width, size.height * 0.2),
    ];

    path.moveTo(points[0].dx, points[0].dy);
    fillPath.moveTo(points[0].dx, size.height);
    fillPath.lineTo(points[0].dx, points[0].dy);

    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
      fillPath.lineTo(points[i].dx, points[i].dy);
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(ChartPainter oldDelegate) => oldDelegate.isDark != isDark;
}