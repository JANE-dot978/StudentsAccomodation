import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../providers/hostel_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/hostel_model.dart';
import '../../services/my_app_function.dart';

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

  // Category: what gets stored in database (match student category keys)
  String _category = 'bedsitter';

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
      _descriptionController.text = existingHostel!.description;
      _category = existingHostel!.category;
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

  // ---------------- IMAGE PICKER ----------------
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

  // ---------------- CLOUDINARY UPLOAD ----------------
  Future<String?> uploadImage(Uint8List imageBytes, String fileName) async {
    const cloudName = 'dgppqmq3t';
    const uploadPreset = 'studentaccomodations';

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload');

    final request = http.MultipartRequest('POST', url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes('file', imageBytes, filename: fileName),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      return jsonDecode(respStr)['secure_url'];
    }
    return null;
  }

  // ---------------- SAVE HOSTEL ----------------
  Future<void> _saveHostel() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pickedImages.isEmpty && (existingHostel?.images.isEmpty ?? true)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one image')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      List<String> imageUrls = [];

      for (int i = 0; i < _pickedImages.length; i++) {
        final url = await uploadImage(_pickedImages[i], _pickedImageNames[i]);
        if (url != null) imageUrls.add(url);
      }

      final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

        final hostel = HostelModel(
        id: existingHostel?.id ?? '',
        name: _nameController.text.trim(),
        location: _locationController.text.trim(),
        price: double.parse(_priceController.text),
        availableRooms: int.parse(_roomsController.text),
        images: imageUrls.isNotEmpty
            ? imageUrls
            : existingHostel?.images ?? [],
        landlordId: authProvider.user!.uid,
        description: _descriptionController.text.trim(),
        category: _category, // Stores: 'single room', 'bedsitter', or 'shared room'
        sharedItems: existingHostel?.sharedItems ?? [],
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
        SnackBar(content: Text('Error: $e')),
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
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField(_nameController, 'Hostel Name'),
              _buildField(_locationController, 'Location'),
              _buildField(_priceController, 'Price (KES)', number: true, isInteger: false),
              _buildField(_roomsController, 'Available Rooms', number: true, isInteger: true),
              _buildField(_descriptionController, 'Description', maxLines: 4),

              const SizedBox(height: 20),

              // CATEGORY DROPDOWN
              DropdownButtonFormField<String>(
                value: _category,
                decoration: _inputDecoration('Room Category'),
                items: const [
                  DropdownMenuItem(value: 'single room', child: Text('Single Room')),
                  DropdownMenuItem(value: 'bedsitter', child: Text('Bedsitter')),
                  DropdownMenuItem(value: 'shared room', child: Text('Shared Room')),
                ],
                onChanged: (val) => setState(() => _category = val!),
              ),

              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hostel Images',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._pickedImages.map((bytes) => ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.memory(
                          bytes,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        ),
                      )),
                  GestureDetector(
                    onTap: _pickImages,
                    child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.add_a_photo, size: 30),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              _isSaving
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _saveHostel,
                        child: Text(
                          existingHostel == null ? 'ADD HOSTEL' : 'UPDATE HOSTEL',
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool number = false,
    bool isInteger = false,
    int maxLines = 1,
  }) {
    List<TextInputFormatter> inputFormatters = [];
    
    if (number) {
      if (isInteger) {
        // Integer only - digits only
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
        ];
      } else {
        // Decimal number - digits and one decimal point
        inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
        ];
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        inputFormatters: inputFormatters,
        maxLines: maxLines,
        validator: (v) {
          if (v == null || v.isEmpty) return 'Required';
          if (number) {
            final value = v.trim();
            if (isInteger) {
              if (int.tryParse(value) == null) return 'Enter a valid integer';
              if (int.parse(value) < 0) return 'Cannot be negative';
            } else {
              if (double.tryParse(value) == null) return 'Enter a valid number';
              if (double.parse(value) < 0) return 'Cannot be negative';
            }
          }
          return null;
        },
        decoration: _inputDecoration(label),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      );
}