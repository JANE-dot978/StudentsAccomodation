import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';

import '../../screens/student/student_home_screen.dart';
import '../../screens/student/room_detail_screen.dart';
import '../../screens/student/booking_screen.dart';

import '../../screens/landlord/landlord_dashboard.dart';
import '../../screens/landlord/add_hostel_screen.dart';

import '../../screens/admin/admin_dashboard.dart';

import '../../models/hostel_model.dart';

class AppRoutes {
  // Static routes
  static const String login = '/login';
  static const String register = '/register';
  static const String studentHome = '/student-home';
  static const String landlordDashboard = '/landlord-dashboard';
  static const String addHostel = '/add-hostel';
  static const String adminDashboard = '/admin-dashboard';

  /// Static routes map (screens without required arguments)
  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    studentHome: (context) => const StudentHomeScreen(),
    landlordDashboard: (context) => const LandlordDashboard(),
    addHostel: (context) => const AddHostelScreen(),
    adminDashboard: (context) => const AdminDashboard(),
  };

  /// Dynamic route generator (screens requiring parameters)
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/booking':
        final hostel = settings.arguments as HostelModel;
        return MaterialPageRoute(
          builder: (_) => BookingScreen(hostel: hostel),
        );

      case '/room-detail':
        final hostel = settings.arguments as HostelModel;
        return MaterialPageRoute(
          builder: (_) => RoomDetailScreen(hostel: hostel),
        );

      default:
        // Fallback screen if route not found
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found')),
          ),
        );
    }
  }
}
