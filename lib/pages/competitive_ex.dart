import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/components/exercise_tile.dart';
import 'package:mathapp/components/formule_input.dart';
import 'package:mathapp/components/icon_button_switch.dart';
import 'package:mathapp/components/row_exercise.dart';
import 'package:mathapp/components/start_exercise.dart';
import 'package:mathapp/components/title_tile.dart';
import 'package:intl/intl.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';

class CompetitiveEx extends StatefulWidget {
  final VoidCallback callback;
  final int z;
  final int? b;
  final int h;
  final int amountExercises;
  final int currentExercise;
  final dynamic showFormule;
  final String image;
  final String figure;
  final bool conversion;

  const CompetitiveEx(
      {super.key,
      required this.showFormule,
      required this.z,
      required this.currentExercise,
      required this.amountExercises,
      required this.image,
      required this.figure,
      required this.callback,
      required this.conversion,
      this.b,
      required this.h});

  @override
  State<CompetitiveEx> createState() => new _CompetitiveState();
}

class _CompetitiveState extends State<CompetitiveEx> {
  final _show_start_exercise = true;
  int size = Random().nextInt(98) + 2; //number between 2 and 100
  String errorCode = "";
  String fromEenheid = "m";
  String toEenheid = "m";
  double mulitplyWith = 1;
  List<String> eenhedenAll = ["cm", "dm", "m"];
  Map omzettingen = {
    "cm": {"cm": 1, "dm": 0.1, "m": 0.01},
    "dm": {"cm": 10, "dm": 1, "m": 0.1},
    "m": {"cm": 100, "dm": 10, "m": 1},
  };
  //vierkant
  final TextEditingController zijde1 = TextEditingController();
  final TextEditingController zijde2 = TextEditingController();
  final TextEditingController formuleVierkant = TextEditingController();
  final TextEditingController oppervlakte = TextEditingController();
  //cirkel
  final TextEditingController straal1 = TextEditingController();
  final TextEditingController straal2 = TextEditingController();
  final TextEditingController pi = TextEditingController();
  final TextEditingController formuleCirkel = TextEditingController();
  final TextEditingController oppervlakteCirkel = TextEditingController();
  //rechthoek
  final TextEditingController lengte = TextEditingController();
  final TextEditingController breedte = TextEditingController();
  final TextEditingController formuleRechthoek = TextEditingController();
  final TextEditingController oppervlakteRechthoek = TextEditingController();
  //driehoek
  final TextEditingController basis = TextEditingController();
  final TextEditingController hoogte = TextEditingController();
  final TextEditingController formuleDriehoek = TextEditingController();
  final TextEditingController oppervlakteDriehoek = TextEditingController();
  //combined: select the figures
  String warning =
      "De afmetingen van de figuren zijn niet realistisch voorgesteld!";
  String textCombined =
      "Welke figuren kan je vinden op bovenstaande afbeelding?";

  //int max = Consts().maxMultiplyByHead;
  int r = Random().nextInt(Consts().maxMultiplyByHead) + 1;
  int l = Random().nextInt(Consts().maxMultiplyByHead) + 1;
  int b = Random().nextInt(Consts().maxMultiplyByHead) + 1;
  ValueNotifier<List> selectedItems = ValueNotifier([]);
  ValueNotifier<String> errorSelect = ValueNotifier("");
  ValueNotifier<List> rowCombined = ValueNotifier([]);
  MultiSelectController<String> controllerSelector = MultiSelectController();
  //
  String labelVierkant = "Vierkant";
  late String label1;
  late String label2;
  List<String> storyArr = [];

  // Formule needs to be given
  late dynamic showFormule;
  bool checkFormule = false;
  final TextEditingController inputFormule = TextEditingController();

  //omzettingen van eenheden
  bool conversion = false;
  final TextEditingController convertFrom1 = TextEditingController();
  final TextEditingController convertTo1 = TextEditingController();
  final TextEditingController convertFrom2 = TextEditingController();
  final TextEditingController convertTo2 = TextEditingController();

  //check chance?
  String errorCheck = "";

  @override
  void initState() {
    super.initState();
    conversion = widget.conversion;
    setupVars();
    //update db?
  }

  void setupVars() {
    int max = Consts().maxMultiplyByHead;
    showFormule = widget.showFormule;

    List<String> imageSplitted = widget.image.split("/");
    int lengthPath = imageSplitted.length;
    String imageShort = imageSplitted[lengthPath - 1];

    if (widget.figure != "combined") {
      List images = Consts.images[widget.figure]!;
      List stories = Consts.stories[widget.figure]!;
      List eenheden = Consts.eenheden[widget.figure]!;
      if (images == null || stories == null || eenheden == null) {
        throw ArgumentError("Figure does not exists!");
      }
      int index = images.indexOf(imageShort);
      if (index == null) {
        throw ArgumentError("Figure does not exists!");
      }
      storyArr = stories[index];

      fromEenheid = eenheden[index];
      toEenheid = eenheden[index];

      //if (lastImage != widget.image) {
      if (conversion) {
        print("setup conversion");
        //TODO: from eenheid different
        int maxIdx = eenhedenAll.length;
        int idx = Random().nextInt(maxIdx);
        if (eenhedenAll[idx] == fromEenheid) {
          idx += 1;
        }
        if (idx == eenhedenAll.length) {
          idx = 0;
        }
        toEenheid = eenhedenAll[idx];
        mulitplyWith = omzettingen[fromEenheid][toEenheid];
      }
      //lastImage = widget.image;
      //}
    }

    if (widget.figure == "combined") {
      //if (widget.z != )
      //r = Random().nextInt(max);
      //l = Random().nextInt(max);
      //b = Random().nextInt(max);
    } else if (widget.figure == "cirkel") {
      r = widget.z;
    } else if (widget.figure == "driehoek") {
      b = widget.z;
    } else if (widget.figure == "rechthoek") {
      l = widget.z;
    }
  }

