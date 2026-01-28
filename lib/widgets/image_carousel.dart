// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';

// class ImageCarousel extends StatefulWidget {
//   final List<String> imageUrls;

//   const ImageCarousel({super.key, required this.imageUrls});

//   @override
//   State<ImageCarousel> createState() => _ImageCarouselState();
// }

// class _ImageCarouselState extends State<ImageCarousel> {
//   int _currentIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     if (widget.imageUrls.isEmpty) {
//       return Container(
//         height: 250,
//         color: Colors.grey[300],
//         child: const Center(child: Icon(Icons.image, size: 60)),
//       );
//     }

//     return Column(
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             CarouselSlider.builder(
//               itemCount: widget.imageUrls.length,
//               options: CarouselOptions(
//                 height: 250,
//                 autoPlay: widget.imageUrls.length > 1,
//                 enlargeCenterPage: true,
//                 enableInfiniteScroll: widget.imageUrls.length > 1,
//                 onPageChanged: (index, reason) {
//                   setState(() => _currentIndex = index);
//                 },
//               ),
//               itemBuilder: (context, index, realIndex) {
//                 final url = widget.imageUrls[index];
//                 return ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Image.network(
//                     url,
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                   ),
//                 );
//               },
//             ),

//             // LEFT ARROW (visual only)
//             if (widget.imageUrls.length > 1)
//               const Positioned(
//                 left: 10,
//                 child: Icon(Icons.arrow_back_ios, color: Colors.white),
//               ),

//             // RIGHT ARROW (visual only)
//             if (widget.imageUrls.length > 1)
//               const Positioned(
//                 right: 10,
//                 child: Icon(Icons.arrow_forward_ios, color: Colors.white),
//               ),
//           ],
//         ),

//         const SizedBox(height: 8),

//         if (widget.imageUrls.length > 1)
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: widget.imageUrls.asMap().entries.map((entry) {
//               return Container(
//                 width: _currentIndex == entry.key ? 12 : 8,
//                 height: _currentIndex == entry.key ? 12 : 8,
//                 margin: const EdgeInsets.symmetric(horizontal: 4),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: _currentIndex == entry.key
//                       ? Colors.blueAccent
//                       : Colors.grey,
//                 ),
//               );
//             }).toList(),
//           ),
//       ],
//     );
//   }
// }
