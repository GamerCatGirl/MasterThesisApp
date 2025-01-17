import 'package:flutter/material.dart';

class FigureInputTile extends StatefulWidget {
  final IconData icon;
  final String name;
  final bool showAnswers;
  final void Function(bool) saveResult;
  final TextEditingController controller;

  const FigureInputTile(
      {super.key,
      required this.showAnswers,
      required this.saveResult,
      required this.controller,
      required this.icon,
      required this.name});

  @override
  State<FigureInputTile> createState() => _FigureInputTileState();
}

class _FigureInputTileState extends State<FigureInputTile> {
  var iconCheck = Icons.check;
  var iconWrong = Icons.close;
  var answer = SizedBox(child: Text(""));
  @override
  Widget build(BuildContext context) {
    var inputField = TextFormField(
      controller: widget.controller,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Naam figuur',
      ),
    );

    if (widget.showAnswers) {
      if (widget.name.toUpperCase() ==
          widget.controller.value.text.toUpperCase().trim()) {
        answer = SizedBox(
            child: Icon(
          iconCheck,
          color: Colors.green,
        ));
        widget.saveResult(true);
      } else {
        answer = SizedBox(
            child: Icon(
          iconWrong,
          color: Colors.red,
        ));
        widget.saveResult(false);
      }
    }

    return Row(children: [
      Spacer(),
      Icon(
        widget.icon,
        size: 60,
      ),
      SizedBox(width: 100, child: inputField),
      //TODO: question mark

      //TODO: show answer
      answer,

      Spacer(),
    ]);
  }
}
