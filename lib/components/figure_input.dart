import 'package:flutter/material.dart';

class FigureInputTile extends StatefulWidget {
  final VoidCallback onTileClicked;
  final IconData icon;
  final String name;

  const FigureInputTile(
      {super.key,
      required this.onTileClicked,
      required this.icon,
      required this.name});

  @override
  State<FigureInputTile> createState() => _FigureInputTileState();
}

class _FigureInputTileState extends State<FigureInputTile> {
  final TextEditingController inputText = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var inputField = TextFormField(
      controller: inputText,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Naam figuur',
      ),
    );

    return Row(children: [
      Spacer(),
      Icon(
        widget.icon,
        size: 60,
      ),
      SizedBox(width: 100, child: inputField),
      //TODO: question mark
      //TODO: check answer
      Spacer(),
    ]);
  }
}
