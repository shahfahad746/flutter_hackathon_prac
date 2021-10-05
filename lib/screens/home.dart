import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";
  String email = "";

  logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("name");
    prefs.remove("email");
    await auth.signOut();
    Navigator.of(context).pushNamed("/login");
  }

  userLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("name");
    String email = prefs.getString("email");

    setState(() {
      this.name = name;
      this.email = email;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    this.userLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome ${this.name}"),
        centerTitle: true,
        backgroundColor: Colors.primaries[7],
        // automaticallyImplyLeading: false,
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.cyan,
              ),
              child: Text('Logged In User Info'),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed("/home");
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed("/profile");
              },
            ),
            ListTile(
              title: const Text('Search'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed("/search");
              },
            ),
            ListTile(
              title: const Text('Favorite'),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed('/favorite');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text("Logout"),
          onPressed: logout,
        ),
      ),
    );
  }
}
