import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'tasks.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            isDone INTEGER
          )
        ''');
      },
    );
  }

  static Future<List<Map<String, dynamic>>> getTasks() async {
    final db = await database;
    return db.query('tasks');
  }

  static Future<int> insertTask(Map<String, dynamic> task) async {
    final db = await database;
    return await db.insert('tasks', task);
  }

  static Future<int> updateTask(int id, Map<String, dynamic> task) async {
    final db = await database;
    return await db.update('tasks', task, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
