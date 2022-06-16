import 'package:intl/intl.dart';
import 'package:reminder_app/tasks/taskData.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../tasks/btaskdata.dart';

class DatabaseManager {
  static int firsttime = 0;
  static late final _db;

  static const taskDbName = 'Tasks.db';

  static const version = 1;

  get db => _db;

  DatabaseManager._factory();

  static final DatabaseManager databaseManagerInstance =
      DatabaseManager._factory();

  Future<void> initiateTask() async {
    _db = await openDatabase(join(await getDatabasesPath(), taskDbName),
        onCreate: (db, version) async {
      return await db
          .execute(
        'CREATE TABLE  IF NOT EXISTS BTASK(ID INTEGER PRIMARY KEY,TITLE TEXT NOT NULL, DONE INTEGER NOT NULL, TDATE DATE)',
      )
          .then((value) async {
        return await db.execute(
            'CREATE TABLE IF NOT EXISTS TASK(ID INTEGER PRIMARY KEY,TITLE TEXT NOT NULL, DESCRIPTION TEXT NOT NULL, REACH INTEGER NOT NULL, SCORE INTEGER NOT NULL)');
      });
    }, onOpen: (db) async {}, version: 2);
  }

  Future<List<Map<String, dynamic>>> queryBriefTaskRows() async {
    Database db = await databaseManagerInstance.db;
    String date = DateFormat('yMMdd').format(DateTime.now());
    return await db
        .query('BTASK', where: 'TDATE = ?', whereArgs: ['DATE(\'$date\')']);
  }

  Future<void> addBriefTask(List<BData> data) async {
    Database db = await databaseManagerInstance.db;

    for (var element in data) {
      await db.insert('BTASK', {
        'TITLE': element.title,
        'DONE': 0,
        'TDATE': 'DATE(\'${element.date}\')'
      });
    }
  }

  Future<int> deleteBreifTask(int id) async {
    Database db = await databaseManagerInstance.db;

    return await db.delete('BTASK', where: 'ID = ?', whereArgs: [id]);
  }

  Future<int> updateBreifTask(int id, bool done) async {
    Database db = await databaseManagerInstance.db;

    return await db.update('BTASK', {'DONE': (done) ? 1 : 0},
        where: 'ID = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryDailyTaskRows() async {
    Database db = await databaseManagerInstance.db;
    return await db.query('TASK');
  }

  Future<int> addDailyTask(TaskData taskData) async {
    Database db = await databaseManagerInstance.db;

    return await db.insert('TASK', {
      'ID': taskData.index,
      'TITLE': taskData.title,
      'DESCRIPTION': taskData.description,
      'REACH': 0,
      'SCORE': 0,
    });
  }

  Future<int> deleteDailyTask(int id) async {
    Database db = await databaseManagerInstance.db;

    return await db.delete('TASK', where: 'ID = ?', whereArgs: [id]);
  }

  Future<int> updateDailyTask(
      int id, String title, String description, int reach, int score) async {
    Database db = await databaseManagerInstance.db;
    return await db.update(
        'TASK',
        {
          'TITLE': title,
          // taskData.title,
          'DESCRIPTION': description,
          // taskData.description,
          'REACH': reach,
          'SCORE': score,
          // (taskData.reached) ? 1 : 0,
        },
        where: 'ID = ?',
        whereArgs: [id]
        // [taskData.index!]

        );
  }
}
