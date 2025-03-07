import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/Utils/elo.dart';
import 'package:mathapp/Utils/redirections.dart';
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
  final String exerciseName;

  const FigureTheory(
      {super.key,
      required this.user,
      required this.amountExercises,
      required this.exerciseName,
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

  List<dynamic> path = [];
  List<dynamic> pathCompletion = [];

  List<String> imagesVierkant = Consts.imagesVierkant;
  List<String> imagesCirkel = Consts.imagesCirkel;
  List<String> imagesRechthoek = Consts.imagesRechthoek;
  List<String> imagesDriehoek = Consts.imagesDriehoek;
  List<String> imagesCombined = Consts.imagesCombined;

  List<dynamic> harderExercises = [];
  List<dynamic> easierExercises = [];

  List<dynamic> generatedToPost = [];

  String image = "assets/images/Vierkant_Easy.jpg";
  String figure = "vierkant";
  int eloExercise = 0;
  double tExercise = Elo.initT;
  String idExercise = "";
  bool generated = false;
  int exerciseTook = 0;
  int z = 2;
  int hoogte = 0;
  int breedte = 0;
  int speed = 10;
  double speedInterval = 0.5;
  bool showFormule = false;
  ValueNotifier<bool> completed = ValueNotifier(false);
  ValueNotifier<bool> won = ValueNotifier(false);

  //TODO: save progression
  //TODO: ex: db and id
  //TODO: ex: [10, 20, 40, 30, ....]

  //TODO: rebuild after callback!

  List<dynamic>? generatedPlayed;
  int elo = Elo.initElo;
  double t = Elo.initT;
  double? eloOpponent;
  double? tOpponent;

  bool foundLower = false;
  bool foundHigher = false;
  bool wonCurrent = false;

  int timeLastEx = 0;

  List<int> speeds = [];
  ValueNotifier<bool> startExercise = ValueNotifier(false);

  Map<String, dynamic> generatedPlayedGenaral = {};

  var elos = {};

  void generateSpeedInfo() {
    var document;
    for (document in easierExercises) {
      var data = document.data() as Map<String, dynamic>;
      var speedMaybe = data['speed'];
      speeds.add(speedMaybe as int);
    }
    for (document in harderExercises) {
      var data = document.data() as Map<String, dynamic>;
      var speedMaybe = data['speed'];
      speeds.add(speedMaybe as int);
    }

    speeds.sort();
  }

  void generateExercisesBot() {
    //get exercises already played
    if (figure == "combined") {
    } else {}
    String exerciseID = "oppervlakte-" + widget.skills.join("-");
    String tableID = "generated-" + exerciseID;

    CollectionReference dbComp = db.collection("exercises");
    CollectionReference dbEx = db.collection(tableID);

    dbComp.doc(widget.user).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      elos = document['elo'] as Map<String, dynamic>;
      generatedPlayedGenaral =
          document['generatedPlayed'] as Map<String, dynamic>;

      var alreadyPlayed = generatedPlayedGenaral[exerciseID];
      var eloInfo = elos[exerciseID];

      if (alreadyPlayed != null) {
        generatedPlayed = alreadyPlayed;
      } else {
        generatedPlayed = [];
        generatedPlayedGenaral[exerciseID] = [];
      }

      if (eloInfo != null) {
        elo = eloInfo["elo"];
        t = eloInfo["t"];
      } else {
        elo = Elo.initElo;
        t = Elo.initT;
      }

      //look if there are exercises for current user to play against
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
          generateSpeedInfo();
          newExercise();
          startTimer();
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
          generateSpeedInfo();
          newExercise();
          startTimer();
          startExercise.value = true;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    figure = widget.exerciseName;

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

    CollectionReference dbUser = db.collection("users");
    dbUser.doc(widget.user).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      path = document['path'];
      pathCompletion = document['pathCompletion'];
    });
  }

  void generateExercise() {
    //TODO: make more general now just vierkant
    int maxIDX = imagesVierkant.length;
    int idx = Random().nextInt(maxIDX);
    String imageChosen = imagesVierkant[idx];
    String pathImage = "assets/images/vierkant/";

    if (figure == "cirkel") {
      maxIDX = imagesCirkel.length;
      idx = Random().nextInt(maxIDX);
      imageChosen = imagesCirkel[idx];
      pathImage = "assets/images/cirkel/";
      //TODO: give more time per exercise, need calculator!!!!
    } else if (figure == "rechthoek") {
      maxIDX = imagesRechthoek.length;
      idx = Random().nextInt(maxIDX);
      imageChosen = imagesRechthoek[idx];
      pathImage = "assets/images/rechthoek/";
      breedte = Random().nextInt(Consts().maxMultiplyByHead + 1);
    } else if (figure == "driehoek") {
      maxIDX = imagesDriehoek.length;
      idx = Random().nextInt(maxIDX);
      imageChosen = imagesDriehoek[idx];
      pathImage = "assets/images/driehoek/";
      hoogte = Random().nextInt(Consts().maxMultiplyByHead + 1);
    } else if (figure == "combined") {
      maxIDX = imagesCombined.length;
      idx = Random().nextInt(
          maxIDX); //TODO: length of vect of combined exercises determines speed/elo
      imageChosen = imagesCombined[idx];
      pathImage = "assets/images/combined-figures/";

      hoogte = Random().nextInt(Consts().maxMultiplyByHead + 1);
      breedte = Random().nextInt(Consts().maxMultiplyByHead + 1);
    }

    image = pathImage + imageChosen;
    z = Random()
        .nextInt(Consts().maxMultiplyByHead + 1); //TODO: hou rekening met elo
    speed = Random().nextInt(16) +
        2; //tussen 5 en 20 seconden //TODO: hou rekening met elo
    generated = true;
    eloExercise = elo.floor();
    return;
  }

  void newExercise() {
    bool easierExercise = Random().nextBool();
    List<dynamic> toChooseFrom =
        easierExercise ? easierExercises : harderExercises;

    int amountToChooseFrom = toChooseFrom.length;

    if (amountToChooseFrom == 0) {
      //make new exercise
      generateExercise();
      return;
    }
    generated = false;
    int randomExerciseIdx = Random().nextInt(amountToChooseFrom);

    var doc = toChooseFrom[randomExerciseIdx];
    var idExercise = doc.id;
    //TODO:
    //generatedPlayed?.map(
    //    (e) => {print("check if player has not already had this ex before")});

    var data = doc.data();

    image = data['image'];
    eloExercise = data['elo'];
    z = data['z'];
    speed = data['speed'];

    toChooseFrom.remove(doc);
  }

  void announceWinner() {
    print("Announcing a winner :)");
    print(generatedToPost);
    //TODO: post generated exercises
    WriteBatch batch = FirebaseFirestore.instance.batch();
    String exerciseID = "oppervlakte-" + widget.skills.join("-");
    String tableID = "generated-" + exerciseID;

    CollectionReference dbComp = db.collection(tableID);

    for (var data in generatedToPost) {
      DocumentReference reference = dbComp.doc();
      //see if you can id's of the matches
      generatedPlayed?.add(reference.id);

      batch.set(reference, data);
    }

    batch.commit();

    //update Info of the match
    var skillString = "oppervlakte-" + widget.skills.join("-");

    var idxPath = path.indexOf(widget.exerciseName);
    pathCompletion[idxPath] = true;

    generatedPlayedGenaral[skillString] = generatedPlayed;

    CollectionReference dbUser = db.collection("users");
    dbUser
        .doc(widget.user)
        .set({"pathCompletion": pathCompletion}, SetOptions(merge: true));

    //post to DB
    //post matchIDs played

    CollectionReference dbEx = db.collection("exercises");

    elos[skillString] = {"elo": elo, "t": t};

    dbEx.doc(widget.user).set(
        {"elo": elos, "generatedPlayed": generatedPlayedGenaral},
        SetOptions(merge: true));

    if (opponentProgress.value > ownProgress.value) {
      won.value = false;
    } else {
      won.value = true;
    }
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

        /*
        if (ownProgress.value == widget.amountExercises) {
          announceWinner();
          stopWatch?.cancel();
          completed.value = true;
        }
        */
      }
    });
  }

  void updateElo() {
    //TODO:
    print(elo);
    print(eloExercise);

    //TODO: how long did my exercise take?
    int time = seconds.value;
    exerciseTook = time - timeLastEx;
    timeLastEx = time;

    print(exerciseTook);
    speeds.add(exerciseTook);
    speeds.sort();

    if (exerciseTook > speed) {
      wonCurrent = false;
    } else {
      wonCurrent = true;
    }

    int current = speeds.indexOf(exerciseTook) + 1;
    int totalSpeeds = speeds.length;

    speedInterval = current / totalSpeeds;

    List<dynamic> newInfo =
        Elo.updateElo(elo, eloExercise, wonCurrent, t, speedInterval);

    print(newInfo);
    elo = newInfo[0];
    t = newInfo[1];

    speeds.add(speed);
    speeds.sort();

    current = speeds.indexOf(speed) + 1;
    totalSpeeds = speeds.length;

    List<dynamic> newInfoExercise =
        Elo.updateElo(1500, elo, !wonCurrent, tExercise, current / totalSpeeds);
    //speeds.reduce(combine)
    speeds.removeAt(current - 1);

    // update directly if exercise was already existing
    //(chances exist that some writes get lost when the whole class is playing at the same time)

    if (generated) {
      //TODO: also post timeStamp to see progression over time
      var newDoc = {
        'elo': newInfoExercise[0],
        't': newInfoExercise[1],
        'image': image,
        'speed': speed,
        'z': z,
        'showFormule': true,
      };

      //TODO: setup page for teacher to see engagement!

      if (widget.exerciseName == "cirkel") {
        newDoc['straal'] = z;
      } else if (widget.exerciseName == "rechthoek") {
        newDoc['lengte'] = z;
        newDoc['breedte'] = breedte;
      } else if (widget.exerciseName == "driehoek") {
        newDoc['basis'] = z;
        newDoc['hoogte'] = hoogte;
      }

      generatedToPost.add(newDoc);
    } else {
      //TODO: update directly
    }
  }

  void exerciseSolved() {
    //update Elo
    updateElo();

    //TODO: lastWon?

    newExercise();

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
      stopWatch?.cancel();
      completed.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var winner = SizedBox(width: 100, child: Text("Gewonnen"));
    var loser = SizedBox(width: 100, child: Text("Verloren"));

    var viewAnswersButton =
        ElevatedButton(onPressed: () {}, child: Text("Bekijk mijn oefeningen"));
    var viewProgressButton = ElevatedButton(
        onPressed: () {}, child: Text("Bekijk mijn vooruitgang!"));
    var learningPathButton = ElevatedButton(
        onPressed: () {
          Functions()
              .toLearningPatch(widget.user, path, pathCompletion, context);
        },
        child: Text("Ga terug naar leerpad!"));

    var loading = Column(
      children: [
        Spacer(),
        Text("Finding opponent ..."),
        LoadingAnimationWidget.threeRotatingDots(
            color: Colors.purple, size: 200),
        Spacer()
      ],
    );

    var done = Column(
      children: [
        Spacer(),
        ValueListenableBuilder(
            valueListenable: won,
            builder: (context, value, child) => value ? winner : loser),
        SizedBox(
          height: 200,
          child: viewAnswersButton,
        ),
        SizedBox(
          height: 200,
          child: viewProgressButton,
        ),
        SizedBox(
          height: 200,
          child: learningPathButton,
        ),
        Spacer(),
      ],
    );

    var exercisesOrLoading = ValueListenableBuilder(
        valueListenable: startExercise,
        builder: (context, value, child) {
          var exercise = ListView(
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
                        b: breedte,
                        h: hoogte,
                        currentExercise: value + 1,
                        amountExercises: 10,
                        image: image,
                        figure: figure,
                        callback: exerciseSolved);
                  }),
              Spacer(),
            ],
          );
          if (value) {
            return exercise;
          } else {
            return loading;
          }
        });

    return Scaffold(
        body: Center(
            child: ValueListenableBuilder(
                valueListenable: completed,
                builder: (context, value, child) =>
                    value ? done : exercisesOrLoading)));
  }
}
