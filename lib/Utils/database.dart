import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathapp/Utils/consts.dart';

class Database {
  //TODO:
  FirebaseFirestore db = FirebaseFirestore.instance;

  CollectionReference getUserTable() {
    return db.collection("users");
  }

  CollectionReference getPartyTable() {
    return db.collection("parties");
  }

  CollectionReference getActivePartyTable() {
    return db.collection("activeParties");
  }

  static Future<bool> userExists(String username) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference users = db.collection("users");

    var user = await users.doc(username).get();

    if (user.exists) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> partyExists(String partyName) async {
    return false;
  }

  static void makeParty(
      String partyName, List<String> usersParty, List<String> selectedItems) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    WriteBatch batch = db.batch();
    CollectionReference partiesDB = db.collection("activeParties");
    CollectionReference exercisesDB = db.collection("exercises");

    List<dynamic> exercises = [];

    int amountExercises = Consts().amountExercises;
    int amountPlayers = 0;

    List<dynamic> skills = [];

    int amountVierkant = 0;
    int amountRechthoek = 0;
    int amountCirkel = 0;
    int amountDriehoek = 0;
    int amountTable = 0;

    var docToPost = {};

    if (usersParty.length > 1) {
      amountPlayers = usersParty.length;
    }

    if (selectedItems.contains("All")) {
      skills = Consts.skills;
    } else {
      skills = selectedItems;
    }

    if (selectedItems.contains("Recommended")) {
      skills.remove("Recommended");
      //TODO: get Elo of users
    } else {
      for (int i = 0; i < amountExercises; i++) {
        int idxSkill = Random().nextInt(skills.length);
        String skill = skills[idxSkill];
        String skillDB = "generated-oppervlakte-" + skill;

        String image = Consts.getPathRandomImage(skill);

        var doc = Consts.generateVars(skill);

        doc["image"] = image;
        doc["figure"] = skill;

        exercises.add(doc);
      }
    }

    docToPost["skills"] = skills;
    docToPost["exercises"] = exercises;

    partiesDB.doc(partyName).set({
      "skills": skills,
      "exercises": exercises,
      "amountPlayers": amountPlayers,
      "player": usersParty
    });
  }
}
