import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:tuple/tuple.dart';
import 'word.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:SpellingWizard/save.dart';
import 'dart:io';

class ChallengePage extends StatelessWidget {
  final List<Word> wordList;
  final Color color;
  final Tuple3 prefix;
  ChallengePage(this.wordList, this.color, this.prefix);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Challenge'),
        backgroundColor: this.color,
      ),
      body: ChallengeBody(wordList, color, prefix),
    );
  }
}

class ChallengeBody extends StatefulWidget {
  final List<Word> wordList;
  final Color accentColor;
  final Tuple3 prefix;
  ChallengeBody(this.wordList, this.accentColor, this.prefix);
  @override
  _ChallengeBodyState createState() =>
      _ChallengeBodyState(wordList, accentColor, prefix);
}

class _ChallengeBodyState extends State<ChallengeBody> {
  int numberOfRightAnswers = 0;
  int numberOfWrongAnswers = 0;
  List messages = [
    'Right!',
    'Wrong!',
    'moving to the next word',
    'End of the Challenge',
  ];
  int i = 0;
  int step = 0;
  int attempt = 3;
  final List<Word> wordList;
  final Color accentColor;
  final Tuple3 prefix;
  _ChallengeBodyState(this.wordList, this.accentColor, this.prefix);
  String message = '';
  final TextEditingController textController = new TextEditingController();

  // related to playing audio files.
  AudioCache player;

  @override
  initState() {
    super.initState();
    player = AudioCache(prefix: this.prefix.item1);
  }

  @override
  void dispose() {
    player = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: body(),
    );
  }

  List<Widget> body() {
    return [
      SizedBox(
        height: 2,
      ),
      progressIndicator(this.step),
      Card(
        color: this.accentColor,
        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0.01, 1],
                  colors: [Colors.purple, Colors.deepOrange])),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.greenAccent[400],
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 3, 5, 5),
                        child: Text(
                          '$numberOfRightAnswers',
                          textAlign: TextAlign.center,
                          textScaleFactor: 0.8,
                        ),
                      ),
                    ),
                    Container(
                      width: 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.redAccent[400],
                        border: Border.all(
                          color: Colors.black,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                        child: Text(
                          '$numberOfWrongAnswers',
                          textAlign: TextAlign.center,
                          textScaleFactor: 0.8,
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                playButton(context),
                Text(
                  '${this.wordList[this.i].word}',
                  style: headinSyle,
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Meaning: ${this.wordList[this.i].meaning}',
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Usage: ${this.wordList[this.i].usage}',
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Phonetic: ${this.wordList[this.i].phonetic}',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      Text('You Have ${this.attempt} attempt(s) left.'),
      Text(
        message,
        textAlign: TextAlign.center,
      ),
      Padding(
        padding: const EdgeInsets.all(10),
        child: inputWordForm(),
      ),
    ];
  }

  Form inputWordForm() {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: textController,
            onFieldSubmitted: (value) async {
              final path = await savePath();
              setState(() {
                bool move = false;
                bool endOfGame = false;
                bool stillPages = this.i < this.wordList.length - 1;
                bool lastPage = this.i == this.wordList.length - 1;
                if (this.wordList[this.i].word == value) {
                  move = true;
                  this.numberOfRightAnswers++;
                  if (lastPage) {
                    // If we reached the last word
                    this.attempt = 0;
                    message = this.messages[3];
                    endOfGame = true;
                  } else {
                    this.attempt = 3;
                    message = this.messages[0];
                  }
                } else {
                  this.numberOfWrongAnswers++;
                  this.attempt--;
                  message = this.messages[1];
                  if (this.attempt < 1) {
                    move = true;
                    if (this.i == this.wordList.length - 1) {
                      // If we reached the last word.
                      message = this.messages[3];
                      this.attempt = 0;
                      endOfGame = true;
                    } else {
                      // otherwise, we move to the next word.
                      message = this.messages[2];
                      this.attempt = 3;
                    }
                  }
                }
                if (stillPages && move) {
                  this.i++;
                  this.step++;
                  textController.text = '';
                }
                if (endOfGame) {
                  // the save the results in the save files.
                  this.step++;
                  final file = File('$path/${this.prefix.item3}.csv');
                  final SaveFile saveFile = SaveFile(file: file);
                  saveFile.saveChallenge(prefix.item2,
                      this.numberOfRightAnswers, this.wordList.length);
                }
              });
            },
            keyboardType: TextInputType.name,
            decoration: InputDecoration(
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w900, color: this.accentColor),
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

  Widget playButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(0),
            margin: const EdgeInsets.only(
                top: 10, left: 10.0, right: 10.0, bottom: 10.0),
            child: Center(
              child: FlatButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.all(1),
                onPressed: () {
                  player.play('sound_${prefix.item2}_${this.i}.mp3', volume: 1);
                },
                child: Icon(
                  Icons.play_arrow,
                  size: 40,
                  color: this.accentColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  StepProgressIndicator progressIndicator(int step) {
    return StepProgressIndicator(
      totalSteps: this.wordList.length,
      currentStep: step,
      selectedColor: Colors.purple,
      unselectedColor: Colors.grey,
      size: 8,
      padding: 1,
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
