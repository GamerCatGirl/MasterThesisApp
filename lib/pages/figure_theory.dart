import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/Utils/elo.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/competitive_ex.dart';
import 'package:mathapp/pages/meetkunde_ex.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FigureTheory extends StatefulWidget {
  final int amountExercises;
  final String opponent;
  final String user;
  final List<String> skills;
  final bool synced;

  const FigureTheory(
      {super.key,
      required this.user,
      required this.amountExercises,
      required this.opponent,
      required this.synced,
      required this.skills});

  @override
  State<FigureTheory> createState() => new _FigureState();
}

class _FigureState extends State<FigureTheory> {
  ValueNotifier<int> seconds = ValueNotifier(0);
  ValueNotifier<int> ownProgress = ValueNotifier(0);
  ValueNotifier<int> opponentProgress = ValueNotifier(0);
  FirebaseFirestore db = FirebaseFirestore.instance;

  ValueNotifier<Color> colorBar = ValueNotifier(Colors.orange);
  Timer? stopWatch;
  bool hasOpponent = false;
  List<dynamic>? progressionOpponent;

  List<String> imagesVierkant = [];
  List<String> imagesCirkel = [];
  List<String> imagesRechthoek = [];
  List<String> imagesDriehoek = [];

  List<dynamic> harderExercises = [];
  List<dynamic> easierExercises = [];

  String image = "assets/images/Vierkant_Easy.jpg";
  String figure = "vierkant";
  int z = 2;
  bool showFormule = false;

  List<dynamic>? generatedPlayed;
  double elo = Elo.initElo;
  double? t;
  double? eloOpponent;
  double? tOpponent;

  bool foundLower = false;
  bool foundHigher = false;
  ValueNotifier<bool> startExercise = ValueNotifier(false);

  //TODO: finding opponent loading sequence

