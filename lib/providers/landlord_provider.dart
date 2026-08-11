import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Landlord {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String verificationStatus; 
  final DateTime createdAt;
  final int totalProperties;
  final int totalBookings;
  final double rating;
  final String profileImageUrl;
  final Map<String, dynamic> documents;

  Landlord({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.verificationStatus,
    required this.createdAt,
    required this.totalProperties,
    required this.totalBookings,
    required this.rating,
    required this.profileImageUrl,
    required this.documents,
  });

  factory Landlord.fromMap(Map<String, dynamic> map, String docId) {
    return Landlord(
      id: docId,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      businessName: map['businessName'] ?? '',
      verificationStatus: map['verificationStatus'] ?? 'pending',
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      totalProperties: map['totalProperties'] ?? 0,
      totalBookings: map['totalBookings'] ?? 0,
      rating: (map['rating'] ?? 0.0).toDouble(),
      profileImageUrl: map['profileImageUrl'] ?? '',
      documents: map['documents'] ?? {},
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'businessName': businessName,
      'verificationStatus': verificationStatus,
      'createdAt': Timestamp.fromDate(createdAt),
      'totalProperties': totalProperties,
      'totalBookings': totalBookings,
      'rating': rating,
      'profileImageUrl': profileImageUrl,
      'documents': documents,
    };
  }
}

class LandlordProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Landlord> _landlords = [];
  List<Landlord> _filteredLandlords = [];
  bool _isLoading = false;
  String _filterStatus = 'all'; // all, pending, verified, rejected

  List<Landlord> get landlords => _landlords;
  List<Landlord> get filteredLandlords => _filteredLandlords;
  bool get isLoading => _isLoading;
  String get filterStatus => _filterStatus;

  Future<void> fetchLandlords() async {
    _isLoading = true;
    notifyListeners();
    try {
      final QuerySnapshot snapshot =
          await _firestore.collection('users').where('role', isEqualTo: 'landlord').get();
      _landlords = snapshot.docs
          .map((doc) => Landlord.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      _applyFilter();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching landlords: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilterStatus(String status) {
    _filterStatus = status;
    _applyFilter();
    notifyListeners();
  }

  void _applyFilter() {
    if (_filterStatus == 'all') {
      _filteredLandlords = _landlords;
    } else {
      _filteredLandlords = _landlords
          .where((landlord) => landlord.verificationStatus == _filterStatus)
          .toList();
    }
  }

  Future<void> verifyLandlord(String landlordId) async {
    try {
      await _firestore
          .collection('users')
          .doc(landlordId)
          .update({'verificationStatus': 'verified'});
      await fetchLandlords();
      notifyListeners();
    } catch (e) {
      debugPrint('Error verifying landlord: $e');
      rethrow;
    }
  }

  Future<void> rejectLandlord(String landlordId, String reason) async {
    try {
      await _firestore.collection('users').doc(landlordId).update({
        'verificationStatus': 'rejected',
        'rejectionReason': reason,
      });
      await fetchLandlords();
      notifyListeners();
    } catch (e) {
      debugPrint('Error rejecting landlord: $e');
      rethrow;
    }
  }

  Future<void> suspendLandlord(String landlordId) async {
    try {
      await _firestore
          .collection('users')
          .doc(landlordId)
          .update({'verificationStatus': 'suspended'});
      await fetchLandlords();
      notifyListeners();
    } catch (e) {
      debugPrint('Error suspending landlord: $e');
      rethrow;
    }
  }

  Landlord? getLandlordById(String id) {
    try {
      return _landlords.firstWhere((landlord) => landlord.id == id);
    } catch (e) {
      return null;
    }
  }

  Map<String, int> getStatistics() {
    return {
      'total': _landlords.length,
      'pending': _landlords.where((l) => l.verificationStatus == 'pending').length,
      'verified': _landlords.where((l) => l.verificationStatus == 'verified').length,
      'rejected': _landlords.where((l) => l.verificationStatus == 'rejected').length,
    };
  }

  double getTotalRevenue() {
    // Calculate based on booking data (to be implemented with booking provider)
    return 0.0;
  }

  List<Map<String, dynamic>> generateReport() {
    return _landlords.map((landlord) {
      return {
        'name': landlord.name,
        'email': landlord.email,
        'businessName': landlord.businessName,
        'status': landlord.verificationStatus,
        'properties': landlord.totalProperties,
        'bookings': landlord.totalBookings,
        'rating': landlord.rating,
        'joinDate': landlord.createdAt.toString(),
      };
    }).toList();
  }
}
