import 'package:flutter/material.dart';

class TimeLineScreen extends StatefulWidget {
  const TimeLineScreen({Key key}) : super(key: key);

  @override
  _TimeLineScreenState createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Soccial Media',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          IconButton(icon: Icon(Icons.chat_bubble), onPressed: () {}),
        ],
      ),
      body: Container(),
    );
  }
}
