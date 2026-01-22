import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Create a booking
  Future<void> createBooking(Booking booking) async {
    await _firestore.collection('bookings').add(booking.toMap());
  }

  /// Update booking status (approved/rejected)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _firestore.collection('bookings').doc(bookingId).update({
      'status': status,
    });
  }

  /// Stream bookings for a student
  Stream<List<Booking>> getStudentBookings(String studentId) {
    return _firestore
        .collection('bookings')
        .where('studentId', isEqualTo: studentId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList());
  }

  /// Stream bookings for a landlord
  Stream<List<Booking>> getLandlordBookings(String landlordId) {
    return _firestore
        .collection('bookings')
        .where('landlordId', isEqualTo: landlordId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Booking.fromFirestore(doc)).toList());
  }
}
