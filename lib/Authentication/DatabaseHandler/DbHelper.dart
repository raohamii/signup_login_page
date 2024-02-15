import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static Database? _database;
  static final DbHelper instance = DbHelper._();

  DbHelper._();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'your_database.db');

    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          email TEXT,
          password TEXT
        )
      ''');
    });
  }

  Future<int> insertData(String table, Map<String, dynamic> data) async {
    final db = await instance.database;
    return await db.insert(table, data);
  }

  Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await instance.database;
    return await db.query(table);
  }

  Future<int> updateData(String table, Map<String, dynamic> data, int id) async {
    final db = await instance.database;
    return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteData(String table, int id) async {
    final db = await instance.database;
    return await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }
  Future<Map<String, dynamic>?> getUser(String username, String password) async {
    final db = await instance.database;
    final List<Map<String, dynamic>> result = await db.query(
      'your_table',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) {
      return result.first;
    } else {
      return null;
    }
  }
}
