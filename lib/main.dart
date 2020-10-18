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
      body: Column(children: <Widget>[
        SizedBox(
          height: 80,
        ),
        Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("Spelling Wizard",
                      style: TextStyle(
                          fontSize: 30,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.w900,
                          color: Colors.white)),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Challenges",
                    style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.w100,
                        color: Colors.white),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 40,
        ),
        GridDashboard(),
      ]),
    );
  }
}
