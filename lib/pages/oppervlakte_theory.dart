import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/figure_input.dart';
import 'package:mathapp/components/formule_input.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';

class OppervlakteTheory extends StatefulWidget {
  final VoidCallback done;
  const OppervlakteTheory({super.key, required this.done});

  @override
  State<OppervlakteTheory> createState() => new _OppervlakteTheoryState();
}

class _OppervlakteTheoryState extends State<OppervlakteTheory> {
  IconData iconVierkantEx = Icons.square_outlined;
  IconData iconTriangleEx = Icons.change_history_sharp;
  IconData iconCirlceEx = Icons.circle_outlined;
  IconData iconRectangle = Icons.crop_16_9_outlined;

  //FirebaseFirestore db = FirebaseFirestore.instance;
  //CollectionReference dbExercises = db.collection("MeetkundeResults");
  //CollectionReference dbExercises = db.collection("MeetkundeResults");
  //TODO: check add_exercise.dart for more info on how to connect with DB

  final meetkundeLevel = <String, dynamic>{
    "studentID": "Admin",
  };

  final meetkundeResults = <String, dynamic>{
    "studentID": "Admin",
  };

  final TextEditingController inputVierkant = TextEditingController();
  final TextEditingController inputRechthoek = TextEditingController();
  final TextEditingController inputDriehoek = TextEditingController();
  final TextEditingController inputCirkel = TextEditingController();
  final TextEditingController inputVierkantFormule = TextEditingController();
  final TextEditingController inputRechthoekFormule = TextEditingController();
  final TextEditingController inputDriehoekFormule = TextEditingController();
  final TextEditingController inputCirkelFormule = TextEditingController();

  bool showAnswers = false;

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
    //TODO:
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
        driehoekFormule == "" ||
        cirkelFormule == "") {
      setState(() {
        error =
            "Please fill in all fields, if you don't know the answer fill in '/'";
      });
    } else {
      setState(() {
        showAnswers = true;
      });

      // post the results
      var time = DateTime.now();
      meetkundeLevel["date"] = time;
      meetkundeResults["date"] = time;

      print(meetkundeLevel);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(children: [
      Text("Oppervlakte"),
      Spacer(),
      Text("Ken je alle onderstaande figuren?"),
      FigureInputTile(
          controller: inputVierkant,
          saveResult: (res) {
            meetkundeLevel["vierkantName"] = res;
            meetkundeResults["vierkantName"] = inputVierkant.text;
          },
          showAnswers: showAnswers,
          icon: iconVierkantEx,
          name: "Vierkant"),
      FigureInputTile(
          controller: inputRechthoek,
          saveResult: (res) {
            meetkundeLevel["rechthoekName"] = res;
            meetkundeResults["rechthoekName"] = inputRechthoek.text;
          },
          showAnswers: showAnswers,
          icon: iconRectangle,
          name: "Rechthoek"),
      FigureInputTile(
          controller: inputDriehoek,
          saveResult: (res) {
            meetkundeLevel["driehoekName"] = res;
            meetkundeResults["driehoekName"] = inputDriehoek.text;
          },
          showAnswers: showAnswers,
          icon: iconTriangleEx,
          name: "Driehoek"),
      FigureInputTile(
          controller: inputCirkel,
          saveResult: (res) {
            meetkundeLevel["cirkelName"] = res;
            meetkundeResults["cirkelName"] = inputCirkel.text;
          },
          showAnswers: showAnswers,
          icon: iconCirlceEx,
          name: "Cirkel"),
      Spacer(),
      Text("Welke formules ken je nog voor de oppervlakte?"),
      FormuleInputTile(
          controller: inputVierkantFormule,
          saveResult: (res) {
            meetkundeLevel["vierkantFormule"] = res;
            meetkundeResults["vierkantFormule"] = inputVierkantFormule.text;
          },
          showAnswers: showAnswers,
          icon: iconVierkantEx,
          name: "Vierkant"),
      FormuleInputTile(
          controller: inputRechthoekFormule,
          saveResult: (res) {
            meetkundeLevel["rechthoekFormule"] = res;
            meetkundeResults["rechthoekFormule"] = inputRechthoekFormule.text;
          },
          showAnswers: showAnswers,
          icon: iconRectangle,
          name: "Rechthoek"),
      FormuleInputTile(
          controller: inputDriehoekFormule,
          saveResult: (res) {
            //meetkundeLevel["driehoekFormule"] = res;
            //meetkundeResults["driehoekFormule"] = inputDriehoekFormule.text;
          },
          showAnswers: showAnswers,
          icon: iconTriangleEx,
          name: "Driehoek"),
      FormuleInputTile(
          controller: inputCirkelFormule,
          saveResult: (res) {
            meetkundeLevel["cirkelFormule"] = res;
            meetkundeResults["cirkelFormule"] = inputCirkelFormule.text;
            print(meetkundeLevel);
            print(meetkundeResults);
          },
          showAnswers: showAnswers,
          icon: iconCirlceEx,
          name: "Cirkel"),
      Spacer(),
      Text(
          "Geen zorgen als je niet alle antwoorden wist, ik zal je helpen bij het leren van deze formules!"),
      Spacer(),
      ElevatedButton(
          onPressed: checkResults, child: Text('Controleer Antwoorden')),
      Text(error, style: TextStyle(color: Colors.red)),
      Spacer(),
    ])));
  }
}
