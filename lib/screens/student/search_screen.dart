import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hostel_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/hostel_model.dart';
import 'room_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'all';
  RangeValues _priceRange = const RangeValues(5000, 30000);
  final List<String> _selectedAmenities = [];
  String _searchQuery = '';

  final List<String> _categories = ['all', 'single', 'bedsitter', 'shared'];
  final List<String> _amenities = ['WiFi', 'Parking', 'Laundry', 'Security', 'Kitchen', 'Hot Water'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Hostels'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // SEARCH BAR
          Container(
            padding: const EdgeInsets.all(16),
            color: Theme.of(context).cardColor,
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Search by name or location...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // CATEGORY CHIPS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(
                            category == 'all' ? 'All' : 
                            category == 'single' ? 'Single Rooms' :
                            category == 'bedsitter' ? 'Bedsitters' : 'Shared Rooms',
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() => _selectedCategory = category);
                          },
                          selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          checkmarkColor: Theme.of(context).colorScheme.primary,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // ACTIVE FILTERS DISPLAY
          if (_priceRange.start > 5000 || _priceRange.end < 30000 || _selectedAmenities.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              child: Wrap(
                spacing: 8,
                children: [
                  if (_priceRange.start > 5000 || _priceRange.end < 30000)
                    Chip(
                      label: Text(
                        'KES ${_priceRange.start.round()} - ${_priceRange.end.round()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onDeleted: () {
                        setState(() => _priceRange = const RangeValues(5000, 30000));
                      },
                      deleteIconColor: Theme.of(context).colorScheme.primary,
                    ),
                  ..._selectedAmenities.map((amenity) => Chip(
                        label: Text(amenity, style: const TextStyle(fontSize: 12)),
                        onDeleted: () {
                          setState(() => _selectedAmenities.remove(amenity));
                        },
                        deleteIconColor: Theme.of(context).colorScheme.primary,
                      )),
                ],
              ),
            ),

          // SEARCH RESULTS
          Expanded(
            child: StreamBuilder<List<HostelModel>>(
              stream: _selectedCategory == 'all'
                  ? Provider.of<HostelProvider>(context, listen: false).getAllHostelsStream()
                  : Provider.of<HostelProvider>(context, listen: false)
                      .getHostelsByCategory(_selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text('Error: ${snapshot.error}'),
                      ],
                    ),
                  );
                }

                var hostels = snapshot.data ?? [];

                // Apply search query filter
                if (_searchQuery.isNotEmpty) {
                  hostels = hostels.where((hostel) {
                    final query = _searchQuery.toLowerCase();
                    return hostel.name.toLowerCase().contains(query) ||
                        hostel.location.toLowerCase().contains(query);
                  }).toList();
                }

                // Apply price filter
                hostels = hostels.where((hostel) {
                  return hostel.price >= _priceRange.start && hostel.price <= _priceRange.end;
                }).toList();

                // Apply amenities filter (if your model supports it)
                // This is a placeholder - adjust based on your actual data model
                if (_selectedAmenities.isNotEmpty) {
                  // Filter based on amenities if your HostelModel has that field
                  // For now, we'll skip this since your model doesn't have amenities field
                }

                // Empty state
                if (hostels.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty ? 'No hostels available' : 'No results found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _searchQuery.isEmpty
                              ? 'Try adjusting your filters'
                              : 'Try a different search term',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                        if (_searchQuery.isNotEmpty || _priceRange.start > 5000 || 
                            _priceRange.end < 30000 || _selectedAmenities.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: OutlinedButton.icon(
                              onPressed: () {
                                setState(() {
                                  _searchController.clear();
                                  _searchQuery = '';
                                  _selectedCategory = 'all';
                                  _priceRange = const RangeValues(5000, 30000);
                                  _selectedAmenities.clear();
                                });
                              },
                              icon: const Icon(Icons.clear_all),
                              label: const Text('Clear All Filters'),
                            ),
                          ),
                      ],
                    ),
                  );
                }

                // Results list
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: hostels.length,
                  itemBuilder: (context, index) {
                    return _HostelSearchCard(hostel: hostels[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filters',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        setModalState(() {
                          _priceRange = const RangeValues(5000, 30000);
                          _selectedAmenities.clear();
                        });
                      },
                      child: const Text('Reset All'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // PRICE RANGE
                const Text(
                  'Price Range (KES per month)',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                RangeSlider(
                  values: _priceRange,
                  min: 5000,
                  max: 30000,
                  divisions: 25,
                  labels: RangeLabels(
                    'KES ${_priceRange.start.round()}',
                    'KES ${_priceRange.end.round()}',
                  ),
                  onChanged: (values) {
                    setModalState(() => _priceRange = values);
                  },
                ),
                Text(
                  'KES ${_priceRange.start.round()} - KES ${_priceRange.end.round()}',
                  style: TextStyle(color: Colors.grey.shade600),
                ),

                const SizedBox(height: 24),

                // AMENITIES
                const Text(
                  'Amenities',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _amenities.map((amenity) {
                    final isSelected = _selectedAmenities.contains(amenity);
                    return FilterChip(
                      label: Text(amenity),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          if (selected) {
                            _selectedAmenities.add(amenity);
                          } else {
                            _selectedAmenities.remove(amenity);
                          }
                        });
                      },
                      selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                      checkmarkColor: Theme.of(context).colorScheme.primary,
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // APPLY BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {}); // Refresh main screen
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// HOSTEL SEARCH CARD
class _HostelSearchCard extends StatelessWidget {
  final HostelModel hostel;

  const _HostelSearchCard({required this.hostel});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RoomDetailScreen(hostel: hostel),
            ),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: hostel.images.isNotEmpty
                  ? Image.network(
                      hostel.images.first,
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 120,
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image, size: 40),
                      ),
                    )
                  : Container(
                      width: 120,
                      height: 120,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.home, size: 40),
                    ),
            ),

            // DETAILS
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hostel.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            hostel.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'KES ${hostel.price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${hostel.availableRooms} available',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        hostel.category == 'single' ? 'Single Room' :
                        hostel.category == 'bedsitter' ? 'Bedsitter' : 'Shared Room',
                        style: TextStyle(
                          fontSize: 11,
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}