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
        backgroundColor: Colors.deepPurpleAccent[700],
        elevation: 0,
      ),
      backgroundColor: Colors.deepPurpleAccent[700],
      body: SafeArea(
        child: Column(
          children: body(),
        ),
      ),
    );
  }

  List<Widget> body() {
    double titlesize = MediaQuery.of(context).size.width;
    print(titlesize);
    if (titlesize > 390) titlesize *= 0.065;
    if (titlesize > 300) titlesize *= 0.075;
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
                color: Colors.white,
                fontWeight: FontWeight.normal,
                fontSize: titlesize,
                height: 1.2,
              ),
            ),
            Padding(padding: EdgeInsets.only(right: 5)),
            Icon(
              Icons.verified,
              color: Colors.white,
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
        color: Colors.white,
        enableSubTitle: true,
        onpressed: () {},
      ),
      _aboutOption(
        title: 'Source code',
        icon: FlutterIcons.logo_github_ion,
        onpressed: _launchGitRepo,
      ),
      SizedBox(
        height: 7,
      ),
      _aboutOption(
        title: 'Open Source Licences',
        icon: Icons.menu_book,
        onpressed: () {},
      ),
      SizedBox(
        height: 7,
      ),
      _aboutOption(
        title: 'Send feedback',
        icon: Icons.rate_review,
        onpressed: _sendEmailFeedback,
      ),
      SizedBox(
        height: 7,
      ),
      _aboutOption(
        title: 'Rate this app',
        icon: Icons.star_rate,
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
