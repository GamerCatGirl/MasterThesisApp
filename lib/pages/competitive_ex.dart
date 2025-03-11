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

  const CompetitiveEx(
      {super.key,
      required this.showFormule,
      required this.z,
      required this.currentExercise,
      required this.amountExercises,
      required this.image,
      required this.figure,
      required this.callback,
      this.b,
      required this.h});

  @override
  State<CompetitiveEx> createState() => new _CompetitiveState();
}

class _CompetitiveState extends State<CompetitiveEx> {
  final _show_start_exercise = true;
  int size = Random().nextInt(98) + 2; //number between 2 and 100
  String errorCode = "";
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
  int r = 0;
  int l = 0;
  int b = 0;
  ValueNotifier<List> selectedItems = ValueNotifier([]);
  ValueNotifier<String> errorSelect = ValueNotifier("");
  ValueNotifier<List> rowCombined = ValueNotifier([]);
  MultiSelectController<String> controllerSelector = MultiSelectController();
  //
  String labelVierkant = "Vierkant";
  late String label1;
  late String label2;

  // Formule needs to be given
  late dynamic showFormule;
  bool checkFormule = false;
  final TextEditingController inputFormule = TextEditingController();

  @override
  void initState() {
    super.initState();
    int max = Consts().maxMultiplyByHead;
    showFormule = widget.showFormule;

    if (widget.figure == "combined") {
      r = Random().nextInt(max);
      l = Random().nextInt(max);
      b = Random().nextInt(max);
    } else if (widget.figure == "cirkel") {
      r = widget.z;
    } else if (widget.figure == "driehoek") {
      b = widget.z;
    } else if (widget.figure == "rechthoek") {
      l = widget.z;
    }
    //update db?
  }

  void onSelect(allSelectedItems, selectedItem) {
    selectedItems.value = allSelectedItems;

    if (selectedItems.value.length > 0) {
      errorSelect.value = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    //Widget iconButton = IconButton(onPressed: (){}), icon: icon);
    double width = MediaQuery.of(context).size.width;

    double widthImage = width / 3 * 2;

    final vierkant = Image(
        fit: BoxFit.cover, width: widthImage, image: AssetImage(widget.image));

    String story = //TODO: make this dynamic depending on image!
        "We willen de oppervlakte van de vloer van ons nieuw kapsalon berekenen. \nWe weten dat 1 zijde " +
            widget.z.toString() +
            "m lang is, hoeveel is dan de oppervlakte van onze vloer?";

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

    String varAssignVierkant = "z = " + widget.z.toString() + "m";

    String varAssignCirkel = "straal = " + r.toString() + "m";

    String varAssignRechthoek = "lengte = " +
        l.toString() +
        "m\n breedte = " +
        widget.b.toString() +
        "m";

    String varAssignDriehoek =
        "basis = " + b.toString() + "m\n hoogte = " + widget.h.toString() + "m";

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
      return true;
    }

    bool checkResultVierkantFormule() {
      return true;
    }

    bool checkResultDriehoekFormule() {
      return true;
    }

    bool checkResultCirkelFormule() {
      return true;
    }

    bool checkResultRechthoek() {
      //check if formule needs to be checked
      if (widget.figure != "combined" && !showFormule) {
        return checkResultRechthoekFormule();
      } else if (widget.figure == "combined" && !showFormule["rechthoek"]) {
        return checkResultRechthoekFormule();
      }

      int oppervlakteCalc = (widget.b ?? 1) * l;

      if (lengte.text != l.toString()) {
        setState(() {
          errorCode =
              "de ingevulde lengte (l) komt niet overeen met de werkelijke lengte (input 1)";
        });
        return false;
      } else if (breedte.text != widget.b.toString()) {
        setState(() {
          errorCode =
              "de ingevulde breedte (b) komt niet overeen met de werkelijke breedte (input 2)";
        });
        return false;
      } else if (oppervlakteRechthoek.text != oppervlakteCalc.toString()) {
        setState(() {
          errorCode =
              "de oppervlakte (rechthoek) is niet juist berekend, maar de breedte en lengte kloppen, probeer opnieuw, je bent er bijna :)";
        });
        return false;
      }
      return true;
    }

    bool checkResultDriehoek() {
      double oppervlakteCalc = ((widget.h ?? 1) * b) / 2;

      if (widget.figure != "combined" && !showFormule) {
        return checkResultDriehoekFormule();
      } else if (widget.figure == "combined" && !showFormule["rechthoek"]) {
        return checkResultDriehoekFormule();
      }

      if (basis.text != b.toString()) {
        setState(() {
          errorCode =
              "de ingevulde basis (b) komt niet overeen met de werkelijke basis (input 1)";
        });
        return false;
      } else if (hoogte.text != widget.h.toString()) {
        setState(() {
          errorCode =
              "de ingevulde hoogte (h) komt niet overeen met de werkelijke hoogte (input 2)";
        });
        return false;
      } else if (double.parse(oppervlakteDriehoek.text) != oppervlakteCalc) {
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
      } else if (widget.figure == "combined" && !showFormule["rechthoek"]) {
        return checkResultCirkelFormule();
      }

      if (straal1.text != r.toString()) {
        setState(() {
          errorCode =
              "de ingevulde straal (r) komt niet overeen met de werkelijke straal (input 1)";
        });
        return false;
      } else if (straal2.text != r.toString()) {
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
        double oppervlakteVal = r * r * 3.14;
        String oppervlakteNumber = oppervlakteCirkel.text.replaceAll(",", ".");
        double oppervlakteFilledin = double.parse(oppervlakteNumber);

        var rounded1 = (oppervlakteVal * 100).round();
        var rounded2 = (oppervlakteFilledin * 100).round();

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
        zijde1.text = "";
        zijde2.text = "";
        oppervlakte.text = "";
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
        controllerSelector.deselectAll();
      });
    }

