import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/Utils/redirections.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/figure_input.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/async_match.dart';
import 'package:mathapp/pages/competitive_party.dart';
import 'package:mathapp/pages/figure_theory.dart';
import 'package:mathapp/pages/lobby.dart';
import 'package:mathapp/pages/meetkunde_ex.dart';
import 'dart:math';

import 'package:mathapp/pages/profile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

enum Topics { vierkant, rechthoek, cirkel, driehoek, recommended }

class _HomeState extends State<Home> {
  late int selectedPage;
  int currentExercise = 1;
  int amountExercises = 0;
  int currentRandom = 0;
  late String user = "";
  List<String> selectedItems = [];

  String playAgainst = "";
  String partyName = "";

  final TextEditingController opponent = TextEditingController();
  final TextEditingController partyMake = TextEditingController();
  final TextEditingController partyJoin = TextEditingController();

  ValueNotifier<String> errorSelect = ValueNotifier("");
  ValueNotifier<String> errorFriend = ValueNotifier("");
  ValueNotifier<String> errorParty1 = ValueNotifier("");
  ValueNotifier<String> errorParty2 = ValueNotifier("");

  @override
  void initState() {
    bool loggedIn = Consts.loggedIn();
    bool pathDone;
    if (loggedIn) {
      user = Consts.getLoggedInUser();
      var pathDone = Consts.pathCompleted();
      selectedPage = 0;

      if (!pathDone) {
        selectedPage = 4;
      }
    } else {
      selectedPage = 1;
    }

    //TODO: check if part of active part to join back in
  }

  void goHome() {
    setState(() {
      selectedPage = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final topicsSelect = MultiSelectContainer(
        itemsDecoration: MultiSelectDecorations(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.purple[200]!),
              borderRadius: BorderRadius.circular(20)),
        ),
        prefix: MultiSelectPrefix(
          selectedPrefix: const Padding(
            padding: EdgeInsets.only(right: 5),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
        items: [
          MultiSelectCard(value: 'vierkant', label: 'Vierkant'),
          MultiSelectCard(value: 'rechthoek', label: 'Rechthoek'),
          MultiSelectCard(value: 'driehoek', label: 'Driehoek'),
          MultiSelectCard(value: 'cirkel', label: 'Cirkel'),
        ],
        onChange: (allSelectedItems, selectedItem) {
          selectedItems = allSelectedItems;

          if (selectedItems.length > 0) {
            errorSelect.value = "";
          }
        });

    final opponentField = SizedBox(
        width: 250,
        child: TextFormField(
          controller: opponent,
          onChanged: (value) => errorFriend.value = "",
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Gebruikersnaam vriend',
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
      } else if (nameField == "Gebruikersnaam vriend" && field.text != user) {
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
          Database.makeParty(field.text, [user], selectedItems);
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

    void playBot() {
      if (checkSelect()) {
        setState(() {
          playAgainst = "Bot";
          selectedPage = 2;
        });
      }
    }

    void playRandom() {
      if (checkSelect()) {
        Database.findUserToPlayAgainst(selectedItems, user)
            .then((String opponent) {
          setState(() {
            playAgainst = opponent;
            selectedPage = 2;
          });
        });
      }
    }

    void playFriendAsync() {
      if (checkSelect()) {
        checkInput(opponent, errorFriend, "Gebruikersnaam vriend").then((val) {
          if (val) {
            setState(() {
              playAgainst = opponent.text;
              selectedPage = 2;
            });
          }
        });
      }
    }

    void playFriendSync() {
      checkInput(opponent, errorFriend, "Gebruikersnaam vriend").then((val) {
        if (val) {
          String you = user;
          String opponentName = opponent.text;

          List<String> partyUsers = [you, opponentName];
          partyUsers.sort();

          partyName = partyUsers.join("%%");

          //TODO: check if party exists -> join
          Database.partyExists(partyName).then((exists) {
            if (exists) {
              setState(() {
                selectedPage = 5;
              });

              //Functions.toCompExercise(context, partyName, user);
            } else if (checkSelect()) {
              Database.makeParty(partyName, partyUsers, selectedItems);
              setState(() {
                selectedPage = 5;
              });
              //Functions.toCompExercise(context, partyName, user);
            }

            //ELSE: waiting page for opponent
          });
        }
      });
    }

    void makeParty() {
      if (checkSelect()) {
        checkInput(partyMake, errorParty1, "Naam Party").then((val) {
          if (val) {
            String you = user;
            String party = partyMake.text;
            //setState(() {
            //  selectedPage = 3;
            //});
            Functions.toLobby(context, party, you);
          }
        });
      }
    }

    void joinParty() {
      checkInput(partyJoin, errorParty2, "Naam Party").then((val) {
        if (val) {
          String party = partyJoin.text;
          setState(() {
            selectedPage = 3;
          });
        }
      });
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
        /*
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                  onPressed: playRandom,
                  icon: Icon(Icons.play_circle_outline),
                  label: Text("Willekeurige Tegenspeler")),
            ),
            Spacer()
          ],
        ),
        Center(
            child: Text(
          "De tegenspeler speelt niet op hetzelfde moment!",
          style: TextStyle(color: Colors.grey),
        )),
        */
        widthSpacer,
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: playBot,
                  label: Text("Oefen tegen bot")),
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
        Center(
            child: Text(
          "OPGELET: hoofdletter gevoelig!",
          style: TextStyle(color: Colors.grey),
        )),
        errorFriendListener,
        widthSpacer,
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: playFriendSync,
                  label: Text("Speel tegen vriend")),
            ),
            Spacer()
          ],
        ),
        Center(
            child: Text(
          "De tegenspeler moet op zijn scherm jouw gebruikersnaam invullen!",
          style: TextStyle(color: Colors.grey),
        )),
        widthSpacer,
        /*
        Row(
          children: [
            Spacer(),
            SizedBox(
              width: 250,
              child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: playFriendAsync,
                  label: Text("Speel tegen vriend (offline)")),
            ),
            Spacer()
          ],
        ),
        Center(
            child: Text(
          "De tegenspeler zal niet op hetzelfde moment tegen jou spelen!",
          style: TextStyle(color: Colors.grey),
        )),
        */
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
              child: ElevatedButton.icon(
                  icon: Icon(Icons.add),
                  onPressed: makeParty,
                  label: Text("Maak een party!")),
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
              child: ElevatedButton.icon(
                  icon: Icon(Icons.play_circle_outline),
                  onPressed: joinParty,
                  label: Text("Ga naar party!")),
            ),
            Spacer()
          ],
        ),
      ],
    );

    Widget asyncFriend() {
      return AsyncMatch(
        user: user,
        opponent: playAgainst,
        selectedSkills: selectedItems,
        goHome: goHome,
      );
    }

    Widget syncFriend() {
      return CompetitiveParty(
        partyName: partyName,
        user: user,
        done: () {
          setState(() {
            selectedPage = 0;
          });
        },
      );
    }

    Widget lobby() {
      return Lobby(
          partyName: partyJoin.text,
          user: user,
          done: () {
            setState(() {
              selectedPage = 0;
            });
          });
    }

    final completePath = ListView(
      children: [
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text("Voltooi eerst het leerpad!"),
        )
      ],
    );

    List<Widget> pages = [
      home, //0
      Consts.logginFirst, //1
      asyncFriend(), //2
      lobby(), //3
      completePath, //4
      syncFriend() //5
    ];

    // TODO: implement build
    return Scaffold(
      body: Center(child: pages[selectedPage]),
    );
  }
}
