class Room {
  final String id;
  final String hostelId;
  final String roomNumber;
  final double price;
  final bool isAvailable;
  final List<String> imageUrls;

  Room({
    required this.id,
    required this.hostelId,
    required this.roomNumber,
    required this.price,
    required this.isAvailable,
    required this.imageUrls,
  });

  factory Room.fromMap(Map<String, dynamic> data, String documentId) {
    return Room(
      id: documentId,
      hostelId: data['hostelId'] ?? '',
      roomNumber: data['roomNumber'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      isAvailable: data['isAvailable'] ?? true,
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hostelId': hostelId,
      'roomNumber': roomNumber,
      'price': price,
      'isAvailable': isAvailable,
      'imageUrls': imageUrls,
    };
  }
}
