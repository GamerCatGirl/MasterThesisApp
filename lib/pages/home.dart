import 'package:flutter/material.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/meetkunde_ex.dart';
import 'dart:math';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _show_start_exercise = true;
  final ValueNotifier<bool> _makeNewExercise = ValueNotifier<bool>(false);

  //TODO: make difficulties depending on the student
  List Difficulties = ["easy", "medium", "hard"];

  List<String> ImagesEasy = ["Vierkant_Easy.jpg"];

  List<String> ImagesSquare = [
    "Bakery.jpg",
    "Bar.jpg",
    "Beautysalon_.jpg",
    "IceShop.jpg",
    "Lobby.jpg",
    "Paintrstudio2.jpg",
    "Paintstudio.jpg",
    "Room.jpg",
    "Room2.jpg",
    "Room3.jpg",
    "Room4.jpg",
    "Room5.jpg",
    "Vierkant.jpg"
  ];

  String path_images = "assets/images/vierkant/";

  String path_easy_square = "assets/images/Vierkant_Easy.jpg";
  String path_harder_square = "assets/images/Vierkant_Harder.jpg";

  int selectedPage = 0;
  int currentExercise = 1;
  int amountExercises = 0;
  List _pages = [];
  int currentRandom = 0;

  @override
  Widget build(BuildContext context) {
    //print(imageIdx.toString() + "\n");
    List<String> images = [path_easy_square, path_harder_square];
    int amountDifficulties = Difficulties.length;

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

    VoidCallback newExercise = () {
      print("Parent knows that action is done");
      _makeNewExercise.value = true;
    };

    void generateInt() {
      currentRandom = Random().nextInt(98) + 2;
    }

    bool randomBool() {
      int x = Random().nextInt(2);
      if (x == 0) {
        return false;
      } else {
        return true;
      }
    }

    void setupImages(String difficulty) {
      if (difficulty == "easy") {
        images = ImagesEasy;
      } else {
        images = ImagesSquare;
      }
    }

    bool displayFormula(difficulty) {
      if (difficulty == "easy") {
        return true;
      } else {
        return randomBool();
      }
    }

    _makeNewExercise.addListener(() {
      print("Value is changed");
      if (_makeNewExercise.value) {
        int random = Random().nextInt(98) + 2;
        int imageIdx = Random().nextInt(2);
        ////...
        int difficultyIdx = Random().nextInt(amountDifficulties);
        String difficulty = Difficulties[difficultyIdx];
        setupImages(difficulty);

        int length = images.length;
        int imageIdxNew = Random().nextInt(length);
        bool formula = displayFormula(difficulty); //TODO: implement in ex
        //......
        String image = images[imageIdx];
        String pathImage = path_images + difficulty + "/" + image;
        this.currentExercise += 1;
        print("random: " + random.toString() + "\n");
        _pages.add(MeetkundeEx(
          z: random,
          callback: newExercise,
          image: pathImage,
          figure: 'vierkant',
          amountExercises: amountExercises,
          currentExercise: this.currentExercise,
        ));
        print(_pages);
        setState(() {
          selectedPage += 1;
          print(selectedPage);
        });
        _makeNewExercise.value = false;
      }
    });

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
            child: StartExercise(
              typeOefeningen: "Meetkunde",
              onStartClicked: (amount) {
                _pages.add(new MeetkundeEx(
                  z: Random().nextInt(98) + 2,
                  figure: 'vierkant',
                  image: path_easy_square,
                  callback: newExercise,
                  amountExercises: amount,
                  currentExercise: this.currentExercise,
                ));
                setState(() {
                  amountExercises = amount;
                  selectedPage = 1;
                });
              },
            ),
            visible: _show_start_exercise,
          )
        ]),
      ),
    );

    if (_pages.isEmpty) {
      _pages.add(homePage);
    }
    // TODO: implement build
    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
