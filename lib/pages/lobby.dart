import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/Utils/redirections.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/pages/competitive_party.dart';

class Lobby extends StatefulWidget {
  final String partyName;
  final String user;
  final VoidCallback done;

  Lobby(
      {super.key,
      required this.partyName,
      required this.user,
      required this.done});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  // VARIABLES
  late String partyName;
  String? lobbyControler;
  ValueNotifier<List> players = ValueNotifier([]);
  FirebaseFirestore db = FirebaseFirestore.instance;
  late StreamSubscription listener;

  int selectedPage = 0;

  void startParty() {
    listener.cancel();
    setState(() {
      selectedPage = 1;
    });
  }

  void partyInfoChanged(data) {
    players.value = data["player"];
    var oldLeader = lobbyControler;
    lobbyControler = players.value[0];

    bool? start = data["start"];

    if (start != null && start) {
      // start exercise
      //Functions.toCompExercise(context, partyName, widget.user);
      startParty();
    }

    if ((lobbyControler != oldLeader) && (lobbyControler == widget.user)) {
      setState(() {
        lobbyControler;
      });
    }
  }

  //TODO: houd geen rekening met een reload van een pagina!
  @override
  void dispose() {
    listener.cancel();
    Database.leaveLobby(partyName, widget.user);
    //if no one left -> distroy party
    if (players.value.length == 1) {
      Database.deleteParty(partyName);
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    partyName = widget.partyName;
    players.value.add(widget.user);

    Database.partyHead(partyName).then((String head) {
      setState(() {
        lobbyControler = head;
      });

      if (head != widget.user) {
        Database.joinLobby(partyName, widget.user);
      }
    });

    CollectionReference activeDB = db.collection("activeParties");
    DocumentReference docRef = activeDB.doc(partyName);

    listener = docRef.snapshots().listen(
      (event) {
        var data = event.data() as Map<String, dynamic>;
        partyInfoChanged(data);
      },
      onError: (error) => print("Listen failed: $error"),
    );
  }

  void startPartyBuild() async {
    bool done = await Database.startParty(partyName);

    if (done) {
      startParty();
      //Functions.toCompExercise(context, partyName, widget.user);
    }
  }

  @override
  Widget build(BuildContext context) {
    var header = Center(
      child: Header(title: "Lobby of " + widget.partyName),
    );

    var loading = Column(children: [
      Text("Aan het wachten op de spelers..."),
      LoadingAnimationWidget.threeRotatingDots(color: Colors.purple, size: 200),
    ]);

    var playersWidget = ValueListenableBuilder(
        valueListenable: players,
        builder: (build, value, context) {
          return Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: value.map((text) {
                return Container(
                  padding: EdgeInsets.all(12),
                  color: Colors.blueAccent,
                  child: Text(text, style: TextStyle(color: Colors.white)),
                );
              }).toList());
        });

    var startButton = Center(
      child: SizedBox(
        width: 200,
        child: ElevatedButton(onPressed: startPartyBuild, child: Text("Start")),
      ),
    );

    bool lobbyHead = (widget.user == lobbyControler);

    var spacer = SizedBox(
      height: 20,
    );

    var startOrLoading = lobbyHead ? startButton : loading;
    Widget lobbyPage = ListView(
      children: [header, spacer, playersWidget, spacer, startOrLoading],
    );

    List pages = [
      lobbyPage,
      CompetitiveParty(
        partyName: widget.partyName,
        user: widget.user,
        done: () {
          widget.done();
        },
      )
    ];

    return Scaffold(body: pages[selectedPage]);
  }
}
