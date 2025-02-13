import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/figure_input.dart';
import 'package:mathapp/components/formule_input.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/components/title_tile.dart';

class OppervlakteTheory extends StatefulWidget {
  final VoidCallback done;
  final String user;
  final bool solved;
  final List<dynamic> path;
  final List<dynamic> pathCompletion;
  const OppervlakteTheory(
      {super.key,
      required this.done,
      required this.solved,
      required this.user,
      required this.path,
      required this.pathCompletion});

  @override
  State<OppervlakteTheory> createState() => new _OppervlakteTheoryState();
}

class _OppervlakteTheoryState extends State<OppervlakteTheory> {
  IconData iconVierkantEx = Icons.square_outlined;
  IconData iconTriangleEx = Icons.change_history_sharp;
  IconData iconCirlceEx = Icons.circle_outlined;
  IconData iconRectangle = Icons.crop_16_9_outlined;
  final pGuessInit = 0.3;
  final pSlippInit = 0.1;
  final pLearningInfluence = 0.02;

  FirebaseFirestore db = FirebaseFirestore.instance;
  var pKnow = 0.5;
  var pLearn = 0.5;
  bool learningDissability = false;
  bool fetchInfoFromDB = false;

  int page = 0;

  late bool solvedLocal;

  late List<dynamic> path;
  late List<dynamic> pathCompletion;
  bool resPosted = false;
  bool answPosted = false;

  void loadPath() {
    CollectionReference dbUsers = db.collection("users");

    dbUsers.doc(widget.user).get().then((doc) {
      path = doc['path'];
      pathCompletion = doc['pathCompletion'];
    });
  }

  _goPath() {
    Navigator.pushNamed(context, '/learning-path', arguments: {
      'user': widget.user,
      'path': path,
      'pathCompletion': pathCompletion
    });
  }

  @override
  void initState() {
    super.initState();
    solvedLocal = widget.solved; // Initialize locally
    if (widget.solved) {
      page = 1;
    }

    path = widget.path;
    pathCompletion = widget.pathCompletion;
  }

  final meetkundeLevel = <String, dynamic>{};

  final meetkundeResults = <String, dynamic>{};

  final TextEditingController inputVierkant = TextEditingController();
  final TextEditingController inputRechthoek = TextEditingController();
  final TextEditingController inputDriehoek = TextEditingController();
  final TextEditingController inputCirkel = TextEditingController();
  final TextEditingController inputVierkantFormule = TextEditingController();
  final TextEditingController inputRechthoekFormule = TextEditingController();
  final TextEditingController inputDriehoekFormule = TextEditingController();
  final TextEditingController inputCirkelFormule = TextEditingController();

  void checkCompleted() {
    if (meetkundeLevel.length >= 8) {
      //TODO: verander naar 9 al driehoek ook is toegevoegd
      print("postToDB?");
      CollectionReference dbExercises = db.collection("exercises");

      final docRef = dbExercises.doc(widget.user);

      //Houd enkel laatste antwoord bij -> aanpassen als je list append wilt doen!
      docRef.set({
        "oppervlakteTheoryResults": [meetkundeLevel]
      }, SetOptions(merge: true));

      answPosted = true;
      if (resPosted) {
        solvedLocal = true;
        resPosted = false;
        answPosted = false;
      }
    }
  }

  bool showAnswers = false;
  int tries = 3;
  String textButton = "Controleer antwoorden!";

