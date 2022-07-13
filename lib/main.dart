import 'package:aikeen_park/screens/log_in.dart';
//import 'package:aikeen_park/screens/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

//starting point of app
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Start());
}

class Start extends StatelessWidget {
  const Start({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LogIn(),
      // routes: {
      // signInRoute: (context) => const Home(),
      // }
    );
  }
}
/*
class LogInScreen extends StatelessWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Log In Page',
      theme: ThemeData(
          // primarySwatch: Colors.pink,
          ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Log In'),
          backgroundColor: const Color.fromARGB(255, 188, 240, 66),
          titleTextStyle: const TextStyle(color: Colors.purple),
        ),
        body: const Center(
          child: Text('Log In Page Test'),
        ),
        backgroundColor: Colors.lightBlue,
      ),
    );
  }
}
*/