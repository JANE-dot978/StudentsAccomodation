import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../services/booking_service.dart';

class BookingProvider with ChangeNotifier {
  final BookingService _bookingService = BookingService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Booking> _studentBookings = [];
  List<Booking> get studentBookings => _studentBookings;

  List<Booking> _landlordBookings = [];
  List<Booking> get landlordBookings => _landlordBookings;

  String? _error;
  String? get error => _error;

  
  Stream<List<Booking>> getLandlordBookings(String landlordId) {
    return _bookingService.getLandlordBookings(landlordId);
  }


  Stream<List<Booking>> getStudentBookingsStream(String studentId) {
    return _bookingService.getStudentBookings(studentId);
  }

  
  Stream<List<Booking>> getPendingBookings(String landlordId) {
    return _bookingService.getPendingBookings(landlordId);
  }

  
  Stream<List<Booking>> getApprovedBookings(String userId, {bool isLandlord = false}) {
    return _bookingService.getApprovedBookings(userId, isLandlord: isLandlord);
  }


  Stream<List<Booking>> getActiveBookings(String studentId) {
    return _bookingService.getActiveBookings(studentId);
  }

  

  Future<bool> createBooking(Booking booking) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _bookingService.createBooking(booking);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  

  void fetchStudentBookings(String studentId) {
    _bookingService.getStudentBookings(studentId).listen((bookings) {
      _studentBookings = bookings;
      notifyListeners();
    });
  }

  void fetchLandlordBookings(String landlordId) {
    _bookingService.getLandlordBookings(landlordId).listen((bookings) {
      _landlordBookings = bookings;
      notifyListeners();
    });
  }

  

  Future<bool> updateBookingStatus(String bookingId, String status) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _bookingService.updateBookingStatus(bookingId, status);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> approveBooking(String bookingId) async {
    return await updateBookingStatus(bookingId, 'approved');
  }

  Future<bool> rejectBooking(String bookingId) async {
    return await updateBookingStatus(bookingId, 'rejected');
  }

  Future<bool> cancelBooking(String bookingId) async {
    return await updateBookingStatus(bookingId, 'cancelled');
  }

  

  Future<bool> updatePaymentStatus(String bookingId, bool isPaid) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _bookingService.updatePaymentStatus(bookingId, isPaid);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }



  void clearError() {
    _error = null;
    notifyListeners();
  }
}
