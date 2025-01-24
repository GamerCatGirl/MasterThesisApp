import 'package:flutter/material.dart';
import 'package:mathapp/components/formule_input.dart';
import 'package:mathapp/components/subtitle.dart';
import 'package:mathapp/components/title.dart';

class ConvInput extends StatefulWidget {
  final TextEditingController controller;
  final Color color;
  const ConvInput({super.key, required this.controller, required this.color});

  @override
  State<ConvInput> createState() => new _ConvState();
}

class _ConvState extends State<ConvInput> {
  //FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 64,
        height: 64,
        child: Center(
            child: SizedBox(
          width: 27,
          child: TextFormField(
            controller: widget.controller,
            style: TextStyle(fontSize: 36),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
          ),
        )),
        color: widget.color);
  }
}
