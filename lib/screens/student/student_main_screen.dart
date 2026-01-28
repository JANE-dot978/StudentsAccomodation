// import 'package:flutter/material.dart';
// import 'package:studentsaccomodations/screens/landlord/profile_screen.dart';
// import 'student_home_screen.dart';
// import 'booking_screen.dart';
// import 'profile_screen.dart';

// class StudentMainScreen extends StatefulWidget {
//   const StudentMainScreen({super.key});

//   @override
//   State<StudentMainScreen> createState() => _StudentMainScreenState();
// }

// class _StudentMainScreenState extends State<StudentMainScreen> {
//   int _index = 0;

//   final pages = const [
//     StudentHomeScreen(),
//     BookingScreen(),
//     ProfileScreen(),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: pages[_index],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _index,
//         onTap: (i) => setState(() => _index = i),
//         selectedItemColor: Colors.blueAccent,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.book), label: "Bookings"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
//         ],
//       ),
//     );
//   }
// }
