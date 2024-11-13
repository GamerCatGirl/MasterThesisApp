import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/add_exercise.dart';

//TODO: add floating add button 

class Exercises extends StatefulWidget{
  const Exercises({super.key});

  @override
  State<Exercises> createState() => _ExercisesState();
}

class _ExercisesState extends State<Exercises> {
  int selectedPage = 0;

   void _routeToAddExercise() {
    //TODO
    setState(() {
      selectedPage = 1;
    });
  }


  final List addPage = [AddExercise()];
  final List _exercises = [
      ExerciseTile(nameExercise: "Exercise 1"), 
      ExerciseTile(nameExercise: "Exercise 2"), 
      ExerciseTile(nameExercise: "Exercise 3"), 
      ExerciseTile(nameExercise: "Exercise 4"),
    ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final Center exercises = Center(
        child: ListView(
          children: [
            // SUBDIVISION
            TitleTile(title: "MEETKUNDE"),
            RowExercise(exercise_1: _exercises[0], exercise_2: _exercises[1]),
            TitleTile(title:"GETALLENLEER"),
            RowExercise(exercise_1: _exercises[2], exercise_2: _exercises[3]),

            //Button
            ElevatedButton(
              onPressed: _routeToAddExercise, 
              child: Icon(Icons.add)
                
              )
          ]
        ),
      );

    final List _pages = [exercises, AddExercise()];

    return Scaffold(
      body: Center(
        child: _pages[selectedPage]
      ),
    );
  }
}