import 'package:flutter/material.dart';
import 'package:flutter_hackathon_prac/data/news.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewsCard extends StatefulWidget {
  // const Card({ Key? key }) : super(key: key);
  final News news;

  NewsCard({this.news});

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<NewsCard> {
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
            ));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.cyan,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      width: size.width * 1,
      margin: EdgeInsets.all(5),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: size.height * 0.2,
                width: size.width * 1,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image(
                    image: NetworkImage(
                      widget.news.image != ""
                          ? widget.news.image
                          : "https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__480.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
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
              widget.news.title,
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
              widget.news.description,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
