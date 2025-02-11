import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathapp/components/learningPathTile.dart';
import 'package:mathapp/components/learningPathTileLeft.dart';
import 'package:mathapp/components/learningPathTileMid.dart';
import 'package:mathapp/components/learningPathTileRight.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/add_exercise.dart';
import 'package:mathapp/pages/conversion_theory.dart';
import 'package:mathapp/pages/oppervlakte_theory.dart';
import 'package:mathapp/pages/square_theory.dart';

//TODO: add floating add button

class LearningPath extends StatefulWidget {
  final String username;
  final List<dynamic> path;
  final List<dynamic> pathCompletion;

  const LearningPath(
      {super.key,
      required this.username,
      required this.path,
      required this.pathCompletion});

  @override
  State<LearningPath> createState() => _LearningPathState();
}

class _LearningPathState extends State<LearningPath> {
  int selectedPage = 0;
  bool theoryDoneOppervlakte = false;

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

  void theoryCallback() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OppervlakteTheory(
          done: () {},
          solved: theoryDoneOppervlakte,
          user: widget.username,
          path: widget.path,
          pathCompletion: widget.pathCompletion,
        ),
      ),
    );
  }

  void conversionCallback() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ConversionTheory(done: () {}),
      ),
    );
  }

  final leftToMid = Image(
      fit: BoxFit.fitWidth, image: AssetImage("assets/images/paths/LtoM.jpg"));

  final midToRight = Image(
      fit: BoxFit.fitWidth, image: AssetImage("assets/images/paths/MtoR.jpg"));

  final rightToMid = Image(
      fit: BoxFit.fitWidth, image: AssetImage("assets/images/paths/RtoM.jpg"));

  final midToLeft = Image(
      fit: BoxFit.fitWidth, image: AssetImage("assets/images/paths/MtoL.jpg"));

  @override
  Widget build(BuildContext context) {
    List<Widget> pathWidgets = [
      Header(title: "H5: Oppervlakte"),
      Text("Leerpad van " + widget.username),
    ];

    //final vierkant = Learningpathtilemid(
    //    onTileClicked: theoryCallback, icon: iconVierkantEx);

    //final cirkel = Learningpathtileright(
    //    onTileClicked: theoryCallback, icon: iconCirlceEx);

    void addCustoms() {
      List<dynamic> path = widget.path;
      List<dynamic> pathCompletion = widget.pathCompletion;
      List<Widget> pathTiles = [leftToMid, midToRight, rightToMid, midToLeft];
      List<String> positions = ["left", "mid", "right", "mid"];
      int current = 0;
      int indexCompleted = 0;

      path.forEach((element) {
        var completed = pathCompletion[current] as bool;
        var position = positions[current];
        var enabeled = true;

        if (indexCompleted < current) {
          enabeled = false;
        }

        if (element == "oppervlakte") {
          theoryDoneOppervlakte = completed;
          var oppervlakte = Learningpathtile(
              onTileClicked: theoryCallback,
              position: position,
              icon: theory,
              completed: completed,
              enabeled: enabeled,
              userID: widget.username);
          pathWidgets.add(oppervlakte);
          pathWidgets.add(pathTiles[current]);
          current += 1;
        } else if (element == "vierkant") {
          var vierkant = Learningpathtile(
            onTileClicked: theoryCallback,
            icon: iconVierkantEx,
            position: position,
            completed: completed,
            enabeled: enabeled,
            userID: widget.username,
          );
          pathWidgets.add(vierkant);
          pathWidgets.add(pathTiles[current]);
          current += 1;
        } else if (element == "cirkel") {
          var cirkel = Learningpathtile(
            onTileClicked: theoryCallback,
            icon: iconCirlceEx,
            position: position,
            completed: completed,
            enabeled: enabeled,
            userID: widget.username,
          );
          pathWidgets.add(cirkel);
          pathWidgets.add(pathTiles[current]);
          current += 1;
        }
        if (current > 3) {
          current = 0;
        }
        if (completed) {
          indexCompleted += 1;
        }
      });

      pathWidgets.removeLast();
    }

    addCustoms();

    // TODO: implement build
    /*
    final ListView exercisesOld = ListView(children: [
      // SUBDIVISION
      Header(title: "H5: Oppervlakte"),
      Text("Leerpad van " + widget.username),
      oppervlakte,
      leftToMid,
      vierkant,
      midToRight,
      Learningpathtileright(
          onTileClicked: conversionCallback, icon: iconOppervlakte),
      rightToMid,
      Learningpathtilemid(onTileClicked: theoryCallback, icon: iconTriangleEx),
      midToLeft,
      Learningpathtileleft(onTileClicked: theoryCallback, icon: iconCirlceEx),
    ]); */

    final ListView exercises = ListView(
      children: pathWidgets,
    );

    final List _pages = [exercises, AddExercise()];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
