import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/hostel_model.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';

class BookingScreen extends StatefulWidget {
  final HostelModel hostel;

  const BookingScreen({required this.hostel, super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _roomsController = TextEditingController();
  bool _termsAccepted = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _roomsController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate() || !_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill form and accept terms')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bookingProvider =
          Provider.of<BookingProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final rooms = int.parse(_roomsController.text);

      final booking = Booking(
        id: '',
        studentId: authProvider.user!.uid,
        landlordId: widget.hostel.landlordId,
        hostelId: widget.hostel.id,
        roomId: '', // optional for now
        checkInDate: DateTime.now(),
        checkOutDate: DateTime.now().add(const Duration(days: 30)),
        totalPrice: widget.hostel.price * rooms,
        status: 'pending',
        createdAt: Timestamp.now(),
      );

      await bookingProvider.createBooking(booking);

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Booking submitted successfully')));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Booking failed: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Hostel')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _roomsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Number of Rooms',
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        final value = int.tryParse(v);
                        if (value == null || value <= 0)
                          return 'Enter valid number';
                        if (value > widget.hostel.availableRooms)
                          return 'Not enough rooms';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _termsAccepted,
                          onChanged: (val) =>
                              setState(() => _termsAccepted = val ?? false),
                        ),
                        const Expanded(
                            child: Text(
                                'I accept the terms and conditions of booking.'))
                      ],
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _submitBooking,
                      child: const Text('Submit Booking'),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}
