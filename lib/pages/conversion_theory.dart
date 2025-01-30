import 'package:flutter/material.dart';
import 'package:mathapp/components/conversionTable.dart';
import 'package:mathapp/components/formule_input.dart';
import 'package:mathapp/components/subtitle.dart';
import 'package:mathapp/components/title.dart';

class ConversionTheory extends StatefulWidget {
  final VoidCallback done;
  const ConversionTheory({super.key, required this.done});

  @override
  State<ConversionTheory> createState() => new _OppervlakteTheoryState();
}

class _OppervlakteTheoryState extends State<ConversionTheory> {
  //FirebaseFirestore db = FirebaseFirestore.instance;
  //CollectionReference dbExercises = db.collection("MeetkundeResults");
  //CollectionReference dbExercises = db.collection("MeetkundeResults");
  //TODO: check add_exercise.dart for more info on how to connect with DB

  /*

  final widthColumns = <int, TableColumnWidth>{
    0: IntrinsicColumnWidth(),
    1: FixedColumnWidth(128),
    2: FixedColumnWidth(128),
    3: FixedColumnWidth(128),
    4: FixedColumnWidth(128),
    5: FixedColumnWidth(128),
    6: FixedColumnWidth(128),
    7: FixedColumnWidth(128),
  };
  //ex 1
  bool showVoorbeeld1 = false;

  //Gegeven ex 2
  final TextEditingController breedte1controller = TextEditingController();
  final TextEditingController lengte1controller = TextEditingController();
  //Gevraagd ex 2
  final TextEditingController inputRechthoekFormule = TextEditingController();
  bool showGevraagd2 = false;
  //Oplossing ex 2
  final TextEditingController inputBreedte = TextEditingController();
  final TextEditingController inputLengte = TextEditingController();
  final TextEditingController inputOplossingX = TextEditingController();
  final TextEditingController inputResult = TextEditingController();
  bool showOplossing2 = false;

  final correct = Icon(Icons.check);
  final fault = Icon(Icons.error);

  bool breedte1Correct = false;
  bool lengte1Correct = false;
  bool showFormule = false;
  bool showAnswers = false;
  bool formuleCorrect = false;
  //bool table1correct = false;
  final ValueNotifier<bool> table1correct = ValueNotifier(false);
  bool table2correct = false;

  String table1correctString = "";
  String table2correctString = "";

  bool checkFilledIn = false;
  //String errorTable = "";
  final ValueNotifier<String> errorTable = ValueNotifier("");
  List<String> filledIn = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "8",
    "4",
    "0",
    "0",
    "",
    ""
  ];
  List<String> extended = [
    "",
    "",
    "",
    "",
    "",
    "",
    "",
    "0,",
    "8",
    "4",
    "0",
    "0",
    "",
    ""
  ];

  IconData iconRectangle = Icons.crop_16_9_outlined;

  String errorBreedte = "";
  String errorLengte = "";
  String errorFormule = "";
  String oppervlakteRechthoek = "Oppervlakte rechthoek = ";
  String oppervlakteRechthoek2 = "Oppervlakte rechthoek = ";

  //EX2: oplossing
  bool breedte2Correct = false;
  String errorBreedte2 = "";
  String errorResult = "";
  Color resError = Colors.red;

  final breedte1 = 60;
  final lengte1 = 140;
  final oplossing = 8400;
  final row1 = TableRow(
    decoration: const BoxDecoration(
      color: Color.fromARGB(255, 218, 188, 255),
    ),
    children: <Widget>[
      Container(
        height: 32,
        child: Center(child: Text("km^2")),
      ),
      Container(
        child: Center(
          child: Text("10 000 km^2 (ha)"),
        ),
      ),
      Container(
        child: Center(child: Text("100 m^2 (a)")),
      ),
      Container(
        child: Center(child: Text("m^2 (ca)")),
      ),
      Container(
        child: Center(child: Text("dm^2")),
      ),
      Container(
        child: Center(child: Text("cm^2")),
      ),
      Container(
        child: Center(child: Text("mm^2")),
      ),
    ],
  );

  final rows = <TableRow>[
    TableRow(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 218, 188, 255),
      ),
      children: <Widget>[
        Container(
          height: 32,
          child: Center(child: Text("km^2")),
        ),
        Container(
          child: Center(
            child: Text("10 000 km^2 (ha)"),
          ),
        ),
        Container(
          child: Center(child: Text("100 m^2 (a)")),
        ),
        Container(
          child: Center(child: Text("m^2 (ca)")),
        ),
        Container(
          child: Center(child: Text("dm^2")),
        ),
        Container(
          child: Center(child: Text("cm^2")),
        ),
        Container(
          child: Center(child: Text("mm^2")),
        ),
      ],
    ),
    TableRow(
      decoration: const BoxDecoration(
        color: Color.fromARGB(100, 229, 208, 255),
      ),
      children: <Widget>[
        Container(
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  print("on km-1 clicked");
                },
                child: Container(width: 64, height: 64, color: Colors.white),
              ),
              Container(
                width: 64,
              )
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Container(width: 64, height: 64, color: Colors.white),
              Container(
                width: 64,
              )
            ],
          ),
        ),
        Center(
          child: Row(
            children: [
              Container(width: 64, height: 64, color: Colors.white),
              Container(
                width: 64,
              )
            ],
          ),
        ),
        Center(
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                color: Colors.white,
              ),
              Container(
                width: 64,
                child: Center(child: Text("0 ,")),
              )
            ],
          ),
        ),
        Center(
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                color: Colors.white,
                child: Center(child: Text("8")),
              ),
              Container(
                width: 64,
                child: Center(child: Text("4")),
              )
            ],
          ),
        ),
        Center(
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                color: Colors.white,
                child: Center(child: Text("0")),
              ),
              Container(
                child: Center(child: Text("0")),
                width: 64,
              )
            ],
          ),
        ),
        Center(
          child: Row(
            children: [
              Container(width: 64, height: 64, color: Colors.white),
              Container(
                width: 64,
              )
            ],
          ),
        ),
      ],
    ),
  ];

  */

