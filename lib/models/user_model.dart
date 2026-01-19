import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String username;
  final String email;
  final String role;
  final String userImage;
  final List<dynamic> userCart;
  final List<dynamic> userWish;
  final Timestamp createdAt;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.role,
    required this.userImage,
    required this.userCart,
    required this.userWish,
    required this.createdAt,
  });

  // Convert UserModel to Map (for Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'role': role,
      'userImage': userImage,
      'userCart': userCart,
      'userWish': userWish,
      'createdAt': createdAt,
    };
  }

  // **Add this factory to convert Firestore data to UserModel**
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'user',
      userImage: map['userImage'] ?? '',
      userCart: List<dynamic>.from(map['userCart'] ?? []),
      userWish: List<dynamic>.from(map['userWish'] ?? []),
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }
}
