import 'dart:math';
import 'dart:html' as html;

class Consts {
  int maxMultiplyByHead = 12;
  int maxMultiplyCalc = 999;
  int amountSkills = 4;
  int amountExercises = 10;
  static List<String> skills = ["vierkant", "rechthoek", "cirkel", "driehoek"];

  static final paths = {
    "vierkant": "assets/images/vierkant/",
    "rechthoek": "assets/images/rechthoek/",
    "driehoek": "assets/images/driehoek/",
    "cirkel": "assets/images/cirkel/"
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

  static void logout() {
    html.window.localStorage.remove("loggedInAs");
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
    html.window.localStorage[key];
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
