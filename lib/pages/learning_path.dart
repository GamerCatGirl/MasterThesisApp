import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/learningPathTileLeft.dart';
import 'package:mathapp/components/learningPathTileMid.dart';
import 'package:mathapp/components/learningPathTileRight.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/add_exercise.dart';
import 'package:mathapp/pages/oppervlakte_theory.dart';
import 'package:mathapp/pages/square_theory.dart';

//TODO: add floating add button

class LearningPath extends StatefulWidget {
  const LearningPath({super.key});

  @override
  State<LearningPath> createState() => _LearningPathState();
}

class _LearningPathState extends State<LearningPath> {
  int selectedPage = 0;

  void _routeToAddExercise() {
    //TODO
    setState(() {
      selectedPage = 1;
    });
  }

  IconData theory = Icons.article_outlined;
  IconData iconVierkantEx = Icons.square;
  IconData iconTriangleEx = Icons.change_history_sharp;
  IconData iconOppervlakte = Icons.category_outlined;
  IconData iconCirlceEx = Icons.circle_outlined;
  IconData iconRectangle = Icons.crop_16_9_outlined;
  IconData iconPlattegrond = Icons.design_services;
  IconData classExercise = Icons.diversity_3;
  IconData iconSkip = Icons.double_arrow_rounded;
  IconData iconDownload = Icons.download;
  IconData iconTestKnowledge = Icons.edit_note_outlined;
  IconData iconCheckKnowledge = Icons.fact_check_rounded;
  List path = [];

  //TODO: in first theory of chapter, get the knowledge of the student
  //TODO: then make sure if student needs a fast or slow learning path

  @override
  Widget build(BuildContext context) {
    VoidCallback theoryCallback = () => {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OppervlakteTheory(done: () {}),
            ),
          )
        };
    // TODO: implement build
    final Center exercises = Center(
      child: Column(children: [
        // SUBDIVISION
        TitleTile(title: "H5: Oppervlakte"),
        Spacer(),
        Learningpathtileleft(onTileClicked: theoryCallback, icon: theory),
        Image(
            fit: BoxFit.fitWidth,
            image: AssetImage("assets/images/paths/LtoM.jpg")),
        Learningpathtilemid(
            onTileClicked: theoryCallback, icon: iconVierkantEx),
        Image(
            fit: BoxFit.fitWidth,
            image: AssetImage("assets/images/paths/MtoR.jpg")),
        Learningpathtileright(
            onTileClicked: theoryCallback, icon: iconOppervlakte),
        Image(
            fit: BoxFit.fitWidth,
            image: AssetImage("assets/images/paths/RtoM.jpg")),
        Learningpathtilemid(
            onTileClicked: theoryCallback, icon: iconTriangleEx),
        Image(
            fit: BoxFit.fitWidth,
            image: AssetImage("assets/images/paths/MtoL.jpg")),
        Learningpathtileleft(onTileClicked: theoryCallback, icon: iconCirlceEx),
        Spacer(),
        //RowExercise(exercise_1: _exercises[0], exercise_2: _exercises[1]),
        //TitleTile(title: "GETALLENLEER"),
        //RowExercise(exercise_1: _exercises[2], exercise_2: _exercises[3]),

        //Button
        //ElevatedButton(onPressed: _routeToAddExercise, child: Icon(Icons.add))
      ]),
    );

    final List _pages = [exercises, AddExercise()];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
