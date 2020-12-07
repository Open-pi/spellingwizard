import 'package:SpellingWizard/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: body(),
        ),
      ),
    );
  }

  List<Widget> body() {
    return [
      Container(
        padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
        child: Row(
          children: [
            Image.asset(
              "assets/wizard.png",
              width: 44,
            ),
            Padding(padding: EdgeInsets.only(right: 16)),
            Text(
              'Spelling Wizard',
              style: TextStyle(
                color: appTheme.currentTheme.primaryTextColor,
                fontWeight: FontWeight.normal,
                fontSize: 27,
                height: 1.2,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 5)),
            Icon(
              Icons.verified,
              color: appTheme.currentTheme.primaryIconColor,
            )
          ],
        ),
      ),
      SizedBox(
        height: 15,
      ),
      _aboutOption(
        title: 'Version',
        subTitle: '2.2.4',
        icon: Icons.info_outline,
        color: appTheme.currentTheme.primaryTextColor,
        enableSubTitle: true,
        onpressed: () {},
      ),
      _aboutOption(
        title: 'Source code',
        icon: FlutterIcons.logo_github_ion,
        color: appTheme.currentTheme.primaryTextColor,
        onpressed: _launchGitRepo,
      ),
      SizedBox(
        height: 7,
      ),
      _aboutOption(
        title: 'Open Source Licences',
        icon: Icons.menu_book,
        color: appTheme.currentTheme.primaryTextColor,
        onpressed: () {},
      ),
      SizedBox(
        height: 7,
      ),
      _aboutOption(
        title: 'Send feedback',
        icon: Icons.rate_review,
        color: appTheme.currentTheme.primaryTextColor,
        onpressed: _sendEmailFeedback,
      ),
      SizedBox(
        height: 7,
      ),
      _aboutOption(
        title: 'Rate this app',
        icon: Icons.star_rate,
        color: appTheme.currentTheme.primaryTextColor,
        onpressed: () {},
      )
    ];
  }
}

_aboutOption(
    {@required void Function() onpressed,
    String title = "",
    String subTitle = "",
    IconData icon = Icons.verified,
    Color color = Colors.white,
    bool enableSubTitle = false}) {
  return FlatButton(
    padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    onPressed: onpressed,
    color: Colors.transparent,
    child: Row(
      children: [
        Icon(
          icon,
          color: color,
        ),
        Padding(padding: EdgeInsets.only(right: 25)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.normal,
                height: 1.2,
              ),
            ),
            if (enableSubTitle)
              Text(
                subTitle,
                style: TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.normal,
                  height: 1.2,
                ),
              ),
          ],
        ),
      ],
    ),
  );
}

_launchGitRepo() async {
  const url = 'https://github.com/open-segmentation-systems/spellingwizard.git';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_sendEmailFeedback() async {
  const url =
      'mailto:open-segmentation-systems@protonmail.com?subject=S.W-Feedback%20&body=';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
