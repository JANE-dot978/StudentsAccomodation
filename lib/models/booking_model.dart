import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String studentId;
  final String landlordId;
  final String hostelId;
  final String roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice; // ✅ changed to double
  final String status;
  final Timestamp createdAt;

  Booking({
    required this.id,
    required this.studentId,
    required this.landlordId,
    required this.hostelId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice, // ✅ double
    required this.status,
    required this.createdAt,
  });

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking(
      id: doc.id,
      studentId: data['studentId'] ?? '',
      landlordId: data['landlordId'] ?? '',
      hostelId: data['hostelId'] ?? '',
      roomId: data['roomId'] ?? '',
      checkInDate: (data['checkInDate'] as Timestamp).toDate(),
      checkOutDate: (data['checkOutDate'] as Timestamp).toDate(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(), // ✅ ensure double
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'landlordId': landlordId,
      'hostelId': hostelId,
      'roomId': roomId,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'totalPrice': totalPrice, // ✅ double
      'status': status,
      'createdAt': createdAt,
    };
  }
}
