class Word {
  String word;
  String meaning;
  String usage;
  String phonetic;

  Word({this.word, this.meaning, this.usage, this.phonetic});
}

Word convertListToWord(List<dynamic> wordList) {
  return Word(
    word: wordList[0],
    meaning: wordList[1],
    usage: wordList[2],
    phonetic: wordList[3],
  );
}

List<Word> convertListToWords(List<List<dynamic>> listwordList) {
  List<Word> wordList = [];
  for (int i = 0; i < listwordList.length; i++) {
    wordList.add(convertListToWord(listwordList[i]));
  }
  return wordList;
}
