import 'package:flutter/material.dart';

import 'config.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Map<String, bool> optionsValues = {
    'FSM': false,
    'DT': false,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: body(),
        ),
      ),
    );
  }

  List<Widget> body() {
    return [
      Container(
          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
          child: Text(
            "General",
            style: TextStyle(
                color: Colors.teal[400],
                fontWeight: FontWeight.normal,
                fontSize: 13),
          )),
      SizedBox(height: 3),
      Theme(
        data: ThemeData(
          primarySwatch: Colors.teal,
          unselectedWidgetColor: Colors.white70, // Your color
        ),
        child: CheckboxListTile(
          title: Text(
            "Fullscreen mode",
            style: TextStyle(
              color: appTheme.currentTheme.primaryTextColor,
              fontWeight: FontWeight.normal,
              height: 1.2,
            ),
          ),
          value: optionsValues['FSM'],
          onChanged: (newValue) {
            setState(() {
              optionsValues['FSM'] = newValue;
            });
          },
        ),
      ),
      SizedBox(height: 5),
      Theme(
        data: ThemeData(
          primarySwatch: Colors.teal,
          unselectedWidgetColor: Colors.white70, // Your color
        ),
        child: SwitchListTile(
          title: Text(
            "Dark theme",
            style: TextStyle(
              color: appTheme.currentTheme.primaryTextColor,
              fontWeight: FontWeight.normal,
              height: 1.2,
            ),
          ),
          value: appTheme.switchState,
          onChanged: (value) {
            value
                ? appTheme.changeThemeTo('Dark')
                : appTheme.changeThemeTo('Normal');
          },
        ),
      ),
    ];
  }
}
