import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/providers/hostel_provider.dart';
import 'package:studentsaccomodations/widgets/hostels_cards.dart';

class SingleRoomScreen extends StatelessWidget {
  const SingleRoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final hostels = Provider.of<HostelProvider>(context)
    .hostels
    .where((h) => h.category.toLowerCase() == "single room")
    .toList();


    return Scaffold(
      appBar: AppBar(title: const Text("Single Rooms")),
      body: hostels.isEmpty
          ? const Center(child: Text("No single rooms available"))
          : ListView.builder(
              itemCount: hostels.length,
              itemBuilder: (_, i) => StyledHostelCard(hostel: hostels[i]),
            ),
    );
  }
}
