import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:SpellingWizard/save.dart';
import 'package:SpellingWizard/admob.dart';
import 'package:SpellingWizard/dashboard.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'providermodel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseAdMob.instance.initialize(appId: AdManager.appId);
  InAppPurchaseConnection.enablePendingPurchases();
  runApp(ChangeNotifierProvider(
      create: (context) => ProviderModel(),
      child:
          MaterialApp(theme: ThemeData(fontFamily: 'WorkSans'), home: App())));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    loadTheme();
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.initialize();
    super.initState();
    appTheme.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    var provider = Provider.of<ProviderModel>(context, listen: false);
    provider.subscription.cancel();
    super.dispose();
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
      title: 'Spelling Wizard',
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
      backgroundColor: Colors.deepPurpleAccent[700],
      loaderColor: Colors.white,
      seconds: 2,
    );
  }
}
