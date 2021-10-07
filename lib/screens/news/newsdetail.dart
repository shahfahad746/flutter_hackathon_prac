import 'package:flutter/material.dart';
import 'package:flutter_hackathon_prac/data/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsDetail extends StatefulWidget {
  @override
  _NewsDetailState createState() => _NewsDetailState();
}

class _NewsDetailState extends State<NewsDetail> {
  int favoriteColor = 0xFF000000;

  renderColor() {
    setState(() {
      favoriteColor = 0xFFFF0000;
    });
  }

  isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool userLoggedIn = prefs.containsKey("name") && prefs.containsKey("email");
    userLoggedIn ? renderColor() : showAlert();
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final News news = ModalRoute.of(context).settings.arguments as News;
    print("News Detail >>>> $news");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
      ),
      backgroundColor: Colors.cyan,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      child: Image(
                        image: NetworkImage(
                          news.image != ""
                              ? news.image
                              : "https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__480.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        padding: EdgeInsets.all(20),
                        child: GestureDetector(
                          child: Icon(
                            Icons.favorite,
                            size: 30,
                            color: Color(favoriteColor),
                          ),
                          onTap: isUserLoggedIn,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    news.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    news.description,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "Written by: " + (news.author ?? 'Unknown'),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
