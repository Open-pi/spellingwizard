import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                            color: Colors.white,
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
            height: MediaQuery.of(context).size.height * 0.37,
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
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                FlatButton(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: () {},
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.payment,
                        color: Colors.amber,
                      ),
                      Padding(padding: EdgeInsets.only(right: 25)),
                      Text(
                        'Upgrade',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.normal,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: () {},
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.trending_up,
                        color: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.only(right: 25)),
                      Text(
                        'Statistics',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                FlatButton(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: () {},
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.only(right: 25)),
                      Text(
                        'Settings',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                FlatButton(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  onPressed: () {},
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                      ),
                      Padding(padding: EdgeInsets.only(right: 25)),
                      Text(
                        'About',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.normal,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
            //ListView.builder(
            //  physics: NeverScrollableScrollPhysics(),
            //  itemBuilder: (_, index) => MenuList(choices_names[index],
            //      choices_icons[index], choices_colors[index]),
            //  itemCount: choices_names.length,
            //),
            );
      });
}
