import 'package:cloud_firestore/cloud_firestore.dart';

class Maintenance {
  final String id;
  final String hostelId;
  final String landlordId;
  final String title;
  final String description;
  final String category; // electrical, plumbing, cleaning, general
  final String priority; // low, medium, high, urgent
  final String status; // pending, in_progress, completed, cancelled
  final DateTime reportedDate;
  final DateTime? completedDate;
  final String? assignedTo;
  final double? estimatedCost;
  final String? reportedBy; // student uid
  final Timestamp createdAt;

  Maintenance({
    required this.id,
    required this.hostelId,
    required this.landlordId,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.status,
    required this.reportedDate,
    this.completedDate,
    this.assignedTo,
    this.estimatedCost,
    this.reportedBy,
    required this.createdAt,
  });

  // Factory constructor to create Maintenance from Firestore document
  factory Maintenance.fromDocument(String docId, Map<String, dynamic> data) {
    return Maintenance(
      id: docId,
      hostelId: data['hostelId'] ?? '',
      landlordId: data['landlordId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'general',
      priority: data['priority'] ?? 'medium',
      status: data['status'] ?? 'pending',
      reportedDate: (data['reportedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      completedDate: (data['completedDate'] as Timestamp?)?.toDate(),
      assignedTo: data['assignedTo'],
      estimatedCost: (data['estimatedCost'] ?? 0).toDouble(),
      reportedBy: data['reportedBy'],
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Method to convert Maintenance to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'hostelId': hostelId,
      'landlordId': landlordId,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'status': status,
      'reportedDate': Timestamp.fromDate(reportedDate),
      'completedDate': completedDate != null ? Timestamp.fromDate(completedDate!) : null,
      'assignedTo': assignedTo,
      'estimatedCost': estimatedCost,
      'reportedBy': reportedBy,
      'createdAt': createdAt,
    };
  }

  // Copy with method for immutability
  Maintenance copyWith({
    String? id,
    String? hostelId,
    String? landlordId,
    String? title,
    String? description,
    String? category,
    String? priority,
    String? status,
    DateTime? reportedDate,
    DateTime? completedDate,
    String? assignedTo,
    double? estimatedCost,
    String? reportedBy,
    Timestamp? createdAt,
  }) {
    return Maintenance(
      id: id ?? this.id,
      hostelId: hostelId ?? this.hostelId,
      landlordId: landlordId ?? this.landlordId,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      reportedDate: reportedDate ?? this.reportedDate,
      completedDate: completedDate ?? this.completedDate,
      assignedTo: assignedTo ?? this.assignedTo,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      reportedBy: reportedBy ?? this.reportedBy,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() => 'Maintenance(id: $id, title: $title, status: $status)';
}
