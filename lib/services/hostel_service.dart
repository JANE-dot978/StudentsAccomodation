import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hostel_model.dart';

class HostelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------------- ALL HOSTELS (Students) ----------------
  Stream<List<HostelModel>> getAllHostels() {
    return _firestore
        .collection('hostels')
        .where('availableRooms', isGreaterThan: 0)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HostelModel.fromFirestore(doc)).toList());
  }

  // ---------------- CATEGORY ----------------
  Stream<List<HostelModel>> getHostelsByCategory(String category) {
    return _firestore
        .collection('hostels')
        .where('category', isEqualTo: category.toLowerCase().trim())
        .where('availableRooms', isGreaterThan: 0)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HostelModel.fromFirestore(doc)).toList());
  }

  // ---------------- LANDLORD ----------------
  Stream<List<HostelModel>> getHostelsByLandlord(String landlordId) {
    return _firestore
        .collection('hostels')
        .where('landlordId', isEqualTo: landlordId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HostelModel.fromFirestore(doc)).toList());
  }

  // ---------------- CREATE ----------------
  Future<void> createHostel(HostelModel hostel) async {
    await _firestore.collection('hostels').add(hostel.toMap());
  }

  // ---------------- UPDATE ----------------
  Future<void> updateHostel(HostelModel hostel) async {
    await _firestore.collection('hostels').doc(hostel.id).update({
      ...hostel.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ---------------- DELETE ----------------
  Future<void> deleteHostel(String hostelId) async {
    await _firestore.collection('hostels').doc(hostelId).delete();
  }
}
