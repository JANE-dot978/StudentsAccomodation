import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/shared_item_model.dart';

class SharedItemProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<SharedItem> _items = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<SharedItem> get items => _items;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetch shared items for a hostel
  Future<void> fetchHostelItems(String hostelId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('sharedItems')
          .where('hostelId', isEqualTo: hostelId)
          .where('available', isEqualTo: true)
          .get();

      _items = snapshot.docs
          .map((doc) => SharedItem.fromDocument(doc.id, doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch items for a specific room
  Future<void> fetchRoomItems(String roomId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final snapshot = await _firestore
          .collection('sharedItems')
          .where('roomId', isEqualTo: roomId)
          .get();

      _items = snapshot.docs
          .map((doc) => SharedItem.fromDocument(doc.id, doc.data()))
          .toList();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // Create a new shared item
  Future<String?> addItem(SharedItem item) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final docRef = await _firestore.collection('sharedItems').add(item.toMap());

      _items.add(item.copyWith(id: docRef.id));
      _isLoading = false;
      notifyListeners();
      return docRef.id;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  // Update shared item
  Future<bool> updateItem(String itemId, SharedItem updatedItem) async {
    try {
      await _firestore.collection('sharedItems').doc(itemId).update(updatedItem.toMap());

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = updatedItem.copyWith(id: itemId);
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Delete shared item
  Future<bool> deleteItem(String itemId) async {
    try {
      await _firestore.collection('sharedItems').doc(itemId).delete();

      _items.removeWhere((item) => item.id == itemId);
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Update item quantity
  Future<bool> updateQuantity(String itemId, int newQuantity) async {
    try {
      await _firestore.collection('sharedItems').doc(itemId).update({
        'quantity': newQuantity,
      });

      final index = _items.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        _items[index] = _items[index].copyWith(quantity: newQuantity);
        notifyListeners();
      }

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Clear items
  void clearItems() {
    _items = [];
    notifyListeners();
  }
}
