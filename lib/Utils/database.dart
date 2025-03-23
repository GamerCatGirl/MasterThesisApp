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

  static Future<bool> showSkills(String username) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference users = db.collection("users");

    var user = await users.doc(username).get();
    var data = user.data() as Map<String, dynamic>;
    var pathCompletion = data["pathCompletion"];

    print(pathCompletion);

    return pathCompletion[0] as bool;
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

  static Future<String> findUserToPlayAgainst(
      List<String> skills, String user) async {
    List<String> skillsAdapted = skills;

    if (skills.contains("recommended")) {
      skillsAdapted.remove("recommended");
    }
    if (skills.contains("all")) {
      skillsAdapted = ["vierkant", "rechthoek", "cirkel", "driehoek"];
    }

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("users");

    var usersQ = await usersDB.get();
    var users = usersQ.docs;

    var amountUsers = users.length;

    var found = false;

    while (!found) {
      if (amountUsers == 0) {
        found = true;
        return "Bot";
      }

      int idx = Random().nextInt(amountUsers);
      var toCheckConstraint = users[idx];

      if (toCheckConstraint.id == user) {
        users.remove(toCheckConstraint);
        amountUsers -= 1;
      } else {
        var data = toCheckConstraint.data() as Map<String, dynamic>;
        var vec = data["pathCompletion"];
        var goodMatch = true;
        for (var skill in skills) {
          if (skill == "vierkant") {
            goodMatch = vec[1] as bool && goodMatch;
          } else if (skill == "rechthoek") {
            goodMatch = vec[4] as bool && goodMatch;
          } else if (skill == "driehoek") {
            goodMatch = vec[2] as bool && goodMatch;
          } else if (skill == "cirkel") {
            goodMatch = vec[3] as bool && goodMatch;
          }
        }

        if (goodMatch) {
          found = true;
          return toCheckConstraint.id;
        } else {
          users.remove(toCheckConstraint);
          amountUsers -= 1;
        }
      }

      found = true;
    }

    return "Bot";
  }

  static Future<Map<dynamic, dynamic>> getSpeedBots(List<String> bots) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference botsDB = db.collection("Bots");

    //var bot = bots[0];
    var info = {};

    for (var bot in bots) {
      var doc = await botsDB.doc(bot).get();
      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        info[bot] = data;
        //info.addEntries({bot: data})
        //info.add({bot: data});
      } //.then((doc) {
    } //(elm) => bots.contains(elm)).get();

    return info;
  }

  static Future<Map> getAllBots() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference botsDB = db.collection("Bots");

    var bots = await botsDB.get();

    Map<String, dynamic> data = {};

    for (var docSnapshot in bots.docs) {
      data[docSnapshot.id] = docSnapshot.data();
    }
    return data;
  }

  static Future<Map<String, dynamic>> postExercises(
      Map<String, dynamic> exercises) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    WriteBatch batch = firestore.batch();

    Map<String, dynamic> ids = {};

    for (var elm in exercises.entries) {
      var exs = elm.value;
      var dbID = "generated-oppervlakte-" + elm.key;
      CollectionReference db = firestore.collection(dbID);
      var idsSkill = [];
      for (var ex in exs as List) {
        // set doc with ref in batch
        DocumentReference newDocRef = db.doc();
        batch.set(newDocRef, ex);

        // keep ids
        String ref = newDocRef.id;
        idsSkill.add(ref);
      }
      ids[elm.key] = idsSkill;
    }

    await batch.commit();
    return ids;
  }

  static void updateEloAndEx(
      String user, Map<String, dynamic> elo, Map<String, dynamic> exercise) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("exercises");

    Map<String, dynamic> eloToPost = {};
    Map<String, dynamic> exerciseIdToPost = {};
    for (var elm in elo.entries) {
      String newKey = "oppervlakte-" + elm.key;
      eloToPost[newKey] = elm.value;
    }

    for (var elm in exercise.entries) {
      String newKey = "oppervlakte-" + elm.key;
      List value = elm.value as List;

      if (value.length > 0) {
        exerciseIdToPost[newKey] = FieldValue.arrayUnion(value);
      }
    }

    usersDB.doc(user).set(
        {"elo": eloToPost, "generatedPlayed": exerciseIdToPost},
        SetOptions(merge: true));
  }

  static void updateElo(
      String user,
      List<double> vierkant,
      List<double> rechthoek,
      List<double> driehoek,
      List<double> cirkel,
      List<double> conversion) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("exercises");

    var docVierkant = {"elo": vierkant[0], "t": vierkant[1]};
    var docRechthoek = {"elo": rechthoek[0], "t": rechthoek[1]};
    var docCirkel = {"elo": cirkel[0], "t": cirkel[1]};
    var docDriehoek = {"elo": driehoek[0], "t": driehoek[1]};
    var docConversion = {"elo": conversion[0], "t": conversion[1]};

    var doc = {
      "oppervlakte-vierkant": docVierkant,
      "oppervlakte-rechthoek": docRechthoek,
      "oppervlakte-driehoek": docDriehoek,
      "oppervlakte-cirkel": docCirkel,
      "conversion": docConversion,
    };

    //usersDB.add()
    usersDB.doc(user).set({"elo": doc}, SetOptions(merge: true));
  }

  static Future<dynamic> getMatches(String user, String skill, int elo) async {
    String dbName = "generated-oppervlakte-" + skill;
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference exDB = db.collection(dbName);

    print("db Name: $dbName");
    print("user: $user");

    var doc = await exDB.where("user", isEqualTo: user).orderBy("elo").get();

    if (doc.size > 0) {
      doc.docs.sort((a, b) {
        var eloA = a["elo"];
        var eloB = b["elo"];
        return (eloA - elo).abs().compareTo((eloB - elo).abs());
      });
      return doc.docs.take(10).toList();
    } else {
      return "De gebruiker heeft nog geen oefeningen gemaakt voor oppervlakte van een " +
          skill;
    }
  }

  static Future getEloAndT(String user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("exercises");

    var doc = await usersDB.doc(user).get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;
      var elo = data["elo"] as Map<String, dynamic>;

      var elseReturn = {"elo": 0, "t": 0};

      var eloCirkel = (elo["oppervlakte-cirkel"] != null)
          ? elo["oppervlakte-cirkel"]
          : elseReturn;

      var eloVierkant = (elo["oppervlakte-vierkant"] != null)
          ? elo["oppervlakte-vierkant"]
          : elseReturn;
      var eloRechthoek = (elo["oppervlakte-rechthoek"] != null)
          ? elo["oppervlakte-rechthoek"]
          : elseReturn;
      var eloDriehoek = (elo["oppervlakte-driehoek"] != null)
          ? elo["oppervlakte-driehoek"]
          : elseReturn;
      var eloConversion = (elo["conversion-table"] != null)
          ? elo["conversion-table"]
          : elseReturn;

      return [eloVierkant, eloCirkel, eloRechthoek, eloDriehoek, eloConversion];
    } else {
      throw ArgumentError("No existing Elo for user");
    }
  }

  static Future<List<double>> getElo(String user) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("exercises");

    var doc = await usersDB.doc(user).get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;

      if (data.containsKey("elo")) {
        var elo = data["elo"] as Map<String, dynamic>;

        var eloCirkel = (elo["oppervlakte-cirkel"] != null)
            ? elo["oppervlakte-cirkel"]["elo"]
            : 0;

        var eloVierkant = (elo["oppervlakte-vierkant"] != null)
            ? elo["oppervlakte-vierkant"]["elo"]
            : 0;
        var eloRechthoek = (elo["oppervlakte-rechthoek"] != null)
            ? elo["oppervlakte-rechthoek"]["elo"]
            : 0;
        var eloDriehoek = (elo["oppervlakte-driehoek"] != null)
            ? elo["oppervlakte-driehoek"]["elo"]
            : 0;
        var eloConversion = (elo["conversion-table"] != null)
            ? elo["conversion-table"]["elo"]
            : 0;

        return [
          eloVierkant,
          eloCirkel,
          eloRechthoek,
          eloDriehoek,
          eloConversion
        ];
      } else {
        return [0, 0, 0, 0, 0];
      }
    } else {
      throw ArgumentError("No existing Elo for user");
    }
  }

  static Future<List<double>> getAllElo() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("exercises");

    var query = await usersDB.get();
    var docs = query.docs;

    List<double> vierkantElos = [];
    var rechthoekElos = [];
    var cirkelElos = [];
    var driehoekElos = [];
    var conversionElos = [];

    for (var doc in docs) {
      var data = doc.data() as Map<String, dynamic>;

      double eloCirkel = 0;
      double eloVierkant = 0;
      double eloRechthoek = 0;
      double eloDriehoek = 0;
      double eloConversion = 0;

      if (data.containsKey("elo")) {
        var elo = data["elo"] as Map<String, dynamic>;

        eloCirkel = (elo["oppervlakte-cirkel"] != null)
            ? elo["oppervlakte-cirkel"]["elo"]
            : 0;

        eloVierkant = (elo["oppervlakte-vierkant"] != null)
            ? elo["oppervlakte-vierkant"]["elo"]
            : 0;
        eloRechthoek = (elo["oppervlakte-rechthoek"] != null)
            ? elo["oppervlakte-rechthoek"]["elo"]
            : 0;
        eloDriehoek = (elo["oppervlakte-driehoek"] != null)
            ? elo["oppervlakte-driehoek"]["elo"]
            : 0;
        eloConversion = (elo["conversion-table"] != null)
            ? elo["conversion-table"]["elo"]
            : 0;
      }

      vierkantElos.add(eloVierkant);
      rechthoekElos.add(eloRechthoek);
      cirkelElos.add(eloCirkel);
      driehoekElos.add(eloDriehoek);
      conversionElos.add(eloConversion);
    }

    var eloVierkant =
        vierkantElos.reduce((a, b) => a + b) / vierkantElos.length;
    var eloCirkel = cirkelElos.reduce((a, b) => a + b) / cirkelElos.length;
    var eloDriehoek =
        driehoekElos.reduce((a, b) => a + b) / driehoekElos.length;
    var eloRechthoek =
        rechthoekElos.reduce((a, b) => a + b) / rechthoekElos.length;
    var eloConversion =
        conversionElos.reduce((a, b) => a + b) / conversionElos.length;

    return [eloVierkant, eloCirkel, eloRechthoek, eloDriehoek, eloConversion];
  }

  static void login(String user) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("activePlayers");
    usersDB.doc(user).set({"active": true}, SetOptions(merge: true));
  }

  static void logout(String user) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference usersDB = db.collection("activePlayers");
    usersDB.doc(user).delete();
    Consts.logout();
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

    try {
      partiesDB.doc(partyName).update({
        "player":
            FieldValue.arrayRemove([userName]) // Add "newTag" to the array
      });
    } catch (e) {
      print("no party to update");
    }
  }

  static void changeLeader(String partyName) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");

    partiesDB.doc(partyName).update({
      "changeHost": true // Add "newTag" to the array
    });
  }

  static void deleteParty(String partyName) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");
    try {
      partiesDB.doc(partyName).delete();
    } catch (e) {
      print("delete of party: $partyName failed");
    }
  }

  static void leaderChanged(String partyName) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");

    partiesDB.doc(partyName).update({
      "changeHost": false // Add "newTag" to the array
    });
  }

  static Future<bool> startParty(String partyName) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");

    try {
      await partiesDB.doc(partyName).update({
        "start": true // Add "newTag" to the array
      });
      return true;
    } catch (e) {
      return false;
    }
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

  static void leaveParty(String partyName, String userName) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference partiesDB = db.collection("activeParties");
    CollectionReference usersDB = db.collection("activePlayers");

    usersDB
        .doc(userName)
        .set({"party": "", "progress": 0}, SetOptions(merge: true));
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
