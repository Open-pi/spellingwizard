import 'package:built_in_keyboard/built_in_keyboard.dart';
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
  final Tuple3 prefix;
  final String title;
  ChallengePage(this.wordList, this.prefix, this.title);
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  // challenge variables
  double screenHeight;
  Color accentColor = Colors.purple[500];
  int i = 0;
  int attempt = 3;
  final TextEditingController textController = new TextEditingController();

  // input field vriable
  Color inputBackgroundColor = Colors.white;
  String hintText = 'Just try...';

  // result popup variables
  double score = 0;
  int correctAnswers = 0;
  int incorrectAnswers = 0;
  bool enableTextController = true;
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
    [Colors.amberAccent, Colors.amber],
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
      backgroundColor: Colors.deepPurpleAccent[700],
      body: Column(
        children: body(),
      ),
    );
  }

  List<Widget> body() {
    this.screenHeight = MediaQuery.of(context).size.height;
    double height = this.screenHeight < 550
        ? this.screenHeight * 0.004
        : this.screenHeight * 0.13;
    return [
      Container(
        padding: EdgeInsets.only(bottom: height),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              height: 2,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(8.0, 25.0, 8.0, 0.0),
              child: progressIndicator(
                  step: this.i + 1, totalSteps: widget.wordList.length),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                color: Colors.deepPurpleAccent[700],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 2),
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                            color: Colors.lightGreen,
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(5, 3, 5, 5),
                            child: Text(
                              '$correctAnswers',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 10.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 2),
                          width: 25,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(9.0),
                            color: Colors.red[400],
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 3, 5, 5),
                            child: Text(
                              '$incorrectAnswers',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 10.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    _playButton(context),
                    Text(
                      '${widget.wordList[this.i].word.toLowerCase()}',
                      style: headinSyle,
                      textAlign: TextAlign.center,
                    ),
                    infoDevider,
                    Text(
                      'Meaning: ${widget.wordList[this.i].meaning}',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    infoDevider,
                    Text(
                      'Usage: ${widget.wordList[this.i].usage}',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    infoDevider,
                    Text(
                      'Phonetic: ${widget.wordList[this.i].phonetic}',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'You Have ${this.attempt} attempt(s) left.',
              style: TextStyle(color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
              child: _inputWordForm(),
            ),
          ],
        ),
      ),
      Spacer(),
      BuiltInKeyboard(
        layoutType: 'EN',
        enableAllUppercase: true,
        color: Colors.deepPurpleAccent[700],
        borderRadius: BorderRadius.circular(8.0),
        letterStyle: TextStyle(
            fontSize: 25, color: Colors.white, fontWeight: FontWeight.w600),
        controller: this.enableTextController
            ? this.textController
            : TextEditingController(),
      ),
      Spacer(),
    ];
  }

  _inputWordForm() => Container(
        margin: EdgeInsets.fromLTRB(70.0, 0.0, 70.0, 0.0),
        child: Form(
          child: TextFormField(
            controller: textController,
            onFieldSubmitted: (userWord) => _inputFieldUpdate(userWord),
            readOnly: true,
            autocorrect: false,
            keyboardType: TextInputType.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.indigo[900],
              fontSize: 22.0,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(21.0, 0.0, 0.0, 0.0),
              fillColor: this.inputBackgroundColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide:
                    BorderSide(width: 3.0, color: Colors.deepPurpleAccent[700]),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide:
                    BorderSide(width: 3.0, color: Colors.deepPurpleAccent[700]),
              ),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w900, color: this.accentColor),
              hintText: '${this.hintText}',
              hintStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              floatingLabelBehavior: FloatingLabelBehavior.always,
              suffixIcon: IconButton(
                onPressed: () => _inputFieldUpdate(this.textController.text),
                icon: Icon(
                  Icons.arrow_forward,
                ),
              ),
            ),
          ),
        ),
      );

  _inputFieldUpdate(String userWord) async {
    final path = await savePath();
    setState(() {
      bool move = false;
      bool endOfGame = false;
      bool stillPages = this.i < widget.wordList.length - 1;
      bool lastPage = this.i == widget.wordList.length - 1;
      if (widget.wordList[this.i].word.toUpperCase() == userWord) {
        move = true;
        if (this.attempt == 3) {
          this.answerList.add(Row(
                children: [
                  Text('${this.i + 1} - ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber)),
                  Text('${widget.wordList[this.i].word.toUpperCase()}',
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
          endOfGame = true;
        } else {
          this.attempt = 3;
        }
      } else {
        if (this.attempt == 3) {
          this.inputBackgroundColor = Colors.red[100];
          this.hintText = 'Keep trying...';
          this.answerList.add(Row(
                children: [
                  Text('${this.i + 1} - ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber)),
                  Text('${widget.wordList[this.i].word.toUpperCase()}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.greenAccent[700],
                          fontWeight: FontWeight.w600)),
                  Text(' not ',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.amber)),
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
        if (this.attempt < 1) {
          this.enableTextController = false;
          this.textController.text = widget.wordList[this.i].word.toUpperCase();
          this.inputBackgroundColor = Colors.green[100];
          if (lastPage) {
            // If we reached the last word
            this.attempt = 0;
            endOfGame = true;
          }
        }
      }
      if (stillPages && move) {
        this.attempt = 3;
        this.hintText = 'Just try...';
        this.inputBackgroundColor = Colors.white;
        this.i++;
        textController.text = '';
        this.enableTextController = true;
      }
      if (endOfGame) {
        // the save the results in the save files.
        final file = File('$path/${widget.prefix.item3}.csv');
        final SaveFile saveFile = SaveFile(file: file);
        saveFile.saveChallenge(
            widget.prefix.item2, this.correctAnswers, widget.wordList.length);
        this.score = (this.correctAnswers / widget.wordList.length) * 100;
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
  }

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
                    color: Colors.amber,
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

  _frontChild(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 395,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                stops: [0.01, 1],
                colors: [Colors.purple, Colors.deepPurpleAccent[700]]),
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
              height: this.screenHeight * 0.029,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Quit'),
                  textColor: Colors.white,
                ),
                SizedBox(
                  width: 8,
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      this.i = 0;
                      this.textController.text = '';
                      this.attempt = 3;
                      this.score = 0;
                      this.correctAnswers = 0;
                      this.incorrectAnswers = 0;
                      this.scoreTitle = '';
                      this.scoreMessage = '';
                      this.scoreColor = [];
                      this.answerList = [];
                    });
                    Navigator.pop(context, true);
                  },
                  child: Text('Retake'),
                  color: Colors.white,
                  textColor: Colors.deepPurpleAccent[700],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _backChild(BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 395,
          decoration: BoxDecoration(
              color: Colors.deepPurpleAccent[700],
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Column(
              children: [
                Text('Answers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 280,
                  child: Scrollbar(
                    thickness: 1,
                    child: SingleChildScrollView(
                      child: Column(
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
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: () {
                    this.cardKey.currentState.toggleCard();
                  },
                  child: Text(
                    'Go back',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

final headinSyleT = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

final headinSyleD = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w600,
  color: Colors.black,
);

final headinSyle = TextStyle(
  fontSize: 28,
  fontWeight: FontWeight.bold,
  color: Colors.white,
  height: 1.5,
);

final infoDevider = Divider(
  color: Colors.white,
  thickness: 1.0,
);

progressIndicator({int step, int totalSteps}) => StepProgressIndicator(
      roundedEdges: Radius.circular(10),
      totalSteps: totalSteps,
      currentStep: step,
      selectedColor: Colors.deepPurpleAccent[700],
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
