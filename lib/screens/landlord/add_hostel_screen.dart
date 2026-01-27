import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../providers/hostel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/hostel_model.dart';
import '../../services/my_app_function.dart'; // For image picker dialog

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

  // Images
  List<Uint8List> _pickedImages = [];
  List<String> _pickedImageNames = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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

  // ---------------- Image Picker ----------------
  Future<void> _pickImages() async {
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        final image = await _picker.pickImage(source: ImageSource.camera);
        if (image != null) {
          final bytes = await image.readAsBytes();
          setState(() {
            _pickedImages.add(bytes);
            _pickedImageNames.add(image.name);
          });
        }
      },
      galleryFCT: () async {
        final images = await _picker.pickMultiImage();
        for (var image in images) {
          final bytes = await image.readAsBytes();
          setState(() {
            _pickedImages.add(bytes);
            _pickedImageNames.add(image.name);
          });
        }
      },
      removeFCT: () async {
        setState(() {
          _pickedImages.clear();
          _pickedImageNames.clear();
        });
      },
    );
  }

  // ---------------- Cloudinary Upload ----------------
  Future<String?> uploadImageToCloudinary(Uint8List imageBytes, String fileName) async {
    const cloudName = 'dgppqmq3t';
    const uploadPreset = 'studentaccomodations';

    final url = Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');
    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(http.MultipartFile.fromBytes('file', imageBytes, filename: fileName));

    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final data = jsonDecode(respStr);
      return data['secure_url'];
    }
    return null;
  }

  // ---------------- Save Hostel ----------------
  Future<void> _saveHostel() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedImages.isEmpty && (existingHostel?.images.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one image')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      // Upload new images to Cloudinary
      List<String> imageUrls = [];
      for (int i = 0; i < _pickedImages.length; i++) {
        final url = await uploadImageToCloudinary(_pickedImages[i], _pickedImageNames[i]);
        if (url != null) imageUrls.add(url);
      }

      final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final hostel = HostelModel(
        id: existingHostel?.id ?? '',
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        price: int.parse(_priceController.text),
        availableRooms: int.parse(_roomsController.text),
        images: imageUrls.isNotEmpty ? imageUrls : existingHostel?.images ?? [],
        sharedItems: existingHostel?.sharedItems ?? [],
        landlordId: authProvider.user!.uid,
        description: _descriptionController.text.trim(),
      );

      if (existingHostel == null) {
        await hostelProvider.addHostel(hostel);
      } else {
        await hostelProvider.updateHostel(hostel);
      }

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save hostel: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
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
                decoration: const InputDecoration(labelText: 'Available Rooms'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(labelText: 'Hostel Description'),
              ),
              const SizedBox(height: 12),

              // Image Picker
              Text('Hostel Images', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._pickedImages.map((bytes) => Stack(
                        children: [
                          Image.memory(
                            bytes,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  final index = _pickedImages.indexOf(bytes);
                                  _pickedImages.removeAt(index);
                                  _pickedImageNames.removeAt(index);
                                });
                              },
                              child: Container(
                                color: Colors.black54,
                                child: const Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 100,
                      height: 100,
                      color: Colors.grey[300],
                      child: const Icon(Icons.add_a_photo),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveHostel,
                        child: Text(existingHostel == null ? 'Add Hostel' : 'Update Hostel'),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
