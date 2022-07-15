import 'package:flutter/material.dart';

import '../dbhelper/databaseManager.dart';

class TaskData extends ChangeNotifier {
  int index;
  String title;
  String description;
  int reached;
  int score;
  int rem;

  TaskData(this.index, this.title, this.description, this.reached, this.score,
      [this.rem = 9999]);

  Future<void> didAddReminder(int r) async {
    await DatabaseManager.databaseManagerInstance.updateDailyTaskRem(index, r);
    rem = r;
    notifyListeners();
  }

  Future<void> didupdate(String titl, String descriptio, int reach) async {
    if (reach == 1 && reached == 0) {
      score++;
    } else if (reach == 0 && reached == 1) {
      score--;
    }

    await DatabaseManager.databaseManagerInstance
        .updateDailyTask(index, titl, descriptio, reach, score);

    title = titl;
    description = descriptio;
    reached = reach;
    score = score;
    notifyListeners();
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,'score': score,'rem': rem,
      };
}
