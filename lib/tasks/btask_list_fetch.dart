import 'package:flutter/material.dart';

import '../dbhelper/databaseManager.dart';
import 'btaskdata.dart';

class BtaskListFetch extends ChangeNotifier{
  late List<BTaskData> _listtaskdata;
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
  ];


  List<BTaskData> get listtaskdata => _listtaskdata;

  Future<void> setTasks() async {
    BtaskListFetch._rowList.addAll(trueList);
    _listtaskdata =
        (await DatabaseManager.databaseManagerInstance.queryBriefTaskRows()).map((e) {
          BtaskListFetch._rowList.remove(e['ID']);
          return BTaskData(
              e['ID'], e['TITLE'],  (e['DONE']==0)?false:true);
        }).toList();
    notifyListeners();
  }

  Future<void> addTask(
      String title, ) async {
    if (BtaskListFetch._rowList.isNotEmpty) {
      var tsk = BTaskData(
          BtaskListFetch._rowList.last, title, false);
      (await DatabaseManager.databaseManagerInstance.addBriefTask(tsk).then((_) {
        _listtaskdata.add(tsk);
        BtaskListFetch._rowList.removeLast();
        notifyListeners();
      }));
    }
  }

  Future<void> removeTask(BTaskData data) async {
    (await DatabaseManager.databaseManagerInstance
        .deleteBreifTask(data.id)
        .then((_) {
      _listtaskdata.remove(data);
      BtaskListFetch._rowList.add(data.id);
      notifyListeners();
    }));
  }

}