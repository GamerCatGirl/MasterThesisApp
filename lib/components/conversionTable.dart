import 'package:flutter/material.dart';
import 'package:mathapp/components/conv_input.dart';
import 'package:mathapp/components/formule_input.dart';
import 'package:mathapp/components/subtitle.dart';
import 'package:mathapp/components/title.dart';

class Conversiontable extends StatefulWidget {
  final void Function(String) done;
  final bool checkCorrectFilled;
  final List<String> result;
  const Conversiontable(
      {super.key,
      required this.done,
      required this.checkCorrectFilled,
      required this.result});

  @override
  State<Conversiontable> createState() => new _ConversionTableState();
}

class _ConversionTableState extends State<Conversiontable> {
  //FirebaseFirestore db = FirebaseFirestore.instance;
  //CollectionReference dbExercises = db.collection("MeetkundeResults");
  //CollectionReference dbExercises = db.collection("MeetkundeResults");
  //TODO: check add_exercise.dart for more info on how to connect with DB
  final widthColumns = <int, TableColumnWidth>{
    0: IntrinsicColumnWidth(),
    1: FixedColumnWidth(128),
    2: FixedColumnWidth(128),
    3: FixedColumnWidth(128),
    4: FixedColumnWidth(128),
    5: FixedColumnWidth(128),
    6: FixedColumnWidth(128),
    7: FixedColumnWidth(128),
  };

  IconData iconRectangle = Icons.crop_16_9_outlined;
  final TextEditingController km1 = TextEditingController();
  final TextEditingController km2 = TextEditingController();
  final TextEditingController ha1 = TextEditingController();
  final TextEditingController ha2 = TextEditingController();
  final TextEditingController a1 = TextEditingController();
  final TextEditingController a2 = TextEditingController();
  final TextEditingController m1 = TextEditingController();
  final TextEditingController m2 = TextEditingController();
  final TextEditingController dm1 = TextEditingController();
  final TextEditingController dm2 = TextEditingController();
  final TextEditingController cm1 = TextEditingController();
  final TextEditingController cm2 = TextEditingController();
  final TextEditingController mm1 = TextEditingController();
  final TextEditingController mm2 = TextEditingController();

  final Color purple = Color.fromARGB(255, 218, 188, 255);
  final Color purple2 = Color.fromARGB(100, 229, 208, 255);
  final Color white = Colors.white;

  @override
  Widget build(BuildContext context) {
    if (widget.checkCorrectFilled) {
      //TODO:
      List<String> filledIn = [
        km1.text,
        km2.text,
        ha1.text,
        ha2.text,
        a1.text,
        a2.text,
        m1.text,
        m2.text,
        dm1.text,
        dm2.text,
        cm1.text,
        cm2.text,
        mm1.text,
        mm2.text
      ];

      print("Testing");

      bool isEmpty = true;
      int faultOn = -1;

      var resultMap = widget.result;

      filledIn.asMap().forEach((index, elm) {
        if (elm != "") {
          isEmpty = false;
        }
        ;
        if (faultOn < 0 && resultMap[index] != elm) {
          faultOn = index;
        }
        ;
      });

      if (isEmpty) {
        widget.done("Nothing filled in");
      } else if (faultOn > -1) {
        widget.done("fault on index: " + faultOn.toString());
      } else {
        widget.done("correct");
      }
    }

    return Table(
      border: TableBorder.all(),
      columnWidths: widthColumns,
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: <TableRow>[
        TableRow(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 218, 188, 255),
          ),
          children: <Widget>[
            Container(
              height: 32,
              child: Center(child: Text("km^2")),
            ),
            Container(
              child: Center(
                child: Text("10 000 km^2 (ha)"),
              ),
            ),
            Container(
              child: Center(child: Text("100 m^2 (a)")),
            ),
            Container(
              child: Center(child: Text("m^2 (ca)")),
            ),
            Container(
              child: Center(child: Text("dm^2")),
            ),
            Container(
              child: Center(child: Text("cm^2")),
            ),
            Container(
              child: Center(child: Text("mm^2")),
            ),
          ],
        ),
        TableRow(
          decoration: const BoxDecoration(
            color: Color.fromARGB(100, 229, 208, 255),
          ),
          children: <Widget>[
            Container(
              child: Row(
                children: [
                  ConvInput(controller: km1, color: white),
                  ConvInput(
                    controller: km2,
                    color: purple2,
                  )
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  ConvInput(controller: ha1, color: white),
                  ConvInput(
                    controller: ha2,
                    color: purple2,
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  ConvInput(controller: a1, color: white),
                  ConvInput(
                    controller: a2,
                    color: purple2,
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  ConvInput(controller: m1, color: white),
                  ConvInput(
                    controller: m2,
                    color: purple2,
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  ConvInput(controller: dm1, color: white),
                  ConvInput(
                    controller: dm2,
                    color: purple2,
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  ConvInput(controller: cm1, color: white),
                  ConvInput(
                    controller: cm2,
                    color: purple2,
                  )
                ],
              ),
            ),
            Center(
              child: Row(
                children: [
                  ConvInput(controller: mm1, color: white),
                  ConvInput(
                    controller: mm2,
                    color: purple2,
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
