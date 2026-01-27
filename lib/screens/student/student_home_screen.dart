import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hostel_provider.dart';
import '../../widgets/hostels_cards.dart';
import 'student_hostel_detail_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHostels();
  }

  Future<void> _fetchHostels() async {
    final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
    hostelProvider.fetchHostels(); // fetchHostels is a Stream-based function
    hostelProvider.addListener(() {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hostels = Provider.of<HostelProvider>(context).hostels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Home'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome!',
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Browse hostels, check amenities, book rooms, and pay securely once approved by the landlord.',
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Section title
                  const Text(
                    'Available Hostels',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Horizontally scrollable list
                  SizedBox(
                    height: 300, // card height
                    child: hostels.isEmpty
                        ? const Center(child: Text('No hostels available.'))
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: hostels.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (ctx, i) {
                              return SizedBox(
                                width: 250, // card width
                                child: StyledHostelCard(
                                  hostel: hostels[i],
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => HostelDetailScreen(
                                            hostel: hostels[i]),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Optional: Explanation text
                  const Text(
                    'Select a hostel to view details, including price, location, amenities, and booking options.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
    );
  }
}
