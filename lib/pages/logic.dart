import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/pages/exercises.dart';
import 'package:mathapp/pages/home.dart';
import 'package:mathapp/pages/learning_path.dart';
import 'package:mathapp/pages/profile.dart';
import 'package:mathapp/pages/setting.dart';

class Logic extends StatefulWidget {
  Logic({super.key});

  @override
  State<Logic> createState() => _LogicState();
}

class _LogicState extends State<Logic> {
  // VARIABLES
  late int selectedPage;

  String user = "Preview";

  final List _pagesNames = ["Oefen", "Leerpad", "Profiel", "Settings"];

  final List _iconsPages = [
    Icon(Icons.home),
    Icon(Icons.assignment),
    Icon(Icons.person),
    Icon(Icons.settings),
  ];

  @override
  void initState() {
    bool loggedIn = Consts.loggedIn();

    if (loggedIn) {
      selectedPage = 0;
      user = Consts.getLoggedInUser();
    } else {
      selectedPage = 2;
    }
  }

  void _navigateBottomBar(int index) {
    setState(() {
      selectedPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List _pages = [
      Home(),
      LearningPath(),
      Profile(),
      Setting(),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(_pagesNames[selectedPage]),
          backgroundColor: const Color.fromARGB(255, 212, 175, 248),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedPage,
          onTap: _navigateBottomBar, //index wordt direct meegegeven
          //onTap: navigateTo(),
          items: [
            //TODO: replace this with list
            BottomNavigationBarItem(
              icon: _iconsPages[0],
              label: _pagesNames[0],
            ),
            BottomNavigationBarItem(
              icon: _iconsPages[1],
              label: _pagesNames[1],
            ),
            BottomNavigationBarItem(
              icon: _iconsPages[2],
              label: _pagesNames[2],
            ),
          ],
        ),
        body: _pages[selectedPage]);
  }
}
