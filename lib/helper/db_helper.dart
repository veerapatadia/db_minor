import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'favorites.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE favorites(id INTEGER PRIMARY KEY AUTOINCREMENT, quote TEXT, author TEXT)',
        );
      },
    );
  }

  Future<void> insertFavorite(String quote, String author) async {
    final db = await database;
    await db.insert(
      'favorites',
      {'quote': quote, 'author': author},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getFavorites() async {
    final db = await database;
    return await db.query('favorites');
  }

  Future<void> deleteFavorite(String quote) async {
    final db = await database;
    await db.delete(
      'favorites',
      where: 'quote = ?',
      whereArgs: [quote],
    );
  }

  Future<bool> isFavorite(String quote) async {
    final db = await database;
    var res = await db.query(
      'favorites',
      where: 'quote = ?',
      whereArgs: [quote],
    );
    return res.isNotEmpty;
  }
}
