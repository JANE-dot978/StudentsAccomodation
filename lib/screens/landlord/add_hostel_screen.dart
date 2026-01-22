import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hostel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/hostel_model.dart';

class AddHostelScreen extends StatefulWidget {
  const AddHostelScreen({super.key});

  @override
  State<AddHostelScreen> createState() => _AddHostelScreenState();
}

class _AddHostelScreenState extends State<AddHostelScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _roomsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Hostel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Hostel Name'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter hostel name' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (KES)'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter price' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _roomsController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Available Rooms'),
                validator: (value) =>
                    value!.isEmpty ? 'Enter number of rooms' : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final hostel = HostelModel(
                    id: '',
                    name: _nameController.text,
                    price: int.parse(_priceController.text),
                    availableRooms: int.parse(_roomsController.text),
                    images: [],
                    sharedItems: [],
                    landlordId: authProvider.user!.uid,
                  );

                  await hostelProvider.addHostel(hostel);

                  if (!mounted) return;
                  Navigator.pop(context);
                },
                child: const Text('Add Hostel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
