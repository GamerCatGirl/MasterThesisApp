import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';

class MeetkundeEx extends StatefulWidget {
  const MeetkundeEx({super.key});

  @override
  State<MeetkundeEx> createState() => _MeetkundeExState();
}

class _MeetkundeExState extends State<MeetkundeEx> {
  final _show_start_exercise = true;
  int size = Random().nextInt(98) + 2; //number between 2 and 100
  String errorCode = "";
  final TextEditingController zijde1 = TextEditingController();
  final TextEditingController zijde2 = TextEditingController();
  final TextEditingController oppervlakte = TextEditingController();
  //TODO: hou een lijst bij van de exercises
  final vierkant = Image(
      fit: BoxFit.fitWidth,
      image: AssetImage('assets/images/Vierkant_Easy.jpg'));

  @override
  Widget build(BuildContext context) {
    //Widget iconButton = IconButton(onPressed: (){}), icon: icon);
    String story =
        "We willen de oppervlakte van de vloer van ons nieuw kapsalon berekenen. \nWe weten dat 1 zijde " +
            size.toString() +
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

    String varAssign = "z = " + size.toString() + "m";

    Widget storyText = Text(story);
    Widget vars = Text(varAssign);

    bool checkResult() {
      if (zijde1.text != size.toString()) {
        setState(() {
          errorCode =
              "de ingevulde zijde (z) komt niet overeen met de werkelijke zijde (input 1)";
        });
        return false;
      } else if (zijde2.text != size.toString()) {
        setState(() {
          errorCode =
              "de ingevulde zijde (z) komt niet overeen met de werkelijke zijde (input 2)";
        });
        return false;
      } else if (oppervlakte.text != (size * size).toString()) {
        print((size * size).toString());
        setState(() {
          errorCode =
              "de oppervlakte is niet juist berekend, maar zijde 1 en 2 kloppen, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }
      setState(() {
        errorCode = "";
      });
      return true;
    }

    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Column(children: [
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
          Text(errorCode),
          //])
        ]),
      ),
    );
  }
}
