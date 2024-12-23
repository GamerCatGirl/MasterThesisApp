import 'dart:math';

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
          result: inputVierkant,
          showAnswers: showAnswers,
          icon: iconVierkantEx,
          name: "Vierkant"),
      FigureInputTile(
          result: inputRechthoek,
          showAnswers: showAnswers,
          icon: iconRectangle,
          name: "Rechthoek"),
      FigureInputTile(
          result: inputDriehoek,
          showAnswers: showAnswers,
          icon: iconTriangleEx,
          name: "Driehoek"),
      FigureInputTile(
          result: inputCirkel,
          showAnswers: showAnswers,
          icon: iconCirlceEx,
          name: "Cirkel"),
      Spacer(),
      Text("Welke formules ken je nog voor de oppervlakte?"),
      FormuleInputTile(
          result: inputVierkantFormule,
          showAnswers: showAnswers,
          icon: iconVierkantEx,
          name: "Vierkant"),
      FormuleInputTile(
          result: inputRechthoekFormule,
          showAnswers: showAnswers,
          icon: iconRectangle,
          name: "Rechthoek"),
      FormuleInputTile(
          result: inputDriehoekFormule,
          showAnswers: showAnswers,
          icon: iconTriangleEx,
          name: "Driehoek"),
      FormuleInputTile(
          result: inputCirkelFormule,
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
