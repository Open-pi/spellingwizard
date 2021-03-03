import 'dart:io';

import 'package:SpellingWizard/providermodel.dart';
import 'package:SpellingWizard/reviewMistakes.dart';
import 'package:SpellingWizard/settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'about.dart';
import 'categoryview.dart';
import 'package:SpellingWizard/save.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:provider/provider.dart';

import 'config.dart';

class GridDashboard extends StatefulWidget {
  final List<Items> myList;
  final bool showAds;
  GridDashboard(this.myList, {this.showAds});
  @override
  GridDashboardState createState() => GridDashboardState();
}

class GridDashboardState extends State<GridDashboard> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
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
                                    showAds: widget.showAds,
                                  ))).then((value) async {
                        SaveFile saveTmp = await saveFileOfCategory(data.title);
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
                              colors: appTheme
                                  .currentTheme.gradientDashboardCardsColors),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          SvgPicture.asset(data.img,
                              semanticsLabel: 'Acme Logo'),
                          Text(
                            data.title,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            data.event,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w100,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
          );
        }).toList());
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
    event: "4",
    img: "assets/verbs_category.svg",
    saveFile: await saveFileOfCategory("Verbs"),
  );
  Items item2 = new Items(
    title: "Family",
    event: "3",
    img: "assets/family_category.svg",
    saveFile: await saveFileOfCategory("Family"),
  );
  Items item3 = new Items(
    title: "Tools",
    event: "6",
    img: "assets/tools_category.svg",
    saveFile: await saveFileOfCategory("Tools"),
  );
  Items item4 = new Items(
    title: "Animals",
    event: "6",
    img: "assets/animals_category.svg",
    saveFile: await saveFileOfCategory("Animals"),
  );
  Items item5 = new Items(
    title: "Abstract",
    event: "2",
    img: "assets/abstract_category.svg",
    saveFile: await saveFileOfCategory("Abstract"),
  );
  Items item6 = new Items(
    title: "Household",
    event: "4",
    img: "assets/household_category.svg",
    saveFile: await saveFileOfCategory("Household"),
  );

  return [item1, item2, item3, item4, item5, item6];
}

