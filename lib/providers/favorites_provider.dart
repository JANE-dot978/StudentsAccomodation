import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FavoritesProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Set<String> _favoriteIds = {};
  String? _loadedForUid;

  Set<String> get favoriteIds => _favoriteIds;

  bool isFavorite(String hostelId) => _favoriteIds.contains(hostelId);

  Future<void> loadFavorites(String uid) async {
    if (_loadedForUid == uid) return;
    final doc = await _firestore.collection('userFavorites').doc(uid).get();
    _favoriteIds = Set<String>.from(
      (doc.data()?['hostelIds'] as List?) ?? [],
    );
    _loadedForUid = uid;
    notifyListeners();
  }

  Future<void> toggleFavorite(String uid, String hostelId) async {
    final isCurrentlyFavorite = _favoriteIds.contains(hostelId);

    if (isCurrentlyFavorite) {
      _favoriteIds.remove(hostelId);
    } else {
      _favoriteIds.add(hostelId);
    }
    notifyListeners();

    try {
      await _firestore.collection('userFavorites').doc(uid).set({
        'hostelIds': FieldValue.arrayUnion(
          isCurrentlyFavorite ? [] : [hostelId],
        ),
      }, SetOptions(merge: true));

      if (isCurrentlyFavorite) {
        await _firestore.collection('userFavorites').doc(uid).set({
          'hostelIds': FieldValue.arrayRemove([hostelId]),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      // Revert local state if the write failed
      if (isCurrentlyFavorite) {
        _favoriteIds.add(hostelId);
      } else {
        _favoriteIds.remove(hostelId);
      }
      notifyListeners();
      rethrow;
    }
  }
}
