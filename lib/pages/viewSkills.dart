import 'package:flutter/material.dart';
import 'package:mathapp/components/title.dart';
//import 'package:syncfusion_flutter_charts/charts.dart';
//import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Viewskills extends StatefulWidget {
  const Viewskills({super.key});

  @override
  State<Viewskills> createState() => _SkillState();
}

class _SkillState extends State<Viewskills> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final page = ListView(
      children: [
        Header(title: "View Skills"),
        Text("test"),
        Text("Lmao"),
        Text("add"),
        Text("Lol")
      ],
    );
    final List _pages = [page];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
