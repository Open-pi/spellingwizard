import 'package:flutter/material.dart';
import 'package:SpellingWizard/dashboard.dart';

void main() =>
    runApp(MaterialApp(theme: ThemeData(fontFamily: 'Raleway'), home: Home()));

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[900],
      body: homePage(),
    );
  }
}
