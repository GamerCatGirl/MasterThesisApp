import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/meetkunde_ex.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _show_start_exercise = true;
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final List _exercises = [
      ExerciseTile(nameExercise: "Exercise 1"),
      ExerciseTile(nameExercise: "Exercise 2"),
      ExerciseTile(nameExercise: "Exercise 3"),
      ExerciseTile(nameExercise: "Exercise 4"),
    ];

    final GlobalKey<IconButtonSwitchState> tileKey1 =
        GlobalKey<IconButtonSwitchState>();
    final GlobalKey<IconButtonSwitchState> tileKey2 =
        GlobalKey<IconButtonSwitchState>();

    IconButtonSwitch meetkunde = IconButtonSwitch(
      key: tileKey1,
      nameExercise: "Meetkunde",
      icon: Icons.design_services_outlined,
      onTileClicked: () {
        //clickedOn1.value = true;
        print("type1");
      },
      visibility: true,
    );

    IconButtonSwitch hoofdrekenen = IconButtonSwitch(
      key: tileKey2,
      nameExercise: "Hoofdrekenen",
      icon: Icons.calculate_outlined,
      onTileClicked: () {
        //clickedOn1.value = true;
        print("type1");
      },
      visibility: true,
    );

    final homePage = Scaffold(
      body: Center(
        child: Stack(children: [
          Row(
            children: [Spacer(), hoofdrekenen, meetkunde, Spacer()],
          ),
          Visibility(
            //TODO: visibility doesn't change yet
            child: StartExercise(
              typeOefeningen: "Meetkunde",
              onStartClicked: () {
                setState(() {
                  selectedPage = 1;
                });
              },
            ),
            visible: _show_start_exercise,
          )
        ]),
      ),
    );

    final List _pages = [homePage, MeetkundeEx()];

    // TODO: implement build
    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
