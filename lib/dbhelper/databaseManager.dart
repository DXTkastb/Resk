import 'package:reminder_app/tasks/taskData.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  static int firsttime = 0;
  static late final _db;
  static const dbName = 'Tasks.db';
  static const version = 1;
  static int index = 0;

  get db => _db;

  DatabaseManager._factory();

  static final DatabaseManager databaseManagerInstance =
      DatabaseManager._factory();

  Future<void> initiateDatabse() async {
    _db = await openDatabase(join(await getDatabasesPath(), dbName),
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
          'INSERT INTO TASK VALUES(3,\'Competitve Coding\',\'do greedy algos\',\'0\',\'0\')');
      await db.execute(
          'INSERT INTO TASK VALUES(4,\'Sketch Dragon\',\'pencil sketching\',\'1\',\'1\')');

      index = (await db.query(
            'TASK',
          ))
              .length +
          1;
    }, version: 1);
  }

  Future<List<Map<String, dynamic>>> queryRows() async {
    Database db = await databaseManagerInstance.db;
    return await db.query('TASK');
  }

  Future<int> addTask(TaskData taskData) async {
    Database db = await databaseManagerInstance.db;

    return await db.insert('TASK', {
      'ID': index,
      'TITLE': taskData.title,
      'DESCRIPTION': taskData.description,
      'REACH': (taskData.reached) ? 1 : 0,
      'SCORE': taskData.score,
    });
  }

  Future<int> deleteTask(int id) async {
    Database db = await databaseManagerInstance.db;

    return await db.delete('TASK', where: 'ID = ?', whereArgs: [id]);
  }

  Future<int> updateTask(TaskData taskData) async {
    Database db = await databaseManagerInstance.db;
    return await db.update(
        'TASK',
        {
          'TITLE': taskData.title,
          'DESCRIPTION': taskData.description,
          'REACH': (taskData.reached) ? 1 : 0,
        },
        where: 'ID = ?',
        whereArgs: [taskData.index!]);
  }
}
