import 'package:cloud_firestore/cloud_firestore.dart';

class HostelModel {
  String id;
  final String name;
  final String location;
  final int price;
  final int availableRooms;
  final List<String> images;
  final List<String> sharedItems;
  final String landlordId;
  final String description;

  HostelModel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    required this.availableRooms,
    required this.images,
    required this.sharedItems,
    required this.landlordId,
    required this.description,
  });

  factory HostelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return HostelModel(
      id: doc.id,
      name: data['name'] ?? '',
      location: data['location'] ?? '',
      price: data['price'] ?? 0,
      availableRooms: data['availableRooms'] ?? 0,
      images: List<String>.from(data['images'] ?? []),
      sharedItems: List<String>.from(data['sharedItems'] ?? []),
      landlordId: data['landlordId'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'availableRooms': availableRooms,
      'images': images,
      'sharedItems': sharedItems,
      'landlordId': landlordId,
      'description': description,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
