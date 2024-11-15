import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class StartExercise extends StatefulWidget {
  final String typeOefeningen;
  final void Function(int) onStartClicked;

  const StartExercise(
      {super.key, required this.typeOefeningen, required this.onStartClicked});

  @override
  State<StartExercise> createState() => _StartExerciseState();
}

class _StartExerciseState extends State<StartExercise> {
  List<Widget> toShow = [];
  List<TextEditingController> controllers = [];
  List<String> list = <String>['Oefen', 'Timed', 'Against'];
  List<String> tijdsduur = <String>['30s', '60s', '120s', '300s'];
  List<String> aantalOef = <String>['10', '20', '50', '100'];
  List<String> keuzeSelector2 = <String>['10', '20', '50', '100'];
  String typeOefening = "Oefen";
  String aantalOrTijd = "10";

  @override
  Widget build(BuildContext context) {
    Widget dropdownType = DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          typeOefening = value!;
          aantalOrTijd = "";
          if (value == "Oefen") {
            keuzeSelector2 = aantalOef;
          } else if (value == "Timed") {
            keuzeSelector2 = tijdsduur;
          }
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );

    Widget dropdownSecond = DropdownMenu<String>(
      initialSelection: list.first,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          aantalOrTijd = value!;
        });
      },
      dropdownMenuEntries:
          keuzeSelector2.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
    );

    var startButton = Center(
      child: ElevatedButton(
        child: Text("Start"),
        style: ElevatedButton.styleFrom(
          elevation: 3,
        ),
        onPressed: () {
          //TODO: post to database
          int amount = int.parse(aantalOrTijd);
          widget.onStartClicked(amount);
        },
      ),
    );

    var typeOefeningText = Text("Type oefening:  ");
    var tijdOrAantalText = Text("Tijd of aantal:   ");

    // TODO: implement build
    return Positioned(
      left: 10,
      right: 10,
      top: 113,
      child: Container(
        width: 150,
        child: Column(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 10),
              child: Column(children: [
                Row(
                  children: [
                    typeOefeningText,
                    dropdownType,
                  ],
                ),
                Row(
                  children: [
                    tijdOrAantalText,
                    dropdownSecond,
                  ],
                ),
                startButton
              ]),
            ),
            //TODO: on the image add the duration of exercise
          ],
        ),
        decoration: BoxDecoration(
            color: Color.fromRGBO(245, 230, 255, 1),
            borderRadius: BorderRadius.circular(15)),
      ),
    );
  }
}
