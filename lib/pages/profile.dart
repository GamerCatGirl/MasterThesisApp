import 'package:flutter/material.dart';
import 'package:mathapp/pages/signIn.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  int selectedPage = 0;

  void _routeToLogin() {
    //TODO
    setState(() {
      selectedPage = 1;
    });
  }

  void _routeToSignIn() {
    //TODO
    setState(() {
      selectedPage = 2;
    });
  }

  void _ToSignIn() {
    Navigator.pushNamed(context, '/signIn');
  }

  @override
  Widget build(BuildContext context) {
    var inputUsername = SizedBox(
        width: 300,
        child: TextFormField(
          controller: username,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Username',
          ),
        ));

    var inputPassword = SizedBox(
        width: 300,
        child: TextFormField(
          controller: password,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Password',
          ),
        ));

    final loginButton = ElevatedButton(onPressed: () {}, child: Text('Login'));
    final signInButton =
        ElevatedButton(onPressed: _ToSignIn, child: Text('Aanmelden'));

    final signInLogIn = Center(
        child: Column(
      children: [
        Spacer(),
        inputUsername,
        inputPassword,
        Spacer(),
        loginButton,
        Spacer(),
        signInButton,
        Spacer(),
        Spacer(),
      ],
    ));

    final List _pages = [signInLogIn];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
