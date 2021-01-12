import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'config.dart';

class CreditsPage extends StatefulWidget {
  @override
  _CreditsPageState createState() => _CreditsPageState();
}

class _CreditsPageState extends State<CreditsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Credits"),
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: body(),
        ),
      ),
    );
  }
}

List<Widget> body() {
  return [
    Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Text(
          "Developers:",
          style: TextStyle(
            color: appTheme.currentTheme.settingsColor,
            fontSize: 15,
          ),
        )),
    SizedBox(height: 3),
    _contributor(
        name: 'Toukabri Youssef (Maistrox9)',
        link: 'https://github.com/Maistrox9'),
    _contributor(
        name: 'Drissi Mohieddine (zeddo123)',
        link: 'https://github.com/zeddo123'),
    Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
        child: Text(
          "Voice Actors:",
          style: TextStyle(
            color: appTheme.currentTheme.settingsColor,
            fontSize: 15,
          ),
        )),
    SizedBox(height: 3),
    _contributor(name: 'kiara305', link: 'https://www.fiverr.com/kiara305'),
  ];
}

_contributor({String name = '', String link = ''}) {
  return ListTile(
    leading: Icon(Icons.person, color: appTheme.currentTheme.primaryIconColor),
    title: Text(
      name,
      style: TextStyle(
        color: appTheme.currentTheme.primaryTextColor,
        fontWeight: FontWeight.normal,
        fontSize: 17,
        height: 1.2,
      ),
    ),
    subtitle: InkWell(
      child: Text(
        link,
        style: TextStyle(
          color: appTheme.currentTheme.secondaryTextColor,
          fontWeight: FontWeight.normal,
          fontSize: 13,
          height: 1.2,
        ),
      ),
      onTap: () async {
        _lunchUrl(link);
      },
    ),
  );
}

_lunchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
