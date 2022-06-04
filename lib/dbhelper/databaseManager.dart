import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager{
  static int firsttime=0;
  static late final _db;
  static const dbName='Tasks.db';
  static const version=1;

  get db => _db;

  DatabaseManager._factory();
  static final DatabaseManager databaseManagerInstance=DatabaseManager._factory();

  Future<void> initiateDatabse() async{

    _db=await openDatabase(

        join(await getDatabasesPath(), dbName),
        onCreate: (db, version) async {
          return await db.execute(
            'CREATE TABLE TASK(TITLE TEXT NOT NULL, DESCRIPTION TEXT NOT NULL, REACH INTEGER NOT NULL, SCORE INTEGER NOT NULL)',
          );
        },
        onOpen: (db) async {
          if(firsttime==0){
              await db.execute('DELETE FROM TASK') ;
          }
          await db.execute('INSERT INTO TASK VALUES(\'Go Running\',\'fit body\',\'0\',\'0\')') ;
          await db.execute('INSERT INTO TASK VALUES(\'Eat Meal\',\'healthy bowl\',\'1\',\'3\')') ;
          await db.execute('INSERT INTO TASK VALUES(\'Competitve Coding\',\'do greedy algos\',\'0\',\'0\')') ;
          await db.execute('INSERT INTO TASK VALUES(\'Sketch Dragon\',\'pencil sketching\',\'1\',\'1\')') ;
        },

        version: 1
    );



  }


  Future<List<Map<String, dynamic>>> queryRows() async {
    Database db = await databaseManagerInstance.db;
    return await db.query('TASK');
  }


}