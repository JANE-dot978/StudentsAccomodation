// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/hostel_provider.dart';
// import '../../widgets/hostels_cards.dart';
// import '../../models/hostel_model.dart';

// class PropertyScreen extends StatelessWidget {
//   const PropertyScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
//     final landlordId = 'CURRENT_LANDLORD_ID'; // replace with actual landlord UID

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.pushNamed(context, '/add-hostel');
//         },
//         child: const Icon(Icons.add),
//       ),
//       body: StreamBuilder<List<HostelModel>>(
//         stream: hostelProvider.getLandlordHostels(landlordId),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No hostels added yet'));
//           }

//           final hostels = snapshot.data!;

//           return ListView.builder(
//             itemCount: hostels.length,
//             itemBuilder: (context, index) {
//               final hostel = hostels[index];

//               return HostelCard(
//                 hostelId: hostel.id,
//                 hostelName: hostel.name,
//                 location: 'Campus Area',
//                 price: hostel.price,
//                 availableRooms: hostel.availableRooms,
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }
