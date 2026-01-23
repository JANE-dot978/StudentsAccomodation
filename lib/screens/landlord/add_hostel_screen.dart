import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/providers/hostel_provider.dart';
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

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _roomsController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();

  bool _isSaving = false;
  HostelModel? existingHostel;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Detect if editing an existing hostel
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is HostelModel && existingHostel == null) {
      existingHostel = args;

      _nameController.text = existingHostel!.name;
      _locationController.text = existingHostel!.location;
      _priceController.text = existingHostel!.price.toString();
      _roomsController.text = existingHostel!.availableRooms.toString();
      _descriptionController.text = existingHostel!.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _roomsController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(existingHostel == null ? 'Add Hostel' : 'Edit Hostel'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Hostel Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Price (KES)'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _roomsController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Available Rooms'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration:
                    const InputDecoration(labelText: 'Hostel Description'),
              ),
              const SizedBox(height: 24),

              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => _isSaving = true);

                          final hostel = HostelModel(
                            id: existingHostel?.id ?? '',
                            name: _nameController.text.trim(),
                            location: _locationController.text.trim(),
                            price: int.parse(_priceController.text),
                            availableRooms:
                                int.parse(_roomsController.text),
                            images: existingHostel?.images ?? [],
                            sharedItems: existingHostel?.sharedItems ?? [],
                            landlordId: authProvider.user!.uid,
                            description: _descriptionController.text.trim(),
                          );

                          try {
                            if (existingHostel == null) {
                              await hostelProvider.addHostel(hostel);
                            } else {
                              await hostelProvider.updateHostel(hostel);
                            }

                            if (!mounted) return;
                            Navigator.pop(context);
                          } finally {
                            if (mounted) {
                              setState(() => _isSaving = false);
                            }
                          }
                        },
                        child: Text(
                          existingHostel == null
                              ? 'Add Hostel'
                              : 'Update Hostel',
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
