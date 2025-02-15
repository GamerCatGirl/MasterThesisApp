import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathapp/components/learningPathTile.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/add_exercise.dart';
import 'package:mathapp/pages/conversion_theory.dart';
import 'package:mathapp/pages/meetkunde_ex.dart';
import 'package:mathapp/pages/oppervlakte_theory.dart';
import 'package:mathapp/pages/figure_theory.dart';

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
  FirebaseFirestore db = FirebaseFirestore.instance;

  void _routeToAddExercise() {
    //TODO
    setState(() {
      selectedPage = 1;
    });
  }

  @override
  void initState() {
    super.initState();
    print(widget.path);
    print(widget.pathCompletion);
    //update db?
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

  void makeCompEx() {
    //todo: add user
    //todo: add component
    //todo: elo current player
    //todo: matchID for link?

    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => FigureTheory(
              amountExercises: 10,
              opponent: "bot1",
            )));
  }

  void vierkantCallback() {
    //TODO: get all possible values needed from database to get custom exercises
    CollectionReference dbUsers = db.collection("users");

    dbUsers.doc(widget.username).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      //TODO get needed info

      var figureRemember = document['figuur-vierkant-remember'];
      var oppervlakteRemember = document['oppervlakte-vierkant-remember'];

      var oppervlakteApply = {
        "pknow": document['pknow'],
        "plearn": document['plearn']
      };

      if (document['oppervlakte-vierkant-apply'] != null) {
        //TODO:
        oppervlakteApply = document['oppervlakte-vierkant-apply'];
      }

      var eloVierkant = 2800 * oppervlakteApply['pknow'];
      var eloSpeed = 1500;

      if (document['elo-vierkant'] != null) {
        //TODO:
        eloVierkant = document['elo-vierkant'];
      }

      if (document['elo-speed'] != null) {
        //TODO:
        eloVierkant = document['elo-speed'];
      }

      makeCompEx();
    });
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

    void addCustoms() {
      List<dynamic> path = widget.path;
      List<dynamic> pathCompletion = widget.pathCompletion;
      List<Widget> pathTiles = [leftToMid, midToRight, rightToMid, midToLeft];
      List<String> positions = ["left", "mid", "right", "mid"];
      int current = 0;
      int currentTiles = 0;
      int indexCompleted = 0;

      path.forEach((element) {
        var completed = pathCompletion[current] as bool;
        var position = positions[currentTiles];
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
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
        } else if (element == "vierkant") {
          var vierkant = Learningpathtile(
            onTileClicked: vierkantCallback,
            icon: iconVierkantEx,
            position: position,
            completed: completed,
            enabeled: enabeled,
            userID: widget.username,
          );
          pathWidgets.add(vierkant);
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
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
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
        } else if (element == "rechthoek") {
          var rechthoek = Learningpathtile(
            onTileClicked: theoryCallback,
            icon: iconRectangle,
            position: position,
            completed: completed,
            enabeled: enabeled,
            userID: widget.username,
          );
          pathWidgets.add(rechthoek);
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
        } else if (element == "driehoek") {
          var driehoek = Learningpathtile(
            onTileClicked: theoryCallback,
            icon: iconTriangleEx,
            position: position,
            completed: completed,
            enabeled: enabeled,
            userID: widget.username,
          );
          pathWidgets.add(driehoek);
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
        }
        if (currentTiles > 3) {
          currentTiles = 0;
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
