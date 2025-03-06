import 'package:flutter/material.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathapp/components/learningPathTile.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/pages/conversion_theory.dart';
import 'package:mathapp/pages/oppervlakte_theory.dart';
import 'package:mathapp/pages/figure_theory.dart';

class LearningPath extends StatefulWidget {
  const LearningPath({super.key});

  @override
  State<LearningPath> createState() => _LearningPathState();
}

class _LearningPathState extends State<LearningPath> {
  //int selectedPage = 0;
  ValueNotifier<int> selectedPage = ValueNotifier(0);
  bool theoryDoneOppervlakte = false;
  String user = "Preview";
  List<String> path = [""];
  List<bool> pathCompletion = [true];
  FirebaseFirestore db = FirebaseFirestore.instance;

  ValueNotifier<String> figure = ValueNotifier("vierkant");

  @override
  void initState() {
    super.initState();

    bool loggedIn = Consts.loggedIn();

    if (loggedIn) {
      user = Consts.getLoggedInUser();
      selectedPage.value = 0;

      path = Consts.retrievePath();
      pathCompletion = Consts.retrievePathCompletion();
    } else {
      selectedPage.value = 1;
    }
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
          user: user,
          path: path,
          pathCompletion: pathCompletion,
        ),
      ),
    );
  }

  void makeCompEx(String fig) {
    figure.value = fig;
    selectedPage.value = 2;
  }

  void vierkantCallback() {
    //TODO: get all possible values needed from database to get custom exercises
    CollectionReference dbUsers = db.collection("users");

    dbUsers.doc(user).get().then((doc) {
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

      makeCompEx('vierkant');
    });
  }

  void cirkelCallback() {
    //TODO: get all possible values needed from database to get custom exercises
    CollectionReference dbUsers = db.collection("users");

    dbUsers.doc(user).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      //TODO get needed info

      var figureRemember = document['figuur-cirkel-remember'];
      var oppervlakteRemember = document['oppervlakte-cirkel-remember'];

      var oppervlakteApply = {
        "pknow": document['pknow'],
        "plearn": document['plearn']
      };

      if (document['oppervlakte-cirkel-apply'] != null) {
        //TODO:
        oppervlakteApply = document['oppervlakte-cirkel-apply'];
      }

      var eloVierkant = 2800 * oppervlakteApply['pknow'];
      var eloSpeed = 1500;

      if (document['elo-cirkel'] != null) {
        //TODO:
        eloVierkant = document['elo-cirkel'];
      }

      makeCompEx('cirkel');
    });
  }

  void rechthoekCallback() {
    //TODO: get all possible values needed from database to get custom exercises
    CollectionReference dbUsers = db.collection("users");

    dbUsers.doc(user).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      //TODO get needed info

      var figureRemember = document['figuur-rechthoek-remember'];
      var oppervlakteRemember = document['oppervlakte-rechthoek-remember'];

      var oppervlakteApply = {
        "pknow": document['pknow'],
        "plearn": document['plearn']
      };

      if (document['oppervlakte-rechthoek-apply'] != null) {
        //TODO:
        oppervlakteApply = document['oppervlakte-rechthoek-apply'];
      }

      var eloVierkant = 2800 * oppervlakteApply['pknow'];
      var eloSpeed = 1500;

      if (document['elo-rechthoek'] != null) {
        //TODO:
        eloVierkant = document['elo-rechthoek'];
      }

      if (document['elo-speed'] != null) {
        eloSpeed = document['elo-speed'];
      }

      makeCompEx('rechthoek');
    });
  }

  void conversionCallback() {
    selectedPage.value = 3;
  }

  void driehoekCallback() {
    //TODO: get all possible values needed from database to get custom exercises
    CollectionReference dbUsers = db.collection("users");

    dbUsers.doc(user).get().then((doc) {
      var document = doc.data() as Map<String, dynamic>;
      //TODO get needed info

      var figureRemember = document['figuur-driehoek-remember'];
      var oppervlakteRemember = document['oppervlakte-driehoek-remember'];

      var oppervlakteApply = {
        "pknow": document['pknow'],
        "plearn": document['plearn']
      };

      if (document['oppervlakte-driehoek-apply'] != null) {
        //TODO:
        oppervlakteApply = document['oppervlakte-driehoek-apply'];
      }

      var eloVierkant = 2800 * oppervlakteApply['pknow'];
      var eloSpeed = 1500;

      if (document['elo-driehoek'] != null) {
        //TODO:
        eloVierkant = document['elo-driehoek'];
      }

      if (document['elo-speed'] != null) {
        //TODO:
        eloVierkant = document['elo-speed'];
      }

      makeCompEx('driehoek');
    });
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
      Text("Leerpad van " + user),
    ];

    void addCustoms() {
      List<Widget> pathTiles = [leftToMid, midToRight, rightToMid, midToLeft];
      List<String> positions = ["left", "mid", "right", "mid"];
      int current = 0;
      int currentTiles = 0;
      int indexCompleted = 0;

      path.forEach((element) {
        var completed = pathCompletion[current];
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
              userID: user);
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
            userID: user,
          );
          pathWidgets.add(vierkant);
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
        } else if (element == "cirkel") {
          var cirkel = Learningpathtile(
            onTileClicked: cirkelCallback,
            icon: iconCirlceEx,
            position: position,
            completed: completed,
            enabeled: enabeled,
            userID: user,
          );
          pathWidgets.add(cirkel);
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
        } else if (element == "rechthoek") {
          var rechthoek = Learningpathtile(
            onTileClicked: rechthoekCallback,
            icon: iconRectangle,
            position: position,
            completed: completed,
            enabeled: enabeled,
            userID: user,
          );
          pathWidgets.add(rechthoek);
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
        } else if (element == "driehoek") {
          var driehoek = Learningpathtile(
            onTileClicked: driehoekCallback,
            icon: iconTriangleEx,
            position: position,
            completed: completed,
            enabeled: enabeled,
            userID: user,
          );
          pathWidgets.add(driehoek);
          pathWidgets.add(pathTiles[currentTiles]);
          current += 1;
          currentTiles += 1;
        } else if (element == "conversion") {
          var conversion = Learningpathtile(
              onTileClicked: conversionCallback,
              position: position,
              icon: iconPlattegrond,
              completed: completed,
              enabeled: enabeled,
              userID: user);
          pathWidgets.add(conversion);
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

    final ListView exercises = ListView(
      children: pathWidgets,
    );

    final compEx = ValueListenableBuilder(
        valueListenable: figure,
        builder: (x, value, y) {
          return FigureTheory(
            synced: false,
            amountExercises: 10,
            user: user,
            skills: [value],
            opponent: "bot",
            exerciseName: value,
          );
        });

    final List _pages = [
      exercises,
      Consts.logginFirst,
      compEx,
      ConversionTheory(done: () {})
    ];

    final page = ValueListenableBuilder(
        valueListenable: selectedPage,
        builder: (x, val, y) {
          return _pages[val];
        });

    return Scaffold(
      body: Center(child: page),
    );
  }
}
