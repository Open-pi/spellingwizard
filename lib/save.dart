import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:csv/csv.dart';

class SaveFile {
  File file;
  List<SavedChallenge> save = [];

  SaveFile(file) {
    this.file = file;
    Stream<List<int>> inputStream = this.file.openRead();

    inputStream
        .transform(utf8.decoder) // Decode bytes to UTF-8.
        .transform(new LineSplitter()) // Convert stream to individual lines.
        .listen((String line) {
      // Process results.
      List<List<dynamic>> data = CsvToListConverter().convert(line);
      SavedChallenge challenge = convertListToSavedChallenge(data);
      this.save.add(challenge);

      // Debug
      print('$line: ${line.length} bytes');
    }, onDone: () {
      print('File is now closed.');
    }, onError: (e) {
      print(e.toString());
    });
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

  isColored(int id, int indexStar) {
    /* return True if the star of indexStar should be colored */
    if (id > this.save.length - 1) {
      return false;
    }
    if (this.save[id].stars == 3) {
      return true;
    } else if (this.save[id].stars == 2) {
      if (indexStar == 0) {
        return true;
      } else if (indexStar == 1) {
        return true;
      } else {
        return false;
      }
    } else if (this.save[id].stars == 1) {
      if (indexStar == 0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}

class SavedChallenge {
  int id;
  int stars;
  SavedChallenge({this.id, this.stars});
}

SavedChallenge convertListToSavedChallenge(List<List<dynamic>> data) {
  return SavedChallenge(id: data[0][0], stars: data[0][1]);
}
