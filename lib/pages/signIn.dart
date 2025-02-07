import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathapp/components/rating.dart';
import 'package:mathapp/components/title.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SignInState();
}

class _SignInState extends State<Signin> {
  int selectedPage = 0;

  FirebaseFirestore db = FirebaseFirestore.instance;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repeatPassword = TextEditingController();

  double answerQ1 = 0;
  double answerQ2 = 0;
  double answerQ3 = 0;
  double answerQ4 = 0;
  double answerQ5 = 0;
  double answerQ6 = 0;
  double answerQ7 = 0;
  double answerQ8 = 0;
  double answerQ9 = 0;
  double answerQ10 = 0;

  var skills = [
    "OppVierkant",
    "OppRechthoek",
    "OppCirkel",
    "OppDriehoek",
    "ConversionTableSmaller",
    "ConversionTableBigger"
  ];
  //For each level need to have a value assigned
  var levels = [
    "Remeber",
    "Understand",
    "Analyze",
    "Apply",
    "Evaluate",
    "Create"
  ];

  final String intro =
      "Om zo goed mogelijk oefeningen aan te bieden op jouw niveau volgt een kleine vragenlijst. De antwoorden worden enkel gebruikt voor oefeningen op maat aan te bieden, de antwoorden zijn niet zichtbaar voor medeleering of leerkracht.";

  final String question1 =
      "Hoe leuk vind je wiskunde? (1 helemaal niet leuk, 3 neutraal, 5 super leuk)";
  final String question2 =
      "Hoe nuttig vind je wiskunde (1 helemaal niet nuttig, 3 neutraal, 5 heel nuttig)";
  final String question3 =
      "Hoe moeilijk vind je wiskunde? (1 helemaal niet moeilijk, 5 super moeilijk)";
  final String question4 =
      "Vind je van jezelf dat je goed bent in wiskunde? (1 ik kan het helemaal niet, 3 neutraal, 5 ik kan het heel goed)";
  final String question5 =
      "Vind je van jezelf dat je je best doet voor dit vak? (1 ik doe helemaal mijn best niet, 3 neutraal, 5 ik doe heel hard mijn best)";
  final String question6 =
      "Zijn je punten zoals je ze verwacht (1 ik kan helemaal mijn score niet inschatten, 3 neutraal, 5 punten zijn wat ik verwacht)";
  final String question7 =
      "Hoe gemotiveerd ben je om goede punten te halen voor wiskunde? (1 mijn punten maken me helemaal niet uit, 3 neutraal, 5 ik wil heel graag goede punten)";

  final String question8 =
      "Kan je de oppervlakte van figuren berekenen als je de formule gegeven krijgt? (1 ik weet niet hoe ik zou moeten beginnen, 3 neutraal, 5 oppervlakte berekenen is helemaal niet moeilijk)";
  final String question9 =
      "Ken je de formules voor de oppervlakte van figuren te bereken? (rechthoek, driehoek, cirkel) (1 ik ken geen formule vanbuiten, 3 ik ken sommige formules, 5 ik ken alle formules van de gegeven figuren)";
  final String question10 =
      "Weet je hoe je bovenstaande tabel moet gebruiken om van maateenheid te veranderen? (1 geen idee, 3 half, 5 ik weet hoe ik dit moet gebruiken)";

  String submitError = "";

  @override
  Widget build(BuildContext context) {
    // input text widget
    final userNameWidget = Row(
      children: [
        Spacer(),
        SizedBox(
            width: 300,
            child: TextFormField(
              controller: username,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Username',
              ),
            )),
        Spacer()
      ],
    );