class HomePage extends StatefulWidget {
  final List<Items> items;
  HomePage(this.items);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProviderModel provider;
  bool isPro = false;
  InAppPurchaseConnection _iap = InAppPurchaseConnection.instance;
  final double heightFactor = 0.225;
  void _buyProduct(ProductDetails prod) {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: prod);
    _iap.buyNonConsumable(purchaseParam: purchaseParam);
  }

  checkIsPro() async {
    provider = Provider.of<ProviderModel>(context);
    File proStatusFile = await loadProStatusFile();
    if (provider.available) {
      if (provider.products.length > 0) {
        setState(() {
          isPro = provider.hasPurchased(provider.products[0].id) != null;
          proStatusFile.writeAsStringSync(isPro.toString());
        });
      }
    } else {
      String proStatus = proStatusFile.readAsStringSync();
      if (proStatus.toLowerCase() == 'true') {
        setState(() {
          isPro = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    checkIsPro();
    return Stack(fit: StackFit.expand, children: <Widget>[
      FractionallySizedBox(
        alignment: Alignment.topCenter,
        heightFactor: heightFactor,
        child: Padding(
          padding: EdgeInsets.only(left: 16, right: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    AutoSizeText(
                      "Spelling Wizard",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: appTheme.currentTheme.primaryTextColor),
                      maxLines: 1,
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "Categories",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w100,
                          color: appTheme.currentTheme.primaryTextColor),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  color: appTheme.currentTheme.primaryIconColor,
                  size: 30,
                ),
                onPressed: () {
                  _bottomMenu(context);
                },
              )
            ],
          ),
        ),
      ),
      FractionallySizedBox(
          alignment: Alignment.bottomCenter,
          heightFactor: 1 - heightFactor,
          child: GridDashboard(
            widget.items,
            showAds: !isPro,
          )),
    ]);
  }

  void _bottomMenu(BuildContext context) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext bc) {
          return Container(
              decoration: BoxDecoration(
                color: appTheme.currentTheme.bottomMenuSheetColor,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 14.5,
                      ),
                      Image.asset(
                        "assets/wizard.png",
                        width: 36,
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Flexible(
                        child: AutoSizeText(
                          'Spelling Wizard',
                          style: TextStyle(
                            color: appTheme.currentTheme.secondaryTextColor,
                            fontSize: 20,
                          ),
                          minFontSize: 10,
                          maxLines: 1,
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(right: 5)),
                      isPro
                          ? Icon(
                              Icons.verified,
                              color: appTheme.currentTheme.secondaryTextColor,
                            )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  _sheetOption(
                    title: 'Upgrade',
                    icon: FlutterIcons.crown_fou,
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
                    height: 10,
                  ),
                  _sheetOption(
                    title: 'Review Mistakes',
                    icon: Icons.receipt_long,
                    onpressed: () async {
                      Navigator.pop(context);
                      if (isPro)
                        Navigator.of(context)
                            .push(_createRoute('ReviewMistakes'));
                      else
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return _upgradeDialog(context);
                            });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _sheetOption(
                    title: 'Settings',
                    icon: Icons.settings,
                    onpressed: () {
                      Navigator.pop(context);
                      Navigator.of(context)
                          .push(_createRoute('Settings', isPro: isPro));
                    },
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  _sheetOption(
                    title: 'About',
                    icon: Icons.info_outline,
                    onpressed: () {
                      Navigator.pop(context);
                      Navigator.of(context)
                          .push(_createRoute('About', isPro: isPro));
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: onpressed,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 12.5, 20, 12.5),
          child: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              Padding(padding: EdgeInsets.only(right: 25)),
              Flexible(
                child: AutoSizeText(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _upgradeDialog(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: appTheme.currentTheme.gradientDialogColors),
        ),
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 19, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPro) ...[
                Center(
                  child: FittedBox(
                    child: AutoSizeText(
                      "Thank You!",
                      style: TextStyle(
                        fontSize: 20,
                        color: appTheme.currentTheme.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                    ),
                  ),
                ),
                _customHoriSpacer(size: 13),
                AutoSizeText("You are a PRO user! enjoy.",
                    style: TextStyle(
                      color: appTheme.currentTheme.primaryTextColor,
                      fontWeight: FontWeight.normal,
                    )),
              ] else ...[
                Row(
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        "Spelling Wizard",
                        style: TextStyle(
                            fontSize: 20,
                            color: appTheme.currentTheme.primaryTextColor,
                            fontWeight: FontWeight.bold,
                            height: 1.25),
                        maxLines: 1,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(right: 8)),
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 0.2, 4, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.amber,
                      ),
                      child: AutoSizeText('PRO',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: appTheme.currentTheme.primaryTextColor,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                _customHoriSpacer(size: 12),
                AutoSizeText(
                    "Upgrade to support open-source software, remove ads, and enjoy some awsome features!",
                    style: TextStyle(
                      fontSize: 11.5,
                      color: appTheme.currentTheme.primaryTextColor,
                      fontWeight: FontWeight.normal,
                    )),
                _customHoriSpacer(size: 13),
                _feature(
                  text1: "Change app theme",
                  icon: Icons.color_lens,
                  color: appTheme.currentTheme.primaryTextColor,
                ),
                _customHoriSpacer(size: 11),
                _feature(
                  text1: "Remove Ads",
                  icon: Icons.eco,
                  color: appTheme.currentTheme.primaryTextColor,
                ),
                _customHoriSpacer(size: 11),
                _feature(
                  text1: "Review your mistakes",
                  icon: Icons.receipt_long,
                  color: appTheme.currentTheme.primaryTextColor,
                ),
                _customHoriSpacer(size: 11),
                _feature(
                  text1: "Practice your mistakes",
                  icon: FlutterIcons.form_ant,
                  color: appTheme.currentTheme.primaryTextColor,
                ),
                _customHoriSpacer(size: 11),
                _feature(
                  text1: "One time payment",
                  text2: "All future features for free",
                  icon: Icons.favorite,
                  twoLines: true,
                  color: appTheme.currentTheme.primaryTextColor,
                ),
                _customHoriSpacer(size: 13),
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
                        color: appTheme.currentTheme.primaryIconColor,
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
                  onPressed: () => _buyProduct(provider.products[0]),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  _customHoriSpacer({double size = 30}) => SizedBox(height: size);

  _feature(
      {String text1 = "",
      String text2 = "",
      IconData icon = Icons.favorite,
      Color color = Colors.white,
      bool twoLines = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          SizedBox(
            width: 10,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  text1,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: color,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 1,
                ),
                if (twoLines)
                  AutoSizeText(
                    text2,
                    style: TextStyle(
                      fontSize: 11.5,
                      color: color,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 1,
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Route _createRoute(String page, {bool isPro = false}) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        if (page == 'About') {
          return AboutPage(isPro);
        } else if (page == 'Settings') {
          return SettingsPage(isPro);
        } else if (page == 'ReviewMistakes') {
          return ReviewMistakesPage();
        }
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
