import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'calculation.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE calculations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          main_cat_id TEXT,
          currency_id TEXT,
          currency_amount TEXT,
          subcat_id TEXT,
          maintanance_cost TEXT,
          machine_purchase_price TEXT,
          machine_life TEXT,
          salvage_value TEXT,
          operator_wage TEXT,
          consumable_cost TEXT,
          factory_rent TEXT,
          operating_hours TEXT,
          working_days TEXT,
          depreciation TEXT,
          power_cost TEXT,
          operator_wages TEXT,
          total_cost_per_year TEXT,
          total_working_hours TEXT,
          machine_hour_rate TEXT,
          power_consumption TEXT,
          power_cost_per_unit TEXT,
          fuel_cost_per_hour TEXT
        )
      ''');
      },
    );
  }

  Future<int> insertCalculation(Map<String, dynamic> data) async {
    final db = await database;
    print("----------database data $data");
    return await db.insert('calculations', data);
  }

  Future<List<Map<String, dynamic>>> getCalculations() async {
    final db = await database;
    return await db.query('calculations');
  }

  Future<int> deleteCalculation(int id) async {
    final db = await database;
    return await db.delete('calculations', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> closeDB() async {
    final db = await database;
    db.close();
  }
}
