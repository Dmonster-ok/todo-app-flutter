import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/task.dart';

class DatabaseServices {
  static Database? _db;
  static final DatabaseServices instance = DatabaseServices._constructor();

  final String _tasksTableName = 'todos';
  final String _tasksIdCol = 'id';
  final String _tasksContentCol = 'content';
  final String _tasksStatusCol = 'status';

  DatabaseServices._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;

    _db = await getDatabse();
    return _db!;
  }

  Future<Database> getDatabse() async {
    final path = await getDatabasesPath();
    final finalPath = join(path, 'todo.db');

    final database = await openDatabase(
      finalPath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
      CREATE TABLE $_tasksTableName(
      $_tasksIdCol INTEGER PRIMARY KEY AUTOINCREMENT,
      $_tasksContentCol TEXT NOT NULL,
      $_tasksStatusCol INTEGER NOT NULL DEFAULT 0 CHECK($_tasksStatusCol = 0 OR $_tasksStatusCol = 1)
      )
    ''');
      },
    );

    return database;
  }

  Future<List<Task>> getTasks() async {
    final db = await database;
    final tasks = await db.query(_tasksTableName);
    return tasks.map((task) => Task(
      id: task[_tasksIdCol] as int,
      content: task[_tasksContentCol] as String,
      status: task[_tasksStatusCol] as int,
    )).toList();
  }

  Future<void> insertTask(String content) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksContentCol: content,
      _tasksStatusCol: 0,
    });
  }

  void deleteTask(int id) async {
    final db = await database;
    await db.delete(_tasksTableName, where: '$_tasksIdCol = ?', whereArgs: [id]);
  }

  void updateTask(int id, int i) async {
    final db = await database;
    await db.update(_tasksTableName, {
      _tasksStatusCol: i}, where: '$_tasksIdCol = ?', whereArgs: [id]);
  }
}
