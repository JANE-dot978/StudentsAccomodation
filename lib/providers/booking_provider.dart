import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Booking> _studentBookings = [];
  List<Booking> get studentBookings => _studentBookings;

  Future<void> createBooking(Booking booking) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _bookingService.createBooking(booking);
    } catch (e) {
      rethrow;
    }

    _isLoading = false;
    notifyListeners();
  }

  void fetchStudentBookings(String studentId) {
    _bookingService.getStudentBookings(studentId).listen((bookings) {
      _studentBookings = bookings;
      notifyListeners();
    });
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await _bookingService.updateBookingStatus(bookingId, status);
  }
}
