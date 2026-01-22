// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/hostel_provider.dart';

// class RoomDetailScreen extends StatelessWidget {
//   const RoomDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final hostelId = ModalRoute.of(context)!.settings.arguments as String;
//     final hostelProvider = Provider.of<HostelProvider>(context);

//     final hostel =
//         hostelProvider.hostels.firstWhere((hostel) => hostel.id == hostelId);

//     return Scaffold(
//       appBar: AppBar(title: Text(hostel.name)),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Image carousel
//             SizedBox(
//               height: 200,
//               child: PageView.builder(
//                 itemCount: hostel.images.length,
//                 itemBuilder: (context, index) {
//                   return ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       hostel.images[index],
//                       fit: BoxFit.cover,
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             Text('Available Rooms: ${hostel.availableRooms}',
//                 style: const TextStyle(
//                     fontSize: 16, fontWeight: FontWeight.w600)),
//             const SizedBox(height: 8),
//             Text('Price: KES ${hostel.price} / month',
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 16),
//             const Text('Shared Items:',
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 8),
//             Wrap(
//               spacing: 8,
//               children: hostel.sharedItems
//                   .map((item) => Chip(label: Text(item)))
//                   .toList(),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: hostel.availableRooms > 0
//                     ? () {
//                         Navigator.pushNamed(context, '/booking',
//                             arguments: hostel.id);
//                       }
//                     : null,
//                 child: Text(hostel.availableRooms > 0
//                     ? 'Book Now'
//                     : 'No rooms available'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
