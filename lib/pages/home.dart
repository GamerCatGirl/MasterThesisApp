import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/Utils/redirections.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/meetkunde_ex.dart';
import 'dart:math';

class Home extends StatefulWidget {
  final String user;

  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

enum Topics { vierkant, rechthoek, cirkel, driehoek, recommended }

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

  final TextEditingController opponent = TextEditingController();
  final TextEditingController partyMake = TextEditingController();
  final TextEditingController partyJoin = TextEditingController();

  ValueNotifier<String> errorSelect = ValueNotifier("");
  ValueNotifier<String> errorFriend = ValueNotifier("");
  ValueNotifier<String> errorParty1 = ValueNotifier("");
  ValueNotifier<String> errorParty2 = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    //print(imageIdx.toString() + "\n");
    List<String> images = [path_easy_square, path_harder_square];
    int amountDifficulties = Difficulties.length;

    List<String> selectedItems = [];

    final topicsSelect = MultiSelectContainer(
        items: [
          MultiSelectCard(value: 'vierkant', label: 'Vierkant'),
          MultiSelectCard(value: 'rechthoek', label: 'Rechthoek'),
          MultiSelectCard(value: 'driehoek', label: 'Driehoek'),
          MultiSelectCard(value: 'cirkel', label: 'Cirkel'),
          MultiSelectCard(value: 'All', label: 'All'),
          MultiSelectCard(value: 'Recommended', label: 'Recommended'),
        ],
        onChange: (allSelectedItems, selectedItem) {
          selectedItems = allSelectedItems;

          if (selectedItems.length > 0) {
            errorSelect.value = "";
          }
        });

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

    final opponentField = SizedBox(
        width: 330,
        child: TextFormField(
          controller: opponent,
          onChanged: (value) => errorFriend.value = "",
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Gebruikersnaam vriend (CAPS sensitive!)',
          ),
        ));

    final partyMakeField = SizedBox(
        width: 300,
        child: TextFormField(
          controller: partyMake,
          onChanged: (value) => errorParty1.value = "",
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Naam Party',
          ),
        ));

    final partyJoinField = SizedBox(
        width: 300,
        child: TextFormField(
          controller: partyJoin,
          onChanged: (value) => errorParty2.value = "",
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Naam Party',
          ),
        ));

    Widget returnError(context, value, child) {
      return Center(
          child: Text(
        value,
        style: TextStyle(color: Colors.red),
      ));
    }

    final errorSelectListener = ValueListenableBuilder<String>(
        valueListenable: errorSelect, builder: returnError);

    final errorFriendListener = ValueListenableBuilder<String>(
        valueListenable: errorFriend, builder: returnError);

    final errorParty1Listener = ValueListenableBuilder<String>(
        valueListenable: errorParty1, builder: returnError);

    final errorParty2Listener = ValueListenableBuilder<String>(
        valueListenable: errorParty2, builder: returnError);

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
          ),
        ]),
      ),
    );

    bool checkSelect() {
      if (selectedItems.length == 0) {
        errorSelect.value = "Selecteer wat je wil oefenen (bovenaan de pagina)";
      }
      return (selectedItems.length > 0);
    }

    Future<bool> checkInput(TextEditingController field,
        ValueNotifier<String> error, String nameField) async {
      if (field.text == "") {
        error.value = "Vul '" + nameField + "' in!";
        return false;
      } else if (nameField == "Gebruikersnaam vriend" &&
          field.text != widget.user) {
        bool userExists = await Database.userExists(field.text);

        if (!userExists) {
          error.value = "Gebruiker bestaat niet";
        }

        return userExists;
      } else if (field == partyMake) {
        bool partyExists = await Database.partyExists(field.text);
        if (partyExists) {
          error.value = "Party bestaat al";
          return false;
        } else {
          Database.makeParty(field.text, [widget.user], selectedItems);
          return true;
        }
      } else if (nameField == "Naam Party") {
        bool partyExists = await Database.partyExists(field.text);

        if (!partyExists) {
          error.value = "Party bestaat niet";
        }
        return partyExists;
      } else {
        return false;
      }
    }

    void playRandom() {
      if (checkSelect()) {}
    }

    void playBot() {
      if (checkSelect()) {}
    }

    void playFriendAsync() {
      if (checkSelect()) {
        checkInput(opponent, errorFriend, "Gebruikersnaam vriend").then((val) {
          if (val) {}
        });
      }
    }

    void playFriendSync() {
      if (checkSelect()) {
        checkInput(opponent, errorFriend, "Gebruikersnaam vriend").then((val) {
          if (val) {
            //TODO: redirect
            String you = widget.user;
            String opponentName = opponent.text;

            List<String> partyUsers = [you, opponentName];
            partyUsers.sort();

            String partyName = partyUsers.join("%%");

            //TODO: check if party exists -> join
            Database.partyExists(partyName).then((exists) {
              if (exists) {
                Functions.toCompExercise(context, partyName, widget.user);
              } else {
                Database.makeParty(partyName, partyUsers, selectedItems);

                Functions.toCompExercise(context, partyName, widget.user);
              }

              //ELSE: waiting page for opponent
            });
          }
        });
      }
    }

    void makeParty() {
      if (checkSelect()) {
        checkInput(partyMake, errorParty1, "Naam Party").then((val) {
          if (val) {
            String you = widget.user;
            String party = partyMake.text;

            Functions.toLobby(context, party, you);
          }
        });
      }
    }

    void joinParty() {
      if (checkSelect()) {
        checkInput(partyJoin, errorParty2, "Naam Party").then((val) {
          print("Trying to join party");
          if (val) {
            String you = widget.user;
            String party = partyJoin.text;

            Functions.toLobby(context, party, you);
          }
        });
      }
    }

    final widthSpacer = SizedBox(
      height: 20,
    );

    final home = ListView(
      children: [
        widthSpacer,
        Center(
            child: Text(
          "Wat wil je oefenen?",
          style: TextStyle(fontSize: 30),
        )),
        Center(
          child: topicsSelect,
        ),
        errorSelectListener,
        widthSpacer,
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: playRandom,
                  child: Text("Random Opponent (Async)")),
            ),
            Spacer()
          ],
        ),
        widthSpacer,
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: playBot, child: Text("Oefen tegen bot!")),
            ),
            Spacer()
          ],
        ),
        widthSpacer,
        Center(
            child: Text(
          "Speel tegen een vriend!",
          style: TextStyle(fontSize: 30),
        )),
        Center(child: opponentField),
        errorFriendListener,
        widthSpacer,
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: playFriendAsync,
                  child: Text("Play Against Friend (Async)")),
            ),
            Spacer()
          ],
        ),
        widthSpacer,
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: playFriendSync,
                  child: Text("Play Against Friend (Sync)")),
            ),
            Spacer()
          ],
        ),
        widthSpacer,
        Center(
            child: Text(
          "Maak een party aan!",
          style: TextStyle(fontSize: 30),
        )),
        Center(child: partyMakeField),
        errorParty1Listener,
        widthSpacer,
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: makeParty, child: Text("Maak een party!")),
            ),
            Spacer()
          ],
        ),
        widthSpacer,
        Center(
            child: Text(
          "Neem deel aan een party!",
          style: TextStyle(fontSize: 30),
        )),
        Center(child: partyJoinField),
        errorParty2Listener,
        widthSpacer,
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton(
                  onPressed: joinParty, child: Text("Play In Party (Sync)")),
            ),
            Spacer()
          ],
        ),
      ],
    );

    if (_pages.isEmpty) {
      _pages.add(home);
    }
    // TODO: implement build
    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
