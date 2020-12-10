import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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
              color: appTheme.currentTheme.settingsColor,
              fontSize: 13,
            ),
          )),
      SizedBox(height: 3),
      ListTile(
        title: Text(
          "Change theme",
          style: TextStyle(
            fontFamily: '',
            color: appTheme.currentTheme.primaryTextColor,
          ),
        ),
        trailing: Padding(
          padding: const EdgeInsets.only(right: 6.0),
          child: Icon(
            Icons.color_lens,
            color: appTheme.currentTheme.primaryIconColor,
            size: 27,
          ),
        ),
        onTap: () {
          _colorPickerDialog();
        },
      ),
    ];
  }

  _colorPickerDialog() {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text('Change Theme'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: appTheme.pickerColor,
            onColorChanged: changeTheme,
            availableColors: appTheme.availableThemes,
          ),
        ),
        actions: [
          FlatButton(
            child: Text('Got it'),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}

void changeTheme(Color color) {
  if (color == Colors.deepPurpleAccent)
    appTheme.changeThemeTo('Normal');
  else if (color == Color(0xFF121212))
    appTheme.changeThemeTo('Dark');
  else if (color == Colors.teal)
    appTheme.changeThemeTo('Teal');
  else if (color == Color(0xFF202050)) appTheme.changeThemeTo('DarkBlue');
}
