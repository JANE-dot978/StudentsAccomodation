import 'dart:typed_data';
import 'package:flutter/material.dart';

class PickImageWidget extends StatelessWidget {
  final Uint8List? pickedImageBytes;
  final VoidCallback onTap;

  const PickImageWidget({
    super.key,
    this.pickedImageBytes,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: pickedImageBytes == null
            ? Center(
                child: Icon(
                  Icons.image,
                  size: 50,
                  color: Theme.of(context).primaryColor,
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.memory(
                  pickedImageBytes!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.error,
                        size: 50,
                        color: Colors.red,
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
