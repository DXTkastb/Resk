import 'package:reminder_app/tasks/taskData.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../tasks/btaskdata.dart';

class DatabaseManager {
  static int firsttime = 0;
  static late final _db;
  static late final _db2;
  static late final _db3;
  static const taskDbName = 'Tasks.db';
  static const taskDbName2 = 'BTasks.db';

  static const version = 1;

  get db => _db;

  get db2 => _db2;

  get db3 => _db3;

  DatabaseManager._factory();

  static final DatabaseManager databaseManagerInstance =
      DatabaseManager._factory();

  Future<void> initiateBriefTask() async {
    _db2 = await openDatabase(join(await getDatabasesPath(), taskDbName2),
        onCreate: (db, version) async {
      return await db.execute(
        'CREATE TABLE BTASK(ID INTEGER PRIMARY KEY,TITLE TEXT NOT NULL, DONE INTEGER NOT NULL)',
      );
    }, onOpen: (db) async {
      if (firsttime == 0) {
        await db.execute('DELETE FROM BTASK');
      }
      await db.execute('INSERT INTO BTASK VALUES(1,\'Go Running\',1)');
      await db.execute('INSERT INTO BTASK VALUES(2,\'Eat Meal\',0)');
      await db.execute('INSERT INTO BTASK VALUES(3,\'Competitve Coding\',0)');
      await db.execute('INSERT INTO BTASK VALUES(4,\'Sketch Dragon\',1)');
    }, version: 1);
  }

  Future<List<Map<String, dynamic>>> queryBriefTaskRows() async {
    Database db = await databaseManagerInstance.db2;
    return await db.query('BTASK');
  }

  Future<int> addBriefTask(BTaskData btaskData) async {
    Database db = await databaseManagerInstance.db2;

    return await db.insert('BTASK', {
      'ID': btaskData.id,
      'TITLE': btaskData.title,
      'DONE': (btaskData.done)?1:0,
    });
  }

  Future<int> deleteBreifTask(int id) async {
    Database db = await databaseManagerInstance.db2;

    return await db.delete('BTASK', where: 'ID = ?', whereArgs: [id]);
  }

  Future<int> updateBreifTask(int id,bool done) async {
    Database db = await databaseManagerInstance.db2;

    return await db.update('BTASK', {
      'DONE':(done)?1:0
    }, where: 'ID = ?', whereArgs: [id]);
  }

  Future<void> initiateDailyDatabase() async {
    _db = await openDatabase(join(await getDatabasesPath(), taskDbName),
        onCreate: (db, version) async {
      return await db.execute(
        'CREATE TABLE TASK(ID INTEGER PRIMARY KEY,TITLE TEXT NOT NULL, DESCRIPTION TEXT NOT NULL, REACH INTEGER NOT NULL, SCORE INTEGER NOT NULL)',
      );
    }, onOpen: (db) async {
      if (firsttime == 0) {
        await db.execute('DELETE FROM TASK');
      }
      await db.execute(
          'INSERT INTO TASK VALUES(1,\'Go Running\',\'fit body\',\'0\',\'0\')');
      await db.execute(
          'INSERT INTO TASK VALUES(2,\'Eat Meal\',\'healthy bowl\',\'1\',\'3\')');
      await db.execute(
          'INSERT INTO TASK VALUES(3,\'Competitve Codinggggggggggggggggggggggggggggggggg\',\'do greedy algos\',\'0\',\'0\')');
      await db.execute(
          'INSERT INTO TASK VALUES(4,\'Sketch Dragon\',\'pencil sketching\',\'1\',\'1\')');
    }, version: 1);
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
      int id, String title, String description, int reach) async {
    Database db = await databaseManagerInstance.db;
    return await db.update(
        'TASK',
        {
          'TITLE': title,
          // taskData.title,
          'DESCRIPTION': description,
          // taskData.description,
          'REACH': reach
          // (taskData.reached) ? 1 : 0,
        },
        where: 'ID = ?',
        whereArgs: [id]
        // [taskData.index!]

        );
  }
}
