import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/pages/exercises.dart';
import 'package:mathapp/pages/home.dart';
import 'package:mathapp/pages/learning_path.dart';
import 'package:mathapp/pages/profile.dart';
import 'package:mathapp/pages/setting.dart';

class CompetitiveParty extends StatefulWidget {
  final String partyName;

  CompetitiveParty({super.key, required this.partyName});

  @override
  State<CompetitiveParty> createState() => _CompetitivePartyState();
}

class _CompetitivePartyState extends State<CompetitiveParty> {
  // VARIABLES
  late String partyID;
  late String partyName;

  ValueNotifier<bool> loading = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    partyID = widget.partyName;
    partyName = widget.partyName;

    if (partyName.contains("%%")) {
      partyName = partyName.replaceAll("%%", " VS ");
    }
  }

  @override
  Widget build(BuildContext context) {
    var title = Center(child: Header(title: partyName));

    var loading = 0;

    return Scaffold(
        body: ListView(
      children: [title],
    ));
  }
}
