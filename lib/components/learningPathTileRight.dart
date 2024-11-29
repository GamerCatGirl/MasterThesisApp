import 'package:flutter/material.dart';

class Learningpathtileright extends StatelessWidget {
  final VoidCallback onTileClicked;
  final IconData icon;

  const Learningpathtileright(
      {super.key, required this.onTileClicked, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Spacer(),
      Spacer(),
      Spacer(),
      Spacer(),
      IconButton(
          onPressed: onTileClicked,
          icon: Icon(
            icon,
            size: 80,
          )),
      Spacer(),
    ]);
  }
}
