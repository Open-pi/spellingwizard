import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing SpellingWizard',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primaryColor: Colors.orange[900],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CategoriesView(),
    );
  }
}

class CategoriesView extends StatefulWidget {
  @override
  CategoriesViewState createState() => CategoriesViewState();
}

class CategoriesViewState extends State {
  Widget build(BuildContext context) {
    final dividreTile = Divider();

    return Scaffold(
      appBar: AppBar(title: Text('SpellingWizard')),
      body: ListView(
        //padding: const EdgeInsets.all(8),
        children: <Widget>[
          categorieBuilder('Verbs'),
          dividreTile,
          categorieBuilder('Animals'),
          dividreTile,
          categorieBuilder('Tools')
        ],
      ),
    );
  }
}

Widget categorieBuilder(String name) {
  return ListTile(
    title: Text(name,
        style: TextStyle(
            fontFamily: 'Raleway',
            fontWeight: FontWeight.w900,
            fontSize: 18.8)),
  );
}
