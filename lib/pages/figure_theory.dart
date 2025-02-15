import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/competitive_ex.dart';
import 'package:mathapp/pages/meetkunde_ex.dart';

class FigureTheory extends StatefulWidget {
  final int amountExercises;
  final String opponent;

  const FigureTheory(
      {super.key, required this.amountExercises, required this.opponent});

  @override
  State<FigureTheory> createState() => new _FigureState();
}

class _FigureState extends State<FigureTheory> {
  ValueNotifier<int> seconds = ValueNotifier(0);
  ValueNotifier<int> ownProgress = ValueNotifier(0);
  ValueNotifier<int> opponentProgress = ValueNotifier(0);
  FirebaseFirestore db = FirebaseFirestore.instance;
  //Color colorBar = Colors.orange;
  ValueNotifier<Color> colorBar = ValueNotifier(Colors.orange);
  Timer? stopWatch;
  bool hasOpponent = false;
  List<dynamic>? progressionOpponent;

  @override
  void initState() {
    super.initState();
    startTimer();

    if (widget.opponent == "") {
      hasOpponent = false;
    } else {
      hasOpponent = true;
    }

    CollectionReference dbComp = db.collection("competition");

    dbComp.doc("eloVec").get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      progressionOpponent = document['progression'] as List<dynamic>;
      print(progressionOpponent);
    });
  }

  void announceWinner() {
    //TODO:
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

    return Scaffold(
        body: Center(
            child: Column(children: [
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
      CompetitiveEx(
          z: 2,
          currentExercise: 1,
          amountExercises: 10,
          image: "assets/images/Vierkant_Easy.jpg",
          figure: 'vierkant',
          callback: exerciseSolved),
      Spacer(),
    ])));
  }
}
