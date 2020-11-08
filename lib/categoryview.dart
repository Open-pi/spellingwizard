import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:SpellingWizard/challenge.dart';
import 'package:SpellingWizard/word.dart';
import 'package:SpellingWizard/save.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CategoryView extends StatefulWidget {
  final String title;
  final int itemCount;
  final SaveFile saveFile;
  CategoryView({this.title, this.itemCount, this.saveFile});
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  int fileLen;
  List<Word> wordList = [];
  List<List<Word>> fileWordList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 21),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent[100],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.01, 1],
            colors: [
              Colors.deepPurpleAccent[100],
              Colors.deepPurpleAccent[700]
            ],
          ),
        ),
        child: _categListView(context),
      ),
    );
  }

  ListView _categListView(BuildContext context) {
    List<Word> wordList = [];
    loadAsset(int index) async {
      final myData = await rootBundle.loadString(
          "assets/categories/${widget.title}_words/challenge$index.csv");
      List<List<dynamic>> data = CsvToListConverter().convert(myData);
      wordList = convertListToWords(data);
    }

    return ListView.builder(
      itemCount: widget.itemCount,
      padding: EdgeInsets.only(top: 3.0),
      itemBuilder: (_, index) {
        List<Color> colors;
        Icon rateIcon;
        Icon stateIcon;
        TextStyle titleStyle;
        TextStyle subStyle;
        if (widget.saveFile.playable(index)) {
          colors = [Colors.deepPurpleAccent[700], Colors.purpleAccent[700]];
          rateIcon = Icon(
            Icons.star,
            color: Colors.amber,
          );
          stateIcon = Icon(
            Icons.arrow_forward,
            color: Colors.white,
          );
          titleStyle = TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          );
          subStyle = TextStyle(color: Colors.white);
        } else {
          colors = [
            darken(Colors.deepPurpleAccent[700]),
            darken(Colors.purpleAccent[700])
          ];
          rateIcon = Icon(
            Icons.star,
            color: Colors.black38,
          );
          stateIcon = Icon(
            Icons.lock,
            color: Colors.white38,
          );
          titleStyle = TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white38,
          );
          subStyle = TextStyle(color: Colors.white38);
        }
        return Container(
          margin: EdgeInsets.all(4),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(4.5),
            color: Colors.transparent,
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.5),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0.01, 1],
                  colors: colors,
                ),
              ),
              child: ListTile(
                title: Text(
                  'Challenge ${index + 1}',
                  style: titleStyle,
                ),
                subtitle: Text(
                  'Put Small Description Here',
                  style: subStyle,
                ),
                leading: RatingBarIndicator(
                  rating: widget.saveFile.isColored(index).toDouble(),
                  direction: Axis.horizontal,
                  itemCount: 3,
                  itemPadding: EdgeInsets.symmetric(horizontal: 0),
                  itemBuilder: (context, _) => rateIcon,
                  itemSize: 38,
                ),
                trailing: stateIcon,
                onTap: () async {
                  Tuple3 audioPrefix = Tuple3<String, int, String>(
                    'assets/categories/${widget.title}_words/challenges_audio/',
                    index,
                    widget.title,
                  );
                  await loadAsset(index);
                  if (widget.saveFile.playable(index)) {
                    Navigator.push(
                        context,
                        CupertinoPageRoute(
                            maintainState: true,
                            builder: (BuildContext context) => ChallengePage(
                                wordList,
                                audioPrefix,
                                '${widget.title} Challenge ${index + 1}')));
                  }
                },
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
