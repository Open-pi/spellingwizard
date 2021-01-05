import 'dart:io';

import 'package:SpellingWizards/save.dart';
import 'package:flutter/material.dart';
import 'package:SpellingWizards/dashboard.dart';
import 'package:flutter/services.dart';
import 'package:splashscreen/splashscreen.dart';

import 'config.dart';

void main() async {
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    loadTheme();
    super.initState();
    appTheme.addListener(() {
      setState(() {});
    });
  }

  loadTheme() async {
    File themeFile = await loadThemeFile();
    String theme = themeFile.readAsStringSync();
    if (theme.isNotEmpty) {
      appTheme.changeThemeTo(theme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spelling Wizards',
      theme: appTheme.currentTheme.theme,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() => new HomeState();
}

class HomeState extends State<Home> {
  Future<Widget> loadFromFuture() async {
    List<Items> items = await categoryList();
    await new Future.delayed(const Duration(seconds: 2));
    return Future.value(new Scaffold(
      body: HomePage(items),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 550) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }
    return new SplashScreen(
      navigateAfterFuture: loadFromFuture(),
      image: new Image.asset('assets/splash_icon.png'),
      photoSize: 120.0,
      backgroundColor: Colors.purple[900],
      loaderColor: Colors.white,
      seconds: 2,
    );
  }
}
