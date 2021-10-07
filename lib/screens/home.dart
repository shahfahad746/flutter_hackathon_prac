import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hackathon_prac/data/news.dart';
import 'package:flutter_hackathon_prac/screens/news/newscard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name = "";
  String email = "";
  bool loggedIn = false;

  navigate(String path) {
    Navigator.of(context).pushNamed(path);
  }

  isUserLoggedIn(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userLoggedIn = prefs.containsKey("name") && prefs.containsKey("email");
    userLoggedIn ? navigate(path) : showAlert();
  }

  showAlert() {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text("You are not logged in!"),
              content: Text("Do you want to login?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("CANCEL"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed("/login");
                  },
                  child: Text("OK"),
                ),
              ],
            ));
  }

  logout() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("name");
    prefs.remove("email");
    await auth.signOut();
    Navigator.of(context).pushNamed("/home");
  }

  userLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString("name");
    String email = prefs.getString("email");

    if (name != null && email != null) {
      setState(() {
        this.name = name;
        this.email = email;
        this.loggedIn = true;
      });
    }
  }

  Future<List<News>> fetchNews() async {
    final http.Response response = await http.get(Uri.parse(
        'http://api.mediastack.com/v1/news?access_key=170f155d1ecac0c555d093f162068211&languages=en&source=health&limit=5'));

    final Map<String, dynamic> body = jsonDecode(response.body);
    List<dynamic> data = body['data'];

    List<News> news = data.map((item) => News.fromJson(item)).toList();
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
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // title: Text("Welcome ${this.name}"),
          centerTitle: true,
          backgroundColor: Colors.primaries[7],
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Sports',
                icon: Icon(Icons.directions_car),
              ),
              Tab(
                text: 'Health',
                icon: Icon(Icons.health_and_safety),
              ),
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
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.cyan,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    loggedIn
                        ? Text("Welcome $name")
                        : Text("User not logged in"),
                    loggedIn ? Text(email) : Text('')
                  ],
                ),
              ),
              ListTile(
                title: const Text('Home'),
                trailing: Icon(Icons.home),
                onTap: () {
                  navigate('/home');
                },
              ),
              ListTile(
                title: const Text('Profile'),
                trailing: Icon(Icons.person),
                onTap: () {
                  isUserLoggedIn('/profile');
                },
              ),
              ListTile(
                title: const Text('Search'),
                trailing: Icon(Icons.search),
                onTap: () {
                  isUserLoggedIn('/search');
                },
              ),
              ListTile(
                title: const Text('Favorite'),
                trailing: Icon(Icons.favorite),
                onTap: () {
                  isUserLoggedIn('/favorite');
                },
              ),
              loggedIn
                  ? ListTile(
                      title: const Text('Logout'),
                      trailing: Icon(Icons.logout),
                      onTap: () {
                        logout();
                      },
                    )
                  : ListTile(
                      title: const Text('Login'),
                      trailing: Icon(Icons.login),
                      onTap: () {
                        navigate('/login');
                      },
                    ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FutureBuilder(
              future: fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        if (true)
                          NewsCard(
                            news: News(
                                title: snapshot.data[i].title,
                                description: snapshot.data[i].description,
                                image: snapshot.data[i].image),
                          ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("Error !!!! ${snapshot.error}");
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            FutureBuilder(
              future: fetchNews(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: [
                      for (var i = 0; i < snapshot.data.length; i++)
                        if (true)
                          NewsCard(
                            news: News(
                                title: snapshot.data[i].title,
                                description: snapshot.data[i].description,
                                image: snapshot.data[i].image),
                          ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text("Error !!!! ${snapshot.error}");
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),

            // Icon(Icons.directions_car),
            // Icon(Icons.directions_transit),
            // Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