  void onSelect(allSelectedItems, selectedItem) {
    selectedItems.value = allSelectedItems;

    if (selectedItems.value.length > 0) {
      errorSelect.value = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    setupVars();

    double width = MediaQuery.of(context).size.width;

    double widthImage = width / 6 * 2;

    if (conversion) {
      errorCheck =
          "Opgelet, als je resultaten controleerd en het resultaat is niet juist krijg je een nieuwe omzetting! (50% kans)";
    }

    final vierkant = Image(
        fit: BoxFit.cover, width: widthImage, image: AssetImage(widget.image));

    String story = //TODO: make this dynamic depending on image!
        "We willen de oppervlakte van de vloer van ons nieuw kapsalon berekenen. \nWe weten dat 1 zijde " +
            widget.z.toString() +
            fromEenheid +
            " lang is, hoeveel is dan de oppervlakte van onze vloer?";

    if (widget.figure == "rechthoek") {
      story = storyArr[0] +
          " " +
          widget.b.toString() +
          fromEenheid +
          storyArr[1] +
          " " +
          l.toString() +
          fromEenheid +
          storyArr[2];
    } else if (widget.figure == "vierkant") {
      story =
          storyArr[0] + " " + widget.z.toString() + fromEenheid + storyArr[1];
    } else if (widget.figure == "cirkel") {
      story = storyArr[0] + " " + r.toString() + fromEenheid + storyArr[1];
    } else if (widget.figure == "driehoek") {
      story = storyArr[0] +
          " " +
          b.toString() +
          fromEenheid +
          storyArr[1] +
          " " +
          widget.h.toString() +
          fromEenheid +
          storyArr[2];
    } else if (widget.figure == "combined") {
      story = "";
    }

    var input1Field = TextFormField(
      controller: zijde1,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'z',
      ),
    );
    var input2Field = TextFormField(
      controller: zijde2,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'z',
      ),
    );

