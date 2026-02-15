import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'bookings';

  /// Create a new booking
  Future<void> createBooking(Booking booking) async {
    try {
      await _firestore.collection(_collection).doc(booking.id).set(booking.toMap());
    } catch (e) {
      throw Exception('Failed to create booking: $e');
    }
  }

  /// Get bookings for a specific student
  Stream<List<Booking>> getStudentBookings(String studentId) {
    return _firestore
        .collection(_collection)
        .where('studentId', isEqualTo: studentId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Get bookings for a specific landlord
  Stream<List<Booking>> getLandlordBookings(String landlordId) {
    return _firestore
        .collection(_collection)
        .where('landlordId', isEqualTo: landlordId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Get a single booking by ID
  Future<Booking?> getBookingById(String bookingId) async {
    try {
      DocumentSnapshot doc = await _firestore.collection(_collection).doc(bookingId).get();
      
      if (doc.exists) {
        return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to get booking: $e');
    }
  }

  /// Update booking status
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to update booking status: $e');
    }
  }

  /// Delete a booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).delete();
    } catch (e) {
      throw Exception('Failed to delete booking: $e');
    }
  }

  /// Get pending bookings for landlord
  Stream<List<Booking>> getPendingBookings(String landlordId) {
    return _firestore
        .collection(_collection)
        .where('landlordId', isEqualTo: landlordId)
        .where('status', isEqualTo: 'pending')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Get approved bookings
  Stream<List<Booking>> getApprovedBookings(String userId, {bool isLandlord = false}) {
    Query query = _firestore.collection(_collection);
    
    if (isLandlord) {
      query = query.where('landlordId', isEqualTo: userId);
    } else {
      query = query.where('studentId', isEqualTo: userId);
    }
    
    return query
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Update payment status
  Future<void> updatePaymentStatus(String bookingId, bool isPaid) async {
    final bookingRef = _firestore.collection(_collection).doc(bookingId);

    try {
      // Run transaction: ensure we only decrement rooms once and atomically
      await _firestore.runTransaction((tx) async {
        final bookingSnap = await tx.get(bookingRef);
        if (!bookingSnap.exists) throw Exception('Booking not found');

        final bookingData = bookingSnap.data() as Map<String, dynamic>;
        final alreadyPaid = bookingData['isPaid'] == true;
        final status = bookingData['status'] ?? '';
        final hostelId = bookingData['hostelId'];

        // Update booking payment fields
        tx.update(bookingRef, {
          'isPaid': isPaid,
          'paidAt': isPaid ? FieldValue.serverTimestamp() : null,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // If payment just succeeded, and booking is approved, decrement availableRooms
        if (isPaid && !alreadyPaid && status == 'approved' && hostelId != null) {
          final hostelRef = _firestore.collection('hostels').doc(hostelId);
          final hostelSnap = await tx.get(hostelRef);
          if (!hostelSnap.exists) return;
          final hostelData = hostelSnap.data() as Map<String, dynamic>;
          final currentRooms = (hostelData['availableRooms'] ?? 0) as int;
          if (currentRooms > 0) {
            tx.update(hostelRef, {'availableRooms': currentRooms - 1});
          }
        }
      });
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  /// Get all bookings (Admin)
  Stream<List<Booking>> getAllBookings() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Get bookings by status
  Stream<List<Booking>> getBookingsByStatus(String userId, String status, {bool isLandlord = false}) {
    Query query = _firestore.collection(_collection);
    
    if (isLandlord) {
      query = query.where('landlordId', isEqualTo: userId);
    } else {
      query = query.where('studentId', isEqualTo: userId);
    }
    
    return query
        .where('status', isEqualTo: status)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }).toList();
    });
  }

  /// Get bookings count for a student
  Future<int> getStudentBookingsCount(String studentId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('studentId', isEqualTo: studentId)
          .get();
      return snapshot.docs.length;
    } catch (e) {
      throw Exception('Failed to get bookings count: $e');
    }
  }

  /// Get active bookings (approved and not expired)
  Stream<List<Booking>> getActiveBookings(String studentId) {
    return _firestore
        .collection(_collection)
        .where('studentId', isEqualTo: studentId)
        .where('status', isEqualTo: 'approved')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Cancel booking (student side)
  Future<void> cancelBooking(String bookingId) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'status': 'cancelled',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  /// Approve booking (landlord side)
  Future<void> approveBooking(String bookingId) async {
    try {
      await _firestore.collection(_collection).doc(bookingId).update({
        'status': 'approved',
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to approve booking: $e');
    }
  }

  /// Reject booking (landlord side)
  Future<void> rejectBooking(String bookingId, {String? reason}) async {
    try {
      Map<String, dynamic> updateData = {
        'status': 'rejected',
        'updatedAt': FieldValue.serverTimestamp(),
      };
      
      if (reason != null) {
        updateData['rejectionReason'] = reason;
      }
      
      await _firestore.collection(_collection).doc(bookingId).update(updateData);
    } catch (e) {
      throw Exception('Failed to reject booking: $e');
    }
  }

  /// Get bookings by hostel
  Stream<List<Booking>> getBookingsByHostel(String hostelId) {
    return _firestore
        .collection(_collection)
        .where('hostelId', isEqualTo: hostelId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  /// Get total revenue for landlord
  Future<double> getTotalRevenue(String landlordId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('landlordId', isEqualTo: landlordId)
          .where('status', isEqualTo: 'approved')
          .where('isPaid', isEqualTo: true)
          .get();
      
      double total = 0;
      for (var doc in snapshot.docs) {
        final booking = Booking.fromMap(doc.data(), doc.id);
        total += booking.amount;
      }
      return total;
    } catch (e) {
      throw Exception('Failed to calculate total revenue: $e');
    }
  }

  /// Get unpaid bookings for landlord
  Stream<List<Booking>> getUnpaidBookings(String landlordId) {
    return _firestore
        .collection(_collection)
        .where('landlordId', isEqualTo: landlordId)
        .where('status', isEqualTo: 'approved')
        .where('isPaid', isEqualTo: false)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Booking.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }
}