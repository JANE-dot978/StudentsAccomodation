import 'package:cloud_firestore/cloud_firestore.dart';

class HostelModel {
  final String id;
  final String name;
  final String landlordId;
  final List<String> images;
  final int availableRooms;
  final int price;
  final List<String> sharedItems;

  HostelModel({
    required this.id,
    required this.name,
    required this.landlordId,
    required this.images,
    required this.availableRooms,
    required this.price,
    required this.sharedItems,
  });

  factory HostelModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HostelModel(
      id: doc.id,
      name: data['name'] ?? '',
      landlordId: data['landlordId'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      availableRooms: data['availableRooms'] ?? 0,
      price: data['price'] ?? 0,
      sharedItems: List<String>.from(data['sharedItems'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'landlordId': landlordId,
      'images': images,
      'availableRooms': availableRooms,
      'price': price,
      'sharedItems': sharedItems,
    };
  }
}
