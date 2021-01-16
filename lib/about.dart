import 'package:SpellingWizard/config.dart';
import 'package:SpellingWizard/credits.dart';
import 'package:SpellingWizard/openSourceLicences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:auto_size_text/auto_size_text.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("About"),
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
      SizedBox(
        height: 40,
        child: ListTile(
          leading: Image.asset(
            "assets/wizard.png",
            width: 44,
          ),
          title: Row(
            children: [
              Flexible(
                child: AutoSizeText(
                  'Spelling Wizard',
                  style: TextStyle(
                    color: appTheme.currentTheme.primaryTextColor,
                    fontSize: 27,
                  ),
                  minFontSize: 10,
                  maxLines: 1,
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
      ),
      SizedBox(
        height: 15,
      ),
      _aboutOption(
        title: 'Version',
        subTitle: '1.0.5',
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
        onpressed: () {
          Navigator.of(context).push(_createRoute('Licences'));
        },
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
        onpressed: _launchStore,
      ),
      SizedBox(
        height: 7,
      ),
      _aboutOption(
        title: 'Credits',
        icon: Icons.people,
        onpressed: () {
          Navigator.of(context).push(_createRoute('Credits'));
        },
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
  return Material(
    color: Colors.transparent,
    child: InkWell(
      splashFactory: InkRipple.splashFactory,
      onTap: onpressed,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
            ),
            Padding(padding: EdgeInsets.only(right: 25)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    title,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.5,
                    ),
                  ),
                  if (enableSubTitle)
                    AutoSizeText(
                      subTitle,
                      style: TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                        fontSize: 15.5,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
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

_launchStore() async {
  const url =
      'https://play.google.com/store/apps/details?id=com.opensegmentationsystems.spellingwizards';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Route _createRoute(String page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      if (page == 'Licences') {
        return OpenSourceLicencesPage();
      } else if (page == 'Credits') {
        return CreditsPage();
      }
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
