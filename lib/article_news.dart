import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class ReadNews extends StatefulWidget {
  final String title, content, imageUrl;
  const ReadNews(
      {super.key,
      required this.title,
      required this.content,
      required this.imageUrl});

  @override
  State<ReadNews> createState() => _ReadNewsState();
}

class _ReadNewsState extends State<ReadNews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(widget.title.substring(0, 23) + "...")),
        body: SingleChildScrollView(
            child: Column(
          children: [
            Container(
              child: CachedNetworkImage(
                imageUrl: widget.imageUrl != ""
                    ? widget.imageUrl
                    : "https://i.pinimg.com/564x/8d/f8/48/8df848551eb3effb0ad7bf351eac292d.jpg",
                fit: BoxFit.cover,
              ),
            ),
            contentDisplay(widget.title, widget.title, widget.content),
          ],
        )));
  }

  Container contentDisplay(String title, String desc, String content) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              desc,
              style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              content,
              style: const TextStyle(fontSize: 17, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
