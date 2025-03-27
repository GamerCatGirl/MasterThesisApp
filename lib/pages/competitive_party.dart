import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/Utils/elo.dart';
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
  final VoidCallback done;

  CompetitiveParty(
      {super.key,
      required this.partyName,
      required this.user,
      required this.done});

  @override
  State<CompetitiveParty> createState() => _CompetitivePartyState();
}

class _CompetitivePartyState extends State<CompetitiveParty> {
  // VARIABLES
  late String partyID;
  late String partyName;

  DateTime startTime = DateTime.now();

  Map<String, List> tProgression = {
    "vierkant": [],
    "rechthoek": [],
    "cirkel": [],
    "driehoek": []
  };

  Map<String, List> eloProgression = {
    "vierkant": [],
    "rechthoek": [],
    "cirkel": [],
    "driehoek": []
  };

  List<dynamic> exercises = [];
  int amountPlayers = 2;
  int placing = 0;
  int seed = Random().nextInt(1000000000);

  int seconds = 0;

  void updateSeconds() {
    seconds += 1;
  }

  late Timer stopWatch;

  int z = 0;
  int breedte = 0;
  int hoogte = 0;
  String image = "";
  String figure = "";
  bool showFormule = true;
  bool conversion = true; //TODO: dynamic ajust

  //ValueNotifier<Map<String, double>> progression = ValueNotifier({});
  Map<String, ValueNotifier<double>> progression = {};

  ValueNotifier<int> yourProgress = ValueNotifier(0);
  double stepSize = 0;

  Map<String, dynamic> yourElo = {};
  Map bots = {};

  bool done = false;

  List<StreamSubscription> listeners = [];

  ValueNotifier<bool> loading = ValueNotifier(true);
  ValueNotifier<List<String>> activePlayers = ValueNotifier([]);
  FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> updatedUsers = [];

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

      //TODO: if progression player to 0 -> delete from party! (left)

      //TODO: if one player finished delete party?? (later never accesed normally)

      if (progressPlayer >= 1) {
        if (done) {
          progression.remove(user);
        } else if (!updatedUsers.contains(user)) {
          updatedUsers.add(user);
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

    stopWatch = Timer.periodic(Duration(seconds: 1), (timer) {
      updateSeconds();
    });

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

    Database.getEloAndT(widget.user).then((res) {
      yourElo["vierkant"] = res[0];
      yourElo["cirkel"] = res[1];
      yourElo["rechthoek"] = res[2];
      yourElo["driehoek"] = res[3];
      yourElo["conversion"] = res[4];
    });

    Database.getAllBots().then((res) {
      bots = res;
    });

    activePlayers.value.add("you");
    Database.joinParty(partyID, widget.user);

    Database.getPartyInfo(partyID).then((data) {
      exercises = data["exercises"] as List<dynamic>;
      stepSize = 1 / exercises.length;

      List<dynamic> players = data["player"] as List<dynamic>;
      amountPlayers = players.length;

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

    if (!yourElo.isEmpty && !bots.isEmpty) {
      var eloAndTFigure = yourElo[figure];
      var eloFigure = eloAndTFigure["elo"];
      String bot = Consts.getClosetsBot(eloFigure);
      var neededInfoBot = bots[bot];
      showFormule = neededInfoBot["showFormule"];
      conversion = neededInfoBot["conversionUnlocked"];
    }

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

    seconds = 0;
  }

  void exerciseSolved() {
    int newProgress = yourProgress.value + 1;
    int amountExercises = exercises.length;
    //
    double progress = 1 / amountExercises * newProgress;

    progression[widget.user]?.value = progress;
    Database.updateProgress(widget.user, progress);

    var eloAndT = yourElo[figure];
    var elo = eloAndT["elo"];
    var t = eloAndT["t"];
    String botName = Consts.getClosetsBot(elo);
    var bot = bots[botName];
    var key =
        "Speed-" + figure.substring(0, 1).toUpperCase() + figure.substring(1);
    var eloBotStr = botName.substring(3);
    var eloBot = int.parse(eloBotStr);
    var speedBot = bot[key];
    var yourSpeed = seconds;
    var won = !(speedBot < yourSpeed);
    var accuracy = won ? 1 : speedBot / yourSpeed;
    var newElo =
        Elo.updateElo(elo, eloBot, !(speedBot < yourSpeed), t, accuracy);

    eloAndT["elo"] = newElo[0];
    eloAndT["t"] = newElo[1];

    if (eloProgression.containsKey(figure)) {
      eloProgression[figure]!.add(newElo[0]);
      tProgression[figure]!.add(newElo[1]);
    }

    setupExercise(newProgress);
    yourProgress.value = newProgress;

    if (newProgress == amountExercises) {
      progression.remove(widget.user);

      Map<String, List> exercisesToPost = {
        "vierkant": [],
        "rechthoek": [],
        "cirkel": [],
        "driehoek": []
      };
      int id = 0;
      for (var ex in exercises) {
        String fig = ex["figure"];
        String idToPost = partyID + id.toString() + seed.toString();
        exercisesToPost[fig]!.add(idToPost);
        id += 1;
      }

      Database.updateEloAndEx(widget.user, yourElo, exercisesToPost);

      Database.updateProgression(
          widget.user, eloProgression, tProgression, startTime);

      try {
        Database.deleteParty(partyID);
      } catch (e) {
        print("party already deleted");
      }

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
              showFormule: showFormule,
              conversion: conversion,
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

    var duringEx = [title, body];
    var textYourPlace = Center(
      child: Text(
        "Je eindigt op plaats: " + placing.toString(),
        style: TextStyle(fontSize: 20),
      ),
    );
    //var buttonExercise =
    var afterEx = [
      title,
      progressionBars,
      SizedBox(
        height: 20,
      ),
      textYourPlace,
      SizedBox(
        height: 20,
      ),
      Center(
        child: ElevatedButton.icon(
            icon: Icon(Icons.home),
            onPressed: () {
              try {
                Database.leaveParty(partyName, widget.user);
              } catch (e) {
                print("error in leaving party");
              }
              widget.done();
            },
            label: Text("Terug naar oefen pagina!")),
      )
    ];

    var page = done ? afterEx : duringEx;

    return //Scaffold( body:
        ListView(
      children: page,
    ); //);
  }
}
