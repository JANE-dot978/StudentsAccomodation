import 'package:flutter/material.dart';
import '../models/room_model.dart';
import '../services/room_service.dart';

class RoomProvider with ChangeNotifier {
  final RoomService _service = RoomService();

  List<Room> _rooms = [];
  bool _isLoading = false;

  List<Room> get rooms => _rooms;
  bool get isLoading => _isLoading;

  Future<void> loadRooms(String hostelId) async {
    _isLoading = true;
    notifyListeners();

    _rooms = await _service.fetchRoomsByHostel(hostelId);

    _isLoading = false;
    notifyListeners();
  }
}
