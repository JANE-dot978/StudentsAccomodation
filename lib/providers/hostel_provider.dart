import 'package:flutter/material.dart';
import '../models/hostel_model.dart';
import '../services/hostel_service.dart';

class HostelProvider with ChangeNotifier {
  final HostelService _hostelService = HostelService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Hostel> _hostels = [];
  List<Hostel> get hostels => _hostels;

  void fetchHostels() {
    _isLoading = true;
    notifyListeners();

    _hostelService.getAllHostels().listen((hostels) {
      _hostels = hostels;
      _isLoading = false;
      notifyListeners();
    });
  }
}
