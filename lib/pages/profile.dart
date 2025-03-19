import 'package:flutter/material.dart';
import 'package:mathapp/Utils/consts.dart';
import 'package:mathapp/Utils/database.dart';
import 'package:mathapp/Utils/redirections.dart';
import 'package:mathapp/components/title.dart';
import 'package:mathapp/pages/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mathapp/pages/viewSkills.dart';

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

  @override
  void initState() {
    loggedIn = Consts.loggedIn();

    if (loggedIn) {
      userLogged = Consts.getLoggedInUser();
      selectedPage = 1;
    }
  }

  void _routeToLogin() {
    //TODO
    setState(() {
      selectedPage = 0;
    });
  }

  void _routeToSignIn() {
    //TODO
    setState(() {
      selectedPage = 2;
    });
  }

  void _toSignIn() {
    setState(() {
      selectedPage = 2;
    });
    //Navigator.pushNamed(context, '/signIn');
  }

  void _ToSkill() {
    Navigator.pushNamed(context, '/skills');
  }

  void logout() {
    Database.logout(userLogged);
    _routeToLogin();
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
            Consts.login(user);
            Database.login(user);
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
          obscureText: true,
          decoration: const InputDecoration(
            border: UnderlineInputBorder(),
            labelText: 'Password',
          ),
        ));

    final loginButton = ElevatedButton.icon(
        onPressed: login, icon: Icon(Icons.login), label: Text('Login'));
    final signInButton =
        ElevatedButton(onPressed: _toSignIn, child: Text('Aanmelden'));
    final skillsButton =
        ElevatedButton(onPressed: _ToSkill, child: Text('Skills'));
    final logoutButton =
        ElevatedButton(onPressed: logout, child: Text('Uitloggen'));

    final learningPathButton =
        ElevatedButton(onPressed: _toLearning, child: Text('Leer Pad'));

    final spacer = SizedBox(
      height: 20,
    );

    final signInLogIn = Center(
        child: ListView(
      children: [
        spacer,
        Center(
          child: Header(title: "Account"),
        ),
        spacer,
        Center(
          child: inputUsername,
        ),
        Center(
          child: inputPassword,
        ),
        spacer,
        Center(child: loginButton),
        Text(
          errorLogin,
          style: TextStyle(color: Colors.red),
        ),
        spacer,
        Center(
          child: signInButton,
        ),
        spacer,
        //Center(
        //  child: skillsButton,
        //),
      ],
    ));

    final List _pages = [
      signInLogIn,
      Viewskills(
        logout: logout,
      ),
      Signin(
        done: () {
          setState(() {
            selectedPage = 0;
          });
        },
      ),
    ];

    return Scaffold(
      body: Center(child: _pages[selectedPage]),
    );
  }
}
