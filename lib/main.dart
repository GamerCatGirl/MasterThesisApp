import 'package:flutter/material.dart';
import 'package:mathapp/pages/home.dart';
import 'package:mathapp/pages/logic.dart';
import 'package:mathapp/pages/profile.dart';
import 'package:mathapp/pages/setting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

//await Firebase.initializeApp(
//  options: DefaultFirebaseOptions.currentPlatform,
//);

class MyApp extends StatelessWidget {
  
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Logic(),
      routes: {
        '/home' :(context) => Home(),
        '/profile' :(context) => Profile(),
        '/setting' :(context) => Setting(),
      },
    );
  }
}  

