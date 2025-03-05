import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/components/title.dart';

class Lobby extends StatefulWidget {
  final String partyName;
  final String user;

  Lobby({super.key, required this.partyName, required this.user});

  @override
  State<Lobby> createState() => _LobbyState();
}

class _LobbyState extends State<Lobby> {
  // VARIABLES
  late String partyName;
  String? lobbyControler;
  ValueNotifier<List> players = ValueNotifier([]);
  FirebaseFirestore db = FirebaseFirestore.instance;

  void partyInfoChanged(data) {
    players.value = data["player"];

    bool? start = data["start"];

    if (start != null && start) {
      //TODO: start exercise
    }
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
    });

    Database.joinParty(partyName, widget.user);

    CollectionReference activeDB = db.collection("activeParties");
    DocumentReference docRef = activeDB.doc(partyName);
    docRef.snapshots().listen(
      (event) {
        var data = event.data() as Map<String, dynamic>;
        partyInfoChanged(data);
      },
      onError: (error) => print("Listen failed: $error"),
    );
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
        child: ElevatedButton(onPressed: () {}, child: Text("Start")),
      ),
    );

    bool lobbyHead = (widget.user == lobbyControler);

    var spacer = SizedBox(
      height: 20,
    );

    var startOrLoading = lobbyHead ? startButton : loading;

    return Scaffold(
        body: ListView(
      children: [header, spacer, playersWidget, spacer, startOrLoading],
    ));
  }
}
