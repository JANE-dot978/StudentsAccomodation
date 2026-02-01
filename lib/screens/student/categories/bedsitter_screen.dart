// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:studentsaccomodations/providers/hostel_provider.dart';
// import 'package:studentsaccomodations/widgets/hostels_cards.dart';

// class BedsitterScreen extends StatelessWidget {
//   const BedsitterScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//      final hostels = Provider.of<HostelProvider>(context)
//     .hostels
//     .where((h) => h.category.toLowerCase() == "bed sitter")
//     .toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Bedsitters")),
//       body: hostels.isEmpty
//           ? const Center(child: Text("No bedsitters available"))
//           : ListView.builder(
//               itemCount: hostels.length,
//               itemBuilder: (_, i) => StyledHostelCard(hostel: hostels[i]),
//             ),
//     );
//   }
// }
