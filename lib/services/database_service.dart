import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/landmark.dart';
import '../models/visit.dart';
import '../models/pending_visit.dart';
import '../utils/constants.dart';

class DatabaseService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), Constants.dbName);
    return await openDatabase(
      path,
      version: Constants.dbVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Landmarks table
    await db.execute('''
    CREATE TABLE ${Constants.landmarksTable}(
      id INTEGER PRIMARY KEY,
      title TEXT,
      lat REAL,
      lon REAL,
      image TEXT,
      score REAL,
      visit_count INTEGER,
      avg_distance REAL,
      is_active INTEGER
    )
  ''');

    // Visits table - id is AUTOINCREMENT, no need to insert it
    await db.execute('''
    CREATE TABLE ${Constants.visitsTable}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      landmark_id INTEGER,
      landmark_name TEXT,
      visit_time TEXT,
      distance REAL,
      user_lat REAL,
      user_lon REAL
    )
  ''');

    // Pending visits table
    await db.execute('''
    CREATE TABLE ${Constants.pendingVisitsTable}(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      landmark_id INTEGER,
      user_lat REAL,
      user_lon REAL,
      timestamp TEXT
    )
  ''');
  }

  // Landmark operations
  Future<void> saveLandmarks(List<Landmark> landmarks) async {
    final db = await database;
    Batch batch = db.batch();

    for (var landmark in landmarks) {
      batch.insert(
        Constants.landmarksTable,
        landmark.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit();
  }

  Future<List<Landmark>> getCachedLandmarks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Constants.landmarksTable,
      where: 'is_active = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Landmark.fromJson(maps[i]);
    });
  }

  Future<void> softDeleteLandmark(int id) async {
    final db = await database;
    await db.update(
      Constants.landmarksTable,
      {'is_active': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Visit operations
  Future<void> saveVisit(Visit visit) async {
    final db = await database;
    // Don't include id - let database auto-increment
    await db.insert(
      Constants.visitsTable,
      {
        'landmark_id': visit.landmarkId,
        'landmark_name': visit.landmarkName,
        'visit_time': visit.visitTime.toIso8601String(),
        'distance': visit.distance,
        'user_lat': visit.userLat,
        'user_lon': visit.userLon,
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // Ignore duplicates
    );
  }

  Future<List<Visit>> getVisits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      Constants.visitsTable,
      orderBy: 'visit_time DESC',
    );

    return List.generate(maps.length, (i) {
      return Visit(
        id: maps[i]['id'],
        landmarkId: maps[i]['landmark_id'],
        landmarkName: maps[i]['landmark_name'],
        visitTime: DateTime.parse(maps[i]['visit_time']),
        distance: maps[i]['distance'],
        userLat: maps[i]['user_lat'],
        userLon: maps[i]['user_lon'],
      );
    });
  }

  // Pending visits operations
  Future<void> savePendingVisit(PendingVisit visit) async {
    final db = await database;
    await db.insert(Constants.pendingVisitsTable, visit.toMap());
  }

  Future<List<PendingVisit>> getPendingVisits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(Constants.pendingVisitsTable);

    return List.generate(maps.length, (i) {
      return PendingVisit.fromMap(maps[i]);
    });
  }

  Future<void> deletePendingVisit(int id) async {
    final db = await database;
    await db.delete(
      Constants.pendingVisitsTable,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete(Constants.landmarksTable);
    await db.delete(Constants.visitsTable);
    await db.delete(Constants.pendingVisitsTable);
  }
}