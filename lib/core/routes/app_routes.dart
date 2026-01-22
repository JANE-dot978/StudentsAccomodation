import 'package:flutter/material.dart';

import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';

import '../../screens/student/student_home_screen.dart';
import '../../screens/student/room_detail_screen.dart';
import '../../screens/student/booking_screen.dart';

import '../../screens/landlord/landlord_dashboard.dart';
import '../../screens/landlord/add_hostel_screen.dart';

import '../../screens/admin/admin_dashboard.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';

  static const String studentHome = '/student-home';
  static const String roomDetail = '/room-detail';
  static const String booking = '/booking';

  static const String landlordDashboard = '/landlord-dashboard';
  static const String addHostel = '/add-hostel';

  static const String adminDashboard = '/admin-dashboard';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    studentHome: (context) => const StudentHomeScreen(),
    roomDetail: (context) => const RoomDetailScreen(),
    booking: (context) => const BookingScreen(),
    landlordDashboard: (context) => const LandlordDashboard(),
    addHostel: (context) => const AddHostelScreen(),
    adminDashboard: (context) => const AdminDashboard(),
  };
}
