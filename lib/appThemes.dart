import 'dart:io';

import 'package:SpellingWizard/save.dart';
import 'package:flutter/material.dart';

class AppTheme with ChangeNotifier {
  static String theme = 'Normal';
  bool switchState = false;
  Color pickerColor = Colors.deepPurpleAccent;
  List<Color> availableThemes = [
    Colors.deepPurpleAccent,
    Colors.teal,
  ];

  void changeThemeTo(themeChoice) async {
    theme = themeChoice;
    switch (themeChoice) {
      case 'Normal':
        currentTheme = defaultTheme;
        pickerColor = Colors.deepPurpleAccent;
        break;
      case 'Teal':
        currentTheme = tealTheme;
        pickerColor = Colors.teal;
        break;
      default:
        currentTheme = defaultTheme;
        pickerColor = Colors.deepPurpleAccent;
        break;
    }
    await updateThemeFile(themeChoice);
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
    settingsColor: Colors.teal,
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
    settingsColor: Colors.teal,
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

  static CustomTheme tealTheme = CustomTheme(
    theme: ThemeData(
      fontFamily: 'WorkSans',
      scaffoldBackgroundColor: Colors.teal[700],
      appBarTheme: AppBarTheme(
        color: Colors.teal[700],
      ),
    ),
    primaryColor: Colors.teal[700],
    secondaryColor: Colors.teal[100],
    darkClosedColor: Colors.white38,
    challengeBackColor: Colors.white,
    challengeAccentColor: Colors.teal[500],
    primaryTextColor: Colors.white,
    secondaryTextColor: Colors.white70,
    specialTextColor: Colors.black,
    primaryIconColor: Colors.white,
    secondaryIconColor: Colors.white70,
    bottomMenuSheetColor: Colors.teal[700],
    inputTextColor: Colors.indigo[900],
    settingsColor: Colors.purple,
    gradientDashboardCardsColors: [Colors.teal[700], Colors.tealAccent[700]],
    gradientDialogColors: [Colors.teal, Colors.teal[700]],
    gradientCategoryviewColors: [Colors.teal[100], Colors.tealAccent[700]],
    gradientCategoryviewCardColors: [Colors.teal[700], Colors.tealAccent[700]],
    gradientChallengeCardColors: [Colors.tealAccent[700], Colors.teal[700]],
    gradientKeyboardColors: [Colors.tealAccent[700], Colors.teal[700]],
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
  Color settingsColor;

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
    this.settingsColor,
    this.gradientDashboardCardsColors,
    this.gradientDialogColors,
    this.gradientCategoryviewColors,
    this.gradientCategoryviewCardColors,
    this.gradientChallengeCardColors,
    this.gradientKeyboardColors,
  });
}

updateThemeFile(String theme) async {
  File themeFile = await loadThemeFile();
  themeFile.writeAsStringSync(theme);
}
