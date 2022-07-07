import 'package:flutter/material.dart';
import '../dbhelper/databaseManager.dart';

class StatProvider extends ChangeNotifier {
  int score = 0;
  int totalScore = 0;

  Future<void> setScore() async {
    var db = await DatabaseManager.databaseManagerInstance.scoreToday();
    score = db[0]['SCORE'];
    totalScore = db[0]['TSCORE'];
    notifyListeners();
  }

  Future<void> updateScore(int s, int ts) async {
    await DatabaseManager.databaseManagerInstance.upDateTodayScore(s, ts);
    score = s;
    totalScore = ts;
    notifyListeners();
  }

  double getPercent() {
    if (score == totalScore && score == 0) {
      return 0;
    }
    return score / totalScore;
  }
}
