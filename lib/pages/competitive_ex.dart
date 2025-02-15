import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';

class CompetitiveEx extends StatefulWidget {
  final VoidCallback callback;
  final int z;
  final int amountExercises;
  final int currentExercise;
  final String image;
  final String figure;

  const CompetitiveEx(
      {super.key,
      required this.z,
      required this.currentExercise,
      required this.amountExercises,
      required this.image,
      required this.figure,
      required this.callback});

  @override
  State<CompetitiveEx> createState() => new _CompetitiveState();
}

class _CompetitiveState extends State<CompetitiveEx> {
  final _show_start_exercise = true;
  int size = Random().nextInt(98) + 2; //number between 2 and 100
  String errorCode = "";
  final TextEditingController zijde1 = TextEditingController();
  final TextEditingController zijde2 = TextEditingController();
  final TextEditingController oppervlakte = TextEditingController();
  //TODO: hou een lijst bij van de exercises

  @override
  Widget build(BuildContext context) {
    //Widget iconButton = IconButton(onPressed: (){}), icon: icon);
    final vierkant =
        Image(fit: BoxFit.fitWidth, image: AssetImage(widget.image));

    String story =
        "We willen de oppervlakte van de vloer van ons nieuw kapsalon berekenen. \nWe weten dat 1 zijde " +
            widget.z.toString() +
            "m lang is, hoeveel is dan de oppervlakte van onze vloer?";

    var input1Field = TextFormField(
      controller: zijde1,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'z',
      ),
    );
    var input2Field = TextFormField(
      controller: zijde2,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'z',
      ),
    );
    var input3Field = TextFormField(
      controller: oppervlakte,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Opp',
      ),
    );

    String varAssign = "z = " + widget.z.toString() + "m";

    Widget storyText = Text(story);
    Widget vars = Text(
      varAssign,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    bool checkResult() {
      if (zijde1.text != widget.z.toString()) {
        setState(() {
          errorCode =
              "de ingevulde zijde (z) komt niet overeen met de werkelijke zijde (input 1)";
        });
        return false;
      } else if (zijde2.text != widget.z.toString()) {
        setState(() {
          errorCode =
              "de ingevulde zijde (z) komt niet overeen met de werkelijke zijde (input 2)";
        });
        return false;
      } else if (oppervlakte.text != (widget.z * widget.z).toString()) {
        print((widget.z * widget.z).toString());
        setState(() {
          errorCode =
              "de oppervlakte is niet juist berekend, maar zijde 1 en 2 kloppen, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }
      setState(() {
        errorCode = "";
      });

      //TODO: callback to make new ex
      widget.callback();
      setState(() {
        zijde1.text = "";
        zijde2.text = "";
        oppervlakte.text = "";
      });
      return true;
    }

    // TODO: implement build
    return Column(children: [
      Row(
        children: [
          Spacer(),
          Text("Exercise " +
              widget.currentExercise.toString() +
              " out of " +
              widget.amountExercises.toString()),
          Spacer(),
        ],
      ),
      Row(
        children: [Spacer(), vierkant, Spacer()],
      ),
      storyText,
      vars,
      Row(children: [
        Spacer(),
        SizedBox(width: 40, child: input1Field),
        Text("m"),
        Text("  X  "),
        SizedBox(
          width: 40,
          child: input2Field,
        ),
        Text("m"),
        Text("  =  "),
        SizedBox(
          width: 50,
          child: input3Field,
        ),
        Text("m\u00B2"),
        Spacer(),
        IconButton(
            onPressed: () {
              checkResult();
            },
            icon: Icon(Icons.done)),
        Spacer()
      ]),
      Text(
        errorCode,
        style: TextStyle(color: Colors.red),
      ),
      //])
    ]);
  }
}
