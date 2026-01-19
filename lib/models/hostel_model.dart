class Hostel {
  final String id;
  final String name;
  final List<String> images;
  final int availableRooms;
  final int price;
  final List<String> sharedItems;

  Hostel({
    required this.id,
    required this.name,
    required this.images,
    required this.availableRooms,
    required this.price,
    required this.sharedItems,
  });

  factory Hostel.fromMap(Map<String, dynamic> map) {
    return Hostel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      availableRooms: map['availableRooms'] ?? 0,
      price: map['price'] ?? 0,
      sharedItems: List<String>.from(map['sharedItems'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'images': images,
      'availableRooms': availableRooms,
      'price': price,
      'sharedItems': sharedItems,
    };
  }
}
