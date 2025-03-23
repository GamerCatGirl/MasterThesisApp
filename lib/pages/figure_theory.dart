import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/Utils/elo.dart';
import 'package:mathapp/Utils/redirections.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title.dart';
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
  final done;

  const FigureTheory(
      {super.key,
      required this.user,
      required this.amountExercises,
      required this.exerciseName,
      required this.opponent,
      required this.synced,
      required this.done,
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

  List<int> progression = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

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
  dynamic showFormule = false;
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

  int eloVierkant = Elo.initElo;
  double tVierkant = Elo.initT;
  bool showFormuleVierkant = true;
  int eloCirkel = Elo.initElo;
  double tCirkel = Elo.initT;
  bool showFormuleCirkel = true;
  int eloDriehoek = Elo.initElo;
  double tDriehoek = Elo.initT;
  bool showFormuleDriehoek = true;
  int eloRechthoek = Elo.initElo;
  double tRechthoek = Elo.initT;
  bool showFormuleRechthoek = true;
  int eloCoversion = Elo.initElo;
  double tConversion = Elo.initT;

  List<String> bots = ["Bot1200", "Bot1500", "Bot1800"];
  List<String> botsVierkant = ["Bot1200", "Bot1500", "Bot1800"];
  List<String> botsRechthoek = ["Bot1200", "Bot1500", "Bot1800"];
  List<String> botsCirkel = ["Bot1200", "Bot1500", "Bot1800"];
  List<String> botsDriehoek = ["Bot1200", "Bot1500", "Bot1800"];

  var botsInfo = {};

  bool foundLower = false;
  bool foundHigher = false;
  bool wonCurrent = false;

  int timeLastEx = 0;

  List<int> speeds = [];
  ValueNotifier<bool> startExercise = ValueNotifier(false);

  Map<String, dynamic> generatedPlayedGenaral = {};

  int updateTime = 0;

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

  void getExistingExercisesBot() {
    String exerciseID = "oppervlakte-" + widget.skills.join("-");
    String tableID = "generated-" + exerciseID;
    CollectionReference dbEx = db.collection(tableID);
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
  }

  void generateExercisesBot() {
    //get exercises already played
    if (figure == "combined") {
      Database.getEloAndT(widget.user).then((var elo) {
        eloVierkant =
            (elo[0]["elo"] != 0) ? elo[0]["elo"].toInt() : Elo.initElo;
        tVierkant = (elo[0]["t"] != 0) ? elo[0]["t"] : Elo.initT;
        botsVierkant = Consts.getBots(eloVierkant);
        eloCirkel = (elo[1]["elo"] != 0) ? elo[1]["elo"].toInt() : Elo.initElo;
        tCirkel = (elo[1]["t"] != 0) ? elo[1]["t"] : Elo.initT;
        botsCirkel = Consts.getBots(eloCirkel);
        eloRechthoek =
            (elo[2]["elo"] != 0) ? elo[2]["elo"].toInt() : Elo.initElo;
        tRechthoek = (elo[2]["t"] != 0) ? elo[2]["t"] : Elo.initT;
        botsRechthoek = Consts.getBots(eloRechthoek);
        eloDriehoek =
            (elo[3]["elo"] != 0) ? elo[3]["elo"].toInt() : Elo.initElo;
        tDriehoek = (elo[3]["t"] != 0) ? elo[3]["t"] : Elo.initT;
        botsDriehoek = Consts.getBots(eloDriehoek);
        eloCoversion =
            (elo[4]["elo"] != 0) ? elo[4]["elo"].toInt() : Elo.initElo;
        tConversion = (elo[4]["t"] != 0) ? elo[4]["t"] : Elo.initT;

        bots = (botsVierkant + botsRechthoek + botsCirkel + botsDriehoek)
            .toSet()
            .toList();

        Database.getSpeedBots(bots); //.then((info) {});
      });
    }

    //get bots from DB

    String exerciseID = "oppervlakte-" + widget.skills.join("-");
    String tableID = "generated-" + exerciseID;

    CollectionReference dbComp = db.collection("exercises");
    CollectionReference dbEx = db.collection(tableID);

    generatedPlayed = [];
    generatedPlayedGenaral[exerciseID] = [];

    //here can still appear null error
    dbComp.doc(widget.user).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      var alreadyPlayed;

      if (document['elo'] != null) {
        elos = document['elo'] as Map<String, dynamic>;
        generatedPlayedGenaral =
            document['generatedPlayed'] as Map<String, dynamic>;

        alreadyPlayed = generatedPlayedGenaral[exerciseID];
        var eloInfo = elos[exerciseID];

        if (eloInfo != null) {
          elo = eloInfo["elo"];
          t = eloInfo["t"];
          bots = Consts.getBots(elo);
        }
      }

      Database.getSpeedBots(bots).then((data) {
        botsInfo = data;
        generateSpeedInfo();
        newExercise();
        startTimer();
        startExercise.value = true;
        // !!!! Not used
        //getExistingExercisesBot();
      });

      if (alreadyPlayed != null) {
        generatedPlayed = alreadyPlayed;
      }
      //
    });
  }

  @override
  void initState() {
    super.initState();

    if (widget.exerciseName == "competition") {
      throw ArgumentError("Implement Comp bot");
    }

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
    });

    CollectionReference dbUser = db.collection("users");
    dbUser.doc(widget.user).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      path = document['path'];
      pathCompletion = document['pathCompletion'];
    });
  }

  void generateExercise() {
    int maxIDX = imagesVierkant.length;
    int idx = Random().nextInt(maxIDX);
    String imageChosen = imagesVierkant[idx];
    String pathImage = "assets/images/vierkant/";

    speed = Random().nextInt(16) + 2;

    if (figure != "combined") {
      String bot = Consts.getClosetsBot(elo);
      var botInfo = botsInfo[bot];
      var key = "Speed-" + figure[0].toUpperCase() + figure.substring(1);
      if (botInfo != null) {
        //TODO: sometimes null????
        speed = botInfo[key];
        showFormule = botInfo["showFormule"];
      }
      updateTime += speed;

      if (progression.contains(0)) {
        int idx = progression.indexWhere((num) => num == 0);
        var sub = 0;

        if (stopWatch != null) {
          sub = stopWatch!.tick;
        }

        progression[idx] = sub + speed;
      }
    } else {
      maxIDX = imagesCombined.length;
      idx = Random().nextInt(
          maxIDX); //TODO: length of vect of combined exercises determines speed/elo
      imageChosen = imagesCombined[idx];
      pathImage = "assets/images/combined-figures/";

      List<String> figures = Consts.figuresCombined[idx];
      //+ x figures to select
      int speedSum = figures.length;
      showFormule = {};

      //TODO: showFormule a vect of bools
      for (var fig in Consts.figures) {
        int eloFig = 1500;

        if (fig == "vierkant") {
          eloFig = eloVierkant;
        } else if (fig == "rechthoek") {
          eloFig = eloRechthoek;
        } else if (fig == "cirkel") {
          eloFig = eloCirkel;
        } else if (fig == "driehoek") {
          eloFig = eloDriehoek;
        }

        String bot = Consts.getClosetsBot(eloFig);
        var botInfo = botsInfo[bot];
        var key = "showFormule";
        bool val = (botInfo[key] != null) ? botInfo[key] : true;

        showFormule[fig] = val;
      }

      // sum all the speeds
      for (var fig in figures) {
        int eloFig = 1500;

        if (fig == "vierkant") {
          eloFig = eloVierkant;
        } else if (fig == "rechthoek") {
          eloFig = eloRechthoek;
        } else if (fig == "cirkel") {
          eloFig = eloCirkel;
        } else if (fig == "driehoek") {
          eloFig = eloDriehoek;
        }

        String bot = Consts.getClosetsBot(eloFig);
        var botInfo = botsInfo[bot];
        var key = "Speed-" + fig[0].toUpperCase() + fig.substring(1);
        int speedFig = (botInfo[key] != null) ? botInfo[key] : 0;
        speedSum += speedFig;
      }

      speed = speedSum;
      updateTime += speed;

      if (progression.contains(0)) {
        int idx = progression.indexWhere((num) => num == 0);
        var sub = 0;

        if (stopWatch != null) {
          sub = stopWatch!.tick;
        }

        progression[idx] = sub + speed;
      }
    }

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
      hoogte = Random().nextInt(Consts().maxMultiplyByHead + 1);
      breedte = Random().nextInt(Consts().maxMultiplyByHead + 1);
    }

    image = pathImage + imageChosen;
    z = Random().nextInt(Consts().maxMultiplyByHead) +
        1; //TODO: hou rekening met elo
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

    var data = doc.data();

    image = data['image'];
    eloExercise = data['elo'];
    z = data['z'];
    speed = data['speed'];

    toChooseFrom.remove(doc);
  }

  void announceWinner() {
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

    Consts.updatePathCompletion(pathCompletion);

    //post to DB
    //post matchIDs played
    CollectionReference dbEx = db.collection("exercises");

    if (figure == "combined") {
      var vierkant = [eloVierkant.toDouble(), tVierkant];
      var rechthoek = [eloRechthoek.toDouble(), tRechthoek];
      var cirkel = [eloCirkel.toDouble(), tCirkel];
      var driehoek = [eloDriehoek.toDouble(), tDriehoek];
      var conversion = [eloCoversion.toDouble(), tConversion];
      Database.updateElo(
          widget.user, vierkant, rechthoek, driehoek, cirkel, conversion);
    } else {
      elos[skillString] = {"elo": elo, "t": t};

      dbEx.doc(widget.user).set(
          {"elo": elos, "generatedPlayed": generatedPlayedGenaral},
          SetOptions(merge: true));
    }

    if (opponentProgress.value < ownProgress.value) {
      won.value = true;
    } else {
      won.value = false;
    }
  }

  void startTimer() {
    stopWatch = Timer.periodic(Duration(seconds: 1), (timer) {
      seconds.value++; // This now properly updates the UI

      if (hasOpponent &&
          progressionOpponent != null &&
          opponentProgress.value < widget.amountExercises) {
        var update2 = progression[opponentProgress.value];

        if (update2 == seconds.value) {
          opponentProgress.value++;
        }

        if (opponentProgress.value > ownProgress.value) {
          colorBar.value = Colors.red;
        } else if (opponentProgress.value < ownProgress.value) {
          colorBar.value = Colors.green;
        } else {
          colorBar.value = Colors.orange;
        }
      }
    });
  }

  void updateExerciseInfo() {
    //TODO: also post timeStamp to see progression over time
    var date = DateTime.now();

    var newDoc = {
      'elo': elo,
      'tookTime': exerciseTook,
      'timeStamp': date,
      'image': image,
      'speed': speed,
      'user': widget.user,
      'z': z,
      'showFormule': showFormule,
    };

    if (widget.exerciseName == "cirkel") {
      newDoc['straal'] = z;
    } else if (widget.exerciseName == "rechthoek") {
      newDoc['lengte'] = z;
      newDoc['breedte'] = breedte;
    } else if (widget.exerciseName == "driehoek") {
      newDoc['basis'] = z;
      newDoc['hoogte'] = hoogte;
    } else if (widget.exerciseName == "combined") {}

    generatedToPost.add(newDoc);
  }

  void updateElo() {
    int time = seconds.value;
    exerciseTook = time - timeLastEx;
    timeLastEx = time;

    if (exerciseTook > speed) {
      wonCurrent = false;
    } else {
      wonCurrent = true;
    }

    if (figure == "combined") {
      //TODO: update elo
      List<String> imagePath = image.split("/");
      int pathLength = imagePath.length;
      int idx = pathLength - 1;
      String imageNoPath = imagePath[idx];
      int idxImage = Consts.imagesCombined.indexOf(imageNoPath);
      List<String> figures = Consts.figuresCombined[idxImage];

      for (String figure in figures) {
        double speedInterval = wonCurrent ? 1 : speed / exerciseTook;
        int eloFigure = eloVierkant;
        double tFigure = tVierkant;

        if (figure == "rechthoek") {
          eloFigure = eloRechthoek;
          tFigure = tRechthoek;
        } else if (figure == "cirkel") {
          eloFigure = eloCirkel;
          tFigure = tCirkel;
        } else if (figure == "driehoek") {
          eloFigure = eloDriehoek;
          tFigure = tDriehoek;
        }

        List<dynamic> newInfo = Elo.updateElo(
            eloFigure, eloExercise, wonCurrent, tFigure, speedInterval);

        if (figure == "vierkant") {
          eloVierkant = newInfo[0];
          tVierkant = newInfo[1];
        } else if (figure == "rechthoek") {
          eloRechthoek = newInfo[0];
          tRechthoek = newInfo[1];
        } else if (figure == "driehoek") {
          eloDriehoek = newInfo[0];
          tDriehoek = newInfo[1];
        } else if (figure == "cirkel") {
          eloCirkel = newInfo[0];
          tCirkel = newInfo[1];
        }
      }
    }

    speeds.add(exerciseTook);
    speeds.sort();

    int current = speeds.indexOf(exerciseTook) + 1;
    int totalSpeeds = speeds.length;
    //speedInterval = current / totalSpeeds;

    //TODO: % of speed
    double speedInterval = wonCurrent ? 1 : speed / exerciseTook;
    print(speedInterval);

    List<dynamic> newInfo =
        Elo.updateElo(elo, eloExercise, wonCurrent, t, speedInterval);

    print(newInfo);
    print(progression);
    elo = newInfo[0];
    t = newInfo[1];

    speeds.add(speed);
    speeds.sort();

    current = speeds.indexOf(speed) + 1;
    totalSpeeds = speeds.length;

    List<dynamic> newInfoExercise = //update elo of exercise
        Elo.updateElo(1500, elo, !wonCurrent, tExercise, current / totalSpeeds);
    //speeds.reduce(combine)
    speeds.removeAt(current - 1);

    // update directly if exercise was already existing
    //(chances exist that some writes get lost when the whole class is playing at the same time)

    if (generated) {
      updateExerciseInfo();
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
    var winner = Center(child: Header(title: "Gewonnen"));
    var loser = Center(child: Header(title: "Verloren"));

    var viewAnswersButton =
        ElevatedButton(onPressed: () {}, child: Text("Bekijk mijn oefeningen"));
    var viewProgressButton = ElevatedButton(
        onPressed: () {}, child: Text("Bekijk mijn vooruitgang!"));
    var learningPathButton = ElevatedButton(
        onPressed: widget.done, child: Text("Ga terug naar leerpad!"));

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
          height: 20,
        ),
        //viewAnswersButton,
        //SizedBox(
        //  height: 20,
        //),
        //viewProgressButton,
        //SizedBox(
        //  height: 20,
        //),
        learningPathButton,
        Spacer(),
      ],
    );

    var exercisesOrLoading = ValueListenableBuilder(
        valueListenable: startExercise,
        builder: (context, value, child) {
          var exercise = ListView(
            children: [
              Text("Oppervlakte"),
              //Spacer(),
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
              //Spacer(),
              ValueListenableBuilder(
                  valueListenable: ownProgress,
                  builder: (context, value, child) {
                    return CompetitiveEx(
                        showFormule: showFormule,
                        z: z,
                        b: breedte,
                        h: hoogte,
                        currentExercise: value + 1,
                        amountExercises: widget.amountExercises,
                        image: image,
                        figure: figure,
                        callback: exerciseSolved);
                  }),
              //Spacer(),
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
