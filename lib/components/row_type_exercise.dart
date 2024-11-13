import 'package:flutter/material.dart';
import 'package:mathapp/components/type_exercise_tile.dart';

class RowTypeExercise extends StatelessWidget{
  final TypeExerciseTile exercise_1;
  final TypeExerciseTile exercise_2; 
  final TypeExerciseTile exercise_3;
  final TypeExerciseTile exercise_4;
  final TypeExerciseTile exercise_5;

  const RowTypeExercise({super.key, 
    required this.exercise_1, 
    required this.exercise_2, 
    required this.exercise_3, 
    required this.exercise_4,
    required this.exercise_5});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Align(
    alignment: Alignment.center,
    child: Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 25, top: 20),
      child: Row(
        children: [
          exercise_1, 
          exercise_2,
          exercise_3,
          exercise_4,
          exercise_5,
        ],
      ),
    ),
    );
  }
}