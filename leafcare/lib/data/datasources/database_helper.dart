import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/disease_model.dart';

class DatabaseHelper {
  static Database? _database;

  ///  **Get Database Instance**
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  ///  **Initialize Database**
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'diseases.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE diseases (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            disease_name TEXT,
            category TEXT,
            description TEXT,
            severity TEXT,
            recommended_treatment TEXT, -- Stored as JSON
            prevention_methods TEXT, -- Stored as JSON
            image_url TEXT
          )
        ''');
      },
    );
  }

  ///  **Check if Database has Data**
  Future<bool> hasData() async {
    final db = await database;
    final result = await db.query('diseases', limit: 1);
    return result.isNotEmpty;
  }

  ///  **Load JSON Data Only the First Time**
  Future<void> loadDataFromJson() async {
    final db = await database;
    bool exists = await hasData();
    if (!exists) {
      final String jsonString =
          await rootBundle.loadString('assets/json/disease_info.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      if (jsonData.containsKey('diseases')) {
        final List<Disease> diseases = (jsonData['diseases'] as List)
            .map((data) => Disease.fromMap(data))
            .toList();

        for (var disease in diseases) {
          await db.insert('diseases', disease.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        }
        print(" Data inserted into SQLite!");
      }
    }
  }

  ///  **Fetch Data from SQLite**
  Future<List<Disease>> getDiseases() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('diseases');
    print(" Data fetched from SQLite!");
    return List.generate(maps.length, (i) {
      return Disease(
        name: maps[i]['disease_name'],
        category: maps[i]['category'],
        description: maps[i]['description'],
        severity: maps[i]['severity'],
        recommendedTreatment: List<String>.from(json.decode(maps[i]['recommended_treatment'])),
        preventionMethods: List<String>.from(json.decode(maps[i]['prevention_methods'])),
        imageUrl: maps[i]['image_url'], 
        id: maps[i]['id'].toString(),
      );
    });
  }
}
