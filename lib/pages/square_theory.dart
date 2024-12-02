import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';

class SquareTheory extends StatefulWidget {
  const SquareTheory({super.key});

  @override
  State<SquareTheory> createState() => new _SquareTheoryState();
}

class _SquareTheoryState extends State<SquareTheory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      Text("Oppervlakte"),
      Spacer(),
      Text("TODO"),
      Spacer(),
    ])));
  }
}
