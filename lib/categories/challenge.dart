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
  List messages = [
    'Right!',
    'Wrong!',
    'moving to the next word',
    'End of the Challenge',
  ];
  int i = 0;
  int attempt = 3;
  final List<Word> wordList;
  _ChallengeBodyState(this.wordList);
  String message = '';
  final TextEditingController textController = new TextEditingController();

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
      Text('You Have $attempt attempt(s) left.')
    ];
  }

  Form inputWordForm() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: textController,
            onFieldSubmitted: (value) {
              setState(() {
                bool move = false;
                bool stillPages = i < this.wordList.length - 1;
                bool lastPage = i == this.wordList.length - 1;
                if (this.wordList[i].word == value) {
                  move = true;
                  if (lastPage) {
                    // If we reached the last word
                    attempt = 0;
                    message = messages[3];
                  } else {
                    attempt = 3;
                    message = messages[0];
                  }
                } else {
                  attempt--;
                  message = messages[1];
                  if (attempt < 1) {
                    move = true;
                    if (i == this.wordList.length - 1) {
                      // If we reached the last word. The player lost the game
                      message = messages[3];
                      attempt = 0;
                    } else {
                      // otherwise, we move to the next word.
                      message = messages[2];
                      attempt = 3;
                    }
                  }
                }
                if (stillPages && move) {
                  i++;
                  textController.text = '';
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
