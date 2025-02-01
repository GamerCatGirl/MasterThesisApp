import 'package:flutter/material.dart';
import 'package:mathapp/components/rating.dart';
import 'package:mathapp/components/title.dart';

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
      ],
    );

    final List _pages = [page];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
