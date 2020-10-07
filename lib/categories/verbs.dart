import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:SpellingWizard/categories/challenge.dart';
import 'package:SpellingWizard/categories/word.dart';

class VerbsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verbs'),
        centerTitle: true,
        backgroundColor: Colors.blue[600],
      ),
      body: _verbsListView(context),
    );
  }

  ListView _verbsListView(BuildContext context) {
    List<Word> wordList = [];

    loadAsset(int index) async {
      final myData = await rootBundle
          .loadString("assets/categories/verbs_words/challenge$index.csv");
      List<List<dynamic>> data = CsvToListConverter().convert(myData);
      wordList = convertListToWords(data);
    }

    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('Lesson number $index'),
            subtitle: Text('Put Small Description Here'),
            leading: starsIcons(),
            trailing: Icon(Icons.arrow_forward),
            onTap: () async {
              print(index);
              await loadAsset(index);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ChallengePage(wordList, Colors.blue[600])));
            },
          ),
        );
      },
    );
  }
}

Container starsIcons() {
  return Container(
    width: 70,
    child: Row(
      children: <Icon>[
        Icon(
          Icons.star,
          size: 20,
        ),
        Icon(
          Icons.star,
          size: 25,
        ),
        Icon(
          Icons.star,
          size: 20,
        )
      ],
    ),
  );
}
