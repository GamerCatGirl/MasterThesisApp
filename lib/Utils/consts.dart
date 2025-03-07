import 'dart:math';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:mathapp/components/title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Consts {
  int maxMultiplyByHead = 12;
  int maxMultiplyCalc = 999;
  int amountSkills = 4;
  int amountExercises = 10;

  static String vierkant = "vierkant";
  static String rechthoek = "rechthoek";
  static String driehoek = "driehoek";
  static String cirkel = "cirkel";

  static List<String> skills = [vierkant, rechthoek, cirkel, driehoek];

  static final paths = {
    "vierkant": "assets/images/vierkant/",
    "rechthoek": "assets/images/rechthoek/",
    "driehoek": "assets/images/driehoek/",
    "cirkel": "assets/images/cirkel/",
    "combined": "assets/images/combined-figures/"
  };

  static List<String> imagesVierkant = [
    "Bakery.jpg",
    "Bar.jpg",
    "Beautysalon_.jpg",
    "IceShop.jpg",
    "Lobby.jpg",
    "Painrstudio2.jpg",
    "Paintstudio.jpg",
    "Room.jpg",
    "Room2.jpg",
    "Room3.jpg",
    "Room4.jpg",
    "Room5.jpg"
  ];

  static List<String> imagesCirkel = [
    "bench.JPG",
    "books.JPG",
    "books2.JPG",
    "logo.JPG",
    "logo2.JPG",
    "mario.JPG",
    "painting.JPG",
    "sitting.JPG",
    "sitting2.JPG",
    "sitting3.JPG",
    "sitting4.JPG",
    "stairs.JPG"
  ];
  static List<String> imagesRechthoek = [
    "casette1.JPG",
    "casette2.JPG",
    "casette3.JPG",
    "painting.JPG",
    "painting2.JPG",
    "painting3.JPG",
    "painting4.JPG",
    "painting5.JPG",
    "painting6.JPG",
    "painting7.JPG",
    "painting8.JPG",
    "painting9.JPG",
    "painting10.JPG"
  ];
  static List<String> imagesDriehoek = [
    "painting.JPG",
    "painting2.JPG",
    "painting3.JPG",
    "plants.JPG",
    "wall.JPG",
    "wall2.JPG",
    "wall3.JPG",
    "wall4.JPG"
  ];

  static List<String> imagesCombined = [
    "bloem1.JPG",
    "bloem2.JPG",
    "bloem3.JPG",
    "bloem4.JPG",
    "nintendo1.JPG",
    "nintendo2.JPG",
    "shapes.JPG",
    "shapes2.JPG",
    "shapes3.JPG",
    "shapes4.JPG",
    "shapes5.JPG",
    "shapes6.JPG",
    "shapes7.JPG",
    "shapes8.JPG"
  ];

  static List<List<String>> figuresCombined = [
    [vierkant, cirkel, driehoek],
    [vierkant, rechthoek, driehoek, cirkel],
    [driehoek, cirkel, vierkant],
    [driehoek],
    [cirkel, rechthoek, vierkant, driehoek],
    [cirkel, vierkant, driehoek, rechthoek],
    [cirkel, driehoek, rechthoek, vierkant],
    [driehoek, vierkant, cirkel],
    [cirkel, driehoek, vierkant],
    [vierkant, cirkel],
    [vierkant, cirkel],
    [driehoek, cirkel],
    [driehoek, cirkel],
    [driehoek, cirkel]
  ];

  static List<String> retrievePath() {
    String pathStr = retrieveFromCookies("path");
    int length = pathStr.length;

    var pathWithoutBrackets = pathStr.substring(1, length - 1);

    List<String> path = pathWithoutBrackets.split(", ");

    return path;
  }

  static List<bool> retrievePathCompletion() {
    var pathCompletionStr = retrieveFromCookies("pathCompletion");
    int length = pathCompletionStr.length;

    String pathWithoutBrackets = pathCompletionStr.substring(1, length - 1);

    List<String> pathWithout = pathWithoutBrackets.split(", ");

    List<bool> path = pathWithout.map((elm) {
      if (elm == "true") {
        return true;
      } else if (elm == "false") {
        return false;
      } else {
        return false;
      }
    }).toList();

    return path;
  }

  static void refreshInfo() async {
    String username = getLoggedInUser();

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference users = db.collection("users");

    var user = await users.doc(username).get();

    if (user.exists) {
      var data = user.data() as Map<String, dynamic>;

      var path = data["path"];
      var pathCompletion = data["pathCompletion"];

      saveToCookies("path", path.toString());
      saveToCookies("pathCompletion", pathCompletion.toString());
    } else {
      throw ArgumentError("User is non existend in database");
    }
  }

  static void login(String username) {
    saveToCookies("loggedInAs", username);
    refreshInfo();
  }

  static void logout() {
    deleteCookie("loggedInAs");
    deleteCookie("path");
    deleteCookie("pathCompletion");
  }

  static bool loggedIn() {
    String? user = html.window.localStorage["loggedInAs"];
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  static String getLoggedInUser() {
    String? user = html.window.localStorage["loggedInAs"];
    if (user != null) {
      return user;
    } else {
      throw ArgumentError("No logged in user!");
    }
  }

  static void saveToCookies(String key, dynamic value) {
    html.window.localStorage[key] = value;
  }

  static void deleteCookie(String key) {
    html.window.localStorage.remove(key);
  }

  static dynamic retrieveFromCookies(String key) {
    return html.window.localStorage[key];
  }

  static Map<String, dynamic> generateVars(String figure) {
    if (!skills.contains(figure)) {
      throw ArgumentError("Invalid figure: $figure");
    }

    int random1 = Random().nextInt(12) + 1;
    int random2 = Random().nextInt(12) + 1;

    if (figure == "vierkant") {
      return {"z": random1};
    } else if (figure == "rechthoek") {
      return {"breedte": random1, "lengte": random2};
    } else if (figure == "driehoek") {
      return {"basis": random1, "hoogte": random2};
    } else if (figure == "cirkel") {
      return {"straal": random1};
    } else {
      throw ArgumentError("Invalid figure: $figure");
    }
  }

  static Widget logginFirst = ListView(
    children: [
      SizedBox(
        height: 20,
      ),
      Center(
        child: Header(title: "Log eerst in voor je verder kan gaan!"),
      ),
      SizedBox(
        height: 20,
      ),
      Center(
        child: Text("Ga naar profiel om in te loggen, veel succes!"),
      ),
      SizedBox(
        height: 20,
      ),
    ],
  );

  static String getPathRandomImage(String figure) {
    if (!skills.contains(figure)) {
      throw ArgumentError("Invalid figure: $figure");
    }

    var imagesAll = {
      "driehoek": imagesDriehoek,
      "vierkant": imagesVierkant,
      "cirkel": imagesCirkel,
      "rechthoek": imagesRechthoek
    };

    List<String> images = imagesAll[figure] as List<String>;
    String path = paths[figure] as String;
    int maxIDX = images.length;

    int idx = Random().nextInt(maxIDX);
    String image = images[idx];

    String pathImg = path + image;
    return pathImg;
  }
}
