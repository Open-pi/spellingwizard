import 'dart:io';

import 'package:built_in_keyboard/built_in_keyboard.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tuple/tuple.dart';
import 'config.dart';
import 'word.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:SpellingWizard/save.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:auto_size_text/auto_size_text.dart';

class ChallengePage extends StatefulWidget {
  final List<Word> wordList;
  final List<String> mistakesList;
  final Tuple3 prefix;
  final bool isPractice;
  final bool isTerminationMode;
  final int numofRepetitions;
  ChallengePage(this.wordList, this.mistakesList, this.prefix,
      {this.isPractice = false,
      this.isTerminationMode = false,
      this.numofRepetitions = 1});
  @override
  _ChallengePageState createState() => _ChallengePageState();
}

class _ChallengePageState extends State<ChallengePage> {
  // challenge variables
  double screenHeight;
  int i = 0;
  int attempt = 3;
  final TextEditingController textController = new TextEditingController();
  bool restartOrEndofgame = false;
  List<Word> challengeWordList = [];
  List<Word> newMistakesList = [];
  bool answerFeedback = true;

  // practice variables
  List<Word> practiceWordsList = [];
  List<int> practiceTimesList = [];
  List<int> newPracticeTimesList = [];
  int numberOfWords = 1;

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
  final assetsAudioPlayer = AssetsAudioPlayer();
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

  navigateBack() {
    Navigator.of(context).pop(true);
  }

  @override
  initState() {
    super.initState();
    challengeWordList = List.from(widget.wordList);
    newMistakesList = List.from(widget.wordList);
    if (widget.isPractice && widget.isTerminationMode)
      practiceTimesList = List.filled(widget.wordList.length, 0);
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();
    super.dispose();
  }

