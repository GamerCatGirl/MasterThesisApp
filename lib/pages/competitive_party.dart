import 'dart:async';

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

class CompetitiveParty extends StatefulWidget {
  final String partyName;
  final String user;

  CompetitiveParty({super.key, required this.partyName, required this.user});

  @override
  State<CompetitiveParty> createState() => _CompetitivePartyState();
}

class _CompetitivePartyState extends State<CompetitiveParty> {
  // VARIABLES
  late String partyID;
  late String partyName;

  List<dynamic> exercises = [];
  int amountPlayers = 2;
  int placing = 0;

  int z = 0;
  int breedte = 0;
  int hoogte = 0;
  String image = "";
  String figure = "";

  //ValueNotifier<Map<String, double>> progression = ValueNotifier({});
  Map<String, ValueNotifier<double>> progression = {};

  ValueNotifier<int> yourProgress = ValueNotifier(0);
  double stepSize = 0;

  bool done = false;

  List<StreamSubscription> listeners = [];

  ValueNotifier<bool> loading = ValueNotifier(true);
  ValueNotifier<List<String>> activePlayers = ValueNotifier([]);
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> rankings = [];

  @override
  void dispose() {
    for (var listener in listeners) {
      listener.cancel();
    }
    Database.leaveParty(partyID, widget.user);
    super.dispose();
  }

  void playerInfoChanged(Map<String, dynamic> doc, String user) {
    if (loading.value) {
      var party = doc["party"];
      if (party == partyID) {
        activePlayers.value.add(user);
      }

      if (activePlayers.value.length == amountPlayers) {
        if (exercises.length != 0) {
          setState(() {
            loading.value = false;
          });
        }
      }
    } else {
      //progression view
      double progressPlayer = doc["progress"];
      progression[user]?.value = progressPlayer;

      if (progressPlayer >= 1) {
        if (done) {
          progression.remove(user);
        } else {
          placing += 1;
        }
        rankings.add(user);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    partyID = widget.partyName;
    partyName = widget.partyName;

    if (partyName.contains("%%")) {
      partyName = partyName.replaceAll("%%", " VS ");

      //only 2 players
      List<String> players = partyID.split("%%");
      players.remove(widget.user);
      String opponent = players[0];
      //String
      CollectionReference activeDB = db.collection("activePlayers");
      DocumentReference docRef = activeDB.doc(opponent);
      listeners.add(docRef.snapshots().listen(
        (event) {
          var data = event.data() as Map<String, dynamic>;
          playerInfoChanged(data, opponent);
        },
        onError: (error) => print("Listen failed: $error"),
      ));
    }

    activePlayers.value.add("you");
    Database.joinParty(partyID, widget.user);

    //TODO: get info about match out of database
    Database.getPartyInfo(partyID).then((data) {
      //TODO:
      print(data);

      exercises = data["exercises"] as List<dynamic>;
      stepSize = 1 / exercises.length;

      List<dynamic> players = data["player"] as List<dynamic>;
      amountPlayers = players.length;
      print(players);

      for (String player in players) {
        progression[player] = ValueNotifier(0);
      }

      CollectionReference activeDB = db.collection("activePlayers");

      if (!partyName.contains("%%")) {
        for (var player in players) {
          if (player != widget.user) {
            DocumentReference docRef = activeDB.doc(player);
            listeners.add(docRef.snapshots().listen(
              (event) {
                var data = event.data() as Map<String, dynamic>;
                playerInfoChanged(data, player);
              },
              onError: (error) => print("Listen failed: $error"),
            ));
          }
        }
      }

      setupExercise(yourProgress.value);

      if (activePlayers.value.length == amountPlayers) {
        print(activePlayers.value);
        setState(() {
          loading.value = false;
          progression;
        });
      }
    });
  }

  void setupExercise(int idx) {
    if (idx == exercises.length) {
      return;
    }

    Map<String, dynamic> exercise = exercises[idx];
    figure = exercise["figure"];
    image = exercise["image"];

    if (figure == "rechthoek") {
      z = exercise["lengte"];
      breedte = exercise["breedte"];
    } else if (figure == "vierkant") {
      z = exercise["z"];
    } else if (figure == "cirkel") {
      z = exercise["straal"];
    } else if (figure == "driehoek") {
      z = exercise["basis"];
      hoogte = exercise["hoogte"];
    }
  }

  void exerciseSolved() {
    int newProgress = yourProgress.value + 1;
    int amountExercises = exercises.length;
    //
    double progress = 1 / amountExercises * newProgress;

    progression[widget.user]?.value = progress;
    print(progress);
    Database.updateProgress(widget.user, progress);

    setupExercise(newProgress);
    yourProgress.value = newProgress;

    //TODO: Ranking
    if (newProgress == amountExercises) {
      progression.remove(widget.user);
      setState(() {
        placing += 1;
        done = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var title = Center(child: Header(title: partyName));

    var loadingPage = Column(
      children: [
        Text("Aan het wachten op de spelers..."),
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

    return //Scaffold( body:
        ListView(
      children: [title, body],
    ); //);
  }
}
