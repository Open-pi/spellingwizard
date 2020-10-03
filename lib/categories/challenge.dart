import 'package:flutter/material.dart';
import 'word.dart';

class ChallengePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Challenge'),
      ),
      body: ChallengeBody(),
    );
  }
}

class ChallengeBody extends StatefulWidget {
  @override
  _ChallengeBodyState createState() => _ChallengeBodyState();
}

class _ChallengeBodyState extends State<ChallengeBody> {
  Word word = Word(
      word: 'Something',
      meaning: 'meaning of something',
      usage: 'usage of something',
      phonetic: 'phonetic of something');
  String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Column(
        children: [
          Text(
            '${word.word}',
            style: headinSyle,
          ),
          infoDevider,
          Text(
            'Meaning: ${word.meaning}',
            textAlign: TextAlign.right,
          ),
          infoDevider,
          Text(
            'Usage: ${word.usage}',
            textAlign: TextAlign.right,
          ),
          infoDevider,
          Text(
            'Phonetic: ${word.phonetic}',
            textAlign: TextAlign.right,
          ),
          infoDevider,
          InputWordForm(),
        ],
      ),
    );
  }
}

class InputWordForm extends StatefulWidget {
  @override
  _InputWordFormState createState() => _InputWordFormState();
}

class _InputWordFormState extends State<InputWordForm> {
  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            onFieldSubmitted: (value) {},
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
