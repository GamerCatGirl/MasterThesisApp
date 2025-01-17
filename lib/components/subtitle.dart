import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  final String title;

  const Subtitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            decoration: TextDecoration.underline, fontWeight: FontWeight.bold));
  }
}
