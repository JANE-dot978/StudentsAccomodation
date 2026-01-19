import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'core/routes/app_routes.dart';
import 'screens/auth/login_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Hostel & Bedsitter Management',
          theme: ThemeData(primarySwatch: Colors.blue),
          initialRoute: AppRoutes.login,
          routes: AppRoutes.routes,
          home: _buildHome(authProvider),
        );
      },
    );
  }

  Widget _buildHome(AuthProvider authProvider) {
    if (authProvider.user == null) {
      return const LoginScreen();
    }

    return _RoleBasedHome(userId: authProvider.user!.uid);
  }
}

class _RoleBasedHome extends StatelessWidget {
  final String userId;

  const _RoleBasedHome({required this.userId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text('Error loading user data')),
          );
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final role = userData['role'] ?? 'user';

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (role == 'student' || role == 'user') {
            Navigator.pushReplacementNamed(context, AppRoutes.studentHome);
          } else if (role == 'landlord') {
            Navigator.pushReplacementNamed(context, AppRoutes.landlordDashboard);
          } else if (role == 'admin') {
            Navigator.pushReplacementNamed(context, AppRoutes.adminDashboard);
          }
        });

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
