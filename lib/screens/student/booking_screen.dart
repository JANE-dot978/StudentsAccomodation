// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import '../../models/booking_model.dart';
// import '../../providers/auth_provider.dart';
// import '../../providers/booking_provider.dart';

// class BookingScreen extends StatefulWidget {
//   const BookingScreen({super.key});

//   @override
//   State<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends State<BookingScreen> {
//   bool _isBooking = false;

//   @override
//   Widget build(BuildContext context) {
//     final bookingProvider = Provider.of<BookingProvider>(context);
//     final authProvider = Provider.of<AuthProvider>(context);
//     final hostelId = ModalRoute.of(context)!.settings.arguments as String;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Confirm Booking')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text(
//               'Do you want to confirm your booking for this hostel?',
//               style: TextStyle(fontSize: 16),
//             ),
//             const SizedBox(height: 24),
//             bookingProvider.isLoading || _isBooking
//                 ? const CircularProgressIndicator()
//                 : SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: () async {
//                         setState(() => _isBooking = true);

//                         try {
//                           final booking = Booking(
//                             id: DateTime.now().millisecondsSinceEpoch.toString(),
//                             studentId: authProvider.user!.uid,
//                             landlordId: 'landlord_placeholder',
//                             hostelId: hostelId,
//                             roomId: 'defaultRoom',
//                             checkInDate: DateTime.now(),
//                             checkOutDate: DateTime.now().add(const Duration(days: 30)),
//                             totalPrice: 9000,
//                             status: 'pending',
//                             createdAt: Timestamp.now(),
//                           );

//                           await bookingProvider.createBooking(booking);

//                           if (!mounted) return;
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text(
//                                     'Booking request sent! Waiting for approval.')),
//                           );

//                           Navigator.pushReplacementNamed(
//                               context, '/student_dashboard');
//                         } catch (e) {
//                           if (!mounted) return;
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text('Error: $e')),
//                           );
//                         } finally {
//                           setState(() => _isBooking = false);
//                         }
//                       },
//                       child: const Text('Confirm Booking'),
//                     ),
//                   ),
//           ],
//         ),
//       ),
//     );
//   }
// }
