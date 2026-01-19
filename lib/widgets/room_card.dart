import 'package:flutter/material.dart';
import '../models/room_model.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final VoidCallback onTap;

  const RoomCard({
    super.key,
    required this.room,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: ListTile(
        title: Text('Room ${room.roomNumber}'),
        subtitle: Text('KES ${room.price.toStringAsFixed(0)}'),
        trailing: room.isAvailable
            ? const Text(
                'Available',
                style: TextStyle(color: Colors.green),
              )
            : const Text(
                'Booked',
                style: TextStyle(color: Colors.red),
              ),
        onTap: room.isAvailable ? onTap : null,
      ),
    );
  }
}
