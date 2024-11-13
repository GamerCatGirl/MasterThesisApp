//exists of 3 tiles of exercises

import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';

class RowExercise extends StatelessWidget{
  final ExerciseTile exercise_1;
  final ExerciseTile exercise_2; 

  const RowExercise({super.key, 
    required this.exercise_1, 
    required this.exercise_2});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 20),
      child: Row(
        children: [
          exercise_1, 
          exercise_2,
        ],
      ),
    ),
    );
  }
}