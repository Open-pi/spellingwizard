import 'package:flutter/material.dart';
import 'word.dart';

class ChallengePage extends StatelessWidget {
  final List<Word> wordList;
  ChallengePage(this.wordList);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge'),
      ),
      body: ChallengeBody(wordList),
    );
  }
}

class ChallengeBody extends StatefulWidget {
  final List<Word> wordList;
  ChallengeBody(this.wordList);
  @override
  _ChallengeBodyState createState() => _ChallengeBodyState(wordList);
}

class _ChallengeBodyState extends State<ChallengeBody> {
  int i = 0;
  final List<Word> wordList;
  _ChallengeBodyState(this.wordList);
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: body(i),
    );
  }

  List<Widget> body(int i) {
    return [
      Text(
        '${this.wordList[i].word}',
        style: headinSyle,
      ),
      infoDevider,
      Text(
        'Meaning: ${this.wordList[i].meaning}',
        textAlign: TextAlign.right,
      ),
      infoDevider,
      Text(
        'Usage: ${this.wordList[i].usage}',
        textAlign: TextAlign.right,
      ),
      infoDevider,
      Text(
        'Phonetic: ${this.wordList[i].phonetic}',
        textAlign: TextAlign.right,
      ),
      infoDevider,
      inputWordForm(),
      Text(
        message,
        textAlign: TextAlign.right,
      ),
    ];
  }

  Form inputWordForm() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            onFieldSubmitted: (value) {
              setState(() {
                if (this.wordList[i].word == value) {
                  message = 'Right';
                  if (i < this.wordList.length - 1) i++;
                } else {
                  message = 'Wrong';
                }
              });
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelText: 'Spell it!',
              hintText: 'Just try!',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: Padding(padding: EdgeInsets.fromLTRB(0, 20, 20, 20)),
            ),
          ),
        ],
      ),
    );
  }
}

final headinSyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.black,
  height: 1.5,
);

final infoDevider = Divider(
  color: Colors.black,
  thickness: 1.0,
);
