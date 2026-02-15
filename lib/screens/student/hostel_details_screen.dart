import 'package:flutter/material.dart';
import 'package:studentsaccomodations/core/routes/app_routes.dart';
import '../../models/hostel_model.dart';
// import '../../app_routes.dart';

class HostelDetailsScreen extends StatelessWidget {
  final HostelModel hostel;

  const HostelDetailsScreen({super.key, required this.hostel});

  @override
  Widget build(BuildContext context) {

    final image = hostel.images.isNotEmpty ? hostel.images.first : '';

    return Scaffold(
      appBar:AppBar(
        title: Text(hostel.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IMAGE
            image.isEmpty
                ? Container(
                    height: 250,
                    color: Colors.grey.shade300,
                    child: const Center(child: Icon(Icons.image, size: 80)),
                  )
                : Image.network(
                    image,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),

            const SizedBox(height: 18),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// NAME
                  Text(
                    hostel.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LOCATION
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text(hostel.location),
                    ],
                  ),

                  const SizedBox(height: 10),

                  /// PRICE
                  Text(
                    "Ksh ${hostel.price.toStringAsFixed(0)} per month",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// ROOMS
                  Text(
                    "Available Rooms: ${hostel.availableRooms}",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// DESCRIPTION
                  const Text(
                    "Description",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(hostel.description),

                  const SizedBox(height: 30),

                  /// BOOK BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.home_work),
                      label: const Text("Request Booking"),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.booking,
                          arguments: hostel,
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
