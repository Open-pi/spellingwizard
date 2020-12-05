import 'package:SpellingWizard/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'about.dart';
import 'categoryview.dart';
import 'package:SpellingWizard/save.dart';

class GridDashboard extends StatefulWidget {
  final List<Items> myList;
  GridDashboard(this.myList);
  @override
  GridDashboardState createState() => GridDashboardState();
}

class GridDashboardState extends State<GridDashboard> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: widget.myList.map((data) {
            return Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(10),
              color: Colors.transparent,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () async {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                maintainState: true,
                                builder: (BuildContext context) => CategoryView(
                                      title: data.title,
                                      itemCount: int.parse(data.event),
                                      saveFile: data.saveFile,
                                    ))).then((value) async {
                          SaveFile saveTmp =
                              await saveFileOfCategory(data.title);
                          setState(() {
                            data.saveFile = saveTmp;
                          });
                        });
                      },
                      child: Ink(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [
                                  0.01,
                                  1
                                ],
                                colors: [
                                  Colors.deepPurpleAccent[700],
                                  Colors.purpleAccent[700]
                                ]),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Image.asset(
                              data.img,
                              width: 42,
                            ),
                            Text(
                              data.title,
                              style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            Text(
                              data.event,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'WorkSans',
                                  fontWeight: FontWeight.w100,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
            );
          }).toList()),
    );
  }
}

class Items {
  String title;
  String event;
  String img;
  SaveFile saveFile;

  Items({this.title, this.event, this.img, this.saveFile});
}

Future<List<Items>> categoryList() async {
  Items item1 = new Items(
    title: "Verbs",
    event: "6",
    img: "assets/verbs_category.png",
    saveFile: await saveFileOfCategory("Verbs"),
  );

  Items item2 = new Items(
    title: "Family",
    event: "3",
    img: "assets/family_category.png",
    saveFile: await saveFileOfCategory("Family"),
  );
  Items item3 = new Items(
    title: "Tools",
    event: "6",
    img: "assets/tools_category.png",
    saveFile: await saveFileOfCategory("Tools"),
  );
  Items item4 = new Items(
    title: "Animals",
    event: "6",
    img: "assets/animals_category.png",
    saveFile: await saveFileOfCategory("Animals"),
  );
  Items item5 = new Items(
    title: "Abstract",
    event: "2",
    img: "assets/abstract_category.png",
    saveFile: await saveFileOfCategory("Abstract"),
  );

  return [item1, item2, item3, item4, item5];
}

class HomePage extends StatelessWidget {
  final List<Items> items;
  HomePage(this.items);
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
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
                        fontFamily: 'WorkSans',
                        fontWeight: FontWeight.w900,
                        color: Colors.white)),
                SizedBox(
                  height: 4,
                ),
                Text(
                  "Challenges",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: 'WorkSans',
                      fontWeight: FontWeight.w100,
                      color: Colors.white),
                ),
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                _bottomMenu(context);
              },
            )
          ],
        ),
      ),
      SizedBox(
        height: 40,
      ),
      GridDashboard(items),
    ]);
  }
}

void _bottomMenu(context) {
  double screenHeight = MediaQuery.of(context).size.height;
  showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (BuildContext bc) {
        return Container(
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent[700],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            height: screenHeight * 0.37,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 15, 15),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/wizard.png",
                        width: 35,
                      ),
                      Padding(padding: EdgeInsets.only(right: 15)),
                      Text(
                        'Spelling Wizard',
                        style: TextStyle(
                          color: Colors.white70,
                          fontWeight: FontWeight.normal,
                          fontSize: 20,
                          height: 1.2,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      Icon(
                        Icons.verified,
                        color: Colors.white70,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                _sheetOption(
                  title: 'Upgrade',
                  icon: Icons.vpn_key,
                  color: Colors.amber,
                  onpressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _upgradeDialog(context);
                        });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                _sheetOption(
                  title: 'Review Mistakes',
                  icon: Icons.receipt_long,
                  onpressed: () {
                    Navigator.pop(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return _upgradeDialog(context);
                        });
                  },
                ),
                SizedBox(
                  height: 5,
                ),
                _sheetOption(
                  title: 'Settings',
                  icon: Icons.settings,
                  onpressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(_createRoute('Settings'));
                  },
                ),
                Spacer(),
                _sheetOption(
                  title: 'About',
                  icon: Icons.info_outline,
                  onpressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(_createRoute('About'));
                  },
                ),
              ],
            ));
      });
}

_sheetOption(
    {@required void Function() onpressed,
    String title = "",
    IconData icon = Icons.verified,
    Color color = Colors.white}) {
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
        Text(
          title,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.normal,
            height: 1.2,
          ),
        ),
      ],
    ),
  );
}

_upgradeDialog(BuildContext context) => Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 395,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0.001, 1],
              colors: [Colors.purple, Colors.deepPurpleAccent[700]]),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 19, 0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('Spelling Wizard',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          height: 1.25)),
                  Padding(padding: EdgeInsets.only(right: 8)),
                  Container(
                    padding: EdgeInsets.fromLTRB(4, 0.2, 4, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.amber,
                    ),
                    child: Text('PRO',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        )),
                  )
                ],
              ),
              _customHoriSpacer(),
              Text(
                  "Upgrade to support open-source software, remove ads, and enjoy some awsome features!",
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )),
              _customHoriSpacer(size: 20),
              _feature(
                text1: "Change app theme",
                icon: Icons.color_lens,
              ),
              _customHoriSpacer(),
              _feature(
                text1: "Remove Ads",
                icon: Icons.eco,
              ),
              _customHoriSpacer(),
              _feature(
                text1: "Unlock all challenges",
                icon: Icons.all_inclusive,
              ),
              _customHoriSpacer(),
              _feature(
                text1: "Review your mistakes",
                icon: Icons.receipt_long,
              ),
              _customHoriSpacer(),
              _feature(
                text1: "One time payment",
                text2: "All future features for free",
                icon: Icons.favorite,
                twoLines: true,
              ),
              Spacer(),
              RaisedButton(
                color: Colors.teal[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.verified,
                      color: Colors.white,
                    ),
                    Padding(padding: EdgeInsets.only(right: 12)),
                    Text(
                      'UPGRADE',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 1.2),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              _customHoriSpacer(size: 20)
            ],
          ),
        ),
      ),
    );

_customHoriSpacer({double size = 12}) => SizedBox(height: size);

_feature(
    {String text1 = "",
    String text2 = "",
    IconData icon = Icons.favorite,
    Color color = Colors.white,
    bool twoLines = false}) {
  return Padding(
    padding: const EdgeInsets.only(right: 20, left: 20),
    child: Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 20,
        ),
        Padding(padding: EdgeInsets.only(right: 10)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text1,
              style: TextStyle(
                fontSize: 11.5,
                color: color,
                fontWeight: FontWeight.normal,
              ),
            ),
            if (twoLines)
              Text(
                text2,
                style: TextStyle(
                  fontSize: 11.5,
                  color: color,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        )
      ],
    ),
  );
}

Route _createRoute(String page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) {
      if (page == 'About') {
        return AboutPage();
      } else if (page == 'Settings') {
        return SettingsPage();
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
