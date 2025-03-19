import 'package:flutter/material.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/components/title.dart';
import 'package:fl_chart/fl_chart.dart';

class Viewskills extends StatefulWidget {
  final VoidCallback logout;

  const Viewskills({super.key, required this.logout});

  @override
  State<Viewskills> createState() => _SkillState();
}

class RawDataSet {
  RawDataSet({
    required this.title,
    required this.color,
    required this.values,
  });

  final String title;
  final Color color;
  final List<double> values;
}

class _SkillState extends State<Viewskills> {
  int selectedPage = 1;

  ValueNotifier<List<RawDataSet>> eloDataset = ValueNotifier([]);
  ValueNotifier<List<RawDataSet>> effortDataset = ValueNotifier([]);

  ValueNotifier<bool> loading = ValueNotifier(true);

  late String user;

  @override
  void initState() {
    var loggedIn = Consts.loggedIn();

    if (loggedIn) {
      user = Consts.getLoggedInUser();

      //TODO: check if learning path is done
      Database.showSkills(user).then((val) {
        if (val) {
          Database.getElo(user).then((val) {
            if (val.isNotEmpty) {
              var dataset =
                  RawDataSet(title: 'Skills', color: Colors.blue, values: val);
              eloDataset.value.add(dataset);
              //loading.value = false;
            }
          });

          Database.getAllElo().then((val) => {
                eloDataset.value.add(
                  RawDataSet(title: 'Skills', color: Colors.grey, values: val),
                ),
                loading.value = false
              });
          setState(() {
            selectedPage = 0;
          });
        } else {
          selectedPage = 1;
        }
      });
    }

    //TODO: get Elo
  }

  List<RawDataSet> rawDataSets2 = [
    RawDataSet(
      title: 'Bloom',
      color: Colors.purple,
      values: [75, 50, 25, 30, 40],
    ),
    RawDataSet(
      title: 'Bloom',
      color: Colors.grey,
      values: [60, 40, 90, 20, 60],
    ),
  ];

  List<RadarDataSet> showingDataSets() {
    return eloDataset.value.asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;

      final isSelected = true;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withValues(alpha: 0.2)
            : rawDataSet.color.withValues(alpha: 0.05),
        borderColor: isSelected
            ? rawDataSet.color
            : rawDataSet.color.withValues(alpha: 0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }

  List<RadarDataSet> showingDataSets2() {
    return rawDataSets2.asMap().entries.map((entry) {
      final index = entry.key;
      final rawDataSet = entry.value;

      final isSelected = true;

      return RadarDataSet(
        fillColor: isSelected
            ? rawDataSet.color.withValues(alpha: 0.2)
            : rawDataSet.color.withValues(alpha: 0.05),
        borderColor: isSelected
            ? rawDataSet.color
            : rawDataSet.color.withValues(alpha: 0.25),
        entryRadius: isSelected ? 3 : 2,
        dataEntries:
            rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
        borderWidth: isSelected ? 2.3 : 2,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final space = SizedBox(
      height: 20,
    );

    final title = Center(child: Header(title: "Profiel van " + user));

    final h1 = Center(
      child: Text(
        "Hoe goed scoor je tegenover je klasgenoten?",
        style: TextStyle(fontSize: 25),
      ),
    );
    final subH1 = Center(
      child: Text(
        "Dit is gebaseerd op hoe goed je oefeningen oplost tegenover je klasgenoten.",
      ),
    );

    final h2 = Center(
      child: Text(
        "Inzet",
        style: TextStyle(fontSize: 25),
      ),
    );

    final subH2 = Center(
      child: Text(
        "Dit is gebaseerd op het aantal oefeningen je maakt tegenover je klasgenoten.",
      ),
    );

    final list = [
      Text("Progress"),
      Text("Your skills significantly improved for x topics"),
      Text("Long time that you have practiced y topic, refresh your knowledge"),
      Text("Advise"),
      Text("Practice these (link) exercises: (Personalised Feedback)"),
      Text("Analyse"),
      Text("Low Knowledge: oppervlakte cirkel"),
      Text("Medium Knowledge: oppervlakte driehoek"),
      Text("Good Knowledge: Oppervlakte rechthoek"),
      Text("Pro Knowledge: oppervlakte vierkant")
    ];

    final loadingPage = 0; //TODO:

    SizedBox loadRadar1() {
      return SizedBox(
        height: 300,
        child: RadarChart(RadarChartData(
          dataSets: showingDataSets(),
          radarBackgroundColor: Colors.transparent,
          borderData: FlBorderData(show: false),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 14),
          getTitle: (index, angle) {
            final usedAngle = angle;
            switch (index) {
              case 0:
                return RadarChartTitle(
                  text: 'Opp. vierkant',
                  angle: usedAngle,
                );
              case 2:
                return RadarChartTitle(
                  text: 'Opp. rechthoek',
                  angle: usedAngle,
                );
              case 1:
                return RadarChartTitle(text: 'Opp. Cirkel', angle: usedAngle);
              case 3:
                return RadarChartTitle(text: 'Opp. Driehoek', angle: usedAngle);
              case 4:
                return RadarChartTitle(
                    text: 'Conversion Tabel', angle: usedAngle);
              default:
                return const RadarChartTitle(text: '');
            }
          },
          titlePositionPercentageOffset: 0.2,
          tickBorderData: const BorderSide(color: Colors.transparent),
          gridBorderData: BorderSide(color: Colors.orange, width: 2),
          ticksTextStyle:
              const TextStyle(color: Colors.transparent, fontSize: 10),
          radarBorderData:
              const BorderSide(color: Colors.transparent), //buitenste cirkel
        )),
      );
    }

    var radar = ValueListenableBuilder(
        valueListenable: loading,
        builder: (x, val, y) {
          if (val) {
            return Text("loading");
          } else {
            return loadRadar1();
          }
        });

    final logoutButton = ElevatedButton.icon(
      onPressed: widget.logout,
      icon: Icon(
        Icons.logout,
      ),
      label: Text('Uitloggen'),
    );
    /*
    final logoutButton = IconButton(
        onPressed: widget.logout,
        icon: Icon(
          Icons.logout,
          size: 40,
        ));
  */
    final pageCompleteLearning = ListView(
      children: [
        SizedBox(
          height: 40,
        ),
        Center(
          child: Text(
              "Voltooi eerst het leerpad om je vooruitgang te kunnen zien!"),
        ),
      ],
    );

    final page = ListView(
      children: [
        space,
        title,
        h1,
        subH1,
        space,
        radar,
        space,
        space,
        h2,
        subH2,
        space,
        SizedBox(
          height: 300,
          child: RadarChart(RadarChartData(
            dataSets: showingDataSets2(),
            radarBackgroundColor: Colors.transparent,
            borderData: FlBorderData(show: false),
            titleTextStyle: TextStyle(color: Colors.black, fontSize: 14),
            getTitle: (index, angle) {
              final usedAngle = angle;
              switch (index) {
                case 0:
                  return RadarChartTitle(
                    text: 'Opp. vierkant',
                    angle: usedAngle,
                  );
                case 2:
                  return RadarChartTitle(
                    text: 'Opp. rechthoek',
                    angle: usedAngle,
                  );
                case 1:
                  return RadarChartTitle(text: 'Opp. Cirkel', angle: usedAngle);
                case 3:
                  return RadarChartTitle(
                      text: 'Opp. Driehoek', angle: usedAngle);
                case 4:
                  return RadarChartTitle(
                      text: 'Conversion Tabel', angle: usedAngle);
                default:
                  return const RadarChartTitle(text: '');
              }
            },
            titlePositionPercentageOffset: 0.2,
            tickBorderData: const BorderSide(color: Colors.transparent),
            gridBorderData: BorderSide(color: Colors.orange, width: 2),
            ticksTextStyle:
                const TextStyle(color: Colors.transparent, fontSize: 10),
            radarBorderData:
                const BorderSide(color: Colors.transparent), //buitenste cirkel
          )),
        ),
        SizedBox(
          height: 40,
        ),
        Center(
          child: SizedBox(
            width: 150,
            child: logoutButton,
          ),
        )
      ],
    );
    final List _pages = [page, pageCompleteLearning];

    return _pages[selectedPage];
  }
}
