import 'package:flutter/material.dart';
import 'package:mathapp/pages/learning_path.dart';

class Functions {
  void toLearningPatch(String user, List<dynamic> path,
      List<dynamic> pathCompletion, BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => LearningPath(
            username: user, path: path, pathCompletion: pathCompletion)));
  }
}
