import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/maintanance_model.dart';

class MaintenanceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Maintenance> _maintenanceRequests = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Maintenance> get maintenanceRequests => _maintenanceRequests;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch maintenance requests for a hostel
  Future<void> fetchHostelMaintenance(String hostelId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('maintenance')
          .where('hostelId', isEqualTo: hostelId)
          .orderBy('createdAt', descending: true)
          .get();

      _maintenanceRequests = snapshot.docs
          .map((doc) => Maintenance.fromDocument(doc.id, doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch maintenance requests reported by a student
  Future<void> fetchStudentReports(String studentId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('maintenance')
          .where('reportedBy', isEqualTo: studentId)
          .orderBy('createdAt', descending: true)
          .get();

      _maintenanceRequests = snapshot.docs
          .map((doc) => Maintenance.fromDocument(doc.id, doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new maintenance request
  Future<String?> reportMaintenance(Maintenance maintenance) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final docRef = await _firestore.collection('maintenance').add(maintenance.toMap());

      _isLoading = false;
      notifyListeners();
      return docRef.id;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Update maintenance status
  Future<bool> updateStatus(String maintenanceId, String newStatus) async {
    try {
      await _firestore.collection('maintenance').doc(maintenanceId).update({
        'status': newStatus,
        'completedDate': newStatus == 'completed' ? Timestamp.now() : null,
      });

      final index = _maintenanceRequests.indexWhere((m) => m.id == maintenanceId);
      if (index != -1) {
        _maintenanceRequests[index] = _maintenanceRequests[index].copyWith(
          status: newStatus,
          completedDate: newStatus == 'completed' ? DateTime.now() : null,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Assign maintenance to someone
  Future<bool> assignMaintenance(String maintenanceId, String assignedTo) async {
    try {
      await _firestore.collection('maintenance').doc(maintenanceId).update({
        'assignedTo': assignedTo,
      });

      final index = _maintenanceRequests.indexWhere((m) => m.id == maintenanceId);
      if (index != -1) {
        _maintenanceRequests[index] = _maintenanceRequests[index].copyWith(
          assignedTo: assignedTo,
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear maintenance requests
  void clearMaintenance() {
    _maintenanceRequests = [];
    notifyListeners();
  }
}