    final passwordWidget = Row(
      children: [
        Spacer(),
        SizedBox(
            width: 300,
            child: TextFormField(
              controller: password,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Wachtwoord',
              ),
            )),
        Spacer()
      ],
    );
    final passwordRepeatWidget = Row(
      children: [
        Spacer(),
        SizedBox(
            width: 300,
            child: TextFormField(
              controller: repeatPassword,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Herhaal Wachtwoord',
              ),
            )),
        Spacer()
      ],
    );
    //
    final q1 = Rating(
        question: question1,
        onChangeRating: (rating) {
          answerQ1 = rating;
        });
    final q2 = Rating(
        question: question2,
        onChangeRating: (rating) {
          answerQ2 = rating;
        });
    final q3 = Rating(
        question: question3,
        onChangeRating: (rating) {
          answerQ3 = rating;
        });
    final q4 = Rating(
        question: question4,
        onChangeRating: (rating) {
          answerQ4 = rating;
        });
    final q5 = Rating(
        question: question5,
        onChangeRating: (rating) {
          answerQ5 = rating;
        });
    final q6 = Rating(
        question: question6,
        onChangeRating: (rating) {
          answerQ6 = rating;
        });
    final q7 = Rating(
        question: question7,
        onChangeRating: (rating) {
          answerQ7 = rating;
        });
    final q8 = Rating(
        question: question8,
        onChangeRating: (rating) {
          answerQ8 = rating;
        });
    final q9 = Rating(
        question: question9,
        onChangeRating: (rating) {
          answerQ9 = rating;
        });
    final q10 = Rating(
        question: question10,
        onChangeRating: (rating) {
          answerQ10 = rating;
        });

    // functions
    Future<bool> validUsername() async {
      CollectionReference dbUsers = db.collection("users");

      final docRef = dbUsers.doc(username.text);

      try {
        DocumentSnapshot doc = await docRef.get();
        if (doc.exists) {
          submitError = "Gebruikersnaam bestaat al!";
          return false;
        } else {
          return true;
        }
      } catch (e) {
        submitError = "Interne error met de database, probeer later opnieuw!";
        return false;
      }
    }

    bool validPassword() {
      String pass = password.text;
      String passControl = repeatPassword.text;

      if (pass != passControl) {
        submitError = "Wachtwoord komt niet overeen!";
        return false;
      } else if (!pass.contains(RegExp(r'[A-Z]'))) {
        submitError = "Wachtwoord bevat geen hoofdletter!";
        return false;
      } else if (!pass.contains(RegExp(r'[0-9]'))) {
        submitError = "Wachtwoord bevat geen getal!";
        return false;
      }

      return true;
    }

    void makeUser() {
      CollectionReference dbUsers = db.collection("users");

      final doc = {"password": password.text};

      dbUsers.doc(username.text).set(doc).onError((e, _) {
        setState(() {
          submitError =
              "Error met gegevens toe te voegen aan database, probeer later opnieuw!";
        });
      });
    }

    ;

    void setupBKT() {
      int fun = answerQ1.round();
      int usefull = answerQ2.round();
      int difficulty = answerQ3.round();
      int score = answerQ4.round();
      int effort = answerQ5.round();
      int pointsReflectEffort = answerQ6.round();
      int motivation = answerQ7.round();
      int applySurface = answerQ8.round();
      int rememberSurface = answerQ9.round();
      int applyTable = answerQ10.round();
    }

    void postToDB() {}
    void redirectToAccountSuccesfullyMade() {}

    //Button to submit
    Future<void> submitAnswers() async {
      var answers = [
        answerQ1,
        answerQ2,
        answerQ3,
        answerQ4,
        answerQ5,
        answerQ6,
        answerQ7,
        answerQ8,
        answerQ9,
        answerQ10
      ];

      bool changed = false;

      answers.forEach((res) => {
            if (res == 0)
              {
                setState(() {
                  changed = true;
                  submitError = "Niet alle vragen zijn beantwoord!";
                })
              }
          });

      if (!changed) {
        if (!(await validUsername())) {
          //TODO
          setState(() {
            submitError;
          });
        } else if (!validPassword()) {
          setState(() {
            submitError;
          });
        } else {
          makeUser();
          setupBKT();
          redirectToAccountSuccesfullyMade();
        }
      }
    }

    ;

    final upload = Row(
      children: [
        Spacer(),
        ElevatedButton(onPressed: submitAnswers, child: Text('Maak Account')),
        SizedBox(
          width: 50,
        ),
        Text(
          submitError,
          style: TextStyle(color: Colors.red),
        ),
        Spacer()
      ],
    );

    //
    final signInLogIn = Center(child: Text("Sign In Page"));
    final page = ListView(
      children: [
        Header(title: "Sign In"),
        userNameWidget,
        passwordWidget,
        passwordRepeatWidget,
        Text(intro),
        q1,
        q2,
        q3,
        q4,
        q5,
        q6,
        q7,
        q8,
        q9,
        q10,
        upload
      ],
    );

    final List _pages = [page];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
