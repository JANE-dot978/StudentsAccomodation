import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  UserModel? _user;

  UserModel? get getUser => _user;

  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  // Login method
  Future<String?> login(String email, String password) async {
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!cred.user!.emailVerified) {
        await FirebaseAuth.instance.signOut();
        return 'Please verify your email before logging in';
      }

      // Fetch user data from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      if (!doc.exists) return 'User data not found';

      _user = UserModel.fromMap(doc.data()!);
      notifyListeners();
      return null; // null means no error
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return 'No user found for that email';
      if (e.code == 'wrong-password') return 'Wrong password provided';
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    _user = null;
    notifyListeners();
  }
}
