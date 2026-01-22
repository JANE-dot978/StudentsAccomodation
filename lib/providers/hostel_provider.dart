import 'package:flutter/material.dart';
import '../models/hostel_model.dart';
import '../services/hostel_service.dart';

class HostelProvider with ChangeNotifier {
  final HostelService _hostelService = HostelService();

  List<HostelModel> hostels = [];
  bool isLoading = false;

  // For student home screen
  void fetchHostels() {
    isLoading = true;
    notifyListeners();

    _hostelService.getAllHostels().listen((hostelList) {
      hostels = hostelList;
      isLoading = false;
      notifyListeners();
    });
  }

  // For landlord property screen
  Stream<List<HostelModel>> getLandlordHostels(String landlordId) {
    return _hostelService.getHostelsByLandlord(landlordId);
  }

  // Add new hostel
  Future<void> addHostel(HostelModel hostel) async {
    try {
      await _hostelService.createHostel(hostel);
    } catch (e) {
      rethrow;
    }
  }
}
