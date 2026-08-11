import 'package:flutter/material.dart';

// ===== AUTH =====
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/auth/forgot_password_screen.dart'; // ✅ ADD THIS

// ===== MAIN NAV =====
import '../../screens/main_navigation_screen.dart';

// ===== STUDENT SCREENS =====
import '../../screens/student/student_home_screen.dart';
import '../../screens/student/room_detail_screen.dart';
import '../../screens/student/booking_screen.dart';
import '../../screens/student/search_screen.dart';
import '../../screens/student/edit_profile_screen.dart';
import '../../screens/student/favourites_screen.dart';
import '../../screens/student/settings_screen.dart';
import '../../screens/student/help_support_screen.dart';

// Alias the student profile
import '../../screens/student/profile_screen.dart' as student;

// Category screens
import '../../screens/student/categories/single_room_screen.dart';
import '../../screens/student/categories/bedsitter_screen.dart';
import '../../screens/student/categories/shared_room_screen.dart';

// ===== LANDLORD SCREENS =====
import '../../screens/landlord/landlord_dashboard.dart';
import '../../screens/landlord/add_hostel_screen.dart';
import '../../screens/landlord/landlord_main_navigation.dart';

// Alias the landlord profile
import '../../screens/landlord/profile_screen.dart' as landlord;

// ===== ADMIN =====
import '../../screens/admin/admin_dashboard.dart';

// ===== MODELS =====
import '../../models/hostel_model.dart';

class AppRoutes {

  // ================= AUTH =================
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // ================= MAIN =================
  static const String mainNavigation = '/main';

  // ================= STUDENT =================
  static const String studentHome = '/student-home';
  static const String search = '/search';
  static const String studentProfile = '/student-profile';
  static const String editProfile = '/edit-profile';
  static const String favorites = '/favorites';
  static const String settings = '/settings';
  static const String helpSupport = '/help-support';

  // Categories
  static const String singleRooms = '/single-rooms';
  static const String bedsitters = '/bedsitters';
  static const String sharedRooms = '/shared-rooms';

  // Dynamic routes
  static const String booking = '/booking';
  static const String roomDetail = '/room-detail';

  // ================= LANDLORD =================
  static const String landlordDashboard = '/landlord-dashboard';
  static const String landlordProfile = '/landlord-profile';
  static const String addHostel = '/add-hostel';
  static const String landlordMain = '/landlord-main';

  // ================= ADMIN =================
  static const String adminDashboard = '/admin-dashboard';


  /// ================= STATIC ROUTES =================
  static final Map<String, WidgetBuilder> routes = {

    // AUTH
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(), // ✅ ADDED

    // MAIN NAV
    mainNavigation: (context) => const MainNavigationScreen(),

    // STUDENT
    studentHome: (context) => const StudentHomeScreen(),
    search: (context) => const SearchScreen(),
    studentProfile: (context) => const student.ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    favorites: (context) => const FavoritesScreen(),
    settings: (context) => const SettingsScreen(),
    helpSupport: (context) => const HelpSupportScreen(),

    // Category screens
    singleRooms: (context) => const SingleRoomScreen(),
    bedsitters: (context) => const BedsitterScreen(),
    sharedRooms: (context) => const SharedRoomScreen(),

    // LANDLORD
    landlordDashboard: (context) => const LandlordDashboard(),
    landlordProfile: (context) => const landlord.ProfileScreen(),
    addHostel: (context) => const AddHostelScreen(),
    landlordMain: (context) => const LandlordMainNavigation(),

    // ADMIN
    adminDashboard: (context) => const AdminDashboard(),
  };


  /// ================= DYNAMIC ROUTES =================
  static Route<dynamic>? generateRoute(RouteSettings settings) {

    switch (settings.name) {

      case booking:
        final hostel = settings.arguments as HostelModel;
        return MaterialPageRoute(
          builder: (_) => BookingScreen(hostel: hostel),
        );

      case roomDetail:
        final hostel = settings.arguments as HostelModel;
        return MaterialPageRoute(
          builder: (_) => RoomDetailScreen(hostel: hostel),
        );

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'Page not found',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Route: ${settings.name}',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.login,
                      (route) => false,
                    ),
                    icon: const Icon(Icons.home),
                    label: const Text('Go to Login'),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }


  // ================= NAVIGATION HELPERS =================

  /// After login (Student)
  static void navigateToStudent(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      mainNavigation,
      (route) => false,
    );
  }

  /// Landlord
  static void navigateToLandlord(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      landlordMain,
      (route) => false,
    );
  }

  /// Admin
  static void navigateToAdmin(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      adminDashboard,
      (route) => false,
    );
  }

  /// Role router
  static void navigateByRole(BuildContext context, String role) {
    switch (role.toLowerCase()) {
      case 'student':
        navigateToStudent(context);
        break;
      case 'landlord':
        navigateToLandlord(context);
        break;
      case 'admin':
        navigateToAdmin(context);
        break;
      default:
        Navigator.pushNamedAndRemoveUntil(
          context,
          login,
          (route) => false,
        );
    }
  }
}