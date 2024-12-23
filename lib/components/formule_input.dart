import 'package:flutter/material.dart';

class FormuleInputTile extends StatefulWidget {
  final TextEditingController result;
  final IconData icon;
  final String name;
  final bool showAnswers;

  const FormuleInputTile(
      {super.key,
      required this.result,
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

  @override
  Widget build(BuildContext context) {
    if (widget.name.toLowerCase() == "vierkant") {
      formule = formuleVierkant;
      formule2 = formuleVierkant;
    } else if (widget.name.toLowerCase() == "rechthoek") {
      formule = formuleRechthoek;
      formule2 = formuleRechthoek2;
    } else if (widget.name.toLowerCase() == "driehoek") {
      formule = formuleDriehoek;
      formule2 = formuleDriehoek2;
    } else if (widget.name.toLowerCase() == "cirkel") {
      formule = formuleCirkel;
      formule2 = formuleCirkel2;
    }

    var inputField = TextFormField(
      controller: widget.result,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Formule Figuur',
      ),
    );

    if (widget.showAnswers) {
      if (widget.name.toUpperCase() ==
          widget.result.value.text.toUpperCase().trim()) {
        answer = SizedBox(
            child: Icon(
          iconCheck,
          color: Colors.green,
        ));
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
      //TODO: question mark/ tip
      //TODO: check answer
      Spacer(),
    ]);
  }
}
