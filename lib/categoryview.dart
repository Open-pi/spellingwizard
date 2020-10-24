import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:SpellingWizard/challenge.dart';
import 'package:SpellingWizard/word.dart';
import 'package:SpellingWizard/save.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CategoryView extends StatelessWidget {
  final String title;
  final int itemCount;
  final Color color;
  final SaveFile saveFile;
  CategoryView({this.title, this.itemCount, this.color, this.saveFile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[900],
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
        backgroundColor: Colors.purple[900],
      ),
      body: _categListView(context),
    );
  }

  ListView _categListView(BuildContext context) {
    List<Word> wordList = [];
    loadAsset(int index) async {
      final myData = await rootBundle.loadString(
          "assets/categories/${this.title}_words/challenge$index.csv");
      List<List<dynamic>> data = CsvToListConverter().convert(myData);
      wordList = convertListToWords(data);
    }

    return ListView.builder(
      itemCount: this.itemCount,
      padding: EdgeInsets.only(top: 3.0),
      itemBuilder: (_, index) {
        List<Color> colors;
        Icon rateIcon;
        Icon stateIcon;
        if (saveFile.playable(index)) {
          colors = [Colors.purple, Colors.deepOrange];
          rateIcon = Icon(
            Icons.star,
            color: Colors.amber,
          );
          stateIcon = Icon(
            Icons.arrow_forward,
          );
        } else {
          colors = [Colors.purple[900], Colors.deepOrange[900]];
          rateIcon = Icon(
            Icons.star,
            color: Colors.black38,
          );
          stateIcon = Icon(
            Icons.lock,
            color: Colors.black45,
          );
        }
        return Card(
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.5),
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomCenter,
                    stops: [0.01, 1],
                    colors: colors)),
            child: ListTile(
              title: Text(
                'Challenge number ${index + 1}',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Put Small Description Here'),
              leading: RatingBarIndicator(
                rating: saveFile.isColored(index).toDouble(),
                direction: Axis.horizontal,
                itemCount: 3,
                itemPadding: EdgeInsets.symmetric(horizontal: 0),
                itemBuilder: (context, _) => rateIcon,
                itemSize: 38,
              ),
              trailing: stateIcon,
              onTap: () async {
                Tuple3 audioPrefix = Tuple3<String, int, String>(
                  'assets/categories/${this.title}_words/challenges_audio/',
                  index,
                  this.title,
                );
                await loadAsset(index);
                if (saveFile.playable(index)) {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          maintainState: true,
                          builder: (BuildContext context) => ChallengePage(
                              wordList,
                              this.color,
                              audioPrefix,
                              '${this.title} Challenge ${index + 1}')));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
