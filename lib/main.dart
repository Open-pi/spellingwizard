import 'package:flutter/material.dart';
import 'categoryview.dart';
import 'package:SpellingWizard/save.dart';
import 'dart:io';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Testing SpellingWizard',
      theme: ThemeData(
        fontFamily: 'Raleway',
        primaryColor: Colors.purple[900],
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
    final dividreTile = SizedBox(height: 25);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('SpellingWizard'),
        centerTitle: true,
        backgroundColor: Colors.amber[850],
        elevation: 0.0,
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.purple, Colors.orange])),
        child: ListView(
          padding: const EdgeInsets.all(40),
          children: <Widget>[
            RaisedButton(
                onPressed: () async {
                  // load save files for the category
                  final path = await savePath();
                  final file = File('$path/Verbs.csv');
                  final SaveFile saveFile = SaveFile(file: file);
                  await saveFile.readFromFile();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryView(
                            title: 'Verbs',
                            itemCount: 5,
                            color: Colors.purple[500],
                            saveFile: saveFile,
                          )));
                },
                shape: CircleBorder(),
                child: categoryBuilder('assets/verbs_category.png')),
            dividreTile,
            RaisedButton(
                onPressed: () async {
                  // load save files for the category
                  final path = await savePath();
                  final file = File('$path/Animals.csv');
                  final SaveFile saveFile = SaveFile(file: file);
                  await saveFile.readFromFile();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryView(
                            title: 'Animals',
                            itemCount: 5,
                            color: Colors.purple[600],
                            saveFile: saveFile,
                          )));
                },
                shape: CircleBorder(),
                child: categoryBuilder('assets/animals_category.png')),
            dividreTile,
            RaisedButton(
                onPressed: () async {
                  // load save files for the category
                  final path = await savePath();
                  final file = File('$path/Tools.csv');
                  final SaveFile saveFile = SaveFile(file: file);
                  await saveFile.readFromFile();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CategoryView(
                            title: 'Tools',
                            itemCount: 5,
                            color: Colors.deepPurple[850],
                            saveFile: saveFile,
                          )));
                },
                shape: CircleBorder(),
                child: categoryBuilder('assets/tools_category.png')),
          ],
        ),
      ),
    );
  }
}

Widget categoryBuilder(String iconName) {
  return CircleAvatar(
    backgroundColor: Colors.purple[500],
    radius: 49,
    backgroundImage: AssetImage(iconName),
  );
}