  void generateExercisesBot() {
    //get exercises already played
    String exerciseID = "oppervlakte-" + widget.skills.join("-");
    String tableID = "generated-" + exerciseID;

    CollectionReference dbComp = db.collection("exercises");
    CollectionReference dbEx = db.collection(tableID);

    dbComp.doc(widget.user).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      var elos = document['elo'] as Map<String, dynamic>;
      var generatedPlayedGenaral =
          document['generatedPlayed'] as Map<String, dynamic>;

      var alreadyPlayed = generatedPlayedGenaral[exerciseID];
      var eloInfo = elos[exerciseID];

      if (alreadyPlayed != null) {
        print(alreadyPlayed.runtimeType);
        generatedPlayed = alreadyPlayed;
      } else {
        generatedPlayed = [];
      }

      if (eloInfo != null) {
        elo = eloInfo["elo"];
        t = eloInfo["t"];
      } else {
        elo = Elo.initElo;
        t = Elo.initT;
      }

      print(elo);
      print(t);

      //TODO: look if there are exercises for current user to play against
      int upperbound = elo.toInt() + Elo.thresholdElo;
      int lowerbound = elo.toInt() - Elo.thresholdElo;
      dbEx
          .where("elo", isGreaterThanOrEqualTo: elo)
          .where("elo", isLessThan: upperbound)
          .orderBy("elo", descending: false)
          .get()
          .then((doc) {
        var docs = doc.docs as List<dynamic>;
        harderExercises = docs;
        foundHigher = true;

        if (foundLower) {
          newExercise();
          startExercise.value = true;
        }
      });

      dbEx
          .where("elo", isLessThan: elo)
          .where("elo", isGreaterThan: lowerbound)
          .orderBy("elo", descending: true)
          .get()
          .then((doc) {
        var docs = doc.docs;
        easierExercises = docs;
        foundLower = true;
        if (foundHigher) {
          newExercise();
          startExercise.value = true;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();

    if (widget.opponent == "") {
      hasOpponent = false;
    } else {
      hasOpponent = true;
    }

    if (widget.opponent == "bot") {
      generateExercisesBot();
    }

    CollectionReference dbComp = db.collection("competition");

    dbComp.doc("eloVec").get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      progressionOpponent = document['progression'] as List<dynamic>;
      print(progressionOpponent);
    });
  }

  void newExercise() {
    //TODO:
  }

  void announceWinner() {
    //TODO: update Elo-skills

    //TODO: update Elo-speed

    //TODO: also update Elo opponent?
  }

  void startTimer() {
    stopWatch = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds.value++; // This now properly updates the UI
      if (hasOpponent &&
          progressionOpponent != null &&
          opponentProgress.value < widget.amountExercises) {
        var update = progressionOpponent?[opponentProgress.value];

        if (update != null && update == seconds.value) {
          opponentProgress.value++;
        }

        if (opponentProgress.value > ownProgress.value) {
          colorBar.value = Colors.red;
        } else if (opponentProgress.value < ownProgress.value) {
          colorBar.value = Colors.green;
        } else {
          colorBar.value = Colors.orange;
        }

        if (opponentProgress.value == widget.amountExercises) {
          announceWinner();
        }
      }
    });
  }

  void exerciseSolved() {
    //TODO: new image

    //TODO: new value for z

    //TODO: new bool to ask for formule?

    //TODO: new skill?

    ownProgress.value++;
    if (hasOpponent) {
      if (opponentProgress.value > ownProgress.value) {
        colorBar.value = Colors.red;
      } else if (opponentProgress.value < ownProgress.value) {
        colorBar.value = Colors.green;
      } else {
        colorBar.value = Colors.orange;
      }
    }
    if (ownProgress.value == widget.amountExercises) {
      announceWinner();
    }
  }

  @override
  Widget build(BuildContext context) {
    var winner = SizedBox(width: 100, child: Text("Gewonnen"));
    var loser = SizedBox(width: 100, child: Text("Verloren"));

    var loading = Column(
      children: [
        Spacer(),
        Text("Finding opponent ..."),
        LoadingAnimationWidget.inkDrop(color: Colors.purple, size: 200),
        Spacer()
      ],
    );

    var exercise = Column(
      children: [
        Text("Oppervlakte"),
        Spacer(),
        ValueListenableBuilder<int>(
          valueListenable: ownProgress,
          builder: (context, value, child) {
            double progress = value / widget.amountExercises;
            return Row(
              children: [
                Spacer(),
                SizedBox(
                  width: 100,
                  child: Text("your progress: "),
                ),
                SizedBox(
                    width: 300,
                    child: ValueListenableBuilder<Color>(
                        valueListenable: colorBar,
                        builder: (context, color, child) {
                          return LinearProgressIndicator(
                            value: progress,
                            color: color,
                          );
                        })),
                Spacer()
              ],
            );
          },
        ),
        hasOpponent
            ? ValueListenableBuilder<int>(
                valueListenable: opponentProgress,
                builder: (context, value, child) {
                  double progress = value / widget.amountExercises;
                  return Row(
                    children: [
                      Spacer(),
                      SizedBox(
                        width: 100,
                        child: Text(widget.opponent + ": "),
                      ),
                      SizedBox(
                        width: 300,
                        child: LinearProgressIndicator(
                          value: progress,
                        ),
                      ),
                      Spacer()
                    ],
                  );
                },
              )
            : Text(''),
        Spacer(),
        ValueListenableBuilder(
            valueListenable: ownProgress,
            builder: (context, value, child) {
              return CompetitiveEx(
                  showFormule: showFormule,
                  z: z,
                  currentExercise: value + 1,
                  amountExercises: 10,
                  image: image,
                  figure: figure,
                  callback: exerciseSolved);
            }),
        Spacer(),
      ],
    );

    return Scaffold(
        body: Center(
            child: ValueListenableBuilder(
                valueListenable: startExercise,
                builder: (context, value, child) =>
                    value ? exercise : loading)));
  }
}
