import 'package:flutter/material.dart';

import '../dbhelper/databaseManager.dart';
import '../notificationapi/notificationapi.dart';
import '../tasks/taskData.dart';

class TaskListFetch extends ChangeNotifier {
  late final List<TaskData> _listtaskdata;
  static List<int> _rowList = [];
  static const List<int> trueList = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19,
    20,
    21,
    22,
    23,
    24,
    25,
    26,
    27,
    28,
    29,
    30,
    31
  ];

  List<TaskData> get listtaskdata => _listtaskdata;

  Future<void> setTasks() async {
    _rowList = [];
    _rowList.addAll(trueList);
    _listtaskdata =
        (await DatabaseManager.databaseManagerInstance.queryDailyTaskRows())
            .map((e) {
      _rowList.remove(e['ID']);
      return TaskData(e['ID'], e['TITLE'], e['DESCRIPTION'], e['REACH'],
          e['SCORE'], e['REM']);
    }).toList();
    notifyListeners();
  }

  Future<void> addTask(String title, String description,
      [int rr = 9999, int sc = 0]) async {
    if (_rowList.isNotEmpty) {
      var tsk =
          TaskData(TaskListFetch._rowList.last, title, description, 0, sc, rr);
      if (rr != 9999) {
        var nowTime = DateTime.now();
        await NotificationApi.launchPeriodicNotification(
            _rowList.last,
            title,
            description,
            DateTime(
                nowTime.year, nowTime.month, nowTime.day, rr ~/ 100, rr % 100));
      }
      await DatabaseManager.databaseManagerInstance.addDailyTask(tsk);
      _listtaskdata.add(tsk);
      TaskListFetch._rowList.removeLast();
      notifyListeners();
    }
  }

  Future<void> removeTask(TaskData data) async {
    (await DatabaseManager.databaseManagerInstance
        .deleteDailyTask(data.index)
        .then((_) {
      _listtaskdata.remove(data);
      TaskListFetch._rowList.add(data.index);
      notifyListeners();
    }));
  }
}
