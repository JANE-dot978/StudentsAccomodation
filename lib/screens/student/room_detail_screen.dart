import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hostel_provider.dart';
import '../../models/hostel_model.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hostelId = ModalRoute.of(context)!.settings.arguments as String;
    final hostelProvider = Provider.of<HostelProvider>(context);

    // Find the hostel by ID
    final hostel =
        hostelProvider.hostels.firstWhere((hostel) => hostel.id == hostelId);

    return Scaffold(
      appBar: AppBar(title: Text(hostel.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image carousel
            SizedBox(
              height: 250,
              child: PageView.builder(
                itemCount: hostel.images.isNotEmpty ? hostel.images.length : 1,
                itemBuilder: (context, index) {
                  return ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(12)),
                    child: hostel.images.isNotEmpty
                        ? Image.network(
                            hostel.images[index],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(Icons.home, size: 60),
                            ),
                          ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Hostel name and price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          hostel.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text('KES ${hostel.price}/mo',
                          style: const TextStyle(
                              fontSize: 18, color: Colors.blue)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Location
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 18),
                      const SizedBox(width: 4),
                      Text(hostel.location,
                          style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Description
                  const Text('Description',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(hostel.description, style: const TextStyle(fontSize: 15)),
                  const SizedBox(height: 16),

                  // Shared amenities
                  if (hostel.sharedItems.isNotEmpty) ...[
                    const Text('Amenities',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 8,
                      children: hostel.sharedItems
                          .map((item) => Chip(label: Text(item)))
                          .toList(),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Available rooms and booking button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Available: ${hostel.availableRooms}',
                          style: const TextStyle(fontSize: 16)),
                      ElevatedButton(
                        onPressed: hostel.availableRooms > 0
                            ? () {
                                Navigator.pushNamed(context, '/booking',
                                    arguments: hostel.id);
                              }
                            : null,
                        child: Text(hostel.availableRooms > 0
                            ? 'Book Now'
                            : 'No rooms available'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
