// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:studentsaccomodations/screens/student/student_hostel_detail_screen.dart';
// import '../../providers/hostel_provider.dart';
// import '../../widgets/hostels_cards.dart';
// import '../../screens/student/student_hostel_detail_screen.dart';

// class HostelListScreen extends StatefulWidget {
//   const HostelListScreen({super.key});

//   @override
//   State<HostelListScreen> createState() => _HostelListScreenState();
// }

// class _HostelListScreenState extends State<HostelListScreen> {
//   bool _isLoading = true;

//   @override
//   void initState() {
//     super.initState();
//     _fetchHostels();
//   }

//   Future<void> _fetchHostels() async {
//     final hostelProvider = Provider.of<HostelProvider>(context, listen: false);
//     await hostelProvider.fetchHostels();
//     if (mounted) setState(() => _isLoading = false);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hostelProvider = Provider.of<HostelProvider>(context);
//     final hostels = hostelProvider.hostels;

//     return Scaffold(
//       appBar: AppBar(title: const Text('Welcome, Student!')),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : hostels.isEmpty
//               ? const Center(child: Text('No hostels available.'))
//               : ListView(
//                   padding: const EdgeInsets.all(16),
//                   children: [
//                     const Text(
//                       'Find your ideal hostel below. Browse, check details, and book your room.',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                     const SizedBox(height: 16),
//                     ...hostels.map(
//                       (hostel) => StyledHostelCard(
//                         hostel: hostel,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) =>
//                                   HostelDetailScreen(hostel: hostel),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//     );
//   }
// }
