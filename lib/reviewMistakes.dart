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

  double _sliderValue = 1;
  int _groupValue = 0;

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
              onPressed: () async {
                Tuple3 fakePrefix = Tuple3<String, int, String>(
                  '',
                  0,
                  'Mistakes',
                );
                if (snapshot.data.item1.length == 0 ||
                    snapshot.data.item2.length == 0) {
                  await showNoMistakesDialog(context);
                } else {
                  final start = await showPracticeDialog(context);
                  if (start) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            maintainState: true,
                            builder: (BuildContext context) => ChallengePage(
                                  snapshot.data.item1,
                                  snapshot.data.item2,
                                  fakePrefix,
                                  isPractice: true,
                                  isTerminationMode: _groupValue == 1,
                                  numofRepetitions: _sliderValue.toInt(),
                                ))).then((_) async {
                      setState(() {});
                    });
                  }
                }
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

  Future<bool> showPracticeDialog(BuildContext context) async {
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
                    'Choose whether you want to practice with Normal or Termination mode',
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      Row(
                        children: [
                          Radio(
                            groupValue: _groupValue,
                            value: 0,
                            onChanged: (t) {
                              setState(() {
                                _groupValue = t;
                              });
                            },
                          ),
                          Text(
                            'Normal',
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Radio(
                            groupValue: _groupValue,
                            value: 1,
                            onChanged: (t) {
                              setState(() {
                                _groupValue = t;
                              });
                            },
                          ),
                          Text(
                            'Termination',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Repetition for each word:",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: _groupValue == 1 ? Colors.black : Colors.grey),
                  ),
                  Slider.adaptive(
                    onChanged: _groupValue == 1
                        ? (newSliderValue) {
                            setState(() {
                              _sliderValue = newSliderValue;
                            });
                          }
                        : null,
                    value: _sliderValue,
                    min: 1,
                    max: 5,
                    divisions: 4,
                    label: "$_sliderValue",
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text('Start'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });
        });
  }

  Future<void> showNoMistakesDialog(BuildContext context) async {
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
                    "You don't have any mistakes to practice",
                    textAlign: TextAlign.center,
                  ),
                  Divider(),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          });
        });
  }
}

class MyDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

final devider = Divider(
  color: appTheme.currentTheme.challengeBackColor,
  thickness: 1.0,
);
