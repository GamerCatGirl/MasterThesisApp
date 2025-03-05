import 'package:flutter/material.dart';
import 'package:mathapp/pages/competitive_party.dart';
import 'package:mathapp/pages/home.dart';
import 'package:mathapp/pages/learning_path.dart';
import 'package:mathapp/pages/lobby.dart';

class Functions {
  void toLearningPatch(String user, List<dynamic> path,
      List<dynamic> pathCompletion, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LearningPath(
            username: user, path: path, pathCompletion: pathCompletion)));
  }

  static void toCompExercise(
      BuildContext context, String partyName, String user) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => CompetitiveParty(
                partyName: partyName,
                user: user,
              )),
    );
  }

  static void toLogin(BuildContext context) {
    Navigator.pushNamed(context, '/login');
  }

  static void toStartMatch(BuildContext context, String user) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
  }

  static void toLobby(BuildContext context, String party, String user) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Lobby(partyName: party, user: user)));
  }
}
