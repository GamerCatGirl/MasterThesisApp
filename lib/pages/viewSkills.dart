import 'package:flutter/material.dart';
import 'package:mathapp/components/title.dart';
//import 'package:fl_chart/fl_chart.dart';

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

  RawDataSet rawDataSet = RawDataSet(
    title: 'Fashion',
    color: Colors.red,
    values: [
      300,
      50,
      250,
    ],
  );

  @override
  Widget build(BuildContext context) {
    /*
    final radar = RadarDataSet(
      fillColor: rawDataSet.color.withAlpha(100),
      borderColor: rawDataSet.color,
      entryRadius: 3,
      dataEntries: rawDataSet.values.map((e) => RadarEntry(value: e)).toList(),
      borderWidth: 2.3,
    );
    */

    final page = ListView(
      children: [
        Header(title: "View Skills"),
        Text("test"),
        //RadarChart(RadarChartData(dataSets: [radar])),
        Text("Lmao"),
        Text("add"),
      ],
    );
    final List _pages = [page];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
