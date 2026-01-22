import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hostel_model.dart';

class HostelService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<HostelModel>> getHostelsByLandlord(String landlordId) {
    return _firestore
        .collection('hostels')
        .where('landlordId', isEqualTo: landlordId)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HostelModel.fromFirestore(doc)).toList());
  }

  Stream<List<HostelModel>> getAllHostels() {
    return _firestore
        .collection('hostels')
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => HostelModel.fromFirestore(doc)).toList());
  }

  Future<void> createHostel(HostelModel hostel) async {
    await _firestore.collection('hostels').add(hostel.toMap());
  }
}
