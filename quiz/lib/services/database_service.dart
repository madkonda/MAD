import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDB('leaderboard.db');
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE leaderboard(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        score INTEGER
      )
    ''');
  }

  static Future<void> saveScore(String name, int score) async {
    final db = await _instance.database;
    await db.insert(
      'leaderboard',
      {'name': name, 'score': score},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getScores() async {
    final db = await _instance.database;
    return await db.query(
      'leaderboard',
      orderBy: 'score DESC',
      limit: 10,
    );
  }
}
