// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/auth_provider.dart';

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final user = Provider.of<AuthProvider>(context).user;

//     return Scaffold(
//       appBar: AppBar(title: const Text("Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
//             const SizedBox(height: 16),
//             Text(user?.email ?? "No email",
//                 style: const TextStyle(fontSize: 16)),
//             const SizedBox(height: 10),
//             const Text("Role: Landlord"),
//           ],
//         ),
//       ),
//     );
//   }
// }
