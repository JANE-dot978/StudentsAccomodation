import 'package:flutter/material.dart';
import '../models/hostel_model.dart';

class StyledHostelCard extends StatelessWidget {
  final HostelModel hostel;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap; // Add this

  const StyledHostelCard({
    super.key,
    required this.hostel,
    this.onEdit,
    this.onDelete,
    this.onTap, // Add this
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // Trigger tap
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMAGE
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(18)),
                  child: hostel.images.isNotEmpty
                      ? Image.network(
                          hostel.images.first,
                          height: 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 180,
                          color: Colors.grey[300],
                          child: const Center(
                              child: Icon(Icons.home, size: 50)),
                        ),
                ),
                Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(18)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.6),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "KES ${hostel.price}/mo",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hostel.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          hostel.location,
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoItem(Icons.meeting_room,
                          "${hostel.availableRooms} Rooms"),
                      _infoItem(Icons.home_work, "Hostel"),
                      _infoItem(Icons.verified, "Listed"),
                    ],
                  ),
                  const SizedBox(height: 14),
                  if (onEdit != null || onDelete != null)
                    Row(
                      children: [
                        if (onEdit != null)
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: onEdit,
                              icon: const Icon(Icons.edit, size: 18),
                              label: const Text("Edit"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey[800],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        if (onEdit != null && onDelete != null)
                          const SizedBox(width: 10),
                        if (onDelete != null)
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: onDelete,
                              icon: const Icon(Icons.delete, size: 18),
                              label: const Text("Delete"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: TextStyle(color: Colors.grey[700])),
      ],
    );
  }
}



// import 'package:flutter/material.dart';
// import '../models/hostel_model.dart';

// class StyledHostelCard extends StatefulWidget {
//   final HostelModel hostel;
//   final VoidCallback onTap;

//   const StyledHostelCard(
//       {super.key, required this.hostel, required this.onTap});

//   @override
//   State<StyledHostelCard> createState() => _StyledHostelCardState();
// }

// class _StyledHostelCardState extends State<StyledHostelCard> {
//   bool liked = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: widget.onTap,
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: const [
//             BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4))
//           ],
//         ),
//         child: Column(children: [
//           Stack(children: [
//             ClipRRect(
//               borderRadius:
//                   const BorderRadius.vertical(top: Radius.circular(16)),
//               child: Image.network(widget.hostel.images.first,
//                   height: 180, width: double.infinity, fit: BoxFit.cover),
//             ),
//             Positioned(
//               right: 10,
//               top: 10,
//               child: IconButton(
//                 icon: Icon(liked ? Icons.favorite : Icons.favorite_border,
//                     color: Colors.red),
//                 onPressed: () => setState(() => liked = !liked),
//               ),
//             ),
//           ]),
//           Padding(
//             padding: const EdgeInsets.all(12),
//             child:
//                 Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
//               Text(widget.hostel.name,
//                   style: const TextStyle(
//                       fontSize: 18, fontWeight: FontWeight.bold)),
//               Text(widget.hostel.location,
//                   style: const TextStyle(color: Colors.grey)),
//               const SizedBox(height: 6),
//               Text("KES ${widget.hostel.price}/month",
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold)),
//             ]),
//           )
//         ]),
//       ),
//     );
//   }
// }
