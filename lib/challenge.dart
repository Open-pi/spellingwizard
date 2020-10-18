import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:tuple/tuple.dart';
import 'word.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:SpellingWizard/save.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
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
  List scoreTitles = [
    'Excellent!',
    'Very Good!',
    'Good!',
    'Fair!',
    'Poor!',
  ];
  List scoreMessages = ['You are a god', 'Practice more to gain higher mark'];
  List scoreColors = [
    [Colors.yellowAccent, Colors.yellowAccent[700]],
    [Colors.lightBlue, Colors.greenAccent[400]],
    [Colors.orangeAccent[400], Colors.red],
  ];
  List messages = [
    'Right!',
    'Wrong!',
    'moving to the next word',
    'End of the Challenge',
  ];
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  double score = 0;
  String scoreTitle = '';
  String scoreMessage = '';
  List scoreColor = [];
  int i = 0;
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
      progressIndicator(step: this.i + 1, totalSteps: this.wordList.length),
      Card(
        color: this.accentColor,
        margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
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
                          '$correctAnswers',
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
                          '$incorrectAnswers',
                          textAlign: TextAlign.center,
                          textScaleFactor: 0.8,
                        ),
                      ),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.end,
                ),
                _playButton(context),
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
        child: _inputWordForm(),
      ),
    ];
  }

  _inputWordForm() => Form(
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
                    if (this.attempt == 3) {
                      this.correctAnswers++;
                    }
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
                    if (this.attempt == 3) {
                      this.incorrectAnswers++;
                    }
                    this.attempt--;
                    message = this.messages[1];
                    if (this.attempt < 1) {
                      move = true;
                      if (lastPage) {
                        // If we reached the last word
                        this.attempt = 0;
                        message = this.messages[3];
                        endOfGame = true;
                      } else {
                        // otherwise, we move to the next word.
                        this.attempt = 3;
                        message = this.messages[2];
                      }
                    }
                  }
                  if (stillPages && move) {
                    this.i++;
                    textController.text = '';
                  }
                  if (endOfGame) {
                    // the save the results in the save files.
                    final file = File('$path/${this.prefix.item3}.csv');
                    final SaveFile saveFile = SaveFile(file: file);
                    saveFile.saveChallenge(prefix.item2, this.correctAnswers,
                        this.wordList.length);
                    this.score =
                        (this.correctAnswers / this.wordList.length) * 100;
                    if (this.score == 100) {
                      this.scoreTitle = this.scoreTitles[0];
                      this.scoreMessage = this.scoreMessages[0];
                      this.scoreColor = this.scoreColors[0];
                    } else if (this.score >= 75) {
                      this.scoreTitle = this.scoreTitles[1];
                      this.scoreMessage = this.scoreMessages[1];
                      this.scoreColor = this.scoreColors[1];
                    } else if (this.score >= 50) {
                      this.scoreTitle = this.scoreTitles[2];
                      this.scoreMessage = this.scoreMessages[1];
                      this.scoreColor = this.scoreColors[1];
                    } else if (this.score >= 25) {
                      this.scoreTitle = this.scoreTitles[3];
                      this.scoreMessage = this.scoreMessages[1];
                      this.scoreColor = this.scoreColors[2];
                    } else {
                      this.scoreTitle = this.scoreTitles[4];
                      this.scoreMessage = this.scoreMessages[1];
                      this.scoreColor = this.scoreColors[2];
                    }
                    _createAlertDialog(context);
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
                suffixIcon:
                    Padding(padding: EdgeInsets.fromLTRB(0, 20, 20, 20)),
              ),
            ),
          ],
        ),
      );

  _playButton(BuildContext context) => Container(
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
                    player.play('sound_${prefix.item2}_${this.i}.mp3',
                        volume: 1);
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

  _createAlertDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
          child: _buildChild(context),
        );
      });

  _buildChild(BuildContext context) => Container(
        height: 395,
        decoration: BoxDecoration(
            color: Colors.redAccent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  children: [
                    circularSlider(
                      invalue: this.score,
                      colors: this.scoreColor,
                    ),
                    answersCount(
                      correct: this.correctAnswers,
                      incorrect: this.incorrectAnswers,
                    ),
                    FlatButton(
                      onPressed: () {},
                      child: Text(
                        'View Answers',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
            SizedBox(
              height: 24,
            ),
            Text(
              '${this.scoreTitle}',
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Text(
                '${this.scoreMessage}',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Quit'),
                  textColor: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                RaisedButton(
                  onPressed: () {
                    return Navigator.of(context).pop(true);
                  },
                  child: Text('Retake'),
                  color: Colors.white,
                  textColor: Colors.redAccent,
                )
              ],
            )
          ],
        ),
      );
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

progressIndicator({int step, int totalSteps}) => StepProgressIndicator(
      totalSteps: totalSteps,
      currentStep: step,
      selectedColor: Colors.purple,
      unselectedColor: Colors.grey,
      size: 8,
      padding: 1,
    );

answersCount({int correct, int incorrect}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Row(
        children: [
          Icon(
            Icons.check,
            color: Colors.green,
          ),
          Text('$correct Correct')
        ],
      ),
      Row(
        children: [
          Icon(
            Icons.close,
            color: Colors.red,
          ),
          Text('$incorrect Incorrect')
        ],
      ),
    ],
  );
}

circularSlider({double invalue, List<Color> colors}) => SleekCircularSlider(
      appearance: CircularSliderAppearance(
          customWidths: CustomSliderWidths(progressBarWidth: 10),
          customColors: CustomSliderColors(progressBarColors: colors)),
      min: 0,
      max: 100,
      initialValue: invalue,
    );
