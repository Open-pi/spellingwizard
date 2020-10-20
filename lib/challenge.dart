import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:tuple/tuple.dart';
import 'word.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:SpellingWizard/save.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'dart:io';

class ChallengePage extends StatefulWidget {
  final List<Word> wordList;
  final Color accentColor;
  final Tuple3 prefix;
  ChallengePage(this.wordList, this.accentColor, this.prefix);
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  // challenge variables
  List messages = [
    'Right!',
    'Wrong!',
    'moving to the next word',
    'End of the Challenge',
  ];
  String message = '';
  int i = 0;
  int attempt = 3;
  final TextEditingController textController = new TextEditingController();

  // result popup variables
  double score = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  final List scoreTitles = [
    'Excellent!',
    'Very Good!',
    'Good!',
    'Fair!',
    'Poor!',
  ];
  final List scoreMessages = [
    'You are a god',
    'Practice more to gain higher mark'
  ];
  final List scoreColors = [
    [Colors.yellowAccent, Colors.yellowAccent[700]],
    [Colors.lightBlue, Colors.greenAccent[400]],
    [Colors.orangeAccent[400], Colors.red],
  ];
  String scoreTitle = '';
  String scoreMessage = '';
  List scoreColor = [];
  List<Widget> answerList = [];
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  // related to playing audio files.
  AudioCache player;

  @override
  initState() {
    super.initState();
    player = AudioCache(prefix: widget.prefix.item1);
  }

  @override
  void dispose() {
    player = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text('Challenge'),
        backgroundColor: widget.accentColor,
      ),
      body: Column(
        children: body(),
      ),
    );
  }

  List<Widget> body() {
    return [
      SizedBox(
        height: 2,
      ),
      progressIndicator(step: this.i + 1, totalSteps: widget.wordList.length),
      Card(
        color: widget.accentColor,
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
                  '${widget.wordList[this.i].word}',
                  style: headinSyle,
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Meaning: ${widget.wordList[this.i].meaning}',
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Usage: ${widget.wordList[this.i].usage}',
                  textAlign: TextAlign.center,
                ),
                infoDevider,
                Text(
                  'Phonetic: ${widget.wordList[this.i].phonetic}',
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
              onFieldSubmitted: (userWord) async {
                final path = await savePath();
                setState(() {
                  bool move = false;
                  bool endOfGame = false;
                  bool stillPages = this.i < widget.wordList.length - 1;
                  bool lastPage = this.i == widget.wordList.length - 1;
                  if (widget.wordList[this.i].word == userWord) {
                    move = true;
                    if (this.attempt == 3) {
                      this.answerList.add(Row(
                            children: [
                              Text('${this.i + 1} - ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              Text('${widget.wordList[this.i].word}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.greenAccent[700],
                                      fontWeight: FontWeight.w600)),
                            ],
                          ));
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
                      this.answerList.add(Row(
                            children: [
                              Text('${this.i + 1} - ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              Text('${widget.wordList[this.i].word}',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.greenAccent[700],
                                      fontWeight: FontWeight.w600)),
                              Text(' not ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600)),
                              Text('$userWord',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.redAccent[700],
                                      fontWeight: FontWeight.w600)),
                            ],
                          ));
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
                    final file = File('$path/${widget.prefix.item3}.csv');
                    final SaveFile saveFile = SaveFile(file: file);
                    saveFile.saveChallenge(widget.prefix.item2,
                        this.correctAnswers, widget.wordList.length);
                    this.score =
                        (this.correctAnswers / widget.wordList.length) * 100;
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
                    _resultPopup(context);
                  }
                });
              },
              keyboardType: TextInputType.name,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                    fontWeight: FontWeight.w900, color: widget.accentColor),
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
                    player.play('sound_${widget.prefix.item2}_${this.i}.mp3',
                        volume: 1);
                  },
                  child: Icon(
                    Icons.play_arrow,
                    size: 40,
                    color: widget.accentColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  _resultPopup(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        return FlipCard(
          direction: FlipDirection.HORIZONTAL,
          key: this.cardKey,
          flipOnTouch: false,
          front: _frontChild(context),
          back: _backChild(context),
        );
      });

  _frontChild(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        child: Container(
          height: 395,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  stops: [0.01, 1],
                  colors: [Colors.purple, Colors.deepOrange]),
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
                        onPressed: () {
                          this.cardKey.currentState.toggleCard();
                        },
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
                    textColor: Colors.deepOrange,
                  )
                ],
              )
            ],
          ),
        ),
      );

  _backChild(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        child: Container(
          height: 395,
          decoration: BoxDecoration(
              color: Colors.amber[300],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 0),
            child: Column(
              children: [
                Text('Answers',
                    style: TextStyle(
                      fontSize: 25,
                      color: widget.accentColor,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: this
                      .answerList
                      .map((row) => Column(
                            children: [
                              row,
                              SizedBox(
                                height: 13,
                              )
                            ],
                          ))
                      .toList(),
                ),
                FlatButton(
                  onPressed: () {
                    this.cardKey.currentState.toggleCard();
                  },
                  child: Text(
                    'Go back',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
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
