import 'dart:convert';
import 'dart:math';
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:mathapp/components/title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';

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
  static List<String> figures = [vierkant, rechthoek, cirkel, driehoek];

  static List<String> bots = [
    "Bot200",
    "Bot500",
    "Bot800",
    "Bot1000",
    "Bot1200",
    "Bot1500",
    "Bot1800",
    "Bot2000",
    "Bot2500",
    "Bot3000"
  ];

  static Map<String, String> paths = {
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
    "Room4.jpg",
    "Room5.jpg"
  ];

  static List<List<String>> storiesVierkant = [
    [
      "We willen graag een nieuwe vloer leggen in onze bakerij. Hiervoor moeten we weten hoeveel oppervlakte aan tegels we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "We willen graag een nieuwe vloer leggen in onze bar. Hiervoor moeten we weten hoeveel oppervlakte aan tegels we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "We willen graag een nieuwe vloer leggen in ons kapsalon. Hiervoor moeten we weten hoeveel oppervlakte aan tegels we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "We willen graag een nieuwe vloer leggen in ons ijssalon. Hiervoor moeten we weten hoeveel oppervlakte aan tegels we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "We willen graag een nieuwe vloer leggen in onze bar. Hiervoor moeten we weten hoeveel oppervlakte aan tegels we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "De vloer van ons PO lokaal zit zol met verfvlekken die onuitwisbaar zijn. We willen de vloer in een nieuw jasje steken. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "We willen graag een nieuwe vloer leggen in ons atelier. Hiervoor moeten we weten hoeveel oppervlakte aan tegels we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "We willen graag de vloer verven in onze slaapkamer op de 1ste verdieping. Hiervoor moeten we weten hoeveel oppervlakte aan verf we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "We willen graag een nieuwe vloer leggen in onze kamer. Hiervoor moeten we weten hoeveel oppervlakte aan tegels we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
    [
      "We willen graag een nieuwe vloer leggen in onze kamer. Hiervoor moeten we weten hoeveel oppervlakte aan hout we nodig hebben. De vloer heeft een zijde van",
      "m. Kan jij de oppervlakte berekenen?"
    ],
  ];

  static List<String> imagesCirkel = [
    "bench.JPG",
    "books.JPG",
    "books2.JPG",
    "logo.JPG",
    "logo2.JPG",
    "painting.JPG",
    "sitting.JPG",
    "sitting2.JPG",
    "sitting3.JPG",
    "sitting4.JPG",
  ];

  static List<List<String>> storiesCirkel = [
    [
      "We willen een cirkel vormige zitplaats maken voor mensen die moeten wachten voor hun kapersafspraak. We moeten de oppervlakte berekenen van deze zitplaats om best in te schatten waar we dit zouden plaatsen in ons salon. De zitplaats heeft een straal van",
      "m. Wat is de oppervlakte?"
    ],
    [
      "We willen een cirkel vormige boekenstand maken voor mensen die wat inspiratie willen opdoen voor hun nieuw kapsel. We moeten de oppervlakte berekenen van deze zitplaats om best in te schatten waar we dit zouden plaatsen in ons salon. De boekenkast heeft een straal van",
      "m. Wat is de oppervlakte?"
    ],
    [
      "We willen een cirkel vormige boekenstand maken voor mensen die wat inspiratie willen opdoen voor hun nieuw kapsel. We moeten de oppervlakte berekenen van deze zitplaats om best in te schatten waar we dit zouden plaatsen in ons salon. De boekenkast heeft een straal van",
      "m. Wat is de oppervlakte?"
    ],
    [
      "We willen de oppervlakte van ons logo berekenen. De straal van het logo is",
      "m. Kan je de oppervlakte berekenen?"
    ],
    [
      "We willen de oppervlakte van ons logo berekenen. De straal van het logo is",
      "m. Kan je de oppervlakte berekenen?"
    ],
    [
      "We willen een cirkel op de muur childeren maar hiervoor moeten we weten hoevel verf we nodig zullen hebben. De straal van de cirkel is",
      "m. Kan je de oppervlakte berekenen?"
    ],
    [
      "We willen een cirkel vormige zitplaats maken voor mensen die moeten wachten voor hun kapersafspraak. We moeten de oppervlakte berekenen van deze zitplaats om best in te schatten waar we dit zouden plaatsen in ons salon. De zitplaats heeft een straal van",
      "m. Wat is de oppervlakte?"
    ],
    [
      "We willen een cirkel vormige zitplaats maken voor mensen die moeten wachten voor hun kapersafspraak. We moeten de oppervlakte berekenen van deze zitplaats om best in te schatten waar we dit zouden plaatsen in ons salon. De zitplaats heeft een straal van",
      "m. Wat is de oppervlakte?"
    ],
    [
      "We willen een cirkel vormige zitplaats maken voor mensen die moeten wachten voor hun kapersafspraak. We moeten de oppervlakte berekenen van deze zitplaats om best in te schatten waar we dit zouden plaatsen in ons salon. De zitplaats heeft een straal van",
      "m. Wat is de oppervlakte?"
    ],
    [
      "We willen een cirkel vormige zitplaats maken voor mensen die moeten wachten voor hun kapersafspraak. We moeten de oppervlakte berekenen van deze zitplaats om best in te schatten waar we dit zouden plaatsen in ons salon. De zitplaats heeft een straal van",
      "m. Wat is de oppervlakte?"
    ],
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

  static List<List<String>> storiesRechthoek = [
    [
      "Voor ons decor willen we casettes aan de muur hangen. De breedte van een casette is",
      "m en de lengte",
      "m. Kan je de oppervlakte van 1 casette berekenen?"
    ],
    [
      "Voor ons decor willen we casettes aan de muur hangen. De breedte van een casette is",
      "m en de lengte",
      "m. Kan je de oppervlakte van 1 casette berekenen?"
    ],
    [
      "Voor ons decor willen we casettes aan de muur hangen. De breedte van een casette is",
      "m en de lengte",
      "m. Kan je de oppervlakte van 1 casette berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
    [
      "Voor ons decor willen we een kader/schilderij aan de muur hangen. De breedte van een kader is",
      "m en de lengte",
      "m. Kan je de oppervlakte van de kader berekenen?"
    ],
  ];

  static List<String> imagesDriehoek = [
    "painting.JPG",
    "painting2.JPG",
    "painting3.JPG",
    "plants.JPG",
    "wall.JPG",
    "wall2.JPG",
    "wall3.JPG",
  ];

  static List<List<String>> storiesDriehoek = [
    [
      "We willen een driehoek op de muur verven, maar hiervoor moeten we weten hoeveel verf we nodig hebben om de oppervlakte te kunnen bedekken. De driehoek heeft een basis van",
      "m, en de hoogte van de driehoek is",
      "m. Kan je de oppervlakte berekenen?"
    ],
    [
      "We willen een driehoeken op de muur verven, maar hiervoor moeten we weten hoeveel verf we nodig hebben om de oppervlakte te kunnen bedekken. De driehoek heeft een basis van",
      "m, en de hoogte van de driehoek is",
      "m. Kan je de oppervlakte berekenen van 1 driehoek?"
    ],
    [
      "We willen een driehoeken op de muur verven, maar hiervoor moeten we weten hoeveel verf we nodig hebben om de oppervlakte te kunnen bedekken. De driehoek heeft een basis van",
      "m, en de hoogte van de driehoek is",
      "m. Kan je de oppervlakte berekenen van 1 driehoek?"
    ],
    [
      "We willen wat natuur in ons kapsalon aanbrengen. Hiervoor kiezen we driehoekige bloempotten die aan de muur vast hangen. Kan je de oppervlakte dat 1 bloembak op de muur zou innemen berekenen? De basis is",
      "m en de hoogte ",
      "m."
    ],
    [
      "We willen de muur bedenken met driehoeken. Kan je de oppervlakte van 1 driehoek berekenen? De basis is",
      "m en de hoogte ",
      "m."
    ],
    [
      "We willen de muur bedenken met driehoeken. Kan je de oppervlakte van 1 driehoek berekenen? De basis is",
      "m en de hoogte ",
      "m."
    ],
    [
      "We willen de muur bedenken met driehoeken. Kan je de oppervlakte van 1 driehoek berekenen? De basis is",
      "m en de hoogte ",
      "m."
    ],
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

  static String encryptPass(String password) {
    var bytes = utf8.encode(password); // Convert password to bytes
    var digest = sha256.convert(bytes);
    var hashed = digest.toString();
    return hashed;
  }

  static Map<String, List> images = {
    "vierkant": imagesVierkant,
    "rechthoek": imagesRechthoek,
    "cirkel": imagesCirkel,
    "driehoek": imagesDriehoek
  };

  static Map<String, List> stories = {
    "vierkant": storiesVierkant,
    "rechthoek": storiesRechthoek,
    "driehoek": storiesDriehoek,
    "cirkel": storiesCirkel,
  };

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

  static List<String> getBots(int elo) {
    int rounded = (elo / 100).round();
    if (rounded < 8) {
      return ["Bot200", "Bot500", "Bot800"];
    }
    if (rounded < 10) {
      return ["Bot500", "Bot800", "Bot1000"];
    }
    if (rounded < 12) {
      return ["Bot800", "Bot1000", "Bot1200"];
    }
    if (rounded < 15) {
      return ["Bot1000", "Bot1200", "Bot1500"];
    }
    if (rounded < 17) {
      return ["Bot1200", "Bot1500", "Bot1800"];
    }
    if (rounded < 19) {
      return ["Bot1500", "Bot1800", "Bot2000"];
    }
    if (rounded < 23) {
      return ["Bot1800", "Bot2000", "Bot2500"];
    } else {
      return ["Bot2000", "Bot2500", "Bot3000"];
    }
  }

  static String getClosetsBot(int elo) {
    List<int> elosBot = [
      200,
      500,
      800,
      1000,
      1200,
      1500,
      1800,
      2000,
      2500,
      3000
    ];

    List<int> differenceLst = elosBot.map((elm) {
      return (elo - elm).abs();
    }).toList();

    int minValue = differenceLst.reduce((a, b) => a < b ? a : b);
    int idx = differenceLst.indexOf(minValue);
    int eloBot = elosBot[idx];

    String bot = "Bot" + eloBot.toString();
    return bot;
  }

  static List<String> retrievePath() {
    String pathStr = retrieveFromCookies("path");
    int length = pathStr.length;

    var pathWithoutBrackets = pathStr.substring(1, length - 1);

    List<String> path = pathWithoutBrackets.split(", ");

    return path;
  }

  static void updatePathCompletion(List pathCompletion) {
    var pathCompletedStr = pathCompletion.toString();
    saveToCookies("pathCompletion", pathCompletedStr);
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

  static bool pathCompleted() {
    List<bool> pathCompletion = retrievePathCompletion();

    if (pathCompletion.length < 5) {
      return false;
    }

    var completed = true;

    for (bool elm in pathCompletion) {
      completed = elm & true;
    }
    return completed;
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
