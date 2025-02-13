import 'package:flutter/material.dart';

class Learningpathtileleft extends StatelessWidget {
  final VoidCallback onTileClicked;
  final IconData icon;

  const Learningpathtileleft(
      {super.key, required this.onTileClicked, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Spacer(),
      IconButton(
          onPressed: onTileClicked,
          icon: Icon(
            icon,
            size: 80,
          )),
      Spacer(),
      Spacer(),
      Spacer(),
      Spacer(),
    ]);
  }
}
