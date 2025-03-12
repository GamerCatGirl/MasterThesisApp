import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/Utils/redirections.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:mathapp/pages/async_match.dart';
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

    if (loggedIn) {
      user = Consts.getLoggedInUser();
      selectedPage = 0;
    } else {
      selectedPage = 1;
    }

    //TODO: check if part of active part to join back in
  }

  @override
  Widget build(BuildContext context) {
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

    void playRandom() {
      if (checkSelect()) {}
    }

    void playBot() {
      if (checkSelect()) {}
    }

    void playFriendAsync() {
      if (checkSelect()) {
        checkInput(opponent, errorFriend, "Gebruikersnaam vriend").then((val) {
          if (val) {
            setState(() {
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

          String partyName = partyUsers.join("%%");

          //TODO: check if party exists -> join
          Database.partyExists(partyName).then((exists) {
            if (exists) {
              Functions.toCompExercise(context, partyName, user);
            } else if (checkSelect()) {
              Database.makeParty(partyName, partyUsers, selectedItems);
              Functions.toCompExercise(context, partyName, user);
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

            Functions.toLobby(context, party, you);
          }
        });
      }
    }

    void joinParty() {
      checkInput(partyJoin, errorParty2, "Naam Party").then((val) {
        if (val) {
          String party = partyJoin.text;

          Functions.toLobby(context, party, user);
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

    Widget asyncFriend() {
      return AsyncMatch(
        user: user,
        opponent: opponent.text,
        selectedSkills: selectedItems,
      );
    }

    List<Widget> pages = [home, Consts.logginFirst, asyncFriend()];

    // TODO: implement build
    return Scaffold(
      body: Center(child: pages[selectedPage]),
    );
  }
}
