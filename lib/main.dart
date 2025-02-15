import 'package:flutter/material.dart';
import 'package:mathapp/pages/home.dart';
import 'package:mathapp/pages/learning_path.dart';
import 'package:mathapp/pages/logic.dart';
import 'package:mathapp/pages/meetkunde_ex.dart';
import 'package:mathapp/pages/profile.dart';
import 'package:mathapp/pages/setting.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mathapp/pages/signIn.dart';
import 'package:mathapp/pages/viewSkills.dart';
//import 'package:fl_chart/fl_chart.dart';
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
      // TODO: los routing op!!!!
      routes: {
        '/home': (context) => Home(),
        '/profile': (context) => Profile(),
        '/setting': (context) => Setting(),
        '/signIn': (context) => Signin(),
        '/skills': (context) => Viewskills(),
      },
      onGenerateRoute: (settings) {
        final args = settings.arguments as Map<String, dynamic>;
        if (settings.name == '/learning-path') {
          return MaterialPageRoute(
              builder: (context) => LearningPath(
                  username: args['user'],
                  path: args['path'],
                  pathCompletion: args['pathCompletion']));
        } else if (settings.name == '/vierkant-exercises') {
          return MaterialPageRoute(
              builder: (context) => MeetkundeEx(
                  z: args['z'],
                  figure: args['figure'],
                  currentExercise: args['current'],
                  amountExercises: args['amount'],
                  image: args['image'],
                  callback: args['callback']));
        }
      },
    );
  }
}

//TODO: gebruik shuffle misschien ipv random 
//white spaces verwijderen naar upperspace 

// TODO: check of er een wiskunde parser is voor evaluatie tree te checken 
