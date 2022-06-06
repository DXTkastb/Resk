import 'package:flutter/material.dart';
import 'package:reminder_app/tasks/taskData.dart';

import '../dbhelper/databaseManager.dart';

class TaskListFetch extends ChangeNotifier {

  late List<TaskData> _listtaskdata;

  List<TaskData> get listtaskdata => _listtaskdata;

  Future<void> setTasks() async{
    _listtaskdata = (await DatabaseManager.databaseManagerInstance.queryRows()).map((e) {
      return TaskData(e['ID'], e['TITLE'], e['DESCRIPTION'], e['REACH'], e['SCORE']);
    }).toList();

  notifyListeners();
  }




}