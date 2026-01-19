import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  final CollectionReference _bookingsCollection =
      FirebaseFirestore.instance.collection('bookings');

  // Create new booking
  Future<void> createBooking(Booking booking) async {
    await _bookingsCollection.doc(booking.id).set(booking.toMap());
  }

  // Get bookings for a specific student
  Stream<List<Booking>> getStudentBookings(String studentId) {
    return _bookingsCollection
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Booking.fromDocument(doc.id, doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Update booking status (for landlord)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _bookingsCollection.doc(bookingId).update({'status': status});
  }
}
