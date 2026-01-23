import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hostel_model.dart';

class HostelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all hostels (students)
  Stream<List<HostelModel>> getAllHostels() {
    return _firestore.collection('hostels').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => HostelModel.fromFirestore(doc))
          .toList();
    });
  }

  // Fetch hostels by landlord (landlord dashboard)
  Stream<List<HostelModel>> getHostelsByLandlord(String landlordId) {
    return _firestore
        .collection('hostels')
        .where('landlordId', isEqualTo: landlordId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HostelModel.fromFirestore(doc)).toList());
  }

  // Add a new hostel
  Future<void> createHostel(HostelModel hostel) async {
    final docRef = _firestore.collection('hostels').doc(); // auto-generated ID
    hostel.id = docRef.id; // assign Firestore ID to the model
    await docRef.set(hostel.toMap());
  }

  // Update an existing hostel
  Future<void> updateHostel(HostelModel hostel) async {
    await _firestore.collection('hostels').doc(hostel.id).update(hostel.toMap());
  }

  // Delete a hostel
  Future<void> deleteHostel(String hostelId) async {
    await _firestore.collection('hostels').doc(hostelId).delete();
  }
}
