import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:built_in_keyboard/built_in_keyboard.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'config.dart';
import 'word.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:SpellingWizard/save.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengePage extends StatefulWidget {
  final List<Word> wordList;
  final List<String> mistakesList;
  final Tuple3 prefix;
  final bool isPractice;
  ChallengePage(this.wordList, this.mistakesList, this.prefix,
      {this.isPractice = false});
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  // challenge variables
  double screenHeight;
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
  AudioCache audioCache = AudioCache();
  AudioPlayer advancedPlayer;
  bool isNotPlaying = true;

  // avatar
  final List<String> avatarState = [
    'assets/avatar/avatar_rest.svg',
    'assets/avatar/avatar_talk.svg',
    'assets/avatar/avatar_cheer.svg'
  ];
  String avatar = 'assets/avatar/avatar_rest.svg';

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit the challenge'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  initState() {
    super.initState();
    audioCache = AudioCache(prefix: 'assets/audio/');
  }

  @override
  void dispose() {
    audioCache = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        resizeToAvoidBottomPadding: true,
        backgroundColor: Colors.transparent,
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                stops: [0.01, 1],
                colors: appTheme.currentTheme.gradientKeyboardColors),
          ),
          child: SafeArea(
            child: Column(
              children: body(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> body() {
    this.screenHeight = MediaQuery.of(context).size.height;
    double height;
    if (this.screenHeight < 550)
      height = 0;
    else if (this.screenHeight < 650)
      height = this.screenHeight * 0.03;
    else if (this.screenHeight < 750)
      height = this.screenHeight * 0.04;
    else if (this.screenHeight < 850)
      height = this.screenHeight * 0.05;
    else
      height = this.screenHeight * 0.06;
    return [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60),
            bottomRight: Radius.circular(60),
          ),
          child: Container(
            color: appTheme.currentTheme.challengeBackColor,
            child: ListView(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 0.0),
                      child: progressIndicator(
                          step: this.i + 1, totalSteps: widget.wordList.length),
                    ),
                    Container(
                      margin: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomCenter,
                            stops: [0.001, 1],
                            colors: appTheme
                                .currentTheme.gradientChallengeCardColors),
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
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 3),
                                  width: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    color: Colors.lightGreen,
                                    border: Border.all(
                                      color: appTheme
                                          .currentTheme.challengeBackColor,
                                    ),
                                  ),
                                  child: Text(
                                    '$correctAnswers',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.5),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 2),
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 3),
                                  width: 25,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    color: Colors.red[400],
                                    border: Border.all(
                                      color: appTheme
                                          .currentTheme.challengeBackColor,
                                    ),
                                  ),
                                  child: Text(
                                    '$incorrectAnswers',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.5),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            _playButton(context),
                            infoDevider,
                            Text(
                              'Meaning: ${widget.wordList[this.i].meaning}',
                              style: TextStyle(
                                  color:
                                      appTheme.currentTheme.primaryTextColor),
                              textAlign: TextAlign.center,
                            ),
                            infoDevider,
                            Text(
                              'Usage: ${widget.wordList[this.i].usage}',
                              style: TextStyle(
                                  color:
                                      appTheme.currentTheme.primaryTextColor),
                              textAlign: TextAlign.center,
                            ),
                            infoDevider,
                            Text(
                              'Phonetic: ${widget.wordList[this.i].phonetic}',
                              style: TextStyle(
                                  color:
                                      appTheme.currentTheme.primaryTextColor),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      'You Have ${this.attempt} attempt(s) left.',
                      style: TextStyle(
                          color: appTheme.currentTheme.specialTextColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0, 9.3, 10.0, 0.0),
                      child: _inputWordForm(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      SizedBox(
        height: height,
      ),
      BuiltInKeyboard(
        layoutType: 'EN',
        enableAllUppercase: true,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8.0),
        height: this.screenHeight * 0.07,
        letterStyle: TextStyle(
            fontSize: 25,
            color: appTheme.currentTheme.primaryTextColor,
            fontWeight: FontWeight.w600),
        controller: this.enableTextController
            ? this.textController
            : TextEditingController(),
      ),
      SizedBox(
        height: height,
      )
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
              color: appTheme.currentTheme.inputTextColor,
              fontSize: 22.0,
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.fromLTRB(21.0, 0.0, 0.0, 0.0),
              fillColor: this.inputBackgroundColor,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                    width: 3.0, color: appTheme.currentTheme.primaryColor),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25.0),
                borderSide: BorderSide(
                    width: 3.0, color: appTheme.currentTheme.primaryColor),
              ),
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: appTheme.currentTheme.challengeAccentColor),
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
    final SaveFile saveFile = await saveFileOfCategory(widget.prefix.item3);
    File mistakesFile = await loadMistakesFile();
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
                          color: appTheme.currentTheme.primaryTextColor)),
                  Text('${widget.wordList[this.i].word.toUpperCase()}',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.greenAccent[700],
                          fontWeight: FontWeight.w600)),
                ],
              ));
          this.correctAnswers++;
          if (widget.isPractice) {
            mistakesFile.writeAsStringSync('');
            List<Word> newMistakesList = widget.wordList;
            newMistakesList.remove(widget.wordList[this.i]);
            for (int j = 0; j < widget.wordList.length; j++) {
              mistakesFile.writeAsStringSync(
                  "${newMistakesList[j].word},${newMistakesList[j].meaning},${newMistakesList[j].usage},${newMistakesList[j].phonetic}\r\n",
                  mode: FileMode.append);
            }
          }
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
                          color: appTheme.currentTheme.primaryTextColor)),
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
          if (!widget.isPractice &&
              !widget.mistakesList.contains(widget.wordList[this.i].word)) {
            mistakesFile.writeAsStringSync(
                "${widget.wordList[this.i].word},${widget.wordList[this.i].meaning},${widget.wordList[this.i].usage},${widget.wordList[this.i].phonetic}\r\n",
                mode: FileMode.append);
          }
        }
        this.attempt--;
        if (this.attempt < 1) {
          this.avatar = this.avatarState[2];
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
        this.avatar = this.avatarState[0];
        this.attempt = 3;
        this.hintText = 'Just try...';
        this.inputBackgroundColor = Colors.white;
        this.i++;
        textController.text = '';
        this.enableTextController = true;
      }
      if (endOfGame) {
        // the save the results in the save files.

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
        this.avatar = this.avatarState[2];
        _resultPopup(context);
      }
    });
  }

  _playButton(BuildContext context) => Center(
        child: Container(
          child: FlatButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: EdgeInsets.all(1),
            onPressed: () {
              if (isNotPlaying) {
                setState(() {
                  this.avatar = this.avatarState[1];
                });
                play('${widget.wordList[this.i].word}.mp3');
              }
            },
            child: SvgPicture.asset(this.avatar, semanticsLabel: 'Acme Logo'),
          ),
        ),
      );

  play(String path) async {
    isNotPlaying = false;
    AudioPlayer player = await audioCache.play(path, volume: 1);

    player.onPlayerCompletion.listen((event) {
      setState(() {
        this.avatar = this.avatarState[0];
        isNotPlaying = true;
      });
    });
  }

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
                colors: appTheme.currentTheme.gradientDialogColors),
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
                  color: appTheme.currentTheme.challengeBackColor,
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
                  color: appTheme.currentTheme.primaryTextColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 16),
              child: Text(
                '${this.scoreMessage}',
                style: TextStyle(color: appTheme.currentTheme.primaryTextColor),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: this.screenHeight * 0.016,
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
                  textColor: appTheme.currentTheme.primaryTextColor,
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
                      this.inputBackgroundColor = Colors.white;
                      this.avatar = this.avatarState[0];
                      this.enableTextController = true;
                    });
                    Navigator.pop(context, true);
                  },
                  child: Text('Retake'),
                  color: appTheme.currentTheme.challengeBackColor,
                  textColor: appTheme.currentTheme.primaryColor,
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
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.001, 1],
                colors: appTheme.currentTheme.gradientDialogColors),
          ),
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
            child: Column(
              children: [
                Text('Answers',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      color: appTheme.currentTheme.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(
                  height: 5,
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
                                      height: 10,
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
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

final infoDevider = Divider(
  color: appTheme.currentTheme.challengeBackColor,
  thickness: 1.0,
);

progressIndicator({int step, int totalSteps}) => StepProgressIndicator(
      roundedEdges: Radius.circular(10),
      totalSteps: totalSteps,
      currentStep: step,
      selectedColor: appTheme.currentTheme.primaryColor,
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
