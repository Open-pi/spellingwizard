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
      //appBar: AppBar(title: Text('SpellingWizard')),
      body: ListView(
        padding: const EdgeInsets.all(40),
        children: <Widget>[
          categoryBuilder('assets/verbs_category.png'),
          dividreTile,
          categoryBuilder('assets/animals_category.png'),
          dividreTile,
          categoryBuilder('assets/tools_category.png')
        ],
      ),
    );
  }
}

Widget categoryBuilder(String iconName) {
  return RaisedButton(
    onPressed: () {},
    shape: CircleBorder(),
    child: CircleAvatar(
      backgroundColor: Color(0xFFF4511E),
      radius: 55,
      backgroundImage: AssetImage(iconName),
    ),
  );
}
