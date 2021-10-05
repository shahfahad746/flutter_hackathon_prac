import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool loading = false;
  bool userRegistered = false;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  registerUser() async {
    setState(() {
      this.loading = true;
      this.userRegistered = false;
    });
    bool noError = passwordController.text == confirmPasswordController.text &&
        (nameController.text != "") &&
        (emailController.text != "") &&
        (passwordController.text != "");

    if (noError) {
      try {
        FirebaseAuth auth = FirebaseAuth.instance;
        FirebaseFirestore database = FirebaseFirestore.instance;

        UserCredential authResposne = await auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        await database.collection("users").doc(authResposne.user.uid).set(
          {
            "name": nameController.text,
            "email": emailController.text,
          },
        );

        setState(() {
          this.resetControllers();
          this.loading = false;
          this.userRegistered = true;
        });
      } catch (err) {
        print("Error is: $err");
        setState(() {
          this.loading = false;
        });
      }
    } else {
      print("Registration data is not valid!!!");
    }
  }

  resetControllers() {
    nameController.text = "";
    emailController.text = "";
    passwordController.text = "";
    confirmPasswordController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
                    controller: nameController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.person,
                        color: Colors.primaries[7],
                      ),
                      labelText: "name",
                      hintText: "Shah Fahad",
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
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.primaries[7],
                      ),
                      labelText: "email",
                      hintText: "shahfahad@gmail.com",
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
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.primaries[7],
                      ),
                      labelText: "confirm password",
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
                        onPressed: registerUser,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Register"),
                            SizedBox(
                              width: loading ? 10 : 0,
                            ),
                            loading
                                ? SizedBox(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.red,
                                    ),
                                    height: 15,
                                    width: 15,
                                  )
                                : SizedBox(
                                    width: 0,
                                  ),
                          ],
                        ),
                        style: ElevatedButton.styleFrom(
                            primary: Colors.primaries[7]),
                      ),
                      userRegistered
                          ? Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "User got registered!",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            )
                          : Container(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already Registered?"),
                          TextButton(
                            onPressed: () =>
                                {Navigator.of(context).pushNamed("/login")},
                            child: Text(
                              "Login",
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
      ),
    );
  }
}
