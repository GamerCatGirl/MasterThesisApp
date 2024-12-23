import 'package:flutter/material.dart';
import 'package:mathapp/pages/home.dart';
import 'package:mathapp/pages/logic.dart';
import 'package:mathapp/pages/profile.dart';
import 'package:mathapp/pages/setting.dart';
import 'package:firebase_core/firebase_core.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Logic(),
      // TODO: los routing op!!!!
      routes: {
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/setting': (context) => Setting(),
      },
    );
  }
}
