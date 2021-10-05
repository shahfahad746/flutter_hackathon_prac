import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  login() async {
    String email = emailController.text;
    String password = passwordController.text;

    if (email != "" && password != "") {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        FirebaseFirestore database = FirebaseFirestore.instance;

        UserCredential authResponse = await auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        DocumentSnapshot document =
            await database.collection('users').doc(authResponse.user.uid).get();

        Map data = document.data();
        SharedPreferences prefs = await SharedPreferences.getInstance();

        prefs.setString("name", data["name"]);
        prefs.setString("email", data["email"]);
        Navigator.pushNamed(context, "/home");
        print("User is: ${data}");
      } catch (err) {
        print("Error is $err");
      }
    } else {
      print("Login data is invalid !!! ");
    }
  }

  resetControlleres() {
    this.emailController.text = "";
    this.passwordController.text = "";
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
          child: Container(
            width: size.width * 0.8,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.primaries[7],
                    ),
                    labelText: "email",
                    hintText: "shahfahaddemo@gmail.com",
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.primaries[7],
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.primaries[7],
                        width: 25,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.primaries[7],
                    ),
                    labelText: "password",
                    hintText: "abc@123",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide(
                        color: Colors.primaries[7],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: login,
                      child: Text("Login"),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.primaries[7]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Not Registered?"),
                        TextButton(
                          onPressed: () =>
                              {Navigator.of(context).pushNamed("/register")},
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.primaries[7],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