  String textSucceeded100 =
      "Je hebt alles juist ingevuld, je kan deze theory nu proberen toepassen in het dagelijkse leven!";
  String textSucceeded80 =
      "Je wist het meeste van de theory al, heel goed gedaan! Ik zal je nu verder helpen met de delen die iets minder vlot gingen.";
  String textSucceed60 =
      "Je wist meer dan de helft van de theory al, goed gedaan! Ik zal je nu verder helpen met de delen die iets minder vlot gingen.";
  String textSucceed50 =
      "Je wist meer de helft van de theory al! Ik zal je nu verder helpen met de delen die iets minder vlot gingen.";
  String textSucceedLess =
      "Geen zorgen als je niet alle antwoorden wist, ik zal je helpen bij het leren van deze formules!";
  String error = "";
  void checkResults() {
    int index = path.indexOf("oppervlakte");
    bool changed = true;

    if (pathCompletion[index]) {
      changed = false;
    }

    pathCompletion[index] = true;

    CollectionReference dbUser = db.collection("users");
    final docRef = dbUser.doc(widget.user);

    /*
    docRef.get().then((doc) {
      if (doc.exists) {
        pKnow = doc['pknow'];
        pLearn = doc['plearn'];
        learningDissability = doc['learningDisability'];
      }
    });
    */

    if (changed) {
      docRef.set({
        "pathCompletion": pathCompletion,
      }, SetOptions(merge: true));
    }

    if (tries == 0) {
      //go automatically back to learningpath after 3 tries
      _goPath();
    }

    String vierkant = inputVierkant.value.text;
    String rechthoek = inputRechthoek.value.text;
    String driehoek = inputDriehoek.value.text;
    String cirkel = inputCirkel.value.text;
    String vierkantFormule = inputVierkantFormule.value.text;
    String rechthoekFormule = inputRechthoekFormule.value.text;
    String driehoekFormule = inputDriehoekFormule.value.text;
    String cirkelFormule = inputCirkelFormule.value.text;

    if (vierkant == "" ||
        rechthoek == "" ||
        driehoek == "" ||
        cirkel == "" ||
        vierkantFormule == "" ||
        rechthoekFormule == "" ||
        //driehoekFormule == "" ||
        cirkelFormule == "") {
      setState(() {
        error =
            "Please fill in all fields, if you don't know the answer fill in '/'";
      });
    } else {
      tries -= 1;

      if (tries == 0) {
        textButton = "Ga terug naar leerpad";
        error = "Geen zorgen, we zullen later opnieuw proberen :)";
      }

      setState(() {
        showAnswers = true;
      });

      // post the results
      var time = DateTime.now();
      meetkundeLevel["date"] = time;
      meetkundeResults["date"] = time;
      meetkundeResults["vierkantName"] = inputVierkant.text;
      meetkundeResults["rechthoekName"] = inputRechthoek.text;
      meetkundeResults["driehoekName"] = inputDriehoek.text;
      meetkundeResults["cirkelName"] = inputCirkel.text;
      meetkundeResults["vierkantFormule"] = inputVierkantFormule.text;
      meetkundeResults["rechthoekFormule"] = inputRechthoekFormule.text;
      meetkundeResults["cirkelFormule"] = inputCirkelFormule.text;

      CollectionReference dbExercises = db.collection("exercises");

      final docRef = dbExercises.doc(widget.user);

      if (solvedLocal) {
        //TODO: update array
        docRef.set({
          "oppervlakteTheory": [meetkundeResults]
        }, SetOptions(merge: true));
      } else {
        docRef.set({
          "oppervlakteTheory": [meetkundeResults]
        });

        resPosted = true;

        if (answPosted) {
          solvedLocal = true;
        }
      }

      //docRef.get().then((doc) {

      //TODO: if all correct -> solved = true in DB
    }
  }

  String answerVierkant = "";
  bool answerVierkantCorrect = false;
  String answerRechthoek = "";
  bool answerRechthoekCorrect = false;
  String answerCirkel = "";
  bool answerCirkelCorrect = false;
  String answerDriehoek = "";
  bool answerDriehoekCorrect = false;

  String answerVierkantFormule = "";
  bool answerVierkantFormuleCorrect = false;
  String answerDriehoekFormule = "";
  bool answerDriehoekFormuleCorrect = false;
  String answerCirkelFormule = "";
  bool answerCirkelFormuleCorrect = false;
  String answerRechthoekFormule = "";
  bool answerRechthoekFormuleCorrect = false;

  var colorVierkantNaam = Colors.black;
  var colorRechthoekNaam = Colors.black;
  var colorDriehoekNaam = Colors.black;
  var colorCirkelNaam = Colors.black;

  var colorVierkantFormule = Colors.black;
  var colorRechthoekFormule = Colors.black;
  var colorDriehoekFormule = Colors.black;
  var colorCirkelFormule = Colors.black;

  var score = 7;

