import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hostel_provider.dart';
import '../../widgets/hostels_cards.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hostelProvider = Provider.of<HostelProvider>(context);
    hostelProvider.fetchHostels(); // Fetch hostels from Firestore

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Hostels'),
      ),
      body: hostelProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : hostelProvider.hostels.isEmpty
              ? const Center(child: Text('No hostels available'))
              : ListView.builder(
                  itemCount: hostelProvider.hostels.length,
                  itemBuilder: (context, index) {
                    final hostel = hostelProvider.hostels[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          '/room_detail',
                          arguments: hostel.id, // pass hostelId
                        );
                      },
                      child: HostelCard(
                        hostelId: hostel.id,
                        hostelName: hostel.name,
                        location: 'Campus Area',
                        price: hostel.price,
                        availableRooms: hostel.availableRooms,
                      ),
                    );
                  },
                ),
    );
  }
}
