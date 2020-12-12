import 'dart:io';

import 'package:SpellingWizard/challenge.dart';
import 'package:SpellingWizard/config.dart';
import 'package:SpellingWizard/save.dart';
import 'package:SpellingWizard/word.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'package:shimmer/shimmer.dart';

class ReviewMistakesPage extends StatefulWidget {
  @override
  _ReviewMistakesPageState createState() => _ReviewMistakesPageState();
}

class _ReviewMistakesPageState extends State<ReviewMistakesPage> {
  Future<Tuple2<List<Word>, List<String>>> loadMistakes() async {
    final path = await savePath();
    final file = File('$path/mistakes.csv');
    final myData = file.readAsStringSync();
    List<List<dynamic>> data =
        CsvToListConverter(eol: "\r\n", fieldDelimiter: ",").convert(myData);
    await new Future.delayed(const Duration(seconds: 1));
    return Tuple2<List<Word>, List<String>>(
        convertListToWords(data), getWordsListStrOnly(data));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Tuple2<List<Word>, List<String>>>(
      future: loadMistakes(),
      builder: (BuildContext context,
          AsyncSnapshot<Tuple2<List<Word>, List<String>>> snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Review Mistakes"),
              centerTitle: true,
              elevation: 0,
            ),
            floatingActionButton: FloatingActionButton.extended(
              label: Text("Practice Mistakes"),
              icon: Icon(Icons.settings_backup_restore),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16.0))),
              onPressed: () {
                Tuple3 fakePrefix = Tuple3<String, int, String>(
                  '',
                  0,
                  'Mistakes',
                );
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                        maintainState: true,
                        builder: (BuildContext context) => ChallengePage(
                              snapshot.data.item1,
                              snapshot.data.item2,
                              fakePrefix,
                              isPractice: true,
                            ))).then((_) async {
                  setState(() {});
                });
              },
            ),
            body: SafeArea(
              child: ListView.builder(
                  itemCount: snapshot.data.item2.length,
                  itemBuilder: (_, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.transparent,
                          padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: Text(
                            '${index + 1}.   ${snapshot.data.item2[index]}',
                            style: TextStyle(
                                color: appTheme.currentTheme.primaryTextColor,
                                fontSize: 18),
                          ),
                        ),
                        devider,
                      ],
                    );
                  }),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Colors.lightBlue[600],
                child: Text("Review Mistakes"),
              ),
              centerTitle: true,
              elevation: 0,
            ),
          );
        }
      },
    );
  }
}

final devider = Divider(
  color: appTheme.currentTheme.challengeBackColor,
  thickness: 1.0,
);