  @override
  Widget build(BuildContext context) {
    /*
    Container inputBreedteContainer = Container(
      child: Text("data"),
    );

    Container inputLengteContainer = Container(
      child: Text("data"),
    );

    Container inputFormuleContainer = Container(
      child: FormuleInputTile(
          controller: inputRechthoekFormule,
          saveResult: (res) {
            if (res) {
              //TODO:
              formuleCorrect = true;
            }
          },
          showAnswers: showAnswers,
          icon: iconRectangle,
          name: "Rechthoek"),
    );

    //Oplossing ex 2
    void checkOplossing() {
      int res = int.parse(inputBreedte.text);
      if (res == breedte1) {
        setState(() {
          breedte2Correct = true;
        });
      } else {
        //TODO: print error on screen
        setState(() {
          errorBreedte2 =
              "De gegeven breedte klopt niet, lees de zin onder voorbeeld 2!";
        });
      }
    }

    Container inputOplossing = Container(
      child: Row(
        children: [
          Spacer(),
          Text(oppervlakteRechthoek2),
          SizedBox(
            width: 30,
            child: TextFormField(
              controller: inputBreedte,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'b',
              ),
            ),
          ),
          Text("cm x "),
          SizedBox(
            width: 30,
            child: TextFormField(
              controller: inputLengte,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'l',
              ),
            ),
          ),
          Text(" cm =  "),
          SizedBox(
            width: 60,
            child: TextFormField(
              controller: inputOplossingX,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Opp',
              ),
            ),
          ),
          Text(" cm^2"),
          IconButton(onPressed: checkOplossing, icon: Icon(Icons.check)),
          Text(
            errorBreedte2,
            style: TextStyle(color: Colors.red),
          ),
          Spacer()
        ],
      ),
    );

    Row fillinInResult = Row(
      children: [
        Spacer(),
        Text("Oppervlakte = "),
        SizedBox(
          width: 60,
          child: TextFormField(
            controller: inputResult,
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Opp',
            ),
          ),
        ),
        Text("m^2"),
        IconButton(
            onPressed: () {
              setState(() {
                if (!table1correct.value) {
                  errorResult = "Vul eerst de oppervlakte in in de tabel";
                } else if (!table2correct) {
                  errorResult =
                      "Controleer eerst het resultaat in de tabel voor m^2";
                } else if (inputResult.text == "0,84") {
                  resError = Colors.green;
                  errorResult = "Goed!";
                } else if (inputResult.text == "0,8400") {
                  errorResult =
                      "Probeer je resultaat af te ronden op 2 cijfers na de komma";
                } else if (inputResult.text == "0,840") {
                  errorResult =
                      "Probeer je resultaat af te ronden op 2 cijfers na de komma";
                } else {
                  errorResult =
                      "Resultaat is niet juist, kijk naar de waarde dat je in de tabel hebt ingevuld!";
                }
              });
            },
            icon: Icon(Icons.check)),
        Text(
          errorResult,
          style: TextStyle(color: resError),
        ),
        Spacer()
      ],
    );

    Container checkFormule = Container(
        child: Row(
      children: [
        Spacer(),
        IconButton(
            onPressed: () {
              if (!lengte1Correct) {
                setState(() {
                  errorFormule = "Vul eerst de lengte in bij gegeven";
                });
              } else if (!breedte1Correct) {
                setState(() {
                  errorFormule = "Vul eerst de breedte in bij gegeven";
                });
              } else if (inputRechthoekFormule.text == "l x b") {
                setState(() {
                  showOplossing2 = true;
                  formuleCorrect = true;
                });
              } else {
                setState(() {
                  showAnswers = true;
                });
              }
            },
            icon: Icon(Icons.check)),
        Text(errorFormule),
        Spacer()
      ],
    ));

    void checkBreedte1() {
      int res = int.parse(breedte1controller.text);
      if (res == breedte1) {
        setState(() {
          if (lengte1Correct) {
            showGevraagd2 = true;
          }
          breedte1Correct = true;
        });
      } else {
        //TODO: print error on screen
        setState(() {
          errorBreedte =
              "De gegeven breedte klopt niet, lees de zin onder voorbeeld 2!";
        });
      }
    }

    void checkTable() {
      setState(() {
        checkFilledIn = true;
      });
    }

    if (formuleCorrect) {
      print("Formule correct");
      oppervlakteRechthoek = "Oppervlakte rechthoek = l x b";
      oppervlakteRechthoek2 = "l x b = ";
      inputFormuleContainer = Container();
      checkFormule = Container();
    }

    if (breedte1Correct) {
      inputBreedteContainer = Container(
        child: Text("breedte tafel: b = 60 cm"),
      );
    } else {
      inputBreedteContainer = Container(
        child: Row(
          children: [
            Spacer(),
            Text(" - breedte tafel: b = "),
            SizedBox(
              width: 30,
              child: TextFormField(
                controller: breedte1controller,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '...',
                ),
              ),
            ),
            Text("cm"),
            IconButton(onPressed: checkBreedte1, icon: Icon(Icons.check)),
            Text(
              errorBreedte,
              style: TextStyle(color: Colors.red),
            ),
            Spacer()
          ],
        ),
      );
    }

    void checkLengte1() {
      int res = int.parse(lengte1controller.text);
      if (res == lengte1) {
        setState(() {
          if (breedte1Correct) {
            showGevraagd2 = true;
          }
          lengte1Correct = true;
        });
      } else {
        //TODO: result is false
        print("False lengte");
      }
    }

    void callbackTable(String error) {
      if (error == "correct") {
        if (filledIn == extended) {
          table2correct = true;
          table2correctString = "Goed! :)";
        }
        errorTable.value = "";
        table1correct.value = true;
        filledIn = extended;
        table1correctString = "Goed! :)";
        checkFilledIn = false;
      } else {
        errorTable.value = error;
      }
      checkFilledIn = false;
    }

    if (lengte1Correct) {
      inputLengteContainer = Container(
        child: Text("lengte tafel: l = 140 cm"),
      );
    } else {
      inputLengteContainer = Container(
        child: Row(
          children: [
            Spacer(),
            Text(" - lengte tafel: l = "),
            SizedBox(
              width: 30,
              child: TextFormField(
                controller: lengte1controller,
                decoration: const InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: '...',
                ),
              ),
            ),
            Text("cm"),
            IconButton(onPressed: checkLengte1, icon: Icon(Icons.check)),
            Spacer()
          ],
        ),
      );
    }
    */

    return Scaffold(
        body: Center(
      child: Text("test"),
    )

        /* ListView(children: [
      Spacer(),
      Header(title: "Conversion Page"),
      Spacer(),
      Text(
          "Om oppervlakte maten te herleiden kunnen we gebruik maken van onderstaande tabel."),
      Text(
          "Hoe men deze tabel gebruiken, zal worden uitgelegd met behulp van 2 voorbeelden."),
      Spacer(),
      */
        /*
      Row(
        children: [
          Spacer(),
          Conversiontable(
            done: callbackTable,
            result: filledIn,
            checkCorrectFilled: checkFilledIn,
          ),
          Spacer()
        ],
      ),
      */
        /*
      ValueListenableBuilder<String>(
        valueListenable: errorTable,
        builder: (context, value, child) {
          return Text(
            value,
            style: TextStyle(color: Colors.red),
          );
        },
      ),
      Spacer(),
      Visibility(
        visible: showVoorbeeld1,
        child: Text("Voorbeeld 1: \n"),
      ),
      Spacer(),
      Column(children: [
        Text("Voorbeeld 2: \n"),
        Text(
            "We willen de tafel verven want de oude verf is beschadigt. De tafel is 60 cm op 140 cm. Om te kunnen berekenen hoeveel verf we nodig hebben moeten we de oppervlakte van de tafel weten in m^2."),
        Subtitle(title: "Gegeven: "),
        inputBreedteContainer,
        inputLengteContainer,
      ]),
      Visibility(
        visible: showGevraagd2,
        child: Column(
          children: [
            Subtitle(title: "Gevraagd: "),
            Text("Oppervlakte tafel in m^2"),
            Text(oppervlakteRechthoek),
            inputFormuleContainer,
            checkFormule,
          ],
        ),
      ),
      Visibility(
          visible: showOplossing2,
          child: Column(children: [
            Subtitle(title: "Oplossing: "),
            Row(
              children: [Spacer(), Text(oppervlakteRechthoek2), Spacer()],
            ),
            inputOplossing,
            Text(
                "We vullen nu de oppervlakte in de tabel in, we schrijven het laatste getal van de oppervlakte (0), in de laatste kolom van cm^2. We vullen de rest van de cijfers in door steeds een kolom naar links te schuiven."),
            Row(children: [
              Spacer(),
              Text("VUL IN de oppervlakte in de tabel!     "),

              ValueListenableBuilder(
                valueListenable: table1correct,
                builder: (context, value, child) {
                  return Visibility(
                    visible: !table1correct.value,
                    child: IconButton(
                        onPressed: checkTable, icon: Icon(Icons.check)),
                  );
                },
              ),

              //Text(table1correctString),
              ValueListenableBuilder<String>(
                valueListenable: errorTable,
                builder: (context, value, child) {
                  return Text(
                    table1correctString,
                    style: TextStyle(color: Colors.green),
                  );
                },
              ),
              Spacer(),
            ]),
            Text(
                "We zetten altijd de komma van de maateenheid waar we geinteresseerd zijn het meest rechts van die kolom!"),
            Text(
                "Vul nu 0 in voor het getal tot en met we in de rechter kolom van de maateenheid zijn."),
            Row(
              children: [
                Spacer(),
                Text("VUL IN de 0, in op de juiste plaats!"),
                IconButton(
                    onPressed: () {
                      //TODO: check if previous was correct
                      if (table1correct.value) {
                        table2correctString = "";
                        checkTable();
                      } else {
                        //Display error
                        setState(() {
                          table2correctString =
                              "Vul eerst de huidige oppervlakte correct in! En probeer dan opnieuw!";
                        });
                      }
                    },
                    icon: Icon(Icons.check)),
                ValueListenableBuilder<String>(
                  valueListenable: errorTable,
                  builder: (context, value, child) {
                    return Text(
                      table2correctString,
                      style: TextStyle(color: Colors.green),
                    );
                  },
                ),
                Spacer()
              ],
            ),
            fillinInResult,
          ])),
      Spacer(),
      */
        //])
        );
  }
}
