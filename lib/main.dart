import 'dart:io';

import 'package:flutter/material.dart';
import 'package:SpellingWizard/dashboard.dart';
import 'package:splashscreen/splashscreen.dart';

void main() =>
    runApp(MaterialApp(theme: ThemeData(fontFamily: 'Raleway'), home: Home()));

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  Future<Widget> loadFromFuture() async {
    List<Items> items = await categoryList();
    return Future.value(new Scaffold(
      backgroundColor: Colors.purple[900],
      body: homePage(items),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new SplashScreen(
        navigateAfterFuture: loadFromFuture(),
        title: new Text(
          'Welcome to SpellingWizard\n\tmade by OSS',
          style: new TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20.0, color: Colors.white),
        ),
        image: new Image.asset('assets/splash_icon.png'),
        backgroundColor: Colors.purple[900],
        loaderColor: Colors.purple);
  }
}
