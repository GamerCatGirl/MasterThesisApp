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

  //Gegeven ex 2
  final TextEditingController breedte1controller = TextEditingController();
  final TextEditingController lengte1controller = TextEditingController();
  //Gevraagd ex 2
  final TextEditingController inputRechthoekFormule = TextEditingController();
  //Oplossing ex 2
  final TextEditingController inputBreedte = TextEditingController();
  final TextEditingController inputLengte = TextEditingController();
  final TextEditingController inputOplossingX = TextEditingController();

  bool breedte1Correct = false;
  bool lengte1Correct = false;
  bool showFormule = false;
  bool showAnswers = false;
  bool formuleCorrect = false;

  bool checkFilledIn = false;
  //String errorTable = "";
  final ValueNotifier<String> errorTable = ValueNotifier("");
  final filledIn = ["", "", "", "", "", "", "", "", "8", "4", "0", "0", "", ""];
  final extended = [
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

  @override
  Widget build(BuildContext context) {
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
          lengte1Correct = true;
        });
      } else {
        //TODO: result is false
        print("False lengte");
      }
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

    return Scaffold(
        body: Center(
            child: ListView(children: [
      Spacer(),
      Header(title: "Conversion Page"),
      Spacer(),
      Text(
          "Om oppervlakte maten te herleiden kunnen we gebruik maken van onderstaande tabel."),
      Text(
          "Hoe men deze tabel gebruiken, zal worden uitgelegd met behulp van 2 voorbeelden."),
      Spacer(),
      /*
      Table(
        border: TableBorder.all(),
        columnWidths: widthColumns,
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: rows,
      ),
      */
      Conversiontable(
        done: (error) {
          errorTable.value = error;
          checkFilledIn = false;
        },
        result: filledIn,
        checkCorrectFilled: checkFilledIn,
      ),
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
      Text("Voorbeeld 1: \n"),
      Spacer(),
      Text("Voorbeeld 2: \n"),
      Text(
          "We willen de tafel verven want de oude verf is beschadigt. De tafel is 60 cm op 140 cm. Om te kunnen berekenen hoeveel verf we nodig hebben moeten we de oppervlakte van de tafel weten in m^2."),
      Subtitle(title: "Gegeven: "),
      inputBreedteContainer,
      inputLengteContainer,
      Subtitle(title: "Gevraagd: "),
      Text("Oppervlakte tafel in m^2"),
      Text(oppervlakteRechthoek),
      inputFormuleContainer,
      checkFormule,
      Subtitle(title: "Oplossing: "),
      Row(
        children: [Spacer(), Text(oppervlakteRechthoek2), Spacer()],
      ),
      inputOplossing,
      Text(
          "We vullen nu de oppervlakte in de tabel in, we schrijven het laatste getal van de oppervlakte (0), in de laatste kolom van cm^2. We vullen de rest van de cijfers in door steeds een kolom naar links te schuiven."),
      Row(children: [
        Spacer(),
        Text("TODO: vull de gegevens in de tabel in"),
        IconButton(
            onPressed: () {
              setState(() {
                checkFilledIn = true;
              });
            },
            icon: Icon(Icons.check)),
        Spacer(),
      ]),
      Text(
          "We zetten altijd de komma van de maateenheid waar we geinteresseerd zijn het meest rechts van die kolom!"),
      Text("TODO: vul de extra 0 en , in!"),
      Text(
          "Vul nu 0 in voor het getal tot en met we in de rechter kolom van de maateenheid zijn."),
      Text("Oppervlakte = 0,84 m^2"),
      Spacer(),
    ])));
  }
}
