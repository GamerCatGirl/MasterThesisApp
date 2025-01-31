import 'package:flutter/material.dart';
import 'package:mathapp/components/rating.dart';
import 'package:mathapp/components/title.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SignInState();
}

class _SignInState extends State<Signin> {
  int selectedPage = 0;

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController repeatPassword = TextEditingController();

  int answerQ1 = 0;

  final String intro =
      "Om zo goed mogelijk oefeningen aan te bieden op jouw niveau volgt een kleine vragenlijst. De antwoorden worden enkel gebruikt voor oefeningen op maat aan te bieden, de antwoorden zijn niet zichtbaar voor medeleering of leerkracht.";

  final String question1 = "Q1: ";

  @override
  Widget build(BuildContext context) {
    final q1 = Rating(question: question1, onChangeRating: (rating) {});
    final signInLogIn = Center(child: Text("Sign In Page"));
    final page = ListView(
      children: [Header(title: "Sign In"), Text(intro), q1],
    );

    final List _pages = [page];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
