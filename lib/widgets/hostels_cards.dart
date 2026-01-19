import 'package:flutter/material.dart';

class HostelCard extends StatelessWidget {
  final String hostelId;
  final String hostelName;
  final String location;
  final int price;
  final int availableRooms;

  const HostelCard({
    super.key,
    required this.hostelId,
    required this.hostelName,
    required this.location,
    required this.price,
    required this.availableRooms,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            '/room-details',
            arguments: hostelId,
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hostelName,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(location),
              const SizedBox(height: 8),
              Text('From KES $price / month'),
              const SizedBox(height: 8),
              Text(
                '$availableRooms rooms available',
                style: TextStyle(
                  color: availableRooms > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
