import 'package:flutter/material.dart';
import '../models/hostel_model.dart';

class StyledHostelCard extends StatelessWidget {
  final HostelModel hostel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StyledHostelCard({
    super.key,
    required this.hostel,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          hostel.images.isNotEmpty
              ? ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(14)),
                  child: Image.network(
                    hostel.images.first,
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              : Container(
                  height: 160,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(14)),
                  ),
                  child: const Center(child: Icon(Icons.home, size: 50)),
                ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(hostel.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Text(hostel.location,
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 6),
                Text('KES ${hostel.price} / month'),
                const SizedBox(height: 6),
                Text('Rooms Available: ${hostel.availableRooms}'),

                // 🔹 LANDLORD ACTION BUTTONS
                if (onEdit != null || onDelete != null) ...[
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (onEdit != null)
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: onEdit,
                        ),
                      if (onDelete != null)
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: onDelete,
                        ),
                    ],
                  )
                ]
              ],
            ),
          )
        ],
      ),
    );
  }
}
