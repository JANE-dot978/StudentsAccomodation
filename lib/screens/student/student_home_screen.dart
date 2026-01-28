import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/screens/student/student_hostel_detail_screen.dart';
import 'package:studentsaccomodations/widgets/hostels_cards.dart';
import '../../providers/hostel_provider.dart';
import '../../widgets/hostels_cards.dart';
import '../../models/hostel_model.dart';
import 'room_detail_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool _isLoading = true;
  List<HostelModel> _filteredHostels = [];

  @override
  void initState() {
    super.initState();
    _loadHostels();
  }

  Future<void> _loadHostels() async {
    final provider = Provider.of<HostelProvider>(context, listen: false);
    provider.fetchHostels();
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isLoading = false);
  }

  void _applyFilters(String location, double minPrice, double maxPrice) {
    final hostels =
        Provider.of<HostelProvider>(context, listen: false).hostels;

    setState(() {
      _filteredHostels = hostels.where((h) {
        return (location.isEmpty ||
                h.location.toLowerCase().contains(location.toLowerCase())) &&
            h.price >= minPrice &&
            h.price <= maxPrice;
      }).toList();
    });
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        String location = '';
        double minPrice = 0;
        double maxPrice = 50000;

        return StatefulBuilder(builder: (ctx, setSheetState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Filter Hostels',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              TextField(
                decoration: const InputDecoration(labelText: 'Location'),
                onChanged: (v) => setSheetState(() => location = v),
              ),
              RangeSlider(
                values: RangeValues(minPrice, maxPrice),
                min: 0,
                max: 100000,
                divisions: 100,
                labels: RangeLabels(minPrice.toStringAsFixed(0),
                    maxPrice.toStringAsFixed(0)),
                onChanged: (values) {
                  setSheetState(() {
                    minPrice = values.start;
                    maxPrice = values.end;
                  });
                },
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _applyFilters(location, minPrice, maxPrice);
                },
                child: const Text("Apply"),
              )
            ]),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HostelProvider>(context);
    final hostels =
        _filteredHostels.isNotEmpty ? _filteredHostels : provider.hostels;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cozy Corner Residences"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _openFilterSheet,
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // 🔹 TOP INTRO SECTION
                Container(
                  padding: const EdgeInsets.all(20),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey[50],
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Cozy Corner Residences",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Comfortable and affordable student hostels. Browse options, compare amenities, and book securely.",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                // 🔹 HOSTEL LIST
                Expanded(
                  child: hostels.isEmpty
                      ? const Center(child: Text("No hostels available"))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: hostels.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: StyledHostelCard(
                                hostel: hostels[i],
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          HostelDetailScreen(hostel: hostels[i]),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
    );
  }
}
