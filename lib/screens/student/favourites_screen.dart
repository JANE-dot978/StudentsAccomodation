// favorites_screen.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/hostel_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/favorites_provider.dart';
import 'hostel_details_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool _isLoading = true;
  List<HostelModel> _hostels = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadFavoriteHostels);
  }

  String? get _uid =>
      Provider.of<AuthProvider>(context, listen: false).user?.uid;

  Future<void> _loadFavoriteHostels() async {
    final uid = _uid;
    if (uid == null) {
      setState(() => _isLoading = false);
      return;
    }

    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    await favoritesProvider.loadFavorites(uid);
    final ids = favoritesProvider.favoriteIds.toList();

    if (ids.isEmpty) {
      if (mounted) setState(() { _hostels = []; _isLoading = false; });
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('hostels')
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    if (mounted) {
      setState(() {
        _hostels = snapshot.docs.map(HostelModel.fromFirestore).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _removeFavorite(HostelModel hostel) async {
    final uid = _uid;
    if (uid == null) return;

    setState(() => _hostels.removeWhere((h) => h.id == hostel.id));

    await Provider.of<FavoritesProvider>(context, listen: false)
        .toggleFavorite(uid, hostel.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hostels.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No favorites yet',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _hostels.length,
                  itemBuilder: (context, index) {
                    final hostel = _hostels[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                HostelDetailsScreen(hostel: hostel),
                          ),
                        ),
                        leading: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.grey.shade200,
                            image: hostel.images.isNotEmpty
                                ? DecorationImage(
                                    image: NetworkImage(hostel.images.first),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: hostel.images.isEmpty
                              ? const Icon(Icons.home)
                              : null,
                        ),
                        title: Text(hostel.name),
                        subtitle: Text(
                            'KES ${hostel.price.toStringAsFixed(0)} / month'),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () => _removeFavorite(hostel),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
