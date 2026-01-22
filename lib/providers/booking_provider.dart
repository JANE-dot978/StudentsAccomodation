// import 'package:flutter/material.dart';
// import '../models/booking_model.dart';
// import '../services/booking_service.dart';

// class BookingProvider with ChangeNotifier {
//   final BookingService _bookingService = BookingService();

//   bool _isLoading = false;
//   bool get isLoading => _isLoading;

//   List<Booking> _studentBookings = [];
//   List<Booking> get studentBookings => _studentBookings;

//   /// Stream of bookings for landlord
//   Stream<List<Booking>> getLandlordBookings(String landlordId) {
//     return _bookingService.getLandlordBookings(landlordId);
//   }

//   /// Create booking
//   Future<void> createBooking(Booking booking) async {
//     _isLoading = true;
//     notifyListeners();

//     try {
//       await _bookingService.createBooking(booking);
//     } catch (e) {
//       rethrow;
//     }

//     _isLoading = false;
//     notifyListeners();
//   }

//   /// Fetch bookings for a student
//   void fetchStudentBookings(String studentId) {
//     _bookingService.getStudentBookings(studentId).listen((bookings) {
//       _studentBookings = bookings;
//       notifyListeners();
//     });
//   }

//   /// Update booking status
//   Future<void> updateBookingStatus(String bookingId, String status) async {
//     await _bookingService.updateBookingStatus(bookingId, status);
//     notifyListeners();
//   }

//   Future<void> approveBooking(String bookingId) async {
//     await updateBookingStatus(bookingId, 'approved');
//   }

//   Future<void> rejectBooking(String bookingId) async {
//     await updateBookingStatus(bookingId, 'rejected');
//   }
// }
