import 'package:flutter/material.dart';
import '../../models/hostel_model.dart';
import '../../widgets/image_carousel.dart';
import 'booking_screen.dart';

class HostelDetailScreen extends StatelessWidget {
  final HostelModel hostel;

  const HostelDetailScreen({required this.hostel, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hostel.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ImageCarousel(imageUrls: hostel.images),
          const SizedBox(height: 16),
          Text(hostel.name,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(hostel.location),
          const SizedBox(height: 8),
          Text('Price: KES ${hostel.price}'),
          Text('Available Rooms: ${hostel.availableRooms}'),
          const SizedBox(height: 16),
          Text('Description',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(hostel.description ?? ''),
          const SizedBox(height: 16),
          ExpansionTile(
            title: const Text('Terms and Conditions'),
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                    'Bookings are subject to landlord approval before payment.'),
              )
            ],
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BookingScreen(hostel: hostel),
                ),
              );
            },
            child: const Text('Book Now'),
          )
        ],
      ),
    );
  }
}
