import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hackathon_prac/data/news.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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

  Future<News> fetchNews() async {
    final http.Response response = await http.get(Uri.parse(
        'http://api.mediastack.com/v1/news?access_key=170f155d1ecac0c555d093f162068211'));

    final News news = News.fromJson(jsonDecode(response.body));
    print("Result >>> $news");
    return news;
  }

  @override
  void initState() {
    // TODO: implement initState
    this.userLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          // title: Text("Welcome ${this.name}"),
          centerTitle: true,
          backgroundColor: Colors.primaries[7],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              // Tab(icon: Icon(Icons.directions_transit)),
              // Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
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
        body: TabBarView(
          children: [
            // Icon(Icons.directions_car),
            // Icon(Icons.directions_transit),
            // Icon(Icons.directions_bike),
            FutureBuilder<News>(
              future: fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(snapshot.data.title);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                // By default, show a loading spinner.
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
