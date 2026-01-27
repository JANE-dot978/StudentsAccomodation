// import 'package:flutter/material.dart';
// import '../../models/hostel_model.dart';
// import 'booking_screen.dart';
// import '../../widgets/image_carousel.dart';

// class RoomDetailScreen extends StatelessWidget {
//   final HostelModel hostel;

//   const RoomDetailScreen({required this.hostel, super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(hostel.name)),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           // Image carousel
//           ImageCarousel(imageUrls: hostel.images),
//           const SizedBox(height: 16),

//           // Hostel name and location
//           Text(
//             hostel.name,
//             style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             hostel.location,
//             style: const TextStyle(fontSize: 16, color: Colors.grey),
//           ),
//           const SizedBox(height: 8),

//           // Price and available rooms
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text('Price: KES ${hostel.price}/mo',
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold)),
//               Text('Available: ${hostel.availableRooms}',
//                   style: const TextStyle(fontSize: 16)),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Description
//           const Text(
//             'Description',
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 6),
//           Text(hostel.description, style: const TextStyle(fontSize: 16)),
//           const SizedBox(height: 16),

//           // Amenities
//           if (hostel.sharedItems.isNotEmpty) ...[
//             const Text(
//               'Amenities',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 6),
//             Wrap(
//               spacing: 8,
//               children: hostel.sharedItems
//                   .map((item) => Chip(label: Text(item)))
//                   .toList(),
//             ),
//             const SizedBox(height: 16),
//           ],

//           // Terms & Conditions
//           ExpansionTile(
//             title: const Text('Terms and Conditions'),
//             children: const [
//               Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                     'Bookings are subject to landlord approval before payment.'),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16),

//           // Book Now Button
//           ElevatedButton(
//             onPressed: hostel.availableRooms > 0
//                 ? () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (_) => BookingScreen(hostel: hostel),
//                       ),
//                     );
//                   }
//                 : null,
//             child: Text(
//               hostel.availableRooms > 0 ? 'Book Now' : 'No rooms available',
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
