import 'package:flutter/material.dart';
import '../models/hostel_model.dart';

class StyledHostelCard extends StatelessWidget {
  final HostelModel hostel;

  const StyledHostelCard({
    super.key,
    required this.hostel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          Container(
            height: 180,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              image: DecorationImage(
                image: hostel.images.isNotEmpty
                    ? NetworkImage(hostel.images.first)
                    : const AssetImage('assets/images/placeholder.jpg')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hostel.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(hostel.location),
                const SizedBox(height: 8),
                Text('KES ${hostel.price} / month'),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        '/room-detail',
                        arguments: hostel.id,
                      );
                    },
                    child: const Text('View more'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
