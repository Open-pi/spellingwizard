import 'package:SpellingWizard/categories/challenge.dart';
import 'package:SpellingWizard/categories/word.dart';
import 'package:flutter/material.dart';

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
    List<Word> wordList = [
      Word(
        word: 'Elephant',
        meaning: 'Large animal with long trunk',
        usage: 'We ride on an ... at zoo.',
        phonetic: "/'elɪfənt/",
      ),
      Word(
        word: 'Theater',
        meaning: 'Place for performing acts',
        usage: 'This movie is going to play in all ...',
        phonetic: "/'θɪətə(r)/",
      ),
    ];
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (_, index) {
        return Card(
          child: ListTile(
            title: Text('Lesson number $index'),
            subtitle: Text('Put Small Description Here'),
            leading: starsIcons(),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
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