  void showPreviousAnswers() {
    CollectionReference dbExercises = db.collection("exercises");

    final docRef = dbExercises.doc(widget.user);
    docRef.get().then((doc) {
      print(doc);
      var answers = doc['oppervlakteTheory'];
      var answersCorrection = doc['oppervlakteTheoryResults'];

      int amountAnswers = answers.length;
      var lastAnswer = answers[amountAnswers - 1];
      var lastAnswerCor = answersCorrection[amountAnswers - 1];

      answerCirkel = lastAnswer["cirkelName"];
      answerCirkelFormule = lastAnswer["cirkelFormule"];
      answerDriehoek = lastAnswer["driehoekName"];
      answerRechthoek = lastAnswer["rechthoekName"];
      answerRechthoekFormule = lastAnswer["rechthoekFormule"];
      answerVierkant = lastAnswer["vierkantName"];
      answerVierkantFormule = lastAnswer["vierkantFormule"];

      answerCirkelCorrect = lastAnswerCor["cirkelName"];
      if (!answerCirkelCorrect) {
        colorCirkelNaam = Colors.red;
        score -= 1;
      }
      answerCirkelFormuleCorrect = lastAnswerCor["cirkelFormule"];
      if (!answerCirkelFormuleCorrect) {
        colorCirkelFormule = Colors.red;
        score -= 1;
      }
      answerDriehoekCorrect = lastAnswerCor["driehoekName"];
      if (!answerDriehoekCorrect) {
        colorDriehoekNaam = Colors.red;
        score -= 1;
      }
      answerRechthoekCorrect = lastAnswerCor["rechthoekName"];
      if (!answerRechthoekCorrect) {
        colorRechthoekNaam = Colors.red;
        score -= 1;
      }
      answerRechthoekFormuleCorrect = lastAnswerCor["rechthoekFormule"];
      if (!answerRechthoekFormuleCorrect) {
        colorRechthoekFormule = Colors.red;
        score -= 1;
      }
      answerVierkantCorrect = lastAnswerCor["vierkantName"];
      if (!answerVierkantCorrect) {
        colorVierkantNaam = Colors.red;
        score -= 1;
      }
      answerVierkantFormuleCorrect = lastAnswerCor["vierkantFormule"];
      if (!answerVierkantFormuleCorrect) {
        colorVierkantFormule = Colors.red;
        score -= 1;
      }

      setState(() {
        page = 2;
      });
    });
  }

  double newPknow(double pKnow, double pWillLearn, double pGuess, double pSlipp,
      bool correct) {
    double pLEARNEDn_1 = 0;
    if (correct) {
      pLEARNEDn_1 = (pKnow * (1 - pSlipp)) /
          (pKnow * (1 - pSlipp) + (1 - pKnow) * pGuess);
    } else {
      pLEARNEDn_1 =
          (pKnow * pSlipp) / (pKnow * pSlipp + (1 - pKnow) * (1 - pGuess));
    }

    var pLearned =
        pLEARNEDn_1 + (1 - pLEARNEDn_1) * pLearn; //New value for pKnown

    return pLearned;
  }

  void updateSkill(bool correct, List<String> skills, String difficulty) {
    //TODO: Only update skill if value is changed from before!
    String user = widget.user;
    String skillsString = skills.join('-') + '-' + difficulty;
    String infoID = skillsString;

    final docRef = db.collection("users").doc(user);

    docRef.get().then((doc) {
      Map<String, dynamic> document = doc.data() as Map<String, dynamic>;

      var pKnow = document['pknow'];
      var pLearn = document['plearn'];
      var pSlipp = pSlippInit;
      var pGuess = pGuessInit;
      bool learningDisability = document['learningDisability'];
      if (learningDissability) {
        pSlipp += pLearningInfluence;
        pGuess += pLearningInfluence;
      }

      if (document[skillsString] != null) {
        var bkt = document[skillsString] as Map<String, dynamic>;
        pLearn = bkt['plearn'];
        pKnow = bkt['pknow'];
      }

      var pLEARNEDn_1 = 0.0;
      if (correct) {
        pLEARNEDn_1 = (pKnow * (1 - pSlipp)) /
            (pKnow * (1 - pSlipp) + (1 - pKnow) * pGuess);
      } else {
        pLEARNEDn_1 =
            (pKnow * pSlipp) / (pKnow * pSlipp + (1 - pKnow) * (1 - pGuess));
      }

      var pLearned =
          pLEARNEDn_1 + (1 - pLEARNEDn_1) * pLearn; //New value for pKnown

      var newDoc = {"pknow": pLearned, "plearn": pLearn};
      Map<String, dynamic> entries = {skillsString: newDoc};
      var figure = skills[1];

      if (!path.contains(figure)) {
        path.add(figure);
        pathCompletion.add(false);

        entries.addAll({"path": path, "pathCompletion": pathCompletion});
      }

      docRef.set(entries, SetOptions(merge: true));
    });
  }

