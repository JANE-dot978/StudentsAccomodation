// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/booking_provider.dart';
// import '../../models/booking_model.dart';

// class BookingApprovalScreen extends StatelessWidget {
//   const BookingApprovalScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final bookingProvider = Provider.of<BookingProvider>(context, listen: false);

//     final landlordId = 'CURRENT_LANDLORD_ID'; // replace with actual landlord UID

//     return StreamBuilder<List<Booking>>(
//       stream: bookingProvider.getLandlordBookings(landlordId),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No booking requests'));
//         }

//         final bookings = snapshot.data!;

//         return ListView.builder(
//           itemCount: bookings.length,
//           itemBuilder: (context, index) {
//             final booking = bookings[index];

//             return Card(
//               child: ListTile(
//                 title: Text('Room: ${booking.roomId}'),
//                 subtitle: Text('Status: ${booking.status}'),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: const Icon(Icons.check, color: Colors.green),
//                       onPressed: () {
//                         bookingProvider.approveBooking(booking.id);
//                       },
//                     ),
//                     IconButton(
//                       icon: const Icon(Icons.close, color: Colors.red),
//                       onPressed: () {
//                         bookingProvider.rejectBooking(booking.id);
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }
