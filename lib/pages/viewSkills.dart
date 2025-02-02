import 'package:flutter/material.dart';
import 'package:mathapp/components/title.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:fl_chart/fl_chart.dart';

class Viewskills extends StatefulWidget {
  const Viewskills({super.key});

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
  int selectedPage = 0;

  List<RawDataSet> rawDataSets() {
    return [
      RawDataSet(
        title: 'Skills',
        color: Colors.blue,
        values: [75, 50, 25, 30],
      ),
    ];
  }

  List<RawDataSet> rawDataSets2() {
    return [
      RawDataSet(
        title: 'Bloom',
        color: Colors.blue,
        values: [75, 50, 25, 30, 40, 20],
      ),
      RawDataSet(
        title: 'Bloom',
        color: Colors.purple,
        values: [60, 40, 90, 20, 60, 30],
      ),
    ];
  }

  List<RadarDataSet> showingDataSets() {
    return rawDataSets().asMap().entries.map((entry) {
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
    return rawDataSets2().asMap().entries.map((entry) {
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
    final page = ListView(
      children: [
        Header(title: "View Skills"),
        Text("Skills needed"),
        Text("TODO: flowchart of how skills are needed for topics?"),
        Text("Oppervlakte Berekenen"),
        SizedBox(
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
                    text: 'Oppervlakte vierkant',
                    angle: usedAngle,
                  );
                case 2:
                  return RadarChartTitle(
                    text: 'Oppervlakte rechthoek',
                    angle: usedAngle,
                  );
                case 1:
                  return RadarChartTitle(
                      text: 'Oppervlakte Cirkel', angle: usedAngle);
                case 3:
                  return RadarChartTitle(
                      text: 'Oppervlakte Driehoek', angle: usedAngle);
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
        Text("OR"),
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
                    text: 'Remember',
                    angle: usedAngle,
                  );
                case 2:
                  return RadarChartTitle(
                    text: 'Understand',
                    angle: usedAngle,
                  );
                case 1:
                  return RadarChartTitle(text: 'Apply', angle: usedAngle);
                case 3:
                  return RadarChartTitle(text: 'Analyse', angle: usedAngle);
                case 4:
                  return RadarChartTitle(text: 'Evaluate', angle: usedAngle);
                case 5:
                  return RadarChartTitle(text: 'Create', angle: usedAngle);
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
        Text("Progress"),
        Text("Your skills significantly improved for x topics"),
        Text(
            "Long time that you have practiced y topic, refresh your knowledge"),
        Text("Advise"),
        Text("Practice these (link) exercises: (Personalised Feedback)"),
        Text("Analyse"),
        Text("Low Knowledge: oppervlakte cirkel"),
        Text("Medium Knowledge: oppervlakte driehoek"),
        Text("Good Knowledge: Oppervlakte rechthoek"),
        Text("Pro Knowledge: oppervlakte vierkant")
      ],
    );
    final List _pages = [page];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