  void backToLearningPath() {
    if (answerCirkelCorrect &&
        answerDriehoekCorrect &&
        answerVierkantCorrect &&
        answerRechthoekCorrect &&
        answerCirkelFormuleCorrect &&
        //answerDriehoekFormuleCorrect &&
        answerRechthoekFormuleCorrect &&
        answerVierkantFormuleCorrect) {
      _goPath();
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = Header(title: "Oppervlakte");
    final subTitle = Text("Already made: " + widget.solved.toString());

    final vierkantNameWidget = FigureInputTile(
        controller: inputVierkant,
        saveResult: (res) {
          meetkundeLevel["vierkantName"] = res;
          checkCompleted();
          updateSkill(res, ["figuur", "vierkant"], "remember");
        },
        showAnswers: showAnswers,
        icon: iconVierkantEx,
        name: "Vierkant");

    final rechthoekNameWidget = FigureInputTile(
        controller: inputRechthoek,
        saveResult: (res) {
          meetkundeLevel["rechthoekName"] = res;
          checkCompleted();
          meetkundeResults["rechthoekName"] = inputRechthoek.text;
          updateSkill(res, ["figuur", "rechthoek"], "remember");
        },
        showAnswers: showAnswers,
        icon: iconRectangle,
        name: "Rechthoek");

    final driehoekNameWidget = FigureInputTile(
        controller: inputDriehoek,
        saveResult: (res) {
          meetkundeLevel["driehoekName"] = res;
          checkCompleted();
          meetkundeResults["driehoekName"] = inputDriehoek.text;
          updateSkill(res, ["figuur", "driehoek"], "remember");
        },
        showAnswers: showAnswers,
        icon: iconTriangleEx,
        name: "Driehoek");

    final cirkelNameWidget = FigureInputTile(
        controller: inputCirkel,
        saveResult: (res) {
          meetkundeLevel["cirkelName"] = res;
          checkCompleted();
          meetkundeResults["cirkelName"] = inputCirkel.text;
          updateSkill(res, ["figuur", "cirkel"], "remember");
        },
        showAnswers: showAnswers,
        icon: iconCirlceEx,
        name: "Cirkel");

    final vierkantFormuleWidget = FormuleInputTile(
        controller: inputVierkantFormule,
        saveResult: (res) {
          meetkundeLevel["vierkantFormule"] = res;
          checkCompleted();
          meetkundeResults["vierkantFormule"] = inputVierkantFormule.text;
          updateSkill(res, ["oppervlakte", "vierkant"], "remember");
        },
        showAnswers: showAnswers,
        icon: iconVierkantEx,
        name: "Vierkant");

    final rechthoekFormuleWidget = FormuleInputTile(
        controller: inputRechthoekFormule,
        saveResult: (res) {
          meetkundeLevel["rechthoekFormule"] = res;
          checkCompleted();
          meetkundeResults["rechthoekFormule"] = inputRechthoekFormule.text;
          updateSkill(res, ["oppervlakte", "rechthoek"], "remember");
        },
        showAnswers: showAnswers,
        icon: iconRectangle,
        name: "Rechthoek");

    final driehoekFormuleWidget = FormuleInputTile(
        controller: inputDriehoekFormule,
        saveResult: (res) {
          meetkundeLevel["driehoekFormule"] = res;
          //meetkundeResults["driehoekFomule"] = inputDriehoekFormule.text;
          checkCompleted();
          updateSkill(res, ["oppervlakte", "driehoek"], "remember");
        },
        showAnswers: showAnswers,
        icon: iconTriangleEx,
        name: "Driehoek");

    final cirkelFormuleWidget = FormuleInputTile(
        controller: inputCirkelFormule,
        saveResult: (res) {
          meetkundeLevel["cirkelFormule"] = res;
          checkCompleted();
          updateSkill(res, ["oppervlakte", "cirkel"], "remember");
        },
        showAnswers: showAnswers,
        icon: iconCirlceEx,
        name: "Cirkel");

    final buttonViewRes = SizedBox(
        height: 100,
        child: Row(
          children: [
            Spacer(),
            ElevatedButton(
                onPressed: showPreviousAnswers,
                child: Text("Beijk vorige antwoorden!")),
            Spacer()
          ],
        ));

    var showPreviousAnswersButton = SizedBox(
      height: 10,
    );

    if (widget.solved) {
      showPreviousAnswersButton = buttonViewRes;
    }

    final buttonLeerpad = SizedBox(
        height: 100,
        child: Row(
          children: [
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/learning-path', arguments: {
                    'user': widget.user,
                    'path': path,
                    'pathCompletion': pathCompletion
                  });
                },
                child: Text("Ga terug naar leerpad")),
            Spacer()
          ],
        ));

    final exerciseWidgets = [
      title,
      subTitle,
      Text("Ken je alle onderstaande figuren?"),
      vierkantNameWidget,
      rechthoekNameWidget,
      driehoekNameWidget,
      cirkelNameWidget,
      Text("Welke formules ken je nog voor de oppervlakte?"),
      vierkantFormuleWidget,
      rechthoekFormuleWidget,
      // driehoekFormuleWidget,
      cirkelFormuleWidget,
      Text(
          "Geen zorgen als je niet alle antwoorden wist, ik zal je helpen bij het leren van deze formules!"),
      Row(
        children: [
          Spacer(),
          ElevatedButton(onPressed: checkResults, child: Text(textButton)),
          Spacer()
        ],
      ),
      Text(error, style: TextStyle(color: Colors.red)),
      showPreviousAnswersButton,
      buttonLeerpad,
    ];

    final buttonMakeAgain = SizedBox(
        height: 100,
        child: Row(
          children: [
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    page = 0;
                  });
                },
                child: Text("Maak opnieuw!")),
            Spacer()
          ],
        ));

    final sub2 =
        Text("Je hebt deze oefening al gemaakt :) Wat wilt u graag doen?");
    final exercisesMade = [
      title,
      sub2,
      buttonViewRes,
      buttonMakeAgain,
      buttonLeerpad,
    ];

    final iconVierkant = Icon(
      iconVierkantEx,
      size: 40,
    );

    final iconRechthoek = Icon(
      iconRectangle,
      size: 40,
    );
    final iconDriehoek = Icon(
      iconTriangleEx,
      size: 40,
    );
    final iconCirkel = Icon(
      iconCirlceEx,
      size: 40,
    );

    final textNaam = Text(
      "Naam figuur: ",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
    final textVierkant = Text(
      answerVierkant,
      style: TextStyle(color: colorVierkantNaam),
    );
    final textRechthoek = Text(
      answerRechthoek,
      style: TextStyle(color: colorVierkantNaam),
    );
    final textDriehoek = Text(
      answerDriehoek,
      style: TextStyle(color: colorDriehoekNaam),
    );
    final textCirkel = Text(
      answerCirkel,
      style: TextStyle(color: colorCirkelNaam),
    );
    final textFormule = Text(
      "Formule oppervlate: ",
      style: TextStyle(fontWeight: FontWeight.bold),
    );
    final textVierkantFormule = Text(
      answerVierkantFormule,
      style: TextStyle(color: colorVierkantFormule),
    );
    final textRechthoekFormule = Text(
      answerRechthoekFormule,
      style: TextStyle(color: colorRechthoekFormule),
    );
    final textDriehoekFormule = Text(
      answerDriehoekFormule,
      style: TextStyle(color: colorDriehoekFormule),
    );
    final textCirkelFormule = Text(
      answerCirkelFormule,
      style: TextStyle(color: colorCirkelFormule),
    );

    final textScore = Row(children: [
      Spacer(),
      Text(
        "Score: " + score.toString() + "/7",
        style: TextStyle(fontSize: 30),
      ),
      Spacer(),
    ]);

    final vierkantWidget = Row(
      children: [
        Spacer(),
        iconVierkant,
        Spacer(),
        textNaam,
        textVierkant,
        Spacer(),
        textFormule,
        textVierkantFormule,
        Spacer()
      ],
    );

    final rechthoekWidget = Row(
      children: [
        Spacer(),
        iconRechthoek,
        Spacer(),
        textNaam,
        textRechthoek,
        Spacer(),
        textFormule,
        textRechthoekFormule,
        Spacer()
      ],
    );

    final driehoekWidget = Row(
      children: [
        Spacer(),
        iconDriehoek,
        Spacer(),
        textNaam,
        textDriehoek,
        Spacer(),
        textFormule,
        textDriehoekFormule,
        Spacer()
      ],
    );

    final cirkelWidget = Row(
      children: [
        Spacer(),
        iconCirkel,
        Spacer(),
        textNaam,
        textCirkel,
        Spacer(),
        textFormule,
        textCirkelFormule,
        Spacer()
      ],
    );

    final solution = [
      Header(title: "Vorige Antwoorden: "),
      vierkantWidget,
      rechthoekWidget,
      driehoekWidget,
      cirkelWidget,
      textScore,
      buttonMakeAgain,
      buttonLeerpad
    ];

    final pages = [exerciseWidgets, exercisesMade, solution];

    //return Scaffold(body: Center(child: Column(children: exerciseWidgets)));

    return Scaffold(
        body: ListView(
      children: pages[page],
    ));
  }
}
