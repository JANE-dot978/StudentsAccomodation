import 'package:cloud_firestore/cloud_firestore.dart';

class HostelModel {
  final String id;
  final String name;
  final String location;
  final double price;
  final int availableRooms;
  final List<String> images;
  final String category;
  final String landlordId;
  final String description;
  final List<String> sharedItems;

  HostelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.availableRooms,
    required this.images,
    required this.category,
    required this.landlordId,
    required this.description,
    required this.sharedItems,
  });

  factory HostelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return HostelModel(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      availableRooms: data['availableRooms'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
      category: (data['category'] ?? '').toString().toLowerCase().trim(),
      landlordId: data['landlordId'] ?? '',
      description: data['description'] ?? '',
      sharedItems: List<String>.from(data['sharedItems'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'availableRooms': availableRooms,
      'images': images,
      'category': category.toLowerCase().trim(),
      'landlordId': landlordId,
      'description': description,
      'sharedItems': sharedItems,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
