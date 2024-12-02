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

  @override
  Widget build(BuildContext context) {
    var inputField = TextFormField(
      controller: inputVierkant,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Naam figuur',
      ),
    );

    return Scaffold(
        body: Center(
            child: Column(children: [
      Text("Oppervlakte"),
      Spacer(),
      Text("Ken je alle onderstaande figuren?"),
      FigureInputTile(
          onTileClicked: () {}, icon: iconVierkantEx, name: "Vierkant"),
      FigureInputTile(
          onTileClicked: () {}, icon: iconRectangle, name: "Rechthoek"),
      FigureInputTile(
          onTileClicked: () {}, icon: iconTriangleEx, name: "Driehoek"),
      FigureInputTile(onTileClicked: () {}, icon: iconCirlceEx, name: "Cirkel"),
      Text("Welke formules ken je nog voor de oppervlakte?"),
      FormuleInputTile(
          onTileClicked: () {}, icon: iconVierkantEx, name: "Vierkant"),
      FormuleInputTile(
          onTileClicked: () {}, icon: iconRectangle, name: "Rechthoek"),
      FormuleInputTile(
          onTileClicked: () {}, icon: iconTriangleEx, name: "Driehoek"),
      FormuleInputTile(
          onTileClicked: () {}, icon: iconCirlceEx, name: "Cirkel"),
      Text(
          "Geen zorgen als je niet alle antwoorden wist, ik zal je helpen bij het leren van deze formules!"),
      Spacer(),
    ])));
  }
}
