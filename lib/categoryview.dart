import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:SpellingWizard/challenge.dart';
import 'package:SpellingWizard/word.dart';
import 'package:SpellingWizard/save.dart';
import 'package:tuple/tuple.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CategoryView extends StatelessWidget {
  final String title;
  final int itemCount;
  final Color color;
  CategoryView({this.title, this.itemCount, this.color});
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
    // load save files for the category
    final path = _localPath;
    final file = File('$path/$title.csv');
    final SaveFile saveFile = SaveFile(file);

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
<<<<<<< HEAD
            leading: starsIcons(saveFile.isColored(index, 0),
                saveFile.isColored(index, 1), saveFile.isColored(index, 2)),
=======
            leading: ratingStars(index.toDouble()),
>>>>>>> e2038166bd97daf93f8812ce3419d8d7e6e80ceb
            trailing: Icon(Icons.arrow_forward),
            onTap: () async {
              Tuple2 audioPrefix = Tuple2<String, int>(
                  'assets/categories/${this.title}_words/challenges_audio/',
                  index);
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

<<<<<<< HEAD
Container starsIcons(bool star1, bool star2, bool star3) {
  return Container(
    width: 70,
    child: Row(
      children: <Icon>[
        Icon(
          Icons.star,
          size: 20,
          color: star1 ? Colors.purple[900] : Colors.black,
        ),
        Icon(
          Icons.star,
          size: 25,
          color: star2 ? Colors.purple[900] : Colors.black,
        ),
        Icon(
          Icons.star,
          size: 20,
          color: star3 ? Colors.purple[900] : Colors.black,
        )
      ],
=======
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
>>>>>>> e2038166bd97daf93f8812ce3419d8d7e6e80ceb
    ),
    itemSize: 38,
  );
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}
