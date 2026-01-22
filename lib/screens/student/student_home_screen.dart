import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/hostel_provider.dart';
import '../../widgets/hostels_cards.dart';

class StudentHomeScreen extends StatefulWidget {
  const StudentHomeScreen({super.key});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HostelProvider>(context, listen: false).fetchHostels();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hostelProvider = Provider.of<HostelProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Available Hostels')),
      body: hostelProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : hostelProvider.hostels.isEmpty
              ? const Center(child: Text('No hostels available'))
              : ListView.builder(
         itemCount: hostelProvider.hostels.length,
         itemBuilder: (context, index) {
    final hostel = hostelProvider.hostels[index];
    return StyledHostelCard(hostel: hostel);
  },
)

    );
  }
}
