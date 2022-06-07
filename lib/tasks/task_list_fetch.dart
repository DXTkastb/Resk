import 'package:flutter/material.dart';
import 'package:reminder_app/tasks/taskData.dart';

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
    31,
    32,
    33,
    34,
    35,
    36,
    37,
    38,
    39,
    40,
    41,
    42,
    43,
    44,
    45,
    46,
    47,
    48,
    49,
    50,
    51,
    52,
    53,
    54,
    55,
    56,
    57,
    58,
    59,
    60,
    61,
    62,
    63,
    64,
    65,
    66,
    67,
    68,
    69,
    70,
    71,
    72,
    73,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    84,
    85,
    86,
    87,
    88,
    89,
    90,
    91,
    92,
    93,
    94,
    95,
    96,
    97,
    98,
    99,
    100,
  ];

  List<TaskData> get listtaskdata => _listtaskdata;

  Future<void> setTasks() async {
    TaskListFetch._rowList.addAll(trueList);
    _listtaskdata =
        (await DatabaseManager.databaseManagerInstance.queryRows()).map((e) {
      TaskListFetch._rowList.remove(e['ID']);
      return TaskData(
          e['ID'], e['TITLE'], e['DESCRIPTION'], e['REACH'], e['SCORE']);
    }).toList();

    notifyListeners();
  }

  Future<void> addTask(
      String title, String description, int reach, int score) async {
    if (TaskListFetch._rowList.isNotEmpty) {
      var tsk = TaskData(
          TaskListFetch._rowList.last, title, description, reach, score);
      (await DatabaseManager.databaseManagerInstance.addTask(tsk).then((_) {
        _listtaskdata.add(tsk);
        TaskListFetch._rowList.removeLast();
        notifyListeners();
      }));
    }
  }

  Future<void> removeTask(TaskData data) async {
    (await DatabaseManager.databaseManagerInstance
        .deleteTask(data.index)
        .then((_) {
      _listtaskdata.remove(data);
      TaskListFetch._rowList.add(data.index);
      notifyListeners();
    }));
  }
}
