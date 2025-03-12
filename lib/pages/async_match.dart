import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/pages/competitive_ex.dart';
import 'package:mathapp/pages/exercises.dart';
import 'package:mathapp/pages/home.dart';
import 'package:mathapp/pages/learning_path.dart';
import 'package:mathapp/pages/profile.dart';
import 'package:mathapp/pages/setting.dart';

class AsyncMatch extends StatefulWidget {
  final String opponent;
  final String user;
  final List<String> selectedSkills;

  AsyncMatch(
      {super.key,
      required this.user,
      required this.opponent,
      required this.selectedSkills});

  @override
  State<AsyncMatch> createState() => _CompetitivePartyState();
}

class _CompetitivePartyState extends State<AsyncMatch> {
  late String partyID;
  late String partyName;

  Map<String, dynamic> exercises = {};
  int amountPlayers = 2;
  int placing = 0;

  int z = 0;
  int breedte = 0;
  int hoogte = 0;
  String image = "";
  String figure = "";

  Map<String, dynamic> elos = {};

  //ValueNotifier<Map<String, double>> progression = ValueNotifier({});
  Map<String, ValueNotifier<double>> progression = {};

  ValueNotifier<int> yourProgress = ValueNotifier(0);
  double stepSize = 0;

  bool done = false;

  ValueNotifier<bool> loading = ValueNotifier(true);
  ValueNotifier<List<String>> activePlayers = ValueNotifier([]);
  FirebaseFirestore db = FirebaseFirestore.instance;

  String error = "";

  void newExercise() {}
  void exerciseSolved() {
    //TODO: save info

    //TODO: check if winner

    // generate new exercise
    newExercise();
  }

  @override
  void initState() {
    super.initState();

    //get elo current player
    Database.getEloAndT(widget.user).then((res) {
      elos["vierkant"] = res[0];
      elos["rechthoek"] = res[2];
      elos["cirkel"] = res[1];
      elos["driehoek"] = res[3];

      //get matches of matching player
      for (var skill in widget.selectedSkills) {
        int elo = elos[skill]["elo"];
        Database.getMatches(widget.opponent, skill, elo).then((res) {
          if (res is String) {
            error = res;
          } else {
            exercises[skill] = exercises;
          }

          if (widget.selectedSkills.indexOf(skill) ==
              widget.selectedSkills.length - 1) {
            newExercise();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var title =
        Center(child: Header(title: widget.user + " vs. " + widget.opponent));

    var loadingPage = Column(
      children: [
        Text("Ophalen van de data... Even geduld"),
        LoadingAnimationWidget.threeRotatingDots(
            color: Colors.purple, size: 200),
      ],
    );

    var exercise = ValueListenableBuilder(
        valueListenable: yourProgress,
        builder: (context, value, child) {
          return CompetitiveEx(
              showFormule: true,
              z: z,
              b: breedte,
              h: hoogte,
              currentExercise: value + 1,
              amountExercises: exercises.length,
              image: image,
              figure: figure,
              callback: exerciseSolved);
        });

    var progressionBars = Column(
      children: progression.entries.map((entry) {
        return ValueListenableBuilder(
            valueListenable: entry.value,
            builder: (context, value, child) {
              return Row(children: [
                Spacer(),
                Text(entry.key + ": "),
                SizedBox(
                  width: 300,
                  child: LinearProgressIndicator(
                    value: value,
                    color: Colors.amber,
                  ),
                ),
                Spacer(),
              ]);
            });
      }).toList(),
    );

    var exerciseBody = Column(
      children: [
        progressionBars,
        SizedBox(
          height: 20,
        ),
        exercise
      ],
    );

    var body = ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, value, child) => value ? loadingPage : exerciseBody);

    return Scaffold(
        body: ListView(
      children: [title, body],
    ));
  }
}
