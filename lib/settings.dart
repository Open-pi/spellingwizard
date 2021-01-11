import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'config.dart';

class SettingsPage extends StatefulWidget {
  final bool isPro;
  SettingsPage(this.isPro);
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
        child: ListView(
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
        onTap: () async {
          if (widget.isPro)
            _colorPickerDialog();
          else
            await showfeatureLockedDialog(context);
        },
      ),
    ];
  }

  _colorPickerDialog() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
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
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
      },
    );
  }
}

void changeTheme(Color color) {
  if (color == Colors.deepPurpleAccent)
    appTheme.changeThemeTo('Normal');
  else if (color == Colors.teal) appTheme.changeThemeTo('Teal');
}

Future<bool> showfeatureLockedDialog(BuildContext context) async {
  return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            elevation: 10,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Feature Locked',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Upgrade to Spelling Wizard Pro to unlock this feature',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });
      });
}
