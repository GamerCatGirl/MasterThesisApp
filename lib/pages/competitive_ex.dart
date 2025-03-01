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
  final bool showFormule;
  final String image;
  final String figure;

  const CompetitiveEx(
      {super.key,
      required this.showFormule,
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
  final TextEditingController straal1 = TextEditingController();
  final TextEditingController straal2 = TextEditingController();
  final TextEditingController pi = TextEditingController();

  late String label1;
  late String label2;

  @override
  Widget build(BuildContext context) {
    //Widget iconButton = IconButton(onPressed: (){}), icon: icon);
    double width = MediaQuery.of(context).size.width;

    double widthImage = width / 3 * 2;

    final vierkant = Image(
        fit: BoxFit.cover, width: widthImage, image: AssetImage(widget.image));

    String story = //TODO: make this dynamic depending on image!
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

    var input1FieldCirkel = TextFormField(
      controller: straal1,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'straal',
      ),
    );

    var input2FieldCirkel = TextFormField(
      controller: straal2,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'straal',
      ),
    );

    var input3FieldCirkel = TextFormField(
      controller: pi,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'pi',
      ),
    );

    String varAssignVierkant = "z = " + widget.z.toString() + "m";

    String varAssignCirkel = "straal = " + widget.z.toString() + "m";

    String varAssign = (widget.figure == "vierkant")
        ? varAssignVierkant
        : (widget.figure == "cirkel")
            ? varAssignCirkel
            : varAssignVierkant;

    Widget storyText = Text(story);
    Widget vars = Text(
      varAssign,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    bool checkResultCirkel() {
      if (straal1.text != widget.z.toString()) {
        setState(() {
          errorCode =
              "de ingevulde straal (r) komt niet overeen met de werkelijke straal (input 1)";
        });
        return false;
      } else if (straal2.text != widget.z.toString()) {
        setState(() {
          errorCode =
              "de ingevulde straal (r) komt niet overeen met de werkelijke straal (input 2)";
        });
        return false;
      } else if (pi.text != "3,14" && pi.text != "3.14") {
        setState(() {
          errorCode =
              "de ingevulde constante (pi) komt niet overeen met de werkelijke waarde (input 3)";
        });
        return false;
      } else {
        double oppervlakteVal = widget.z * widget.z * 3.14;
        String oppervlakteNumber = oppervlakte.text.replaceAll(",", ".");
        double oppervlakteFilledin = double.parse(oppervlakteNumber);

        var rounded1 = (oppervlakteVal * 100).round();
        var rounded2 = (oppervlakteFilledin * 100).round();

        if (rounded1 != rounded2) {
          setState(() {
            errorCode =
                "de oppervlakte is niet juist berekend, maar de straal en constante kloppen, probeer opnieuw, je bent er bijna :)";
          });
          return false;
        }
      }

      setState(() {
        errorCode = "";
      });
      //TODO: callback to make new ex
      widget.callback();
      setState(() {
        straal1.text = "";
        straal2.text = "";
        pi.text = "";
        oppervlakte.text = "";
      });
      return true;
    }

    bool checkResultVierkant() {
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

    bool checkResult() {
      if (widget.figure == "vierkant") {
        return checkResultVierkant();
      } else if (widget.figure == "cirkel") {
        return checkResultCirkel();
      } else {
        return false;
      }
    }

    var rowVierkant = [
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
    ];

    var rowCirkel = [
      Spacer(),
      SizedBox(
        width: 60,
        child: input1FieldCirkel,
      ),
      Text("m"),
      Text("  X  "),
      SizedBox(
        width: 60,
        child: input2FieldCirkel,
      ),
      Text("m"),
      Text("  X  "),
      SizedBox(
        width: 40,
        child: input3FieldCirkel,
      ),
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
    ];

    var row = (widget.figure == "vierkant")
        ? rowVierkant
        : (widget.figure == "cirkel")
            ? rowCirkel
            : rowVierkant;

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
      Row(children: row),
      Text(
        errorCode,
        style: TextStyle(color: Colors.red),
      ),
      //])
    ]);
  }
}
