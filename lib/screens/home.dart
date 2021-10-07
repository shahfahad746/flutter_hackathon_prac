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

  Future<List<News>> fetchNews(String category) async {
    final http.Response response = await http.get(Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=23dbfee9030c46e5b71cf9411de3792c&category=$category&pageSize=10'));

    final Map<String, dynamic> body = jsonDecode(response.body);
    List<dynamic> data = body['articles'];

    List<News> news = data.map((item) => News.fromJson(item)).toList();
    print("Result >>> $news");
    return news;
  }

  @override
  void initState() {
    this.userLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          // title: Text("Welcome ${this.name}"),
          centerTitle: true,
          backgroundColor: Colors.primaries[7],
          bottom: const TabBar(
            labelColor: Colors.white,
            tabs: [
              Tab(
                text: 'Top Headlines',
                icon: Icon(Icons.update),
              ),
              Tab(
                text: 'Sports',
                icon: Icon(Icons.sports_outlined),
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
              future: fetchNews('general'),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Stack(
                    children: [
                      ListView(
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
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: size.width * 0.8,
                          margin: EdgeInsets.only(bottom: 10),
                          child: TextFormField(
                            decoration: InputDecoration(
                              fillColor: Colors.cyan,
                              filled: true,
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.white,
                              ),
                              hintText: "Search ..",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.white,
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
                        ),
                      )
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
              future: fetchNews('sports'),
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
              future: fetchNews('health'),
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
