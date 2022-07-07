import 'package:flutter/material.dart';
import '../tasks/taskData.dart';

import '../dbhelper/databaseManager.dart';

class TaskListFetch extends ChangeNotifier {
  late List<TaskData> _listtaskdata;
  static final List<int> _rowList = [];
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
  ];

  List<TaskData> get listtaskdata => _listtaskdata;

  Future<void> setTasks() async {
    TaskListFetch._rowList.addAll(trueList);
    _listtaskdata =
        (await DatabaseManager.databaseManagerInstance.queryDailyTaskRows())
            .map((e) {
      TaskListFetch._rowList.remove(e['ID']);
      return TaskData(
          e['ID'], e['TITLE'], e['DESCRIPTION'], e['REACH'], e['SCORE'],e['REM']);
    }).toList();
    notifyListeners();
  }

  Future<void> addTask(
    String title,
    String description,
  ) async {
    if (TaskListFetch._rowList.isNotEmpty) {
      var tsk = TaskData(TaskListFetch._rowList.last, title, description, 0, 0);
      (await DatabaseManager.databaseManagerInstance
          .addDailyTask(tsk)
          .then((_) {
        _listtaskdata.add(tsk);
        TaskListFetch._rowList.removeLast();
        notifyListeners();
      }));
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
