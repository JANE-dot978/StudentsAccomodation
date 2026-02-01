import 'package:flutter/material.dart';

class StudentHomeScreen extends StatelessWidget {
  const StudentHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: Column(
        children: [

          /// 🔴 TOP BANNER
          Container(
            height: 170,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(25)),
                color: Colors.black.withOpacity(0.5),
              ),
              child: const Padding(
                padding: EdgeInsets.all(20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Welcome to Cozy Corner\nSmart Student Living",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// 🧩 CATEGORY GRID
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 20,
                children: [

                  _category(Icons.bed, "Single Rooms", () {}),
                  _category(Icons.home, "Bedsitters", () {}),
                  _category(Icons.meeting_room, "Shared Rooms", () {}),
                  _category(Icons.menu_book, "Library", () {}),
                  _category(Icons.computer, "Computer Lab", () {}),
                  _category(Icons.tv, "TV Lounge", () {}),
                  _category(Icons.sports_esports, "Play Area", () {}),
                  _category(Icons.info, "About", () {}),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 CATEGORY BUTTON WIDGET
  Widget _category(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 8)
              ],
            ),
            child: Icon(icon, size: 28, color: Colors.blueAccent),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
