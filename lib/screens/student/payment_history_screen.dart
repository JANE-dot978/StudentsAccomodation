// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/booking_provider.dart';
// import '../../providers/auth_provider.dart';

// class PaymentHistoryScreen extends StatelessWidget {
//   const PaymentHistoryScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//     final bookingProvider = Provider.of<BookingProvider>(context);

//     bookingProvider.fetchStudentBookings(authProvider.user!.uid);

//     return Scaffold(
//       appBar: AppBar(title: const Text('My Bookings')),
//       body: bookingProvider.studentBookings.isEmpty
//           ? const Center(child: Text('No bookings yet'))
//           : ListView.builder(
//               itemCount: bookingProvider.studentBookings.length,
//               itemBuilder: (context, index) {
//                 final booking = bookingProvider.studentBookings[index];
//                 Color statusColor;
//                 switch (booking.status) {
//                   case 'approved':
//                     statusColor = Colors.green;
//                     break;
//                   case 'rejected':
//                     statusColor = Colors.red;
//                     break;
//                   default:
//                     statusColor = Colors.orange;
//                 }
//                 return Card(
//                   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: ListTile(
//                     title: Text('Hostel ID: ${booking.hostelId}'),
//                     subtitle: Text('Price: KES ${booking.totalPrice}'),
//                     trailing: Text(
//                       booking.status.toUpperCase(),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: statusColor,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }
