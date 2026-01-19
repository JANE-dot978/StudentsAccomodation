import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/room_model.dart';

class RoomService {
  final CollectionReference _roomRef =
      FirebaseFirestore.instance.collection('rooms');

  Future<List<Room>> fetchRoomsByHostel(String hostelId) async {
    final snapshot =
        await _roomRef.where('hostelId', isEqualTo: hostelId).get();

    return snapshot.docs
        .map((doc) =>
            Room.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }
}