  final double heightFactor = 0.7;
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
          child: Stack(
            fit: StackFit.expand,
            children: body(),
          ),
        ),
      ),
    );
  }

  List<Widget> body() {
    return [
      FractionallySizedBox(
        alignment: Alignment.topCenter,
        heightFactor: heightFactor,
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
                          step: this.i + 1,
                          totalSteps: this.challengeWordList.length),
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
                                  width: correctAnswers < 20 ? 25 : 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    color: Colors.lightGreen,
                                    border: Border.all(
                                      color: appTheme
                                          .currentTheme.challengeBackColor,
                                    ),
                                  ),
                                  child: AutoSizeText(
                                    '$correctAnswers',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.5),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 2),
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 3),
                                  width: incorrectAnswers < 20 ? 25 : 30,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9.0),
                                    color: Colors.red[400],
                                    border: Border.all(
                                      color: appTheme
                                          .currentTheme.challengeBackColor,
                                    ),
                                  ),
                                  child: AutoSizeText(
                                    '$incorrectAnswers',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10.5),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                            _playButton(context),
                            infoDevider,
                            Text(
                              'Meaning: ${this.challengeWordList[this.i].meaning}',
                              style: TextStyle(
                                  color:
                                      appTheme.currentTheme.primaryTextColor),
                              textAlign: TextAlign.center,
                            ),
                            infoDevider,
                            Text(
                              'Usage: ${this.challengeWordList[this.i].usage}',
                              style: TextStyle(
                                  color:
                                      appTheme.currentTheme.primaryTextColor),
                              textAlign: TextAlign.center,
                            ),
                            infoDevider,
                            Text(
                              'Phonetic: ${this.challengeWordList[this.i].phonetic}',
                              style: TextStyle(
                                  fontFamily: '',
                                  fontWeight: FontWeight.w600,
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
      FractionallySizedBox(
        alignment: Alignment.bottomCenter,
        heightFactor: 1 - heightFactor,
      ),
      FractionallySizedBox(
        alignment: Alignment.bottomCenter,
        heightFactor: 1 - heightFactor,
        child: Column(
          children: [
            Spacer(),
            BuiltInKeyboard(
              layoutType: 'EN',
              enableAllUppercase: true,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(8.0),
              letterStyle: TextStyle(
                  fontSize: 25,
                  color: appTheme.currentTheme.primaryTextColor,
                  fontWeight: FontWeight.w600),
              controller: this.enableTextController
                  ? this.textController
                  : TextEditingController(),
            ),
            Spacer(),
          ],
        ),
      ),
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
      bool stillPages = this.i < this.challengeWordList.length - 1;
      bool lastPage = this.i == this.challengeWordList.length - 1;
      bool isCorrectAnswer =
          this.challengeWordList[this.i].word.toUpperCase() == userWord;
      if (isCorrectAnswer) {
        if (this.attempt == 3 && this.answerFeedback) {
          this.restartOrEndofgame = true;
          if (!this.answerList.contains(this.challengeWordList[this.i].word)) {
            this.answerList.add(Row(
                  children: [
                    Text('${this.i + 1} - ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: appTheme.currentTheme.primaryTextColor)),
                    Text('${this.challengeWordList[this.i].word.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.greenAccent[700],
                            fontWeight: FontWeight.w600)),
                  ],
                ));
          }
          this.correctAnswers++;
          // if practice
          if (widget.isPractice) {
            this.practiceTimesList[i]++;
            if (this.practiceTimesList[i] == widget.numofRepetitions) {
              mistakesFile.writeAsStringSync('');
              this.newMistakesList.remove(this.challengeWordList[this.i]);
              for (int j = 0; j < this.newMistakesList.length; j++) {
                mistakesFile.writeAsStringSync(
                    "${this.newMistakesList[j].word},${this.newMistakesList[j].meaning},${this.newMistakesList[j].usage},${this.newMistakesList[j].phonetic}\r\n",
                    mode: FileMode.append);
              }
            }
          }
        }
        if (this.answerFeedback) {
          this.answerFeedback = false;
          this.avatar = this.avatarState[2];
          this.enableTextController = false;
          this.textController.text =
              this.challengeWordList[this.i].word.toUpperCase();
          this.inputBackgroundColor = Colors.green[100];
          this.restartOrEndofgame = true;
        } else {
          move = true;
          this.answerFeedback = true;
        }
        if (this.restartOrEndofgame) {
          this.restartOrEndofgame = false;
          if (lastPage &&
              (this.attempt < 1 || (isCorrectAnswer && this.attempt == 3))) {
            // If we reached the last word or the answer is correct from the first try
            if (widget.isPractice && widget.isTerminationMode) {
              this.practiceWordsList = [];
              this.newPracticeTimesList = [];
              for (int k = 0; k < this.practiceTimesList.length; k++) {
                if (this.practiceTimesList[k] < widget.numofRepetitions) {
                  this.practiceWordsList.add(this.challengeWordList[k]);
                  this.newPracticeTimesList.add(this.practiceTimesList[k]);
                }
              }
              if (this.practiceWordsList.length > 0) {
                endOfGame = false;
                this.challengeWordList = List.from(this.practiceWordsList);
                this.practiceTimesList = List.from(newPracticeTimesList);
                this.i = 0;
                this.textController.text = '';
                this.attempt = 3;
                this.inputBackgroundColor = Colors.white;
                this.avatar = this.avatarState[0];
                this.enableTextController = true;
              } else {
                this.attempt = 0;
                endOfGame = true;
              }
            } else {
              this.attempt = 0;
              endOfGame = true;
            }
          }
        }
        // here
      } else {
        if (this.attempt == 3) {
          this.inputBackgroundColor = Colors.red[100];
          this.hintText = 'Keep trying...';
          if (!this.answerList.contains(this.challengeWordList[this.i].word)) {
            this.answerList.add(Row(
                  children: [
                    Flexible(
                      child: AutoSizeText(
                        '${this.i + 1} - ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: appTheme.currentTheme.primaryTextColor),
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      child: AutoSizeText(
                        '${this.challengeWordList[this.i].word.toUpperCase()}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.greenAccent[700],
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      child: AutoSizeText(
                        ' not ',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.amber),
                        maxLines: 1,
                      ),
                    ),
                    Flexible(
                      child: AutoSizeText(
                        '$userWord',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.redAccent[700],
                            fontWeight: FontWeight.w600),
                        maxLines: 1,
                      ),
                    ),
                  ],
                ));
          }

          this.incorrectAnswers++;
          if (!widget.isPractice &&
              !widget.mistakesList
                  .contains(this.challengeWordList[this.i].word)) {
            mistakesFile.writeAsStringSync(
                "${this.challengeWordList[this.i].word},${this.challengeWordList[this.i].meaning},${this.challengeWordList[this.i].usage},${this.challengeWordList[this.i].phonetic}\r\n",
                mode: FileMode.append);
          }
        }
        this.attempt--;
        if (this.attempt < 1) {
          this.avatar = this.avatarState[2];
          this.enableTextController = false;
          this.textController.text =
              this.challengeWordList[this.i].word.toUpperCase();
          this.inputBackgroundColor = Colors.green[100];
          this.answerFeedback = false;
          this.restartOrEndofgame = true;
        }
      }

      if (stillPages && move) {
        this.numberOfWords++;
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
        if (!widget.isPractice) {
          this.score =
              (this.correctAnswers / this.challengeWordList.length) * 100;
          saveFile.saveChallenge(widget.prefix.item2, this.score);
        } else {
          this.numberOfWords++;
          this.score = (this.correctAnswers / this.numberOfWords) * 100;
        }
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
                assetsAudioPlayer.open(
                  Audio(
                      "assets/audio/${this.challengeWordList[this.i].word.toLowerCase()}.mp3"),
                );
                isNotPlaying = false;
                assetsAudioPlayer.playlistAudioFinished
                    .listen((Playing playing) {
                  isNotPlaying = true;
                  setState(() {
                    this.avatar = this.avatarState[0];
                  });
                });
              }
            },
            child: SvgPicture.asset(this.avatar, semanticsLabel: 'Acme Logo'),
          ),
        ),
      );

  _resultPopup(BuildContext context) => showDialog(
      barrierDismissible: false,
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomCenter,
              stops: [0.01, 1],
              colors: appTheme.currentTheme.gradientDialogColors),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
              decoration: BoxDecoration(
                  color: appTheme.currentTheme.challengeBackColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
            ),
            SizedBox(
              height: 10,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${this.scoreTitle}',
                  style: TextStyle(
                      fontSize: 20,
                      color: appTheme.currentTheme.primaryTextColor,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 16, left: 16),
                  child: Text(
                    '${this.scoreMessage}',
                    style: TextStyle(
                        color: appTheme.currentTheme.primaryTextColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        navigateBack();
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
                        Navigator.of(context).pop(true);
                      },
                      child: Text('Retake'),
                      color: appTheme.currentTheme.challengeBackColor,
                      textColor: appTheme.currentTheme.primaryColor,
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  _backChild(BuildContext context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: Container(
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
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText(
                  'Answers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: appTheme.currentTheme.primaryTextColor,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                Container(
                  height: 280,
                  child: Scrollbar(
                    thickness: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
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
          AutoSizeText('$correct Correct')
        ],
      ),
      Row(
        children: [
          Icon(
            Icons.close,
            color: Colors.red,
          ),
          AutoSizeText('$incorrect Incorrect')
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
