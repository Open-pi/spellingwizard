import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  File file;
  List<SavedChallenge> save = [];

  SaveFile({this.file});

  Future<void> readFromFile() async {
    var lines =
        utf8.decoder.bind(this.file.openRead()).transform(LineSplitter());
    try {
      await for (var line in lines) {
        print(lines);
        List<List<dynamic>> data = CsvToListConverter().convert(line);
        SavedChallenge challenge = convertListToSavedChallenge(data);
        this.save.add(challenge);
      }
    } catch (e) {}
  }

  printSave() {
    print(this.save.length);
    for (var i = 0; i <= this.save.length - 1; i++) {
      print('${this.save[i].id}, ${this.save[i].stars}');
    }
  }

  playable(int id) {
    if (id == 0) {
      return true;
    }
    if (id - 1 > this.save.length - 1) {
      return false;
    } else {
      if (this.save[id - 1].stars >= 1) {
        return true;
      }
    }
    return false;
  }

  isColored(int id) {
    /* return True if the star of indexStar should be colored */
    if (id > this.save.length - 1) {
      return 0;
    }
    return this.save[id].stars;
  }

  saveChallenge(int index, int rightAnswers, int numberOfWords) {
    /* save the result of the challenge */
    int stars = 0;
    if (rightAnswers >= numberOfWords / 2) {
      stars = 1;
    }
    if (rightAnswers > numberOfWords - 1) {
      stars = 2;
    }
    if (rightAnswers == numberOfWords) {
      stars = 3;
    }
    if (index > this.save.length - 1) {
      print('adding to the list');
      this.save.add(SavedChallenge(id: 'challenge$index', stars: stars));
    } else {
      print('updating the list');
      this.save[index].stars = stars;
    }
    // re-write the file
    printSave();
    updateFile();
  }

  updateFile() {
    List<List<dynamic>> rows = List<List<dynamic>>();
    for (int i = 0; i <= this.save.length - 1; i++) {
      //row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = List();
      row.add(this.save[i].id);
      row.add(this.save[i].stars);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    print(csv);
    this.file.writeAsString('$csv');
  }
}

class SavedChallenge {
  String id;
  int stars;
  SavedChallenge({this.id, this.stars});
}

SavedChallenge convertListToSavedChallenge(List<List<dynamic>> data) {
  return SavedChallenge(id: data[0][0], stars: data[0][1]);
}

Future<String> savePath() async {
  return await _localPath;
}

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  print(directory.listSync());
  print(directory.path);
  return directory.path;
}

Future<SaveFile> saveFileOfCategory(String title) async {
  // load save files for the category
  final path = await savePath();
  final file = File('$path/$title.csv');
  final SaveFile saveFile = SaveFile(file: file);
  await saveFile.readFromFile();
  return saveFile;
}

Future<File> loadMistakesFile() async {
  final path = await savePath();
  final file = File('$path/mistakes.csv');
  return file;
}
