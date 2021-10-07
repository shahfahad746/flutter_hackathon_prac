import 'package:flutter/material.dart';
import 'package:flutter_hackathon_prac/data/news.dart';

class NewsCard extends StatefulWidget {
  // const Card({ Key? key }) : super(key: key);
  final News news;

  NewsCard({this.news});

  @override
  _CardState createState() => _CardState();
}

class _CardState extends State<NewsCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed("/newsDetail", arguments: widget.news);
      },
      child: Container(
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
                  // height: size.height * 0.2,
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
                        widget.news.image != null
                            ? widget.news.image
                            : "https://cdn.pixabay.com/photo/2021/08/25/20/42/field-6574455__480.jpg",
                      ),
                      fit: BoxFit.cover,
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
                widget.news.description.length > 100
                    ? widget.news.description.substring(0, 100) + ' ...'
                    : widget.news.description,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
