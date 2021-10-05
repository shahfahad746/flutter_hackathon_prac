import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String ellipsis = "";
  int count = 0;

  startTimer() async {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (count == 1) {
        this.isUserLoggedIn(timer);
      } else if (count == 5) {
        timer.cancel();
      } else {
        setState(() {
          ellipsis = ellipsis + ".";
          count++;
        });
      }
    });
  }

  isUserLoggedIn(Timer timer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userLoggedIn = prefs.containsKey("name") && prefs.containsKey("email");
    timer.cancel();
    userLoggedIn
        ? Navigator.pushNamed(context, "/home")
        : Navigator.pushNamed(context, "/login");
  }

  @override
  void initState() {
    super.initState();
    this.startTimer();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(
          color: Colors.primaries[7],
        ),
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Loading",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 80,
                    child: Text(
                      " $ellipsis ",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 36,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
