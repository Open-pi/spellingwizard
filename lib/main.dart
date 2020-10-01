import 'package:flutter/material.dart';

void main() => runApp(MyApp());

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
    final dividreTile = Divider(
      color: Colors.white,
      height: 20,
      thickness: null,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('SpellingWizard'),
        centerTitle: true,
        backgroundColor: Colors.amber[850],
        elevation: 0.0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: <Widget>[
          RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => VerbsPage()));
              },
              shape: CircleBorder(),
              child: categoryBuilder('assets/verbs_category.png')),
          dividreTile,
          RaisedButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AnimalsPage()));
              },
              shape: CircleBorder(),
              child: categoryBuilder('assets/animals_category.png')),
          dividreTile,
          RaisedButton(
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ToolsPage()));
              },
              shape: CircleBorder(),
              child: categoryBuilder('assets/tools_category.png')),
        ],
      ),
    );
  }
}

Widget categoryBuilder(String iconName) {
  return CircleAvatar(
    backgroundColor: Color(0xFFF4511E),
    radius: 55,
    backgroundImage: AssetImage(iconName),
  );
}

class VerbsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verbs'),
        centerTitle: true,
        backgroundColor: Colors.blue[900],
      ),
    );
  }
}

class AnimalsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animals'),
        centerTitle: true,
        backgroundColor: Colors.green[900],
      ),
    );
  }
}

class ToolsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tools'),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
      ),
    );
  }
}
