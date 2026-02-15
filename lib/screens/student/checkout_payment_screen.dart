import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking_model.dart';
import '../../providers/booking_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/payment_service.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  final Booking booking;

  const CheckoutPaymentScreen({required this.booking, super.key});

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  final PaymentService _paymentService = PaymentService(baseUrl: 'http://192.168.1.66:8080');
  final _phoneController = TextEditingController();
  bool _isProcessing = false;
  String? _paymentError;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _initiatePayment() async {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter your phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isProcessing = true;
      _paymentError = null;
    });

    try {
      // Initiate STK push
      final result = await _paymentService.initiateSTKPush(
        bookingId: widget.booking.id,
        phoneNumber: _phoneController.text,
        amount: widget.booking.amount,
        description: 'Room booking for ${widget.booking.roomType}',
      );

      if (!mounted) return;

      if (result['success']) {
        // Show success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment Initiated'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(result['customerMessage'] ?? 'Check your phone for the M-Pesa prompt'),
                const SizedBox(height: 16),
                const Text(
                  'Instructions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text('1. You will receive an M-Pesa prompt on your phone\n'
                    '2. Enter your M-Pesa PIN to complete the payment\n'
                    '3. Your booking will be confirmed once payment is successful'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Return to bookings list
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );

        // Update payment status after successful initiation
        final bookingProvider = Provider.of<BookingProvider>(context, listen: false);
        await bookingProvider.updatePaymentStatus(widget.booking.id, true);
      } else {
        setState(() {
          _paymentError = result['error'] ?? 'Payment initiation failed';
        });
      }
    } catch (e) {
      setState(() {
        _paymentError = 'Error: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout Payment'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Payment Summary Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Payment Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20),
                      _buildSummaryRow(
                        'Room Type',
                        widget.booking.roomType,
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        'Duration',
                        '${widget.booking.durationMonths} ${widget.booking.durationMonths == 1 ? 'month' : 'months'}',
                      ),
                      const Divider(height: 20),
                      _buildSummaryRow(
                        'Check-in Date',
                        '${widget.booking.checkInDate.day}/${widget.booking.checkInDate.month}/${widget.booking.checkInDate.year}',
                      ),
                      const Divider(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Amount',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            'KES ${widget.booking.amount.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Phone Input Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'M-Pesa Payment Details',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: 'Enter your M-Pesa phone number',
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone),
                      prefixText: '+254 ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      helperText: 'Format: 0712345678 or 254712345678',
                      errorText: _paymentError,
                    ),
                  ),
                ],
              ),
            ),

            // Info Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'How it works',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '1. Enter your M-Pesa registered phone number\n'
                      '2. Click "Proceed to Payment"\n'
                      '3. You will receive an M-Pesa prompt on your phone\n'
                      '4. Enter your M-Pesa PIN to complete the payment\n'
                      '5. Your booking will be confirmed immediately',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue.shade800,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Proceed Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: _isProcessing ? null : _initiatePayment,
                  icon: _isProcessing
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.payment),
                  label: Text(
                    _isProcessing ? 'Processing...' : 'Proceed to Payment',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey,
                  ),
                ),
              ),
            ),

            // Security Badge
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock, size: 16, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    'Secure M-Pesa Payment',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
