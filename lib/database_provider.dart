import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'task_model.dart';


class TaskDBProvider {
  TaskDBProvider._();

  static final TaskDBProvider db = TaskDBProvider._();

  Database _database;

  Future<Database> get database async {
    return _database ?? await initDB();
  }

//Database Initialization
  static Future<Database> initDB() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'task_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE task("
          "id INTEGER PRIMARY KEY AUTOINCREMENT,"
          " task TEXT,"
          " deadline TEXT,"
          " status INT)",
        );
      },
      version: 1,
    );
  }

  //Add a new Task
  Future<void> addTask(String newTaskTitle, String deadline, bool status) async {
    Task t1 = Task(taskTitle: newTaskTitle, deadline: deadline, isDone: status);
    final db = await database;
    await db.insert(
      'task',
      t1.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  //Update already existing Task
  void updateTask(Task task) async {
    final db = await database;

    await db.update(
      'task',
      task.toMap(),
      where: "id = ?",
      whereArgs: [task.id],
    );
  }

  //Change status of the task to Done/Completed
  done(Task task) async {
    final db = await database;
    db.update("task", task.toMap(), where: "id = ?", whereArgs: [task.id]);
  }

  //Delete a Task
  delete(int id) async {
    final db = await database;
    db.delete("task", where: "id = ?", whereArgs: [id]);
  }

  //Fetch Tasks from DB which are not completed
  Future<List<Task>> retrieveTodos() async {
    final db = await database;
    var response = await db.query("task", where: "status = ?", whereArgs: [0]);
    List<Task> list = response.map((c) => Task.fromMap(c)).toList();
    return list;
  }

  //Fetch completed Tasks from DB
  Future<List<Task>> retrieveDone() async {
    final db = await database;
    var response = await db.query("task", where: "status = ?", whereArgs: [1]);
    List<Task> list = response.map((c) => Task.fromMap(c)).toList();
    return list;
  }

  //Fetch tasks which are not yet completed and deadline has crossed
  Future<List<Task>> retrievePending() async {
    final db = await database;
    var response = await db.query("task", where: "status = ?", whereArgs: [0]);
    List<Task> list = response.map((c) => Task.fromMap(c)).toList();
    //removal of tasks whose deadline is not yet crossed
    list.removeWhere((element) {
      if (DateTime.tryParse(element.deadline).isAfter(DateTime.now()))
        return true;
      return false;
    });
    return list;
  }

  Future<List<int>> getCount() async {
    final db = await database;
    //getting count of all tasks
    final result = await db.rawQuery('SELECT COUNT(*) FROM task');
    final count = Sqflite.firstIntValue(result);
    //getting count of completed tasks
    final res = await db.rawQuery('SELECT COUNT(*) FROM task WHERE status=1');
    final cnt = Sqflite.firstIntValue(res);

    return [count, cnt];
  }


}
