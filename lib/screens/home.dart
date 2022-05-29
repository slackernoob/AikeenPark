import 'package:aikeen_park/screens/log_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: [
      ElevatedButton(
        onPressed: () {
          _signOut();
          Navigator.pop(context);
        },
        child: Text("Sign out"),
      )
    ]));
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
