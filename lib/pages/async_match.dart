import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/Utils/elo.dart';
import 'package:mathapp/Utils/redirections.dart';
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
  Map<String, dynamic> exercises = {};
  int amountPlayers = 2;
  int placing = 0;

  int z = 0;
  int breedte = 0;
  int hoogte = 0;
  String image = "";
  String figure = "";

  Timer? stopWatch;

  Map<String, List> exercisesMade = {
    "vierkant": [],
    "rechthoek": [],
    "cirkel": [],
    "driehoek": []
  };
  List<dynamic> exercisesToMake = [];

  int updateOpponent = 0;
  int updateYou = 0;

  Map<String, dynamic> botsShowFormule = {};
  Map<String, dynamic> bots = {};

  Map<String, dynamic> elos = {};

  Map<String, ValueNotifier<double>> progression = {};

  ValueNotifier<int> yourProgress = ValueNotifier(0);
  double stepSize = 0;

  bool done = false;
  String winner = "";
  bool showFormule = false;
  bool botsInit = false;
  bool matchInit = false;

  int seconds = 0;

  ValueNotifier<bool> loading = ValueNotifier(true);
  ValueNotifier<List<String>> activePlayers = ValueNotifier([]);
  FirebaseFirestore db = FirebaseFirestore.instance;

  String error = "";

  void startTimer() {
    stopWatch = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds++;
      int prevTime = 0;

      for (int i = 0; i < 10; i++) {
        int timeTook = exercisesToMake[i]["tookTime"];
        prevTime += timeTook;

        if (prevTime == seconds) {
          progression[widget.opponent]?.value += 0.1;
        }
      } // This now properly updates the UI
    });
  }

  void stopTimer() {}

  void newExercise() {
    int idx = yourProgress.value;

    Map<String, dynamic> ex = exercisesToMake[idx];

    figure = ex["figure"];
    showFormule = ex["showFormule"];
    image = ex["image"];

    if (figure == "vierkant") {
      z = ex["z"];
    } else if (figure == "rechthoek") {
      z = ex["lengte"];
      breedte = ex["breedte"];
    } else if (figure == "driehoek") {
      z = ex["basis"];
      hoogte = ex["hoogte"];
    } else if (figure == "cirkel") {
      z = ex["straal"];
    }

    if (loading.value) {
      startTimer();
      loading.value = false;
    }
  }

  void setupAllExercises() {
    for (var i = 0; i < 10; i++) {
      int randomIDX = 0;
      if (widget.selectedSkills.length > 2) {
        randomIDX = Random().nextInt(widget.selectedSkills.length);
      }
      String skill = widget.selectedSkills[randomIDX];

      var exs = exercises[skill];
      int randomIDX2 = Random().nextInt(exs.length);

      var ex = exs[randomIDX2].data();

      ex["figure"] = skill;

      ex["showFormule"] = botsShowFormule[skill];

      exercisesToMake.add(ex);
    }
    newExercise();
  }

  void postAllToDB() {
    //loading.value = true;
    throw ArgumentError("TODO: post info to DB");
  }

  void announceWinner() {
    String opponent = widget.opponent;
    String you = widget.user;
    double progressOpp = progression[opponent]!.value;

    setState(() {
      winner = (progressOpp == 1) ? opponent : you;
      done = true;
    });
  }

  void updateElo(int yourTime) {
    var elo = elos[figure];
    var bot = bots[figure];

    var keyFigure =
        "Speed-" + figure.substring(0, 1).toUpperCase() + figure.substring(1);
    var botTime = bot[keyFigure];

    var eloBot = bot["elo"];
    var eloYou = elo["elo"];
    var t = elo["t"];

    bool won = true;
    double accuracySpeed = 1;

    if (botTime < yourTime) {
      won = false;
      accuracySpeed = botTime / yourTime;
    }

    var newElo = Elo.updateElo(eloYou, eloBot, won, t, accuracySpeed);
    elo["elo"] = newElo[0];
    elo["t"] = newElo[1];
  }

  void exerciseSolved() {
    yourProgress.value += 1;
    progression[widget.user]?.value += 0.1;

    int tookTime = seconds - updateYou;
    updateYou = seconds;

    // update elo
    updateElo(tookTime);

    var time = DateTime.now();
    var doc = {
      "showFormule": showFormule,
      "timeStamp": time,
      "image": image,
      "user": widget.user,
      "tookTime": tookTime,
      "figure": figure,
      "playedAgainst": widget.opponent,
      "elo": 1500,
    };

    if (figure == "vierkant") {
      doc["z"] = z;
    } else if (figure == "rechthoek") {
      doc["lengte"] = z;
      doc["breedte"] = breedte;
    } else if (figure == "driehoek") {
      doc["basis"] = z;
      doc["hoogte"] = hoogte;
    } else if (figure == "cirkel") {
      doc["straal"] = z;
    }

    exercisesMade[figure]?.add(doc);

    if (yourProgress.value == 10) {
      // save all info
      postAllToDB();
      announceWinner();
    } else {
      // generate new exercise
      newExercise();
    }
  }

  void generateExercise(String skill, Map<String, dynamic> botsInfo) {
    Map<String, dynamic> doc = {};

    Map<String, dynamic> botInfo = botsInfo[skill];
    String botName = "Bot" + botInfo["elo"].toString();

    doc["user"] = botName;
    doc["figure"] = skill;
    doc["showFormule"] = botInfo["showFormule"];
    doc["elo"] = botInfo["elo"];

    String speed =
        "Speed-" + skill.substring(0, 1).toUpperCase() + skill.substring(1);
    doc["tookTime"] = botInfo[speed];

    //image
    String? path = Consts.paths[skill];
    List? images = Consts.images[skill];

    if (path != null && images != null) {
      int maxIDX = images.length;
      int idx = Random().nextInt(maxIDX);
      String image = path + images[idx];
      doc["image"] = image;
    }

    if (skill == "vierkant") {
      doc["z"] = Random().nextInt(11) + 1;
    } else if (skill == "rechthoek") {
      doc["breedte"] = Random().nextInt(11) + 1;
      doc["lengte"] = Random().nextInt(11) + 1;
    } else if (skill == "driehoek") {
      doc["basis"] = Random().nextInt(11) + 1;
      doc["hoogte"] = Random().nextInt(11) + 1;
    } else if (skill == "cirkel") {
      doc["straal"] = Random().nextInt(11) + 1;
    }
    exercisesToMake.add(doc);
  }

  void generateExercisesBot(Map<String, dynamic> botsInfo, double sumWeigth) {
    var amounts = {};
    int total = 0;

    int minEx = 10;
    String minExSkill = "";
    for (var skill in widget.selectedSkills) {
      var botInfo = botsInfo[skill];
      double weigth = 1 / botInfo["elo"];
      double amount = (weigth / sumWeigth) * 10;
      total += amount.round();

      amounts[skill] = amount.round();

      if (amount.round() < minEx) {
        minEx = amount.round();
        minExSkill = skill;
      }
    }
    if (total != 10) {
      var toAdd = 10 - total;
      var oldAm = amounts[minExSkill];
      var newAm = oldAm + toAdd;
      amounts[minExSkill] = newAm;
    }

    List<String> skillsToChoseFrom = widget.selectedSkills.toList();
    for (var i = 0; i < 10; i++) {
      int maxIDX = skillsToChoseFrom.length;
      int idx = Random().nextInt(maxIDX);
      String skill = skillsToChoseFrom[idx];

      amounts[skill] -= 1;
      if (amounts[skill] == 0) {
        skillsToChoseFrom.remove(skill);
      }

      generateExercise(skill, botsInfo);
    }
  }

  @override
  void initState() {
    super.initState();

    progression[widget.user] = ValueNotifier(0);
    progression[widget.opponent] = ValueNotifier(0);

    //get elo current player
    Database.getEloAndT(widget.user).then((res) {
      elos["vierkant"] = res[0];
      elos["rechthoek"] = res[2];
      elos["cirkel"] = res[1];
      elos["driehoek"] = res[3];

      List<String> botsNames = [];

      //get matches of matching player
      for (var skill in widget.selectedSkills) {
        //TODO: check if skill is not all or recommended!

        //TODO: check if formule needs to be displayed!

        int elo = elos[skill]["elo"];

        String bot = Consts.getClosetsBot(elo);

        botsShowFormule[skill] = bot;
        botsNames.add(bot);

        if (widget.opponent != "Bot") {
          Database.getMatches(widget.opponent, skill, elo).then((res) {
            if (res is String) {
              error = res;
            } else {
              exercises[skill] = res;
            }

            if (widget.selectedSkills.indexOf(skill) ==
                widget.selectedSkills.length - 1) {
              if (botsInit) {
                setupAllExercises();
              } else {
                matchInit = true;
              }
            }
          });
        } else {
          if (widget.selectedSkills.indexOf(skill) ==
              widget.selectedSkills.length - 1) {
            if (botsInit) {
              newExercise();
            } else {
              matchInit = true;
            }
          }
        }
      }

      Database.getSpeedBots(botsNames).then((res) {
        //Map<String, dynamic> bots = {};
        double sumWeigth = 0;
        for (var skill in widget.selectedSkills) {
          var botName = botsShowFormule[skill];

          var botInfo = res[botName];
          bool showFormuleFigure = botInfo["showFormule"];

          String eloBotStr = botName.substring(3);
          int elo = int.parse(eloBotStr);
          botInfo["elo"] = elo;
          sumWeigth += 1 / elo;

          bots[skill] = botInfo;

          botsShowFormule[skill] = showFormuleFigure;
        }

        if (widget.opponent == "Bot") {
          generateExercisesBot(bots, sumWeigth);
        }

        if (matchInit == true) {
          if (widget.opponent != "Bot") {
            setupAllExercises();
          } else {
            newExercise();
          }
        } else {
          botsInit = true;
        }
      });
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
              showFormule: showFormule,
              z: z,
              b: breedte,
              h: hoogte,
              currentExercise: value + 1,
              amountExercises: 10,
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

    Widget body = ValueListenableBuilder(
        valueListenable: loading,
        builder: (context, value, child) => value ? loadingPage : exerciseBody);

    if (done) {
      body = Column(
        children: [Text("Winner: " + winner)],
      );
    }

    return Scaffold(
        body: ListView(
      children: [title, body],
    ));
  }
}
