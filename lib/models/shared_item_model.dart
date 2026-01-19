import 'package:cloud_firestore/cloud_firestore.dart';

class SharedItem {
  final String id;
  final String hostelId;
  final String roomId;
  final String itemName;
  final String description;
  final String category; // furniture, appliance, utensil, other
  final String condition; // new, good, fair, poor
  final String itemImage;
  final String createdBy; // landlord uid
  final Timestamp createdAt;
  final int quantity;
  final bool available;

  SharedItem({
    required this.id,
    required this.hostelId,
    required this.roomId,
    required this.itemName,
    required this.description,
    required this.category,
    required this.condition,
    required this.itemImage,
    required this.createdBy,
    required this.createdAt,
    required this.quantity,
    required this.available,
  });

  // Factory constructor to create SharedItem from Firestore document
  factory SharedItem.fromDocument(String docId, Map<String, dynamic> data) {
    return SharedItem(
      id: docId,
      hostelId: data['hostelId'] ?? '',
      roomId: data['roomId'] ?? '',
      itemName: data['itemName'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? 'other',
      condition: data['condition'] ?? 'good',
      itemImage: data['itemImage'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
      quantity: data['quantity'] ?? 1,
      available: data['available'] ?? true,
    );
  }

  // Method to convert SharedItem to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'hostelId': hostelId,
      'roomId': roomId,
      'itemName': itemName,
      'description': description,
      'category': category,
      'condition': condition,
      'itemImage': itemImage,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'quantity': quantity,
      'available': available,
    };
  }

  // Copy with method for immutability
  SharedItem copyWith({
    String? id,
    String? hostelId,
    String? roomId,
    String? itemName,
    String? description,
    String? category,
    String? condition,
    String? itemImage,
    String? createdBy,
    Timestamp? createdAt,
    int? quantity,
    bool? available,
  }) {
    return SharedItem(
      id: id ?? this.id,
      hostelId: hostelId ?? this.hostelId,
      roomId: roomId ?? this.roomId,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      itemImage: itemImage ?? this.itemImage,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      quantity: quantity ?? this.quantity,
      available: available ?? this.available,
    );
  }

  @override
  String toString() => 'SharedItem(id: $id, itemName: $itemName, quantity: $quantity)';
}
