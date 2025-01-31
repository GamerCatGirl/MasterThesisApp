import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SignInState();
}

class _SignInState extends State<Signin> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    final signInLogIn = Center(child: Text("Sign In Page"));

    final List _pages = [signInLogIn];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
