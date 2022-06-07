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

  Future<void> addTask(String title,String description, int reach, int score) async{
    print('length is ${
        _listtaskdata.length
    }');
    var tsk=TaskData(_listtaskdata.length+1, title, description, reach, score);
    (await DatabaseManager.databaseManagerInstance.addTask(tsk).then((_) {
      _listtaskdata.add(tsk);
    })
    .then((_){
      notifyListeners();
    })
    );

  }


  Future<void> removeTask(TaskData data) async{


    (await DatabaseManager.databaseManagerInstance.deleteTask(data.index).then((_) {


      _listtaskdata.remove(data);
      notifyListeners();


    }));



  }





}