import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:SpellingWizard/challenge.dart';
import 'package:SpellingWizard/word.dart';
import 'package:SpellingWizard/save.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:SpellingWizard/admob.dart';
import 'package:firebase_admob/firebase_admob.dart';

import 'config.dart';

class CategoryView extends StatefulWidget {
  final String title;
  final int itemCount;
  SaveFile saveFile;
  CategoryView({this.title, this.itemCount, this.saveFile});
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int fileLen;
  List<Word> wordList = [];
  List<List<Word>> fileWordList = [];

  //ads
  MobileAdTargetingInfo _targetingInfo = AdManager.targetingInfo;
  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;

  BannerAd bannerAd() {
    return BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      size: AdSize.smartBanner,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) async {
        print("BannerAd event is $event");
        if (event == MobileAdEvent.loaded) {
          if (mounted) {
            showBannerAd();
          }
        }
      },
    );
  }

  InterstitialAd interstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      targetingInfo: _targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }

  @override
  initState() {
    super.initState();
    _bannerAd = bannerAd()..load();
  }

  @override
  void dispose() async {
    super.dispose();
    try {
      await _bannerAd?.dispose();
      _bannerAd = null;
    } catch (ex) {}
  }

  showBannerAd() {
    _bannerAd.show(
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
      anchorType: AnchorType.bottom,
    );
  }

  showInterstitialAd() {
    _interstitialAd.show(
      anchorType: AnchorType.bottom,
      anchorOffset: 0.0,
      horizontalCenterOffset: 0.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
            color: appTheme.currentTheme.primaryTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 21,
          ),
        ),
        centerTitle: true,
        backgroundColor: appTheme.currentTheme.secondaryColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: appTheme.currentTheme.gradientCategoryviewColors,
          ),
        ),
        child: _categListView(context),
      ),
    );
  }

  ListView _categListView(BuildContext context) {
    List<Word> wordList = [];
    List<String> mistakesList = [];
    loadAsset(int index) async {
      final myData = await rootBundle.loadString(
          "assets/categories/${widget.title}_words/challenge$index.csv");
      List<List<dynamic>> data = CsvToListConverter().convert(myData);
      wordList = convertListToWords(data);
    }

    loadMistakes() async {
      final path = await savePath();
      if (File('$path/mistakes.csv').existsSync()) {
        final file = File('$path/mistakes.csv');
        final myData = file.readAsStringSync();
        List<List<dynamic>> data =
            CsvToListConverter(eol: "\r\n", fieldDelimiter: ",")
                .convert(myData);
        mistakesList = getWordsListStrOnly(data);
      } else {
        new File('$path/mistakes.csv').createSync(recursive: true);
      }
    }

    return ListView.builder(
      itemCount: widget.itemCount,
      padding: EdgeInsets.only(top: 3.0),
      itemBuilder: (_, index) {
        List<Color> colors;
        Icon rateIcon;
        Icon stateIcon;
        TextStyle titleStyle;
        if (widget.saveFile.playable(index)) {
          colors = appTheme.currentTheme.gradientCategoryviewCardColors;
          rateIcon = Icon(
            Icons.star,
            color: Colors.amber,
          );
          stateIcon = Icon(
            Icons.arrow_forward,
            color: appTheme.currentTheme.primaryIconColor,
          );
          titleStyle = TextStyle(
            fontWeight: FontWeight.w600,
            color: appTheme.currentTheme.primaryTextColor,
          );
        } else {
          colors = darkenColors(
              appTheme.currentTheme.gradientCategoryviewCardColors);
          rateIcon = Icon(
            Icons.star,
            color: appTheme.currentTheme.darkClosedColor,
          );
          stateIcon = Icon(
            Icons.lock,
            color: appTheme.currentTheme.darkClosedColor,
          );
          titleStyle = TextStyle(
            fontWeight: FontWeight.w600,
            color: appTheme.currentTheme.darkClosedColor,
          );
        }
        return Container(
          color: Colors.transparent,
          margin: EdgeInsets.all(4),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(4.5),
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.5),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomCenter,
                      colors: colors,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      'Challenge ${index + 1}',
                      style: titleStyle,
                    ),
                    leading: RatingBarIndicator(
                      unratedColor: appTheme.currentTheme.primaryIconColor,
                      rating: widget.saveFile.isColored(index).toDouble(),
                      direction: Axis.horizontal,
                      itemCount: 3,
                      itemPadding: EdgeInsets.symmetric(horizontal: 0),
                      itemBuilder: (context, _) => rateIcon,
                      itemSize: 38,
                    ),
                    trailing: stateIcon,
                    onTap: () async {
                      try {
                        await _bannerAd?.dispose();
                        _bannerAd = null;
                      } catch (ex) {}
                      _interstitialAd = interstitialAd()..load();
                      Tuple3 audioPrefix = Tuple3<String, int, String>(
                        'assets/categories/${widget.title}_words/challenges_audio/',
                        index,
                        widget.title,
                      );
                      await loadAsset(index);
                      await loadMistakes();
                      if (widget.saveFile.playable(index)) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            maintainState: true,
                            builder: (BuildContext context) => ChallengePage(
                              wordList,
                              mistakesList,
                              audioPrefix,
                            ),
                          ),
                        ).then((value) async {
                          if (await _interstitialAd.isLoaded()) {
                            showInterstitialAd();
                          } else {
                            _interstitialAd..load();
                            showInterstitialAd();
                          }
                          _bannerAd ??= bannerAd()..load();
                          SaveFile saveTmp =
                              await saveFileOfCategory(widget.title);
                          setState(() {
                            widget.saveFile = saveTmp;
                          });
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

Color darken(Color color, [double amount = .29]) {
  assert(amount >= 0 && amount <= 1);

  final hsl = HSLColor.fromColor(color);
  final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

  return hslDark.toColor();
}

List<Color> darkenColors(List<Color> colors) {
  return [darken(colors[0]), darken(colors[1])];
}
