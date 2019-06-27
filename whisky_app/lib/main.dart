import 'package:flutter/material.dart';
import 'package:whisky_app/views/home/home_widget.dart';

void main() => runApp(WhiskyApp());

class WhiskyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Whisky App',
      home: Home(),
      theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.brown[900],
          accentColor: Colors.brown,
          backgroundColor: Colors.brown[100],
          cardColor: Colors.brown[200]),
    );
  }
}
