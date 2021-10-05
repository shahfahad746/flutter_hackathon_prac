import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_hackathon_prac/screens/drawer/favorite.dart';
import 'package:flutter_hackathon_prac/screens/drawer/profile.dart';
import 'package:flutter_hackathon_prac/screens/drawer/search.dart';

import 'package:flutter_hackathon_prac/screens/home.dart';
import 'package:flutter_hackathon_prac/screens/login.dart';
import 'package:flutter_hackathon_prac/screens/register.dart';

import 'screens/splashscreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.primaries[7],
        accentColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
      // Scaffold(
      //   appBar: AppBar(
      //     centerTitle: true,
      //     title: Text("hi"),
      //   ),
      //   drawer: Drawer(),
      // ),
      // FutureBuilder(
      //   future: _initialization,
      //   builder: (context, snapshot) {
      //     // if (snapshot.connectionState == ConnectionState.done) {
      //     //   return SplashScreen();
      //     // }

      //     if (snapshot.hasError) {
      //       print("Error ------ ${snapshot.error}");
      //     }

      //     return SplashScreen();
      //     // return Home();
      //   },
      // ),
      routes: {
        "/home": (context) => Home(),
        "/profile": (context) => Profile(),
        "/search": (context) => Search(),
        "/favorite": (context) => Favorite(),
        "/login": (context) => Login(),
        "/register": (context) => Register()
      },
    );
  }
}
