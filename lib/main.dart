import 'package:flutter/material.dart';
import 'categoryview.dart';

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
    final dividreTile = SizedBox(height: 25);
    return Scaffold(
      backgroundColor: Colors.white,
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryView(
                          title: 'Verbs',
                          itemCount: 5,
                          color: Colors.blue[600],
                        )));
              },
              shape: CircleBorder(),
              child: categoryBuilder('assets/verbs_category.png')),
          dividreTile,
          RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryView(
                          title: 'Animals',
                          itemCount: 5,
                          color: Colors.green[900],
                        )));
              },
              shape: CircleBorder(),
              child: categoryBuilder('assets/animals_category.png')),
          dividreTile,
          RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CategoryView(
                          title: 'Tools',
                          itemCount: 5,
                          color: Colors.grey[850],
                        )));
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
