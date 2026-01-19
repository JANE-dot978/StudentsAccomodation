import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String studentId;
  final String landlordId;
  final String hostelId;
  final String roomId;
  final DateTime checkInDate;
  final DateTime checkOutDate;
  final double totalPrice;
  final String status; // pending, confirmed, cancelled, completed
  final Timestamp createdAt;
  final Timestamp? updatedAt;

  Booking({
    required this.id,
    required this.studentId,
    required this.landlordId,
    required this.hostelId,
    required this.roomId,
    required this.checkInDate,
    required this.checkOutDate,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create Booking from Firestore document
  factory Booking.fromDocument(String docId, Map<String, dynamic> data) {
    return Booking(
      id: docId,
      studentId: data['studentId'] ?? '',
      landlordId: data['landlordId'] ?? '',
      hostelId: data['hostelId'] ?? '',
      roomId: data['roomId'] ?? '',
      checkInDate: (data['checkInDate'] as Timestamp).toDate(),
      checkOutDate: (data['checkOutDate'] as Timestamp).toDate(),
      totalPrice: (data['totalPrice'] ?? 0).toDouble(),
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      updatedAt: data['updatedAt'],
    );
  }

  // Method to convert Booking to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'landlordId': landlordId,
      'hostelId': hostelId,
      'roomId': roomId,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'checkOutDate': Timestamp.fromDate(checkOutDate),
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt ?? Timestamp.now(),
    };
  }

  // Copy with method for immutability
  Booking copyWith({
    String? id,
    String? studentId,
    String? landlordId,
    String? hostelId,
    String? roomId,
    DateTime? checkInDate,
    DateTime? checkOutDate,
    double? totalPrice,
    String? status,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Booking(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      landlordId: landlordId ?? this.landlordId,
      hostelId: hostelId ?? this.hostelId,
      roomId: roomId ?? this.roomId,
      checkInDate: checkInDate ?? this.checkInDate,
      checkOutDate: checkOutDate ?? this.checkOutDate,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Booking(id: $id, studentId: $studentId, status: $status)';
}
