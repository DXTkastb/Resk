import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../tasks/btaskdata.dart';
import '../tasks/taskData.dart';

class DatabaseManager {
  static int firsttime = 0;
  static late final _db;
  DateTime testDate = DateTime.now();
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
        'CREATE TABLE  IF NOT EXISTS BTASK(ID INTEGER PRIMARY KEY,DAYS INTEGER DEFAULT 0 NOT NULL,TITLE TEXT NOT NULL, DONE INTEGER DEFAULT 0 NOT NULL, TDATE DATE,CRID INTEGER NOT NULL)',
      )
          .then((value) async {
        return await db.execute(
            'CREATE TABLE IF NOT EXISTS TASK(ID INTEGER PRIMARY KEY,TITLE TEXT NOT NULL, DESCRIPTION TEXT NOT NULL, REACH INTEGER DEFAULT 0 NOT NULL, SCORE INTEGER DEFAULT 0 NOT NULL)');
      }).then((value) async {
        return db
            .execute('CREATE TABLE CDATE(CD DATE NOT NULL)')
            .then((value) async {
          await db.insert('CDATE', {
            'CD': 'DATE(\'${DateFormat('yMMdd').format(DateTime.now())}\')'
          });
        });
      });
    }, onOpen: (db) async {
      List cdate = await db.query('CDATE');

      String nowtime = DateFormat('yMMdd').format(testDate);
      if ((cdate[0]['CD'] as String).substring(6, 14) != nowtime) {
        await db.delete('CDATE');
        await db.insert('CDATE',
            {'CD': 'DATE(\'${DateFormat('yMMdd').format(testDate)}\')'});
        await db.update('TASK', {'REACH': 0});
        await db.delete('BTASK',
            where: 'TDATE < ?', whereArgs: ['DATE(\'$nowtime\')']);
      }
    }, version: 3);
  }

  Future<List<Map<String, dynamic>>> queryBriefTaskRows() async {
    Database db = await databaseManagerInstance.db;
    String date = DateFormat('yMMdd').format(testDate);
    return await db.query('BTASK',
        where: 'TDATE = ?', whereArgs: ['DATE(\'$date\')'], orderBy: 'DONE');
  }

  Future<void> addBriefTask(
    List<BData> data,
  ) async {
    Database db = await databaseManagerInstance.db;

    for (var element in data) {
      await db.insert('BTASK', {
        'DAYS': element.x,
        'TITLE': element.title,
        'TDATE': 'DATE(\'${element.date}\')',
        'CRID': element.crid
      });
    }
  }

  Future<int> deleteBreifTask(int id) async {
    Database db = await databaseManagerInstance.db;

    return await db.delete('BTASK', where: 'ID = ?', whereArgs: [id]);
  }

  Future<int> deleteAllBreifTask(int crid) async {
    Database db = await databaseManagerInstance.db;

    return await db.delete('BTASK', where: 'CRID = ?', whereArgs: [crid]);
  }

  Future<int> updateBreifTask(int id, bool done) async {
    Database db = await databaseManagerInstance.db;

    return await db.update('BTASK', {'DONE': (done) ? 1 : 0},
        where: 'ID = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryDailyTaskRows() async {
    Database db = await databaseManagerInstance.db;
    return await db.query('TASK', orderBy: 'REACH');
  }

  Future<int> addDailyTask(TaskData taskData) async {
    Database db = await databaseManagerInstance.db;

    return await db.insert('TASK', {
      'ID': taskData.index,
      'TITLE': taskData.title,
      'DESCRIPTION': taskData.description,
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
