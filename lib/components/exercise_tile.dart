import 'package:flutter/material.dart';

class ExerciseTile extends StatelessWidget{
  final String nameExercise;

  const ExerciseTile({super.key, required this.nameExercise});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: 150,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Text(
                nameExercise,
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
              )
              ),
              //TODO: on the image add the duration of exercise
              //TODO: add the type of exercise
              //TODO: add the dificulty level 
            ClipRRect(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15), 
                  bottomRight: Radius.circular(15)),
              child: Image(
                width: 150,
                height: 80,
                image: AssetImage('assets/images/example_img.jpg')),
            )
          ],
        ),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 212, 175, 248), 
          borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}