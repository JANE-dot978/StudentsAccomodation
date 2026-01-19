import 'package:flutter/material.dart';

class MyAppFunctions {
  // Image picker dialog with callbacks
  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Future<void> Function() cameraFCT,
    required Future<void> Function() galleryFCT,
    required Future<void> Function() removeFCT,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick Image'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.pop(context);
                  await cameraFCT();
                },
              ),
              ListTile(
                leading: const Icon(Icons.image),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.pop(context);
                  await galleryFCT();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete),
                title: const Text('Remove Image'),
                onTap: () async {
                  Navigator.pop(context);
                  await removeFCT();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Format price
  static String formatPrice(double price) {
    return '\$$price';
  }

  // Show snackbar
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}