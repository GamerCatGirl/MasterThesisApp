import 'package:flutter/material.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/pages/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  bool loggedIn = false;
  var userLogged = "";
  var learningPath = [];
  var pathCompletion = [];

  String errorLogin = "";

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

  void _ToSkill() {
    Navigator.pushNamed(context, '/skills');
  }

  void login() {
    var user = username.text;
    var pass = password.text;

    CollectionReference dbUsers = db.collection("users");

    if (user.isEmpty) {
      setState(() {
        errorLogin = "Vul je gebruikersnaam in!";
      });
    } else if (pass.isEmpty) {
      setState(() {
        errorLogin = "Vull je passwoord in!";
      });
    } else {
      final docRef = dbUsers.doc(username.text);
      docRef.get().then((doc) {
        print("Doc found...");
        if (doc.exists) {
          print("Doc Exists");
          //TODO
          final data = doc.data() as Map<String, dynamic>;
          final passCheck = data['password'];

          if (passCheck == pass) {
            setState(() {
              if (data['path'] != null) {
                learningPath = data['path'];
              }
              if (data['pathCompletion'] != null) {
                pathCompletion = data['pathCompletion'];
              }
              userLogged = user;
              selectedPage = 1;
              loggedIn = true;
            });
          } else {
            setState(() {
              errorLogin = "Fout paswoord!";
            });
          }
        }
      });
    }
  }

  void _toLearning() {
    Navigator.pushNamed(context, '/learning-path', arguments: {
      'user': userLogged,
      'path': learningPath,
      'pathCompletion': pathCompletion
    });
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

    final loginButton = ElevatedButton(onPressed: login, child: Text('Login'));
    final signInButton =
        ElevatedButton(onPressed: _ToSignIn, child: Text('Aanmelden'));
    final skillsButton =
        ElevatedButton(onPressed: _ToSkill, child: Text('Skills'));

    final loggedInPage = ListView(
      children: [
        Header(title: userLogged + ", you are succesfully logged in!"),
        Row(
          children: [
            Spacer(),
            ElevatedButton(
                onPressed: () {
                  //logged();
                  _toLearning();
                },
                child: Text('Leer Pad')),
            Spacer()
          ],
        )
      ],
    );

    final signInLogIn = Center(
        child: Column(
      children: [
        Spacer(),
        Header(title: "Account"),
        Spacer(),
        inputUsername,
        inputPassword,
        Spacer(),
        Row(
          children: [
            Spacer(),
            loginButton,
            Spacer(),
            Text(errorLogin),
            Spacer()
          ],
        ),
        Spacer(),
        signInButton,
        Spacer(),
        skillsButton,
        Spacer(),
      ],
    ));

    final List _pages = [signInLogIn, loggedInPage];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
