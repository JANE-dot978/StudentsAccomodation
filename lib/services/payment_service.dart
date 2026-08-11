import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  final String baseUrl;

  PaymentService({
    this.baseUrl = 'https://2aa3-197-248-137-245.ngrok-free.app',
  });

  
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'ngrok-skip-browser-warning': 'true',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
  };


  Future<Map<String, dynamic>> initiateSTKPush({
    required String bookingId,
    required String phoneNumber,
    required double amount,
    String? description,
  }) async {
    try {
      final formattedPhone = formatPhoneNumber(phoneNumber);

      print('📤 Initiating payment:');
      print('   URL: $baseUrl/mpesa/initiate-payment');
      print('   Booking ID: $bookingId');
      print('   Phone: $formattedPhone');
      print('   Amount: ${amount.toInt()}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/mpesa/initiate-payment'),
            headers: _headers,
            body: jsonEncode({
              'bookingId': bookingId,
              'phoneNumber': formattedPhone,
              'amount': amount.toInt(),
              'description': description ?? 'Room Booking Payment',
            }),
          )
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () => throw Exception('Payment initiation timeout'),
          );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      
      if (!response.body.startsWith('{') && !response.body.startsWith('[')) {
        print('❌ Received HTML instead of JSON');
        return {
          'success': false,
          'error': 'Server returned invalid response. Please check your internet connection.',
        };
      }

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': body['success'] ?? true,
          'checkoutRequestId': body['checkoutRequestId'] ?? 
                               body['CheckoutRequestID'] ?? 
                               '',
          'customerMessage': body['customerMessage'] ?? 
                            body['CustomerMessage'] ?? 
                            'Check your phone for M-Pesa prompt',
          'message': body['message'] ?? 
                     body['ResponseDescription'] ?? 
                     'Payment initiated successfully',
          'responseCode': body['responseCode'] ?? 
                         body['ResponseCode'] ?? 
                         '0',
        };
      } else {
        return {
          'success': false,
          'error': body['error'] ?? 
                   body['details'] ?? 
                   'Payment initiation failed',
        };
      }
    } catch (e) {
      print('❌ Payment error: $e');
      return {
        'success': false,
        'error': 'Payment error: ${e.toString()}',
      };
    }
  }

  
  Future<Map<String, dynamic>> checkPaymentStatus(
      String checkoutRequestId) async {
    try {
      print('🔍 Checking payment status for: $checkoutRequestId');

      final response = await http
          .post(
            Uri.parse('$baseUrl/mpesa/check-payment-status'),
            headers: _headers,
            body: jsonEncode({'checkoutRequestId': checkoutRequestId}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Status check timeout'),
          );

      print('📥 Status response: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'error': 'Failed to check payment status',
        };
      }
    } catch (e) {
      print('❌ Status check error: $e');
      return {
        'success': false,
        'error': 'Status check error: ${e.toString()}',
      };
    }
  }

  /// Simulate payment (sandbox/testing only)
  Future<Map<String, dynamic>> simulatePayment({
    required String bookingId,
    bool success = true,
  }) async {
    try {
      print('🧪 Simulating payment for booking: $bookingId');

      final response = await http
          .post(
            Uri.parse('$baseUrl/mpesa/simulate'),
            headers: _headers,
            body: jsonEncode({'bookingId': bookingId, 'success': success}),
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => throw Exception('Simulation timeout'),
          );

      final body = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': body['message'] ?? 'Payment simulated successfully',
        };
      } else {
        return {
          'success': false,
          'error': body['error'] ?? 'Simulation failed',
        };
      }
    } catch (e) {
      print('❌ Simulation error: $e');
      return {
        'success': false,
        'error': 'Simulation error: ${e.toString()}',
      };
    }
  }

  /// Format phone number to M-Pesa required format
  static String formatPhoneNumber(String phone) {
    phone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    if (phone.startsWith('+254')) return phone.substring(1);
    if (phone.startsWith('254')) return phone;
    if (phone.startsWith('0')) return '254${phone.substring(1)}';
    if (phone.length == 9) return '254$phone';
    return phone;
  }

  /// Validate M-Pesa phone number
  static bool isValidPhoneNumber(String phone) {
    final formatted = formatPhoneNumber(phone);
    return RegExp(r'^254[71]\d{8}$').hasMatch(formatted);
  }

  /// Format amount for display
  static String formatAmount(double amount) {
    return 'KES ${amount.toStringAsFixed(0)}';
  }

  /// Test connection to backend
  Future<bool> testConnection() async {
    try {
      print('🔗 Testing connection to: $baseUrl');
      
      final response = await http.get(
        Uri.parse('$baseUrl/'),
        headers: {
          'ngrok-skip-browser-warning': 'true',
          'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
        },
      ).timeout(const Duration(seconds: 10));

      print('📥 Connection test response: ${response.statusCode}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Connection test failed: $e');
      return false;
    }
  }
}