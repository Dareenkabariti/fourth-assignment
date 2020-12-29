import 'package:fourth_assignment/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper dbHelper = DBHelper._();
  static final String databaseName = 'tasksDb.db';
  static final String tableName = 'tasks';
  static final String taskIdColumnName = 'id';
  static final String taskNameColumnName = 'name';
  static final String taskIsCompleteColumnName = 'isComplete';

  Database database;
  Future<Database> initDatabase() async {
    if (database == null) {
      return await createDatabase();
    } else {
      return database;
    }
  }

  Future<Database> createDatabase() async {
    try {
      var databasesPath = await getDatabasesPath();
      String path = join(databasesPath, databaseName);

      Database database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          db.execute('''CREATE TABLE $tableName(
            $taskIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
            $taskNameColumnName TEXT NOT NULL,
            $taskIsCompleteColumnName INTEGER
          )''');
        },
      );
      return database;
    } on Exception catch (e) {
      print(e);
    }
  }

  insertNewTask(Task task) async {
    try {
      database = await initDatabase();
      int x = await database.insert(tableName, task.toJson());
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<List<Task>> selectAllTasks() async {
    try {
      database = await initDatabase();
      List<Map> result = (await database.query(tableName));
      List<Task> tasks = result.map((e) => Task.fromJson(e)).toList();

      print(result);
      return tasks;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  Future<List<Task>> selectSpecificTask(int isCom) async {
    try {
      database = await initDatabase();
      List<Map> result = await database.query(tableName,
          where: '$taskIsCompleteColumnName = ?', whereArgs: [isCom]);
      List<Task> SpecialTask = result.map((e) => Task.fromJson(e)).toList();
      return SpecialTask;
    } on Exception catch (e) {
      print(e);
      return null;
    }
  }

  updateTask(
    Task task,
  ) async {
    try {
      database = await initDatabase();
      int result = await database.update(tableName, task.toJson(),
          where: '$taskNameColumnName=?', whereArgs: [task.taskName]);
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }

  deleteTask(Task task) async {
    try {
      database = await initDatabase();
      int result = await database.delete(tableName,
          where: '$taskNameColumnName=?', whereArgs: [task.taskName]);
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }

  deleteAllTask() async {
    try {
      database = await initDatabase();
      int result = await database.delete(
        tableName,
      );
      print(result);
    } on Exception catch (e) {
      print(e);
    }
  }
}
