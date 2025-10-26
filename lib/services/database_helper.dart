import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_scan.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('food_scans.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_scans (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        foodName TEXT NOT NULL,
        calories REAL NOT NULL,
        protein TEXT NOT NULL,
        carbs TEXT NOT NULL,
        fat TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        timestamp TEXT NOT NULL
      )
    ''');
  }

  // Save new scan
  Future<int> insertScan(FoodScan scan) async {
    final db = await database;
    return await db.insert('food_scans', scan.toMap());
  }

  // Get all scans (newest first)
  Future<List<FoodScan>> getAllScans() async {
    final db = await database;
    final result = await db.query('food_scans', orderBy: 'timestamp DESC');
    return result.map((map) => FoodScan.fromMap(map)).toList();
  }

  // Delete a scan
  Future<int> deleteScan(int id) async {
    final db = await database;
    return await db.delete('food_scans', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all scans
  Future<void> deleteAllScans() async {
    final db = await database;
    await db.delete('food_scans');
  }
}
