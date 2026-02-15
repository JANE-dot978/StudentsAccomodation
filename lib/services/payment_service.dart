import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  final String baseUrl;

  PaymentService({this.baseUrl = 'http://localhost:8080'});

  /// Initiate STK push payment
  /// 
  /// Parameters:
  /// - [bookingId]: The ID of the booking to pay for
  /// - [phoneNumber]: Customer's M-Pesa registered phone number (e.g., 0712345678 or 254712345678)
  /// - [amount]: Amount in KES (minimum 1, maximum 150,000)
  /// - [description]: Payment description (optional)
  /// 
  /// Returns: Map with payment details including checkoutRequestId
  Future<Map<String, dynamic>> initiateSTKPush({
    required String bookingId,
    required String phoneNumber,
    required double amount,
    String? description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/initiate-payment'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'bookingId': bookingId,
          'phoneNumber': phoneNumber,
          'amount': amount,
          'description': description ?? 'Room Booking Payment',
        }),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () => throw Exception('Payment initiation timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': true,
          'checkoutRequestId': data['checkoutRequestId'],
          'customerMessage': data['customerMessage'] ?? 'Check your phone for M-Pesa prompt',
          'message': data['message'],
        };
      } else {
        final errorData = jsonDecode(response.body) as Map<String, dynamic>;
        return {
          'success': false,
          'error': errorData['error'] ?? 'Payment initiation failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Payment error: ${e.toString()}',
      };
    }
  }

  /// Check the status of a payment
  /// 
  /// Parameters:
  /// - [checkoutRequestId]: The checkout request ID returned from initiateSTKPush
  /// 
  /// Returns: Payment status information
  Future<Map<String, dynamic>> checkPaymentStatus(String checkoutRequestId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/check-payment-status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'checkoutRequestId': checkoutRequestId,
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Status check timeout'),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to check status',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Status check error: ${e.toString()}',
      };
    }
  }

  /// Simulate payment for testing (sandbox only)
  /// 
  /// Parameters:
  /// - [bookingId]: The booking ID to simulate payment for
  /// - [success]: Whether to simulate success or failure
  Future<Map<String, dynamic>> simulatePayment({
    required String bookingId,
    bool success = true,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/mpesa/simulate'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'bookingId': bookingId,
          'success': success,
        }),
      ).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Simulation timeout'),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': jsonDecode(response.body)['message'],
        };
      } else {
        return {
          'success': false,
          'error': 'Simulation failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Simulation error: ${e.toString()}',
      };
    }
  }

  /// Format phone number to standard M-Pesa format
  /// Accepts: 0712345678, 254712345678, +254712345678
  /// Returns: 254712345678
  static String formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), ''); // Remove formatting
    
    if (phone.startsWith('+254')) {
      return phone.substring(1); // Remove +
    } else if (phone.startsWith('254')) {
      return phone;
    } else if (phone.startsWith('0')) {
      return '254${phone.substring(1)}';
    } else {
      return '254$phone';
    }
  }

  /// Validate M-Pesa phone number
  static bool isValidPhoneNumber(String phone) {
    final formatted = formatPhoneNumber(phone);
    return RegExp(r'^254\d{9}$').hasMatch(formatted);
  }

  /// Format amount as currency string
  static String formatAmount(double amount) {
    return 'KES ${amount.toStringAsFixed(0)}';
  }
}
