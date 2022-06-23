import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import './btaskdata.dart';
import '../dbhelper/databaseManager.dart';

class BtaskListFetch extends ChangeNotifier {
  late List<BTaskData> _listtaskdata;

  List<BTaskData> get listtaskdata => _listtaskdata;

  Future<void> setTasks() async {
    _listtaskdata = [];
    _listtaskdata =
        (await DatabaseManager.databaseManagerInstance.queryBriefTaskRows())
            .map((e) {
      return BTaskData(
          e['DAYS'], e['ID'], e['TITLE'], (e['DONE'] == 0) ? false : true,e['CRID']);
    }).toList();

    notifyListeners();
  }

  Future<void> addTask(String title, DateTime sdate, DateTime edate) async {
    int days = DateTime.parse(DateFormat('yMMdd').format(edate))
        .difference(DateTime.parse(DateFormat('yMMdd').format(sdate)))
        .inDays;
    var db = DatabaseManager.databaseManagerInstance;
    List<BData> btasklist = [];
    int crid = int.parse(DateFormat('yMMddHms').format(DateTime.now()));
    for (int i = 0; i <= days; i++) {
      btasklist.add(BData(
        days - i,
        title,
        false,
        DateFormat('yMMdd').format(sdate.add(Duration(days: i))),
        crid,
      ));
    }

    await db.addBriefTask(btasklist);
    await setTasks();
  }

  Future<void> removeTask(BTaskData data) async {
    (await DatabaseManager.databaseManagerInstance
        .deleteBreifTask(data.id)
        .then((_) {
      _listtaskdata.remove(data);
      notifyListeners();
    }));
  }

  Future<void> removeTasks(int crid) async {
    await DatabaseManager.databaseManagerInstance
        .deleteAllBreifTask(crid)
        ;
    await setTasks();
  }
}