    var input3Field = TextFormField(
      controller: oppervlakte,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Opp',
      ),
    );

    var inputVierkantFormule = TextFormField(
      controller: formuleVierkant,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Berekening',
      ),
    );

    var input1FieldCirkel = TextFormField(
      controller: straal1,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'straal',
      ),
    );

    var input2FieldCirkel = TextFormField(
      controller: straal2,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'straal',
      ),
    );

    var input3FieldCirkel = TextFormField(
      controller: pi,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'pi',
      ),
    );

    var inputCirkelFormule = TextFormField(
      controller: formuleCirkel,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Berekening',
      ),
    );

    var inputOppervlakteCirkel = TextFormField(
      controller: oppervlakteCirkel,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Opp',
      ),
    );
    //rechthoek
    var input1FieldRechthoek = TextFormField(
      controller: lengte,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'l',
      ),
    );

    var input2FieldRechthoek = TextFormField(
      controller: breedte,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'b',
      ),
    );

    var inputRechthoekFormule = TextFormField(
      controller: formuleRechthoek,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Berekening',
      ),
    );

    var inputOppervlakteRechthoek = TextFormField(
      controller: oppervlakteRechthoek,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Opp',
      ),
    );

    //driehoek
    var input1FieldDriehoek = TextFormField(
      controller: basis,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'b',
      ),
    );

    var input2FieldDriehoek = TextFormField(
      controller: hoogte,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'h',
      ),
    );

    var inputDriehoekFormule = TextFormField(
      controller: formuleDriehoek,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Berekening',
      ),
    );

    var inputOppervlakteDriehoek = TextFormField(
      controller: oppervlakteDriehoek,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        labelText: 'Opp',
      ),
    );

    var inputFormuleWidget = FormuleInputTile(
        controller: inputFormule,
        saveResult: (res) {},
        showAnswers: checkFormule,
        icon: Icons.abc,
        name: widget.figure);

    var inputFromConv1 = TextFormField(
      controller: convertFrom1,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
      ),
    );

    var inputToConv1 = TextFormField(
      controller: convertTo1,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
      ),
    );

    var inputFromConv2 = TextFormField(
      controller: convertFrom2,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
      ),
    );

    var inputToConv2 = TextFormField(
      controller: convertTo2,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
      ),
    );

    List<Widget> convertArrVierkant = [
      Spacer(),
      Text("z = "),
      SizedBox(
        width: 60,
        child: inputFromConv1,
      ),
      Text(fromEenheid + " = "),
      SizedBox(
        width: 60,
        child: inputToConv1,
      ),
      Text(toEenheid),
      Spacer(),
    ];

    List<Widget> convertArrCircle = [
      Spacer(),
      Text("r = "),
      SizedBox(
        width: 60,
        child: inputFromConv1,
      ),
      Text(fromEenheid + " = "),
      SizedBox(
        width: 60,
        child: inputToConv1,
      ),
      Text(toEenheid),
      Spacer(),
    ];

    List<Widget> convertArrTriangle1 = [
      Spacer(),
      Text("b = "),
      SizedBox(
        width: 60,
        child: inputFromConv1,
      ),
      Text(fromEenheid + " = "),
      SizedBox(
        width: 60,
        child: inputToConv1,
      ),
      Text(toEenheid),
      Spacer(),
    ];

    List<Widget> convertArrTriangle2 = [
      Spacer(),
      Text("h = "),
      SizedBox(
        width: 60,
        child: inputFromConv2,
      ),
      Text(fromEenheid + " = "),
      SizedBox(
        width: 60,
        child: inputToConv2,
      ),
      Text(toEenheid),
      Spacer(),
    ];

    List<Widget> convertArrRectangle1 = [
      Spacer(),
      Text("l = "),
      SizedBox(
        width: 60,
        child: inputFromConv1,
      ),
      Text(fromEenheid + " = "),
      SizedBox(
        width: 60,
        child: inputToConv1,
      ),
      Text(toEenheid),
      Spacer(),
    ];

    List<Widget> convertArrRectangle2 = [
      Spacer(),
      Text("b = "),
      SizedBox(
        width: 60,
        child: inputFromConv2,
      ),
      Text(fromEenheid + " = "),
      SizedBox(
        width: 60,
        child: inputToConv2,
      ),
      Text(toEenheid),
      Spacer(),
    ];

    String varAssignVierkant = "z = " + widget.z.toString() + fromEenheid;

    String varAssignCirkel = "straal = " + r.toString() + fromEenheid;

    String varAssignRechthoek = "lengte = " +
        l.toString() +
        fromEenheid +
        "\n breedte = " +
        widget.b.toString() +
        fromEenheid;

    String varAssignDriehoek = "basis = " +
        b.toString() +
        fromEenheid +
        "\n hoogte = " +
        widget.h.toString() +
        fromEenheid;

    String varAssignCombined = "z = " + //vierkant
        widget.z.toString() +
        "m\nstraal = " + //cirkel
        r.toString() +
        "m\nlengte = " + //rechthoek
        l.toString() +
        "m\nbreedte = " +
        widget.b.toString() +
        "m\nbasis = " + //driehoek
        b.toString() +
        "m\nhoogte = " +
        widget.h.toString() +
        "m";

    String varAssign = (widget.figure == "vierkant")
        ? varAssignVierkant
        : (widget.figure == "cirkel")
            ? varAssignCirkel
            : (widget.figure == "rechthoek")
                ? varAssignRechthoek
                : (widget.figure == "driehoek")
                    ? varAssignDriehoek
                    : (widget.figure == "combined")
                        ? varAssignCombined
                        : varAssignVierkant;

    bool checkResultRechthoekFormule() {
      String inputFormule = formuleRechthoek.text.replaceAll(toEenheid, "");

      double oppervlakteCalc =
          (widget.b ?? 1) * mulitplyWith * l * mulitplyWith;

      if (!inputFormule.contains("x")) {
        setState(() {
          errorCode =
              "De formule moet een 'x' bevatten om de oppervlakte te berekenen!";
        });
        return false;
      }

      List<String> splitted = inputFormule.split("x");

      if (splitted.length > 2) {
        setState(() {
          errorCode = "De formule hoort maar in 'x' te bevatten!";
        });
        return false;
      }

      String leftSide = splitted[0].replaceAll(" ", "");
      String rightSide = splitted[1].replaceAll(" ", "");

      String lengte = (l * mulitplyWith).toString();
      String breedte = (widget.b! * mulitplyWith).toString();

      if (leftSide != lengte && rightSide != lengte) {
        setState(() {
          errorCode =
              "De correcte lengte is niet terug te vinden in de formule!";
        });
        return false;
      }

      if (leftSide != breedte && rightSide != breedte) {
        setState(() {
          errorCode =
              "De correcte breedte is niet terug te vinden in de formule!";
        });
        return false;
      }

      if (oppervlakteRechthoek.text.replaceAll(" ", "") !=
          oppervlakteCalc.toString()) {
        setState(() {
          errorCode =
              "de oppervlakte (rechthoek) is niet juist berekend, maar de breedte en lengte kloppen, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }

      return true;
    }

    bool checkResultVierkantFormule() {
      String inputFormule = formuleVierkant.text.replaceAll(toEenheid, "");

      double oppervlakteCalc =
          widget.z * mulitplyWith * widget.z * mulitplyWith;

      if (!inputFormule.contains("x")) {
        setState(() {
          errorCode =
              "De formule moet een 'x' bevatten om de oppervlakte te berekenen!";
        });
        return false;
      }

      List<String> splitted = inputFormule.split("x");

      if (splitted.length > 2) {
        setState(() {
          errorCode = "De formule hoort maar in 'x' te bevatten!";
        });
        return false;
      }

      String leftSide = splitted[0].replaceAll(" ", "");
      String rightSide = splitted[1].replaceAll(" ", "");

      String zijde = (widget.z * mulitplyWith).toString();

      if (leftSide != zijde || rightSide != zijde) {
        setState(() {
          errorCode = "De formule is niet correct";
        });
        return false;
      }

      if (oppervlakte.text.replaceAll(" ", "") != oppervlakteCalc.toString()) {
        setState(() {
          errorCode =
              "de oppervlakte (vierkant) is niet juist berekend, maar de formule klopt, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }

      return true;
    }

    bool checkResultDriehoekFormule() {
      String inputFormule =
          formuleDriehoek.text.replaceAll(toEenheid, "").replaceAll(" ", "");
      double oppervlakteCalc = (widget.h * mulitplyWith * b * mulitplyWith) / 2;

      if (!inputFormule.contains(":")) {
        setState(() {
          errorCode = "De formule moet een deling (:) bevatten (driehoek)";
        });
        return false;
      }

      List<String> splitted = inputFormule.split(":");
      if (splitted.length > 2) {
        setState(() {
          errorCode = "De formule mag maar 1 deling (:) bevatten (driehoek)";
        });
        return false;
      }

      String leftSide = splitted[0].replaceAll(" ", "");
      String rightSide = splitted[1].replaceAll(" ", "");

      if (rightSide != "2") {
        setState(() {
          errorCode = "De noemer klopt niet (driehoek)";
        });
        return false;
      }

      int maxIdx = leftSide.length - 1;

      if (leftSide[0] != "(" || leftSide[maxIdx] != ")") {
        setState(() {
          errorCode = "De haakjes kloppen niet (driehoek)";
        });
        return false;
      }

      String withoutBrakets = leftSide.substring(1, maxIdx);

      if (!withoutBrakets.contains("x")) {
        setState(() {
          errorCode = "De teller moet een maal (x) bevatten! (driehoek)";
        });
        return false;
      }

      List<String> breakUp = withoutBrakets.split("x");

      if (breakUp.length > 2) {
        setState(() {
          errorCode = "De teller mag maar 1 maalteken (x) bevatten! (driehoek)";
        });
        return false;
      }

      String leftAtom = breakUp[0];
      String rightAtom = breakUp[1];
      //TODO: convert to rounded after 2 dec after ,
      int lft = (double.parse(leftAtom) * 100).round();
      int rght = (double.parse(rightAtom) * 100).round();

      int lftCtr = (widget.h * mulitplyWith * 100).round();
      int rgtCtr = (b * mulitplyWith * 100).round();
      if (lft != lftCtr && rght != lftCtr) {
        setState(() {
          errorCode = "De hoogte van de driehoek ontbreekt in de formule!";
        });
        return false;
      }

      if (lft != rgtCtr && rght != rgtCtr) {
        setState(() {
          errorCode = "De basis van de driehoek ontbreekt in de formule!";
        });
        return false;
      }

      int oppRound = (oppervlakteCalc * 100).round();
      double parsedRes = double.parse(
          oppervlakteDriehoek.text.replaceAll(" ", "").replaceAll(",", "."));
      int pRes = (parsedRes * 100).round();
      if (oppRound != pRes) {
        setState(() {
          errorCode = "De oppervlakte klopt niet, maar formule is wel correct!";
        });
        return false;
      }

      return true;
    }

    bool checkResultCirkelFormule() {
      double oppervlakteVal = r * mulitplyWith * r * mulitplyWith * 3.14;
      String formule = formuleCirkel.text
          .replaceAll(" ", "")
          .replaceAll(",", ".")
          .replaceAll(toEenheid, "");

      if (!formule.contains("x")) {
        setState(() {
          errorCode =
              "De formule moet een vermenigvuldiging (x) bevatten (cirkel)";
        });
        return false;
      }

      List<String> splitted = formule.split("x");

      if (splitted.length != 3) {
        setState(() {
          errorCode = "De formule moet 2 maaltekens (x) bevatten (cirkel)";
        });
        return false;
      }

      // r x r x 3,14
      var var1 = splitted[0];
      var var2 = splitted[1];
      var var3 = splitted[2];

      if (var1 != "3.14" && var2 != "3.14" && var3 != "3.14") {
        setState(() {
          errorCode = "De formule moet 3.14 (pi) bevatten! (cirkel)";
        });
        return false;
      }

      splitted.remove("3.14");

      var r1 = splitted[0];
      var r2 = splitted[1];

      if (r1 != r2) {
        setState(() {
          errorCode = "De formule moet 2 keer de straal (r) bevatten! (cirkel)";
        });
        return false;
      }

      if (r1 != (r * mulitplyWith).toString()) {
        setState(() {
          errorCode = "De straal (r) in de formule klopt niet! (cirkel)";
        });
        return false;
      }

      String oppervlakteNumber = oppervlakteCirkel.text.replaceAll(",", ".");
      double oppervlakteFilledin = double.parse(oppervlakteNumber);

      var rounded1 = (oppervlakteVal * 100).round();
      var rounded2 = (oppervlakteFilledin * 100).round();

      if (rounded1 != rounded2) {
        setState(() {
          errorCode =
              "de oppervlakte (cirkel) is niet juist berekend, de formule klopt wel, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }

      return true;
    }

    bool checkResultRechthoek() {
      //check if formule needs to be checked
      if (widget.figure != "combined" && !showFormule) {
        return checkResultRechthoekFormule();
      } else if (widget.figure == "combined" && !showFormule["rechthoek"]) {
        return checkResultRechthoekFormule();
      }

      double oppervlakteCalc =
          (widget.b ?? 1) * mulitplyWith * l * mulitplyWith;

      if (lengte.text != (l * mulitplyWith).toString()) {
        setState(() {
          errorCode =
              "de ingevulde lengte (l) komt niet overeen met de werkelijke lengte (input 1)";
        });
        return false;
      } else if (breedte.text != (widget.b! * mulitplyWith).toString()) {
        setState(() {
          errorCode =
              "de ingevulde breedte (b) komt niet overeen met de werkelijke breedte (input 2)";
        });
        return false;
      } else if (oppervlakteRechthoek.text.replaceAll(" ", "") !=
          oppervlakteCalc.toString()) {
        setState(() {
          errorCode =
              "de oppervlakte (rechthoek) is niet juist berekend, maar de breedte en lengte kloppen, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }
      return true;
    }

    bool checkResultDriehoek() {
      double oppervlakteCalc =
          ((widget.h * mulitplyWith) * b * mulitplyWith) / 2;

      if (widget.figure != "combined" && !showFormule) {
        return checkResultDriehoekFormule();
      } else if (widget.figure == "combined" && !showFormule["driehoek"]) {
        return checkResultDriehoekFormule();
      }

      if (basis.text != b.toString()) {
        setState(() {
          errorCode =
              "de ingevulde basis (b) komt niet overeen met de werkelijke basis (input 1)";
        });
        return false;
      } else if (hoogte.text != (widget.h * mulitplyWith).toString()) {
        setState(() {
          errorCode =
              "de ingevulde hoogte (h) komt niet overeen met de werkelijke hoogte (input 2)";
        });
        return false;
      }
      //TODO: round * 100
      int contr = (oppervlakteCalc * 100).round();
      String parsedRes =
          oppervlakteDriehoek.text.replaceAll(" ", "").replaceAll(",", ".");
      int comp = (double.parse(parsedRes) * 100).round();
      if (comp != contr) {
        setState(() {
          errorCode =
              "de oppervlakte (driehoek) is niet juist berekend, maar de basis en hoogte kloppen, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }
      return true;
    }

    bool checkResultCirkel() {
      if (widget.figure != "combined" && !showFormule) {
        return checkResultCirkelFormule();
      } else if (widget.figure == "combined" && !showFormule["cirkel"]) {
        return checkResultCirkelFormule();
      }
      if (straal1.text.isEmpty) {
        setState(() {
          errorCode = "vul de straal in (input 1)";
        });
        return false;
      } else if (straal2.text.isEmpty) {
        setState(() {
          errorCode = "vul de straal in (input 2)";
        });
        return false;
      }
      int rtocheck =
          (double.parse(straal1.text.replaceAll(",", ".")) * 100).round();

      int rtocheck2 =
          (double.parse(straal2.text.replaceAll(",", ".")) * 100).round();

      if (rtocheck != (r * mulitplyWith * 100).round()) {
        setState(() {
          errorCode =
              "de ingevulde straal (r) komt niet overeen met de werkelijke straal (input 1)";
        });
        return false;
      } else if (rtocheck2 != (r * mulitplyWith * 100).round()) {
        setState(() {
          errorCode =
              "de ingevulde straal (r) komt niet overeen met de werkelijke straal (input 2)";
        });
        return false;
      } else if (pi.text != "3,14" && pi.text != "3.14") {
        setState(() {
          errorCode =
              "de ingevulde constante (pi) komt niet overeen met de werkelijke waarde (input 3)";
        });
        return false;
      } else {
        double oppervlakteVal = r * mulitplyWith * r * mulitplyWith * 3.14;
        String oppervlakteNumber = oppervlakteCirkel.text.replaceAll(",", ".");
        double oppervlakteFilledin = double.parse(oppervlakteNumber);

        var rounded1 = (oppervlakteVal * 100).round();
        var rounded2 = (oppervlakteFilledin * 100).round();
        print(rounded1);
        print(rounded2);

        if (rounded1 != rounded2) {
          setState(() {
            errorCode =
                "de oppervlakte (cirkel) is niet juist berekend, maar de straal en constante kloppen, probeer opnieuw, je bent er bijna :)";
          });
          return false;
        }
      }

      return true;
    }

    void resultsChecked() {
      widget.callback();
      setState(() {
        convertFrom1.text = "";
        convertTo1.text = "";
        convertFrom2.text = "";
        convertTo2.text = "";
        zijde1.text = "";
        zijde2.text = "";
        oppervlakte.text = "";
        formuleVierkant.text = "";
        formuleCirkel.text = "";
        formuleDriehoek.text = "";
        formuleRechthoek.text = "";
        basis.text = "";
        hoogte.text = "";
        oppervlakteDriehoek.text = "";
        errorCode = "";
        straal1.text = "";
        straal2.text = "";
        pi.text = "";
        oppervlakteCirkel.text = "";
        breedte.text = "";
        lengte.text = "";
        oppervlakteRechthoek.text = "";
        selectedItems.value = [];
        if (widget.figure == "combined") {
          controllerSelector.deselectAll();
        }
      });
    }

    bool checkResultVierkant() {
      if (widget.figure != "combined" && !showFormule) {
        return checkResultVierkantFormule();
      } else if (widget.figure == "combined" && !showFormule["vierkant"]) {
        return checkResultVierkantFormule();
      }

      if (zijde1.text != (widget.z * mulitplyWith).toString()) {
        setState(() {
          errorCode =
              "de ingevulde zijde (z) komt niet overeen met de werkelijke zijde (input 1)";
        });
        return false;
      } else if (zijde2.text != (widget.z * mulitplyWith).toString()) {
        setState(() {
          errorCode =
              "de ingevulde zijde (z) komt niet overeen met de werkelijke zijde (input 2)";
        });
        return false;
      } else if (oppervlakte.text.replaceAll(" ", "") !=
          (widget.z * mulitplyWith * widget.z * mulitplyWith).toString()) {
        setState(() {
          errorCode =
              "de oppervlakte (vierkant) is niet juist berekend, maar zijde 1 en 2 kloppen, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }
      return true;
    }

    bool checkResultCombined() {
      String image = widget.image;
      List<String> imagePath = image.split("/");
      int idx = imagePath.length - 1;
      String img = imagePath[idx];

      int idx2 = Consts.imagesCombined.indexOf(img);
      List<String> figures = Consts.figuresCombined[idx2];

      selectedItems.value.sort();
      figures.sort();

      if (!listEquals(selectedItems.value, figures)) {
        if (selectedItems.value.length < figures.length) {
          setState(() {
            errorCode = "Niet alle figuren zijn gevonden!";
          });
          return false;
        } else if (selectedItems.value.length > figures.length) {
          setState(() {
            errorCode = "Je hebt teveel figuren geselecteerd!";
          });
          return false;
        } else {
          setState(() {
            errorCode = "Je hebt niet de juiste figuren geselecteerd!";
          });
          return false;
        }
      } else {
        bool result = true;
        if (selectedItems.value.contains("vierkant")) {
          bool resVierkant = checkResultVierkant();
          result = result && resVierkant;
        }
        if (selectedItems.value.contains("rechthoek")) {
          bool resVierkant = checkResultRechthoek();
          result = result && resVierkant;
        }
        if (selectedItems.value.contains("driehoek")) {
          bool resVierkant = checkResultDriehoek();
          result = result && resVierkant;
        }
        if (selectedItems.value.contains("cirkel")) {
          bool resVierkant = checkResultCirkel();
          result = result && resVierkant;
        }
        return result;
      }
    }

    bool checkConversion() {
      int convFr =
          (int.parse(convertFrom1.text.replaceAll(",", ".")) * 100).round();
      int convTo =
          (double.parse(convertTo1.text.replaceAll(",", ".")) * 100).round();
      if (widget.figure == "vierkant") {
        if (convFr != (widget.z * 100)) {
          setState(() {
            errorCode =
                "Zijde (z) is niet juist ingevuld voor je van eenheid veranderd!";
          });
          return false;
        } else if (convTo != (widget.z * mulitplyWith * 100)) {
          setState(() {
            errorCode =
                "Zijde (z) is juist ingevuld voor je van eenheid veranderd, maar is niet juist omgezet!";
          });
          return false;
        }
      } else if (widget.figure == "cirkel") {
        if (convFr != r * 100) {
          setState(() {
            errorCode =
                "Straal (r) is niet juist ingevuld voor je van eenheid veranderd!";
          });
          return false;
        }

        int contr = (r * mulitplyWith * 100).round();
        if (convTo != contr) {
          setState(() {
            errorCode =
                "Straal (r) is juist ingevuld voor je van eenheid veranderd, maar is niet juist omgezet!";
          });
          return false;
        }
        return true;
      }
      int convFr2 =
          (int.parse(convertFrom2.text.replaceAll(",", ".")) * 100).round();
      int convTo2 =
          (double.parse(convertTo2.text.replaceAll(",", ".")) * 100).round();

      if (widget.figure == "rechthoek") {
        int contr1 = (l * mulitplyWith * 100).round();
        int contr2 = (widget.b! * mulitplyWith * 100).round();
        if (convFr != l * 100) {
          setState(() {
            errorCode =
                "Lengte (l) is niet juist ingevuld voor je van eenheid veranderd!";
          });
          return false;
        }
        if (convTo != contr1) {
          setState(() {
            errorCode =
                "Lengte (l) is juist ingevuld voor je van eenheid veranderd, maar is niet juist omgezet!";
          });
          return false;
        }
        if (convFr2 != widget.b! * 100) {
          setState(() {
            errorCode =
                "Breedte (b) is niet juist ingevuld voor je van eenheid veranderd!";
          });
          return false;
        }
        if (convTo2 != contr2) {
          setState(() {
            errorCode =
                "Breedte (b) is juist ingevuld voor je van eenheid veranderd, maar is niet juist omgezet!";
          });
          return false;
        }
      } else if (widget.figure == "driehoek") {
        int contr1 = (b * mulitplyWith * 100).round();
        int contr2 = (widget.h! * mulitplyWith * 100).round();
        if (convFr != b * 100) {
          setState(() {
            errorCode =
                "Basis (b) is niet juist ingevuld voor je van eenheid veranderd!";
          });
          return false;
        }
        if (convTo != contr1) {
          setState(() {
            errorCode =
                "Hoogte (h) is juist ingevuld voor je van eenheid veranderd, maar is niet juist omgezet!";
          });
          return false;
        }
        if (convFr2 != widget.h! * 100) {
          setState(() {
            errorCode =
                "Basis (b) is niet juist ingevuld voor je van eenheid veranderd!";
          });
          return false;
        }
        if (convTo2 != contr2) {
          setState(() {
            errorCode =
                "Hoogte (h) is juist ingevuld voor je van eenheid veranderd, maar is niet juist omgezet!";
          });
          return false;
        }
      }
      return true;
    }

    bool checkResult() {
      bool done = false;

      if (conversion && mulitplyWith != 1) {
        bool conversionDone = checkConversion();
        if (!conversionDone) return false;
      }

      if (widget.figure == "vierkant") {
        done = checkResultVierkant();
      } else if (widget.figure == "cirkel") {
        done = checkResultCirkel();
      } else if (widget.figure == "rechthoek") {
        done = checkResultRechthoek();
      } else if (widget.figure == "driehoek") {
        done = checkResultDriehoek();
      } else if (widget.figure == "combined") {
        done = checkResultCombined();
      } else {
        return false;
      }

      if (done) {
        resultsChecked();
        return true;
      } else {
        return false;
      }
    }

    var rowVierkant = [
      Spacer(),
      SizedBox(width: 40, child: input1Field),
      Text(toEenheid),
      Text("  X  "),
      SizedBox(
        width: 40,
        child: input2Field,
      ),
      Text(toEenheid),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: input3Field,
      ),
      Text(toEenheid + "\u00B2"),
      Spacer(),
    ];

    var rowVierkantFormule = [
      Spacer(),
      SizedBox(
        width: 100,
        child: inputVierkantFormule,
      ),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: input3Field,
      ),
      Text(toEenheid + "\u00B2   (vierkant)"),
      Spacer()
    ];

    var rowRechthoek = [
      Spacer(),
      SizedBox(width: 40, child: input1FieldRechthoek),
      Text(toEenheid),
      Text("  X  "),
      SizedBox(
        width: 40,
        child: input2FieldRechthoek,
      ),
      Text(toEenheid),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: inputOppervlakteRechthoek,
      ),
      Text(toEenheid + "\u00B2"),
      Spacer(),
    ];

    var rowRechthoekFormule = [
      Spacer(),
      SizedBox(
        width: 100,
        child: inputRechthoekFormule,
      ),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: inputOppervlakteRechthoek,
      ),
      Text(toEenheid + "\u00B2   (rechthoek)"),
      Spacer()
    ];

    var rowDriehoek = [
      Spacer(),
      Text("( "),
      SizedBox(width: 40, child: input1FieldDriehoek),
      Text(toEenheid),
      Text("  X  "),
      SizedBox(
        width: 40,
        child: input2FieldDriehoek,
      ),
      Text(toEenheid + ") : 2"),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: inputOppervlakteDriehoek,
      ),
      Text(toEenheid + "\u00B2"),
      Spacer(),
    ];

    var rowDriehoekFormule = [
      Spacer(),
      SizedBox(
        width: 100,
        child: inputDriehoekFormule,
      ),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: inputOppervlakteDriehoek,
      ),
      Text(toEenheid + "\u00B2   (driehoek)"),
      Spacer()
    ];

    var rowCirkel = [
      Spacer(),
      SizedBox(
        width: 60,
        child: input1FieldCirkel,
      ),
      Text(toEenheid),
      Text("  X  "),
      SizedBox(
        width: 60,
        child: input2FieldCirkel,
      ),
      Text(toEenheid),
      Text("  X  "),
      SizedBox(
        width: 40,
        child: input3FieldCirkel,
      ),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: inputOppervlakteCirkel,
      ),
      Text(toEenheid + "\u00B2"),
      Spacer(),
    ];

    var rowCirkelFormule = [
      Spacer(),
      SizedBox(
        width: 100,
        child: inputCirkelFormule,
      ),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: inputOppervlakteCirkel,
      ),
      Text(toEenheid + "\u00B2  (cirkel)"),
      Spacer()
    ];

    List<Widget> conversionRow = [];
    List<Widget> conversionRow2 = [];

    if (conversion && mulitplyWith != 1) {
      if (widget.figure == "vierkant") {
        conversionRow = convertArrVierkant;
      } else if (widget.figure == "cirkel") {
        conversionRow = convertArrCircle;
      } else if (widget.figure == "driehoek") {
        conversionRow = convertArrTriangle1;
        conversionRow2 = convertArrTriangle2;
      } else if (widget.figure == "rechthoek") {
        conversionRow = convertArrRectangle1;
        conversionRow2 = convertArrRectangle2;
      }
    }

    final figuresSelect = MultiSelectContainer(
        itemsDecoration: MultiSelectDecorations(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.purple[200]!),
              borderRadius: BorderRadius.circular(20)),
        ),
        prefix: MultiSelectPrefix(
          selectedPrefix: const Padding(
            padding: EdgeInsets.only(right: 5),
            child: Icon(
              Icons.check,
              color: Colors.white,
              size: 14,
            ),
          ),
        ),
        items: [
          MultiSelectCard(value: 'vierkant', label: labelVierkant),
          MultiSelectCard(value: 'rechthoek', label: 'Rechthoek'),
          MultiSelectCard(value: 'driehoek', label: 'Driehoek'),
          MultiSelectCard(value: 'cirkel', label: 'Cirkel'),
        ],
        controller: controllerSelector,
        onChange: (allSelectedItems, selectedItem) {
          var row;
          if (selectedItem == "vierkant") {
            row = rowVierkant;
          } else if (selectedItem == "rechthoek") {
            row = rowRechthoek;
          } else if (selectedItem == "driehoek") {
            row = rowDriehoek;
          } else if (selectedItem == "cirkel") {
            row = rowCirkel;
          }

          if (selectedItems.value.contains(selectedItem)) {
            rowCombined.value = List.from(rowCombined.value)..remove(row);
          } else {
            rowCombined.value = List.from(rowCombined.value)..add(row);
          }

          selectedItems.value = allSelectedItems;

          if (allSelectedItems.length > 0) {
            errorSelect.value = "";
          }
        });

    Widget selector = Center(
      child: figuresSelect,
    );

    Widget whatToSelect = (widget.figure == "combined")
        ? Text(
            textCombined,
            style: TextStyle(color: Colors.grey),
          )
        : Text("");
    Widget selectFigures = (widget.figure == "combined") ? selector : Text("");

    Widget storyText = Container(
      padding: EdgeInsets.all(20),
      child: Text(story),
    );
    Widget vars = Text(
      varAssign,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    if (widget.figure != "combined" && !showFormule) {
      rowVierkant = rowVierkantFormule;
      rowCirkel = rowCirkelFormule;
      rowDriehoek = rowDriehoekFormule;
      rowRechthoek = rowRechthoekFormule;
    }

    var row = (widget.figure == "vierkant")
        ? [rowVierkant]
        : (widget.figure == "cirkel")
            ? [rowCirkel]
            : (widget.figure == "rechthoek")
                ? [rowRechthoek]
                : (widget.figure == "driehoek")
                    ? [rowDriehoek]
                    : rowCombined.value;

    var rows = ValueListenableBuilder(
        valueListenable: selectedItems,
        builder: (x, val, y) {
          if (widget.figure == "combined") {
            return Column(
              children: val.map((elm) {
                var row;
                bool showFor = showFormule[elm];

                if (elm == "vierkant") {
                  if (showFor) {
                    row = rowVierkant;
                  } else {
                    row = rowVierkantFormule;
                  }
                } else if (elm == "rechthoek") {
                  if (showFor) {
                    row = rowRechthoek;
                  } else {
                    row = rowRechthoekFormule;
                  }
                } else if (elm == "driehoek") {
                  if (showFor) {
                    row = rowDriehoek;
                  } else {
                    row = rowDriehoekFormule;
                  }
                } else if (elm == "cirkel") {
                  if (showFor) {
                    row = rowCirkel;
                  } else {
                    row = rowCirkelFormule;
                  }
                }
                return Row(
                  children: row,
                );
              }).toList(),
            );
          } else {
            return Column(
              children: row
                  .map((elm) => Row(
                        children: elm,
                      ))
                  .toList(),
            );
          }
        });

    List<Widget> ex = [
      Center(
        child: Text("Exercise " +
            widget.currentExercise.toString() +
            " out of " +
            widget.amountExercises.toString()),
      ),
      Center(
        child: vierkant,
      ),
      Center(
        child: Text(
          warning,
          style: TextStyle(color: Colors.grey),
        ),
      ),
      storyText,
      vars,
      SizedBox(
        height: 10,
      ),
      Row(
        children: conversionRow,
      ),
      Row(
        children: conversionRow2,
      ),
      selectFigures,
      whatToSelect,
      rows,
      SizedBox(
        height: 20,
      ),
      Center(
        child: Text(
          "Je hoeft zelf geen eenheden in te vullen!",
          style: TextStyle(color: Colors.grey),
        ),
      ),
      Row(
        children: [
          Spacer(),
          SizedBox(
            width: 100,
          ),
          IconButton(
              onPressed: () {
                checkResult();
              },
              icon: Icon(Icons.done)),
          SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 300,
            child: Text(
              errorCheck,
              style: TextStyle(color: Colors.grey),
            ),
          ),
          Spacer()
        ],
      ),
      Text(
        errorCode,
        style: TextStyle(color: Colors.red),
      ),
      //])
    ];

    return Container(
        width: MediaQuery.of(context).size.width,
        child: Row(children: [
          SizedBox(width: 20),
          Expanded(child: Column(children: ex)),
          Expanded(
              child: Column(
            children: [
              Text(
                  style: TextStyle(color: Colors.red),
                  "Opgelet! '.' wordt op dit rekenmachine als komma gebruikt \n(',' is om 1000 tallen te onderscheiden)!"),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 400,
                height: 600,
                child: SimpleCalculator(
                  theme: const CalculatorThemeData(
                    displayColor: Colors.black,
                    displayStyle:
                        const TextStyle(fontSize: 80, color: Colors.yellow),
                    /*...*/
                  ),
                ),
              )
            ],
          ))
        ])); //,
    //Column(children: [Text("test")])
    //],
    //);
  }
}
