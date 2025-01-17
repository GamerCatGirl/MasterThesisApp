import 'package:flutter/material.dart';

class FormuleInputTile extends StatefulWidget {
  final TextEditingController controller;
  final IconData icon;
  final String name;
  final bool showAnswers;
  final void Function(bool) saveResult;

  const FormuleInputTile(
      {super.key,
      required this.controller,
      required this.saveResult,
      required this.icon,
      required this.name,
      required this.showAnswers});

  @override
  State<FormuleInputTile> createState() => _FormuleInputTileState();
}

class _FormuleInputTileState extends State<FormuleInputTile> {
  final TextEditingController inputText = TextEditingController();
  var answer = SizedBox(child: Text(""));

  String tipVierkant = "Gebruik z";
  String tipRechthoek = "Gebruik l en b";
  String tipCirkel = "Gebruik staal of diameter";
  String tipCirkel2 = "Gebruik 3.14";
  String tipDriehoek = "Gebruik b en h";
  String tipDriehoek2 = "Er is een deling door 2";

  String formuleVierkant = "zxz";
  String formuleRechthoek = "lxb";
  String formuleRechthoek2 = "bxl";
  String formuleCirkel = "straalxstraalx3,14";
  String formuleCirkel2 = "diameterx3,14";
  String formuleDriehoek = "(bxh):2";
  String formuleDriehoek2 = "(hxb):2";

  IconData iconHint = Icons.question_mark;
  IconData iconCheck = Icons.check;
  IconData iconWrong = Icons.close;

  var formule = "";
  var formule2 = "";
  var hint1 = "";
  var hint2 = "";
  var amountHints = 1;
  var iconHintPlacer = SizedBox(
      child: IconButton(onPressed: () {}, icon: Icon(Icons.question_mark)));
  var currentHint = 0;
  var showHintText = Text("");

  @override
  Widget build(BuildContext context) {
    var input = widget.controller.text;
    var inputWithoutSpaces = input.replaceAll(' ', '');

    if (widget.name.toLowerCase() == "vierkant") {
      formule = formuleVierkant;
      formule2 = formuleVierkant;
      hint1 = tipVierkant;
    } else if (widget.name.toLowerCase() == "rechthoek") {
      formule = formuleRechthoek;
      formule2 = formuleRechthoek2;
      hint1 = tipRechthoek;
    } else if (widget.name.toLowerCase() == "driehoek") {
      formule = formuleDriehoek;
      formule2 = formuleDriehoek2;
      hint1 = tipDriehoek;
      hint2 = tipDriehoek2;
      amountHints = 2;
    } else if (widget.name.toLowerCase() == "cirkel") {
      formule = formuleCirkel;
      formule2 = formuleCirkel2;
      hint1 = tipCirkel;
      hint2 = tipCirkel2;
      amountHints = 2;
    }

    void shuffleHint() {
      if (currentHint == 0) {
        currentHint += 1;
        setState(() {
          showHintText = Text(hint1);
        });
      } else if (currentHint == 1 && amountHints == 1 || (currentHint == 2)) {
        currentHint += 1;
        setState(() {
          showHintText = Text(
              "All hints have been given, press again to show hints again");
        });
      } else if ((currentHint == 2 && amountHints == 1) || (currentHint == 3)) {
        currentHint = 1;
        setState(() {
          showHintText = Text(hint1);
        });
      } else if (currentHint == 1) {
        currentHint += 1;
        setState(() {
          showHintText = Text(hint2);
        });
      } else {
        currentHint = 1;
        setState(() {
          showHintText = Text(hint1);
        });
      }
    }

    iconHintPlacer = SizedBox(
        child: IconButton(
            onPressed: shuffleHint, icon: Icon(Icons.question_mark)));

    var inputField = TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Formule Figuur',
      ),
    );

    var showHint = true;

    if (widget.showAnswers) {
      if ((formule.toUpperCase() == inputWithoutSpaces.toUpperCase()) ||
          (formule2.toUpperCase() == inputWithoutSpaces.toUpperCase())) {
        answer = SizedBox(
            child: Icon(
          iconCheck,
          color: Colors.green,
        ));
        showHint = false;
        iconHintPlacer = SizedBox(child: Text(""));
        showHintText = Text("");
        widget.saveResult(true);
      } else {
        answer = SizedBox(
            child: Icon(
          iconWrong,
          color: Colors.red,
        ));
      }
    }

    return Row(children: [
      Spacer(),
      Icon(
        widget.icon,
        size: 60,
      ),
      SizedBox(width: 130, child: inputField),
      answer,
      iconHintPlacer,
      showHintText,
      //TODO: question mark/ tip
      //TODO: check answer
      Spacer(),
    ]);
  }
}
