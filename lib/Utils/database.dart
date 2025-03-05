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

  static void login(String user) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("activePlayers");
    usersDB.doc(user).set({"active": true}, SetOptions(merge: true));
  }

  static void joinLobby(String partyName, String userName) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");

    partiesDB.doc(partyName).update({
      "player": FieldValue.arrayUnion([userName]) // Add "newTag" to the array
    });
  }

  static void leaveLobby(String partyName, String userName) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");

    partiesDB.doc(partyName).update({
      "player": FieldValue.arrayRemove([userName]) // Add "newTag" to the array
    });
  }

  static void joinParty(String partyName, String userName) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");
    CollectionReference usersDB = db.collection("activePlayers");

    usersDB
        .doc(userName)
        .set({"party": partyName, "progress": 0}, SetOptions(merge: true));

    //TODO: check if partyExists
  }

  static void updateProgress(String userName, double progress) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");
    CollectionReference usersDB = db.collection("activePlayers");

    usersDB.doc(userName).set({"progress": progress}, SetOptions(merge: true));
  }

  static Future<bool> partyExists(String partyName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");

    var doc = await partiesDB.doc(partyName).get();

    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  static Future<String> partyHead(String partyName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");

    var doc = await partiesDB.doc(partyName).get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      var players = data["player"];
      var head = players[0];
      return head;
    } else {
      return throw ArgumentError("Invalid partyname: $partyName");
    }
  }

  static Future<Map<String, dynamic>> getPartyInfo(String partyName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");
    var doc = await partiesDB.doc(partyName).get();

    if (doc.exists) {
      var docData = doc.data() as Map<String, dynamic>;
      return docData;
    } else {
      throw ArgumentError("Invalid partyID: $partyName");
    }
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
