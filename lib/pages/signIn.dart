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
  int selectedOption = 1;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repeatPassword = TextEditingController();

  bool learningDisability = false;
  double pKnown = 0;
  double pLearn = 0;

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

  Color iconColorCheck = Colors.grey;
  Color iconColorWrong = Colors.grey;

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
      "Hoe interesant vind je wiskunde? (1 helemaal niet leuk, 3 neutraal, 5 super leuk)";
  final String question2 = "Heb je ADHD/ADD/Dyslexie/...?";
  final String question3 =
      "Hoe moeilijk vind je wiskunde? (1 helemaal niet moeilijk, 5 super moeilijk)";
  final String question4 =
      "Hoe zijn je punten voor wiskunde? (1 ik heb altijd buizen, 3 net geslaagd, 4 meer dan 60%, 5 ik heb boven 80%)";
  final String question6 =
      "Zijn je punten zoals je ze verwacht (1 ik kan helemaal mijn score niet inschatten, 3 neutraal, 5 punten zijn wat ik verwacht)";
  final String question7 =
      "Hoe gemotiveerd ben je om goede punten te halen voor wiskunde? (1 mijn punten maken me helemaal niet uit, 3 neutraal, 5 ik wil heel graag goede punten)";

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
    final q2 = Row(
      children: [
        Spacer(),
        Text(question2),
        Spacer(),
        Spacer(),
        Spacer(),
        IconButton(
            onPressed: () {
              answerQ2 = 1;
              learningDisability = true;
              setState(() {
                iconColorWrong = Colors.grey;
                iconColorCheck = Colors.green;
              });
            },
            icon: Icon(
              Icons.check,
              color: iconColorCheck,
            )),
        IconButton(
            onPressed: () {
              answerQ2 = 1;
              learningDisability = false;
              setState(() {
                iconColorCheck = Colors.grey;
                iconColorWrong = Colors.red;
              });
            },
            icon: Icon(
              Icons.close,
              color: iconColorWrong,
            )),
        Spacer()
      ],
    );
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

      final doc = {
        "password": password.text,
        "learningDisability": learningDisability,
        "pknow": pKnown,
        "plearn": pLearn,
      };

      dbUsers.doc(username.text).set(doc).onError((e, _) {
        setState(() {
          submitError =
              "Error met gegevens toe te voegen aan database, probeer later opnieuw!";
        });
      });
    }

    ;

    void setupBKT() {
      int interesting = answerQ1.round();
      int unknown = answerQ2.round();
      int difficulty = answerQ3.round();
      int grades = answerQ4.round();
      int selfAssesment = answerQ6.round();
      int motivation = answerQ7.round();

      final weigthSelfAssesment = 0.01;
      final weigthInterest = 0.005;
      final weigthDifficulty = 0.005;
      final weigthGrades = 0.03;

      final weigthMotivation = 0.005;
      final weigthDifficulty2 = 0.008;

      pKnown = 0.4 +
          (grades * weigthGrades +
              (6 - difficulty) * weigthDifficulty +
              selfAssesment * weigthSelfAssesment +
              interesting * weigthInterest);

      pLearn = 0.52 +
          ((6 - difficulty) * weigthDifficulty2 +
              motivation * weigthMotivation +
              interesting * weigthInterest);

      print("p(known) = " + pKnown.toString());
      print("p(learn) = " + pLearn.toString());
    }

    void postToDB() {}
    void redirectToAccountSuccesfullyMade() {
      setState(() {
        selectedPage = 1;
      });
    }

    //Button to submit
    Future<void> submitAnswers() async {
      var answers = [
        answerQ1,
        answerQ2,
        answerQ3,
        answerQ4,
        answerQ6,
        answerQ7,
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
          setupBKT();
          makeUser();
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
    final accountMadePage = ListView(
      children: [
        Header(title: "Account succesfully made!"),
        Row(
          children: [
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: Text("Login")),
            Spacer(),
          ],
        )
      ],
    );
    final page = ListView(
      children: [
        Header(title: "Sign In"),
        userNameWidget,
        passwordWidget,
        passwordRepeatWidget,
        Text(intro),
        q2,
        q1,
        q3,
        q4,
        q6,
        q7,
        upload
      ],
    );

    final List _pages = [page, accountMadePage];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
