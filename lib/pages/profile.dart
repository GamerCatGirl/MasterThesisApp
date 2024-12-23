import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

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

    var loginButton = ElevatedButton(onPressed: () {}, child: Text('Login'));

    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Spacer(),
          inputUsername,
          inputPassword,
          Spacer(),
          loginButton,
          Spacer(),
          Spacer(),
        ],
      )),
    );
  }
}
