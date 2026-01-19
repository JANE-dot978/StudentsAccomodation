import 'package:flutter/material.dart';

class AppNameTextWidget extends StatelessWidget {
  final double fontSize;
  const AppNameTextWidget({
    super.key,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'Students_Accomodation',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}
