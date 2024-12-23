import 'package:flutter/material.dart';

class FigureInputTile extends StatefulWidget {
  final IconData icon;
  final String name;
  final bool showAnswers;
  final TextEditingController result;

  const FigureInputTile(
      {super.key,
      required this.showAnswers,
      required this.result,
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
      controller: widget.result,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Naam figuur',
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
      SizedBox(width: 100, child: inputField),
      //TODO: question mark

      //TODO: show answer
      answer,

      Spacer(),
    ]);
  }
}
