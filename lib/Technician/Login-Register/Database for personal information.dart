import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_data.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE user_info (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            personalImage TEXT,
            frontID TEXT,
            backID TEXT,
            criminalRecord TEXT,
            armyCertificate TEXT,
            skillsCertificate TEXT,
            nationalID TEXT
          )
        ''');
      },
    );
  }

  Future<void> insertUserData(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert('user_info', userData);
  }

  Future<List<Map<String, dynamic>>> getUserData() async {
    final db = await database;
    return await db.query('user_info');
  }
}
