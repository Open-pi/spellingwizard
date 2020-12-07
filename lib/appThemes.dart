import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  static String theme = 'Normal';
  bool switchState = false;

  void changeThemeTo(themeChoice) {
    theme = themeChoice;
    switch (themeChoice) {
      case 'Normal':
        currentTheme = defaultTheme;
        break;
      case 'Dark':
        currentTheme = darkTheme;
        break;
      default:
        currentTheme = defaultTheme;
        break;
    }
    switchState = !switchState;
    notifyListeners();
  }

  CustomTheme currentTheme = CustomTheme(
    theme: ThemeData(
      fontFamily: 'WorkSans',
      scaffoldBackgroundColor: Colors.deepPurpleAccent[700],
      appBarTheme: AppBarTheme(
        color: Colors.deepPurpleAccent[700],
      ),
    ),
    primaryColor: Colors.deepPurpleAccent[700],
    secondaryColor: Colors.deepPurpleAccent[100],
    darkClosedColor: Colors.white38,
    challengeBackColor: Colors.white,
    challengeAccentColor: Colors.purple[500],
    primaryTextColor: Colors.white,
    secondaryTextColor: Colors.white70,
    specialTextColor: Colors.black,
    primaryIconColor: Colors.white,
    secondaryIconColor: Colors.white70,
    bottomMenuSheetColor: Colors.deepPurpleAccent[700],
    inputTextColor: Colors.indigo[900],
    gradientDashboardCardsColors: [
      Colors.deepPurpleAccent[700],
      Colors.purpleAccent[700]
    ],
    gradientDialogColors: [Colors.purple, Colors.deepPurpleAccent[700]],
    gradientCategoryviewColors: [
      Colors.deepPurpleAccent[100],
      Colors.deepPurpleAccent[700]
    ],
    gradientCategoryviewCardColors: [
      Colors.deepPurpleAccent[700],
      Colors.purpleAccent[700]
    ],
    gradientChallengeCardColors: [
      Colors.purpleAccent[700],
      Colors.deepPurpleAccent[700]
    ],
    gradientKeyboardColors: [
      Colors.purpleAccent[700],
      Colors.deepPurpleAccent[700]
    ],
  );

  static CustomTheme defaultTheme = CustomTheme(
    theme: ThemeData(
      fontFamily: 'WorkSans',
      scaffoldBackgroundColor: Colors.deepPurpleAccent[700],
      appBarTheme: AppBarTheme(
        color: Colors.deepPurpleAccent[700],
      ),
    ),
    primaryColor: Colors.deepPurpleAccent[700],
    secondaryColor: Colors.deepPurpleAccent[100],
    darkClosedColor: Colors.white38,
    challengeBackColor: Colors.white,
    challengeAccentColor: Colors.purple[500],
    primaryTextColor: Colors.white,
    secondaryTextColor: Colors.white70,
    specialTextColor: Colors.black,
    primaryIconColor: Colors.white,
    secondaryIconColor: Colors.white70,
    bottomMenuSheetColor: Colors.deepPurpleAccent[700],
    inputTextColor: Colors.indigo[900],
    gradientDashboardCardsColors: [
      Colors.deepPurpleAccent[700],
      Colors.purpleAccent[700]
    ],
    gradientDialogColors: [Colors.purple, Colors.deepPurpleAccent[700]],
    gradientCategoryviewColors: [
      Colors.deepPurpleAccent[100],
      Colors.deepPurpleAccent[700]
    ],
    gradientCategoryviewCardColors: [
      Colors.deepPurpleAccent[700],
      Colors.purpleAccent[700]
    ],
    gradientChallengeCardColors: [
      Colors.purpleAccent[700],
      Colors.deepPurpleAccent[700]
    ],
    gradientKeyboardColors: [
      Colors.purpleAccent[700],
      Colors.deepPurpleAccent[700]
    ],
  );

  static CustomTheme darkTheme = CustomTheme(
    theme: ThemeData(
      fontFamily: 'WorkSans',
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.black,
      ),
    ),
    primaryColor: Colors.black,
    secondaryColor: Colors.deepPurpleAccent[100],
    darkClosedColor: Colors.white38,
    challengeBackColor: Colors.black,
    challengeAccentColor: Colors.purple[500],
    primaryTextColor: Colors.white,
    secondaryTextColor: Colors.white70,
    specialTextColor: Colors.black,
    primaryIconColor: Colors.white,
    secondaryIconColor: Colors.white70,
    bottomMenuSheetColor: Color(0xFF121212),
    inputTextColor: Colors.indigo[900],
    gradientDashboardCardsColors: [Color(0xFF121212), Color(0xFF3700B3)],
    gradientDialogColors: [Colors.purple, Colors.deepPurpleAccent[700]],
    gradientCategoryviewColors: [
      Colors.deepPurpleAccent[100],
      Colors.deepPurpleAccent[700]
    ],
    gradientCategoryviewCardColors: [
      Colors.deepPurpleAccent[700],
      Colors.purpleAccent[700]
    ],
    gradientChallengeCardColors: [
      Colors.purpleAccent[700],
      Colors.deepPurpleAccent[700]
    ],
    gradientKeyboardColors: [
      Colors.purpleAccent[700],
      Colors.deepPurpleAccent[700]
    ],
  );
}

class CustomTheme {
  ThemeData theme;
  Color primaryColor;
  Color secondaryColor;
  Color specialColor;
  Color darkClosedColor;
  Color challengeBackColor;
  Color challengeAccentColor;
  Color primaryTextColor;
  Color secondaryTextColor;
  Color specialTextColor;
  Color inputTextColor;
  Color primaryIconColor;
  Color secondaryIconColor;
  Color specialIconColor;
  Color bottomMenuSheetColor;

  List<Color> gradientDashboardCardsColors;
  List<Color> gradientDialogColors;
  List<Color> gradientCategoryviewColors;
  List<Color> gradientCategoryviewCardColors;
  List<Color> gradientChallengeCardColors;
  List<Color> gradientKeyboardColors;

  CustomTheme({
    this.theme,
    this.primaryColor,
    this.secondaryColor,
    this.specialColor,
    this.darkClosedColor,
    this.challengeBackColor,
    this.challengeAccentColor,
    this.primaryTextColor,
    this.secondaryTextColor,
    this.specialTextColor,
    this.inputTextColor,
    this.primaryIconColor,
    this.secondaryIconColor,
    this.specialIconColor,
    this.bottomMenuSheetColor,
    this.gradientDashboardCardsColors,
    this.gradientDialogColors,
    this.gradientCategoryviewColors,
    this.gradientCategoryviewCardColors,
    this.gradientChallengeCardColors,
    this.gradientKeyboardColors,
  });
}
