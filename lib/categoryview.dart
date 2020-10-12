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
      appBar: AppBar(
        title: Text(this.title),
        centerTitle: true,
        backgroundColor: this.color,
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
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('Challenge number $index'),
            subtitle: Text('Put Small Description Here'),
            leading: ratingStars(saveFile.isColored(index).toDouble()),
            trailing: Icon(Icons.arrow_forward),
            onTap: () async {
              Tuple3 audioPrefix = Tuple3<String, int, String>(
                  'assets/categories/${this.title}_words/challenges_audio/',
                  index,
                  this.title);
              await loadAsset(index);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChallengePage(wordList, this.color, audioPrefix)));
            },
          ),
        );
      },
    );
  }
}

RatingBar ratingStars(double initrating) {
  return RatingBar(
    initialRating: initrating,
    minRating: 0,
    maxRating: 3,
    direction: Axis.horizontal,
    allowHalfRating: true,
    itemCount: 3,
    itemPadding: EdgeInsets.symmetric(horizontal: 0),
    itemBuilder: (context, _) => Icon(
      Icons.star,
      color: Colors.amber,
    ),
    itemSize: 38,
  );
}
