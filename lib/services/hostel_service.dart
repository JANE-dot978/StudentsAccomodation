import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/hostel_model.dart';

class HostelService {
  final CollectionReference _hostelCollection =
      FirebaseFirestore.instance.collection('hostels');

  Stream<List<Hostel>> getAllHostels() {
    return _hostelCollection.snapshots().map((snapshot) =>
        snapshot.docs
            .map((doc) => Hostel.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
