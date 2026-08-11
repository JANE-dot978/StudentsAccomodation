import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

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

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      if (!doc.exists) return 'User data not found';

      _user = UserModel.fromMap(doc.data()!);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') return 'No user found for that email';
      if (e.code == 'wrong-password') return 'Wrong password provided';
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // ✅ Google Sign-In (Web and Mobile)
  Future<String?> signInWithGoogle() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // ✅ WEB IMPLEMENTATION
        GoogleAuthProvider googleProvider = GoogleAuthProvider();
        googleProvider.addScope('email');
        googleProvider.addScope('profile');

        userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // ✅ MOBILE IMPLEMENTATION
        final GoogleSignIn googleSignIn = GoogleSignIn();
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          return 'Sign-in cancelled';
    }

        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        return 'Failed to sign in with Google';
      }

      // Check if user exists
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        // Create new user
        final newUser = UserModel(
          uid: firebaseUser.uid,
          username: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          userImage: firebaseUser.photoURL ?? '',
          createdAt: Timestamp.now(),
          userWish: [],
          userCart: [],
          role: 'student',
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());

        _user = newUser;
      } else {
        _user = UserModel.fromMap(userDoc.data()!);
      }

      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'popup-closed-by-user') {
        return 'Sign-in cancelled';
      }
      return e.message ?? 'Google sign-in failed';
    } catch (e) {
      return e.toString();
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      if (!kIsWeb) {
        final GoogleSignIn googleSignIn = GoogleSignIn();
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      _user = null;
      notifyListeners();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  // Fetch user by ID
  Future<void> fetchUserById(String uid) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();

      if (doc.exists) {
        _user = UserModel.fromMap(doc.data()!);
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching user: $e');
    }
  }
}