import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'payment_service.dart';

class PaymentPollingService {
  final PaymentService _paymentService = PaymentService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<Map<String, dynamic>> pollPaymentStatus({
    required String bookingId,
    Duration timeout = const Duration(minutes: 3),
    Duration pollInterval = const Duration(seconds: 3),
  }) async {
    final startTime = DateTime.now();
    
    while (DateTime.now().difference(startTime) < timeout) {
      try {
      
        final bookingDoc = await _firestore
            .collection('bookings')
            .doc(bookingId)
            .get();

        if (!bookingDoc.exists) {
          return {
            'success': false,
            'error': 'Booking not found',
          };
        }

        final data = bookingDoc.data()!;
        final isPaid = data['isPaid'] ?? false;
        final mpesaCode = data['mpesaReceiptNumber'];

        if (isPaid && mpesaCode != null) {
          print('✅ Payment confirmed! M-Pesa Code: $mpesaCode');
          return {
            'success': true,
            'message': 'Payment successful',
            'mpesaCode': mpesaCode,
            'isPaid': true,
          };
        }

      
        final paymentStatus = data['paymentStatus'];
        if (paymentStatus == 'failed') {
          return {
            'success': false,
            'error': 'Payment failed. Please try again.',
          };
        }

        print('⏳ Payment pending... checking again in ${pollInterval.inSeconds}s');
        await Future.delayed(pollInterval);

      } catch (e) {
        print('❌ Error checking payment: $e');
        await Future.delayed(pollInterval);
      }
    }

    // Timeout
    return {
      'success': false,
      'error': 'Payment confirmation timeout. Please check your payment history.',
      'timeout': true,
    };
  }

  /// Listen to booking changes in real-time
  Stream<Map<String, dynamic>> listenToPaymentStatus(String bookingId) {
    return _firestore
        .collection('bookings')
        .doc(bookingId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return {
          'success': false,
          'error': 'Booking not found',
        };
      }

      final data = snapshot.data()!;
      final isPaid = data['isPaid'] ?? false;
      final mpesaCode = data['mpesaReceiptNumber'];
      final paymentStatus = data['paymentStatus'];

      if (isPaid && mpesaCode != null) {
        return {
          'success': true,
          'message': 'Payment successful',
          'mpesaCode': mpesaCode,
          'isPaid': true,
        };
      }

      if (paymentStatus == 'failed') {
        return {
          'success': false,
          'error': 'Payment failed',
        };
      }

      return {
        'success': false,
        'pending': true,
        'message': 'Payment pending...',
      };
    });
  }
}