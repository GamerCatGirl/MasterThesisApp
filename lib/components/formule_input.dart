import 'package:flutter/material.dart';

class FormuleInputTile extends StatefulWidget {
  final VoidCallback onTileClicked;
  final IconData icon;
  final String name;

  const FormuleInputTile(
      {super.key,
      required this.onTileClicked,
      required this.icon,
      required this.name});

  @override
  State<FormuleInputTile> createState() => _FormuleInputTileState();
}

class _FormuleInputTileState extends State<FormuleInputTile> {
  final TextEditingController inputText = TextEditingController();
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
  @override
  Widget build(BuildContext context) {
    var inputField = TextFormField(
      controller: inputText,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Formule Figuur',
      ),
    );

    return Row(children: [
      Spacer(),
      Icon(
        widget.icon,
        size: 60,
      ),
      SizedBox(width: 130, child: inputField),
      //TODO: question mark/ tip
      //TODO: check answer
      Spacer(),
    ]);
  }
}