    bool checkResultVierkant() {
      if (widget.figure != "combined" && !showFormule) {
        return checkResultVierkantFormule();
      } else if (widget.figure == "combined" && !showFormule["rechthoek"]) {
        return checkResultVierkantFormule();
      }

      if (zijde1.text != widget.z.toString()) {
        setState(() {
          errorCode =
              "de ingevulde zijde (z) komt niet overeen met de werkelijke zijde (input 1)";
        });
        return false;
      } else if (zijde2.text != widget.z.toString()) {
        setState(() {
          errorCode =
              "de ingevulde zijde (z) komt niet overeen met de werkelijke zijde (input 2)";
        });
        return false;
      } else if (oppervlakte.text != (widget.z * widget.z).toString()) {
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

    bool checkResult() {
      bool done = false;
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
      Text("m"),
      Text("  X  "),
      SizedBox(
        width: 40,
        child: input2Field,
      ),
      Text("m"),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: input3Field,
      ),
      Text("m\u00B2"),
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
      Text("m\u00B2"),
      Spacer()
    ];

    var rowRechthoek = [
      Spacer(),
      SizedBox(width: 40, child: input1FieldRechthoek),
      Text("m"),
      Text("  X  "),
      SizedBox(
        width: 40,
        child: input2FieldRechthoek,
      ),
      Text("m"),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: inputOppervlakteRechthoek,
      ),
      Text("m\u00B2"),
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
        child: input3Field,
      ),
      Text("m\u00B2"),
      Spacer()
    ];

    var rowDriehoek = [
      Spacer(),
      Text("( "),
      SizedBox(width: 40, child: input1FieldDriehoek),
      Text("m"),
      Text("  X  "),
      SizedBox(
        width: 40,
        child: input2FieldDriehoek,
      ),
      Text("m) : 2"),
      Text("  =  "),
      SizedBox(
        width: 50,
        child: inputOppervlakteDriehoek,
      ),
      Text("m\u00B2"),
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
        child: input3Field,
      ),
      Text("m\u00B2"),
      Spacer()
    ];

    var rowCirkel = [
      Spacer(),
      SizedBox(
        width: 60,
        child: input1FieldCirkel,
      ),
      Text("m"),
      Text("  X  "),
      SizedBox(
        width: 60,
        child: input2FieldCirkel,
      ),
      Text("m"),
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
      Text("m\u00B2"),
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
        child: input3Field,
      ),
      Text("m\u00B2"),
      Spacer()
    ];

    final figuresSelect = MultiSelectContainer(
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
    Widget selectFigures = (widget.figure == "combined") ? selector : Text("");

    Widget storyText = Text(story);
    Widget vars = Text(
      varAssign,
      style: TextStyle(fontWeight: FontWeight.bold),
    );

    if (widget.figure != "combined" && !widget.showFormule) {
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

    return Column(children: [
      Center(
        child: Text("Exercise " +
            widget.currentExercise.toString() +
            " out of " +
            widget.amountExercises.toString()),
      ),
      Center(
        child: vierkant,
      ),
      storyText,
      vars,
      selectFigures,
      rows,
      SizedBox(
        height: 20,
      ),
      Center(
        child: IconButton(
            onPressed: () {
              checkResult();
            },
            icon: Icon(Icons.done)),
      ),
      Text(
        errorCode,
        style: TextStyle(color: Colors.red),
      ),
      //])
    ]);
  }
}
