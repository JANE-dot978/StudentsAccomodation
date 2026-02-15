import 'package:cloud_firestore/cloud_firestore.dart';

class Booking {
  final String id;
  final String studentId;
  final String landlordId;
  final String hostelId;
  final String roomId;
  final String roomType;
  final double amount;
  final String status; // pending, approved, rejected, cancelled
  final bool isPaid;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? paidAt;
  final DateTime checkInDate;
  final int durationMonths;
  final String? rejectionReason;

  Booking({
    required this.id,
    required this.studentId,
    required this.landlordId,
    required this.hostelId,
    required this.roomId,
    required this.roomType,
    required this.amount,
    this.status = 'pending',
    this.isPaid = false,
    required this.createdAt,
    this.updatedAt,
    this.paidAt,
    required this.checkInDate,
    required this.durationMonths,
    this.rejectionReason,
  });

  /// Convert Booking to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'studentId': studentId,
      'landlordId': landlordId,
      'hostelId': hostelId,
      'roomId': roomId,
      'roomType': roomType,
      'amount': amount,
      'status': status,
      'isPaid': isPaid,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'paidAt': paidAt != null ? Timestamp.fromDate(paidAt!) : null,
      'checkInDate': Timestamp.fromDate(checkInDate),
      'durationMonths': durationMonths,
      'rejectionReason': rejectionReason,
    };
  }

  /// Create Booking from Firestore Map
  factory Booking.fromMap(Map<String, dynamic> map, String documentId) {
    return Booking(
      id: documentId,
      studentId: map['studentId'] ?? '',
      landlordId: map['landlordId'] ?? '',
      hostelId: map['hostelId'] ?? '',
      roomId: map['roomId'] ?? '',
      roomType: map['roomType'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      status: map['status'] ?? 'pending',
      isPaid: map['isPaid'] ?? false,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (map['updatedAt'] as Timestamp?)?.toDate(),
      paidAt: (map['paidAt'] as Timestamp?)?.toDate(),
      checkInDate: (map['checkInDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      durationMonths: map['durationMonths'] ?? 1,
      rejectionReason: map['rejectionReason'],
    );
  }

  /// Create Booking from Firestore DocumentSnapshot
  factory Booking.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Booking.fromMap(data, doc.id);
  }

  /// Copy with method for updates
  Booking copyWith({
    String? id,
    String? studentId,
    String? landlordId,
    String? hostelId,
    String? roomId,
    String? roomType,
    double? amount,
    String? status,
    bool? isPaid,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? paidAt,
    DateTime? checkInDate,
    int? durationMonths,
    String? rejectionReason,
  }) {
    return Booking(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      landlordId: landlordId ?? this.landlordId,
      hostelId: hostelId ?? this.hostelId,
      roomId: roomId ?? this.roomId,
      roomType: roomType ?? this.roomType,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      isPaid: isPaid ?? this.isPaid,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      paidAt: paidAt ?? this.paidAt,
      checkInDate: checkInDate ?? this.checkInDate,
      durationMonths: durationMonths ?? this.durationMonths,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  /// Convert to JSON (for debugging or API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentId': studentId,
      'landlordId': landlordId,
      'hostelId': hostelId,
      'roomId': roomId,
      'roomType': roomType,
      'amount': amount,
      'status': status,
      'isPaid': isPaid,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'paidAt': paidAt?.toIso8601String(),
      'checkInDate': checkInDate.toIso8601String(),
      'durationMonths': durationMonths,
      'rejectionReason': rejectionReason,
    };
  }

  @override
  String toString() {
    return 'Booking(id: $id, roomType: $roomType, status: $status, amount: $amount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Booking && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}