import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Register user
  Future<UserModel> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
    required String role,
  }) async {
    // Create user in Firebase Auth
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());

    User? user = userCredential.user;

    if (user != null) {
      // Create Firestore document with UID
      await _firestore.collection('users').doc(user.uid).set({
        'fullName': fullName.trim(),
        'email': email.trim(),
        'phoneNumber': phoneNumber.trim(),
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return UserModel(
        uid: user.uid,
        username: fullName,
        email: email,
        role: role,
        userCart: [],
        userWish: [],
        userImage: '',
        createdAt: Timestamp.now(),
      );
    } else {
      throw FirebaseAuthException(
          code: 'user-not-created', message: 'User registration failed');
    }
  }

  // Login
  Future<void> login(String email, String password) async {
    await _auth.signInWithEmailAndPassword(
        email: email.trim(), password: password.trim());
  }

  // Get current user from Firestore
  Future<UserModel?> getCurrentUser() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        return UserModel.fromMap(data..['uid'] = user.uid);

      }
    }
    return null;
  }

  // Logout
  void logout() async {
    await _auth.signOut();
  }
}
