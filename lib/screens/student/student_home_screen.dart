// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:video_player/video_player.dart';
// import '../../providers/hostel_provider.dart';
// import '../../widgets/hostels_cards.dart';
// import '../../models/hostel_model.dart';
// import 'student_hostel_detail_screen.dart';

// class StudentHomeScreen extends StatefulWidget {
//   const StudentHomeScreen({super.key});

//   @override
//   State<StudentHomeScreen> createState() => _StudentHomeScreenState();
// }

// class _StudentHomeScreenState extends State<StudentHomeScreen> {
//   bool _isLoading = true;
//   List<HostelModel> _filteredHostels = [];
//   late VideoPlayerController _videoController;

//   @override
//   void initState() {
//     super.initState();
//     _initializeVideo();
//     _loadHostels();
//   }

//   Future<void> _loadHostels() async {
//     final provider = Provider.of<HostelProvider>(context, listen: false);
//     await provider.fetchHostels();
//     setState(() => _isLoading = false);
//   }

//   void _initializeVideo() {
//     _videoController = VideoPlayerController.asset('assets/videos/hostels.mp4')
//       ..initialize().then((_) {
//         setState(() {}); // Refresh UI
//         _videoController.setLooping(true);
//         _videoController.setVolume(0);
//         _videoController.play();
//       });
//   }

//   void _applyFilters(String location, double minPrice, double maxPrice) {
//     final hostels =
//         Provider.of<HostelProvider>(context, listen: false).hostels;
//     setState(() {
//       _filteredHostels = hostels.where((h) {
//         return (location.isEmpty ||
//                 h.location.toLowerCase().contains(location.toLowerCase())) &&
//             h.price >= minPrice &&
//             h.price <= maxPrice;
//       }).toList();
//     });
//   }

//   void _openFilterSheet() {
//     showModalBottomSheet(
//       context: context,
//       builder: (ctx) {
//         String location = '';
//         double minPrice = 0;
//         double maxPrice = 50000;
//         return StatefulBuilder(builder: (ctx, setSheetState) {
//           return Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(mainAxisSize: MainAxisSize.min, children: [
//               const Text('Filter Hostels',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               TextField(
//                 decoration: const InputDecoration(labelText: 'Location'),
//                 onChanged: (v) => setSheetState(() => location = v),
//               ),
//               RangeSlider(
//                 values: RangeValues(minPrice, maxPrice),
//                 min: 0,
//                 max: 100000,
//                 divisions: 100,
//                 labels: RangeLabels(minPrice.toStringAsFixed(0),
//                     maxPrice.toStringAsFixed(0)),
//                 onChanged: (values) {
//                   setSheetState(() {
//                     minPrice = values.start;
//                     maxPrice = values.end;
//                   });
//                 },
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _applyFilters(location, minPrice, maxPrice);
//                 },
//                 child: const Text("Apply"),
//               )
//             ]),
//           );
//         });
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _videoController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<HostelProvider>(context);
//     final hostels =
//         _filteredHostels.isNotEmpty ? _filteredHostels : provider.hostels;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : CustomScrollView(
//               slivers: [
//                 /// 🌟 HERO VIDEO SECTION
//                 SliverToBoxAdapter(
//                   child: SizedBox(
//                     height: 320,
//                     width: double.infinity,
//                     child: _videoController.value.isInitialized
//                         ? Stack(
//                             children: [
//                               FittedBox(
//                                 fit: BoxFit.cover,
//                                 child: SizedBox(
//                                   width: _videoController.value.size.width,
//                                   height: _videoController.value.size.height,
//                                   child: VideoPlayer(_videoController),
//                                 ),
//                               ),
//                               Container(
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.black.withOpacity(0.7),
//                                       Colors.transparent
//                                     ],
//                                     begin: Alignment.bottomCenter,
//                                     end: Alignment.topCenter,
//                                   ),
//                                 ),
//                               ),
//                               Positioned(
//                                 left: 20,
//                                 bottom: 30,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: const [
//                                     Text(
//                                       "Cozy Corner Residences",
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 38,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                     SizedBox(height: 6),
//                                     Text(
//                                       "A place where comfort meets community, and every student feels at home. Experience the best stay, peace, and support as you focus on your dreams.",
//                                       style: TextStyle(
//                                           color: Colors.white70, fontSize: 16),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           )
//                         : Stack(
//                             children: [
//                               Image.network(
//                                 "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85",
//                                 height: 320,
//                                 width: double.infinity,
//                                 fit: BoxFit.cover,
//                               ),
//                               Container(
//                                 height: 320,
//                                 decoration: BoxDecoration(
//                                   gradient: LinearGradient(
//                                     colors: [
//                                       Colors.black.withOpacity(0.7),
//                                       Colors.transparent
//                                     ],
//                                     begin: Alignment.bottomCenter,
//                                     end: Alignment.topCenter,
//                                   ),
//                                 ),
//                               ),
//                               const Center(
//                                 child: CircularProgressIndicator(),
//                               ),
//                             ],
//                           ),
//                   ),
//                 ),

//                 /// 🔍 GLASS-LIKE FILTER BUTTON
//                 SliverToBoxAdapter(
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: ElevatedButton.icon(
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: Colors.blueAccent,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(30)),
//                       ),
//                       onPressed: _openFilterSheet,
//                       icon: const Icon(Icons.search),
//                       label: const Text("Find Your Perfect Hostel"),
//                     ),
//                   ),
//                 ),

//                 /// 🏠 AVAILABLE HOSTELS TITLE
//                 const SliverToBoxAdapter(
//                   child: Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 20),
//                     child: Text("Available Hostels",
//                         style: TextStyle(
//                             fontSize: 20, fontWeight: FontWeight.bold)),
//                   ),
//                 ),

//                 /// 🏢 HOSTELS LIST
//                 hostels.isEmpty
//                     ? const SliverFillRemaining(
//                         child: Center(child: Text("No hostels available")))
//                     : SliverList(
//                         delegate: SliverChildBuilderDelegate(
//                           (context, i) {
//                             return Padding(
//                               padding: const EdgeInsets.all(16),
//                               child: StyledHostelCard(
//                                 hostel: hostels[i],
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) => HostelDetailScreen(
//                                           hostel: hostels[i]),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             );
//                           },
//                           childCount: hostels.length,
//                         ),
//                       )
//               ],
//             ),
//     );
//   }
// }
