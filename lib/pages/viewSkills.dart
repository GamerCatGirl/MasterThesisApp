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
        title: 'Fashion',
        color: Colors.red,
        values: [
          300,
          50,
          250,
        ],
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

  @override
  Widget build(BuildContext context) {
    final page = ListView(
      children: [
        Header(title: "View Skills"),
        Text("test"),
        Text("Lmao"),
        Text("add"),
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
                    text: 'Mobile or Tablet',
                    angle: usedAngle,
                  );
                case 2:
                  return RadarChartTitle(
                    text: 'Desktop',
                    angle: usedAngle,
                  );
                case 1:
                  return RadarChartTitle(text: 'TV', angle: usedAngle);
                default:
                  return const RadarChartTitle(text: '');
              }
            },
            titlePositionPercentageOffset: 0.2,
            tickBorderData: const BorderSide(color: Colors.transparent),
            gridBorderData: BorderSide(color: Colors.purple, width: 2),
            ticksTextStyle:
                const TextStyle(color: Colors.transparent, fontSize: 10),
            radarBorderData:
                const BorderSide(color: Colors.transparent), //buitenste cirkel
          )),
        ),
        Text("Lol"),
      ],
    );
    final List _pages = [page];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
