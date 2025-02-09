import 'package:flutter/material.dart';

class Learningpathtile extends StatelessWidget {
  final VoidCallback onTileClicked;
  final IconData icon;
  final bool completed;
  final bool enabeled;
  final String position;
  final String userID;

  const Learningpathtile(
      {super.key,
      required this.onTileClicked,
      required this.position,
      required this.icon,
      required this.completed,
      required this.enabeled,
      required this.userID});

  @override
  Widget build(BuildContext context) {
    Color color = Colors.black;

    if (completed) {
      color = Colors.green;
    } else if (!enabeled) {
      color = Colors.grey;
    }

    IconButton tileButton = IconButton(
        onPressed: onTileClicked,
        icon: Icon(
          icon,
          color: color,
          size: 80,
        ));

    List<Widget> left = [
      Spacer(),
      tileButton,
      Spacer(),
      Spacer(),
      Spacer(),
      Spacer(),
    ];

    List<Widget> mid = [Spacer(), tileButton, Spacer()];

    List<Widget> right = [
      Spacer(),
      Spacer(),
      Spacer(),
      Spacer(),
      tileButton,
      Spacer(),
    ];

    var tile = left;

    if (position == "left") {
      tile = left;
    } else if (position == "mid") {
      tile = mid;
    } else if (position == "right") {
      tile = right;
    }

    return Row(children: tile);
  }
}
