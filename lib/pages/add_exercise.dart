import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/components/row_type_exercise.dart';
import 'package:mathapp/components/text_exercise_edit.dart';
import 'package:mathapp/components/type_exercise_tile.dart';
//how to use database: https://firebase.google.com/docs/database/flutter/read-and-write

class AddExercise extends StatefulWidget {
  const AddExercise({super.key});

  @override
  State<AddExercise> createState() => _AddExerciseState();
}

class _AddExerciseState extends State<AddExercise> {
  //TODO put back button to go back to exercises

  void addExerciseSet(String topic, String course_id, int difficulty) async {
    print("In add Exercise -> post to database");

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference dbExercises = db.collection("exercise_set");

    final newExercise = <String, dynamic>{
      "courseId": "3Lat",
      "difficulty": 2,
      "topic": "Test",
    };

    //TODO: WORKS :) now the programming can start xoxo
    //dbExercises.add(newExercise).then((DocumentReference doc) =>
    //    print('DocumentSnapshot added with ID: ${doc.id}'));
  }

  bool _showTextEdit = true;
  final GlobalKey<TypeExerciseTileState> tileKey1 =
      GlobalKey<TypeExerciseTileState>();
  final GlobalKey<TypeExerciseTileState> tileKey2 =
      GlobalKey<TypeExerciseTileState>();
  final GlobalKey<TypeExerciseTileState> tileKey3 =
      GlobalKey<TypeExerciseTileState>();
  final GlobalKey<TypeExerciseTileState> tileKey4 =
      GlobalKey<TypeExerciseTileState>();
  final GlobalKey<TypeExerciseTileState> tileKey5 =
      GlobalKey<TypeExerciseTileState>();

  final ValueNotifier<bool> clickedOn1 = ValueNotifier<bool>(true);
  final ValueNotifier<bool> clickedOn2 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> clickedOn3 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> clickedOn4 = ValueNotifier<bool>(false);
  final ValueNotifier<bool> clickedOn5 = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    addExerciseSet("Test1", "Course1", 3);

    TypeExerciseTile type1 = TypeExerciseTile(
      key: tileKey1,
      nameExercise: "Theory",
      onTileClicked: () {
        clickedOn1.value = true;
        print("type1");
      },
      visibility: true,
    );
    TypeExerciseTile type2 = TypeExerciseTile(
      key: tileKey2,
      nameExercise: "Fill in",
      onTileClicked: () {
        clickedOn2.value = true;
        print("type2");
      },
    );
    TypeExerciseTile type3 = TypeExerciseTile(
      key: tileKey3,
      nameExercise: "Quizz",
      onTileClicked: () {
        clickedOn3.value = true;
        print("type3");
      },
    );
    TypeExerciseTile type4 = TypeExerciseTile(
      key: tileKey4,
      nameExercise: "Timed",
      onTileClicked: () {
        clickedOn4.value = true;
        print("type4");
      },
    );
    TypeExerciseTile type5 = TypeExerciseTile(
      key: tileKey5,
      nameExercise: "TODO",
      onTileClicked: () {
        clickedOn5.value = true;
        print("type5");
      },
    );

    if (clickedOn1.value) {
      type1.toggleIconVisibility(true);
    }

    clickedOn1.addListener(() {
      if (clickedOn1.value) {
        type1.toggleIconVisibility(true);
        setState(() {
          _showTextEdit = true;
        });
        clickedOn2.value = false;
        clickedOn3.value = false;
        clickedOn4.value = false;
        clickedOn5.value = false;
      } else {
        print("In else of clickedOn1");
        type1.toggleIconVisibility(false);
      }
    });

    clickedOn2.addListener(() {
      if (clickedOn2.value) {
        type2.toggleIconVisibility(true);
        setState(() {
          _showTextEdit = false;
        });
        clickedOn1.value = false;
        clickedOn3.value = false;
        clickedOn4.value = false;
        clickedOn5.value = false;
      } else {
        type2.toggleIconVisibility(false);
      }
    });

    clickedOn3.addListener(() {
      if (clickedOn3.value) {
        type3.toggleIconVisibility(true);
        clickedOn2.value = false;
        clickedOn1.value = false;
        clickedOn4.value = false;
        clickedOn5.value = false;
      } else {
        type3.toggleIconVisibility(false);
      }
    });

    clickedOn4.addListener(() {
      if (clickedOn4.value) {
        type4.toggleIconVisibility(true);
        clickedOn2.value = false;
        clickedOn3.value = false;
        clickedOn1.value = false;
        clickedOn5.value = false;
      } else {
        type4.toggleIconVisibility(false);
      }
    });

    clickedOn5.addListener(() {
      if (clickedOn5.value) {
        type5.toggleIconVisibility(true);
        clickedOn2.value = false;
        clickedOn3.value = false;
        clickedOn4.value = false;
        clickedOn1.value = false;
      } else {
        type5.toggleIconVisibility(false);
      }
    });

    // TODO: implement build
    return Scaffold(
      body: Center(
        child: Stack(children: [
          RowTypeExercise(
              exercise_1: type1,
              exercise_2: type2,
              exercise_3: type3,
              exercise_4: type4,
              exercise_5: type5),
          //TextExerciseEdit(),
          Visibility(
            //TODO: visibility doesn't change yet
            child: TextExerciseEdit(),
            visible: _showTextEdit,
          )
        ]),
      ),
    );
  }
}
