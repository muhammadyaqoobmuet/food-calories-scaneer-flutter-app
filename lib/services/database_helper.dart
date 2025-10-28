import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/food_scan.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  // In-memory fallback for web (sqflite is not available on web)
  final List<Map<String, Object?>> _webStorage = [];
  int _webNextId = 1;

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
    // Web fallback: sqflite is not available on web, use in-memory storage
    if (kIsWeb) {
      final map = Map<String, Object?>.from(scan.toMap());
      final id = _webNextId++;
      map['id'] = id;
      _webStorage.add(map);
      return id;
    }

    final db = await database;
    return await db.insert('food_scans', scan.toMap());
  }

  // Get all scans (newest first)
  Future<List<FoodScan>> getAllScans() async {
    if (kIsWeb) {
      final result = List<Map<String, Object?>>.from(_webStorage);
      // Ensure newest-first by timestamp string (ISO8601)
      result.sort((a, b) {
        final ta = a['timestamp'] as String? ?? '';
        final tb = b['timestamp'] as String? ?? '';
        return tb.compareTo(ta);
      });
      return result.map((map) => FoodScan.fromMap(map)).toList();
    }

    final db = await database;
    final result = await db.query('food_scans', orderBy: 'timestamp DESC');
    return result.map((map) => FoodScan.fromMap(map)).toList();
  }

  // Delete a scan
  Future<int> deleteScan(int id) async {
    if (kIsWeb) {
      final before = _webStorage.length;
      _webStorage.removeWhere((m) => (m['id'] as int?) == id);
      final after = _webStorage.length;
      final removed = before - after;
      // sqflite.delete returns number of rows affected; emulate 1 or 0
      return removed > 0 ? 1 : 0;
    }

    final db = await database;
    return await db.delete('food_scans', where: 'id = ?', whereArgs: [id]);
  }

  // Delete all scans
  Future<void> deleteAllScans() async {
    if (kIsWeb) {
      _webStorage.clear();
      return;
    }

    final db = await database;
    await db.delete('food_scans');
  }
}
