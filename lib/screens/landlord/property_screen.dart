import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/providers/hostel_provider.dart';

import '../../providers/hostel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/hostels_cards.dart';

class PropertyScreen extends StatelessWidget {
  const PropertyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    final landlordId = authProvider.user!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('My Properties')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add-hostel');
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List>(
        stream: hostelProvider.getLandlordHostels(landlordId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hostels added yet'));
          }

          final hostels = snapshot.data!;

         return ListView.builder(
  itemCount: hostels.length,
  itemBuilder: (context, index) {
    final hostel = hostels[index];

    return StyledHostelCard(
      hostel: hostel,
      onEdit: () {
        Navigator.pushNamed(
          context,
          '/add-hostel',
          arguments: hostel, // pass hostel for editing
        );
      },
      onDelete: () async {
        final confirm = await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Delete Hostel'),
            content: const Text('Are you sure you want to delete this hostel?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Delete')),
            ],
          ),
        );

        if (confirm == true) {
          await hostelProvider.deleteHostel(hostel.id);
        }
      },
    );
  },
);

        },
      ),
    );
  }
}
