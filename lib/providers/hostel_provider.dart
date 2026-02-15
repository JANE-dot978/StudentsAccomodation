import 'package:flutter/material.dart';
import '../models/hostel_model.dart';
import '../services/hostel_service.dart';

class HostelProvider with ChangeNotifier {
  final HostelService _hostelService = HostelService();

  // ⭐ REMOVE OLD LIST LOGIC
  // Students should NOT rely on a cached list.

  // ---------------- STUDENT STREAM ----------------
  Stream<List<HostelModel>> getAllHostelsStream() {
    return _hostelService.getAllHostels();
  }

  // ⭐ CATEGORY FILTER STREAM
  Stream<List<HostelModel>> getHostelsByCategory(String category) {
    return _hostelService.getHostelsByCategory(category);
  }

  // ---------------- LANDLORD ----------------
  Stream<List<HostelModel>> getLandlordHostels(String landlordId) {
    return _hostelService.getHostelsByLandlord(landlordId);
  }

  // ---------------- CRUD ----------------
  Future<void> addHostel(HostelModel hostel) async {
    await _hostelService.createHostel(hostel);
  }

  Future<void> updateHostel(HostelModel hostel) async {
    await _hostelService.updateHostel(hostel);
  }

  Future<void> deleteHostel(String hostelId) async {
    await _hostelService.deleteHostel(hostelId);
  }
}
