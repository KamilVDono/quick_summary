import 'package:path/path.dart';
import 'package:quick_summary/data/summary.dart';
import 'package:quick_summary/utils/consts.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  // === Implementation
  static const databaseFileName = "summaries.db";
  Database? _database;

  Future<int> addSummary(Summary summary) async {
    final db = await _db();
    return db.insert(
      Consts.databaseSummariesTable,
      summary.dump(),
      conflictAlgorithm: ConflictAlgorithm.rollback,
    );
  }

  removeSummary(Summary summary) async {
    if (summary.id == -1) {
      return;
    }
    final db = await _db();
    return db.delete(
      Consts.databaseSummariesTable,
      where: "id = ?",
      whereArgs: [summary.id],
    );
  }

  Future<List<Summary>> allSummaries() async {
    final db = await _db();

    final List<Map<String, dynamic>> serializedSummaries = await db.query(
      Consts.databaseSummariesTable,
      orderBy: Consts.databaseSummaryTime + " DESC",
    );

    return serializedSummaries.isNotEmpty
        ? serializedSummaries.map((s) => Summary.fromDatabase(s)).toList()
        : [];
  }

  Future<List<Summary>> summariesForPage(int itemsPerPage, int page) async {
    final db = await _db();
    
    final offset = page * itemsPerPage;

    final List<Map<String, dynamic>> serializedSummaries = await db.query(
      Consts.databaseSummariesTable,
      offset: offset,
      limit: itemsPerPage,
      orderBy: Consts.databaseSummaryTime + " DESC",
    );

    return serializedSummaries.isNotEmpty
        ? serializedSummaries.map((s) => Summary.fromDatabase(s)).toList()
        : [];
  }

  Future<Database> _db() async {
    if (!(_database?.isOpen ?? false)) {
      await _init();
    }
    // _init creates _database instance so it should not be null here
    return _database!;
  }

  Future<void> _init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), databaseFileName),
      onCreate: (db, version) {
        return _createSummariesTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        return _dropSummaries(db).then((_) => _createSummariesTable(db));
      },
      version: 2,
    );
  }

  Future<void> _dropSummaries(Database db) =>
      db.execute("DROP TABLE ${Consts.databaseSummariesTable}");

  Future<void> _createSummariesTable(Database db) {
    return db.execute("CREATE TABLE ${Consts.databaseSummariesTable}("
        "${Consts.databaseID} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "${Consts.databaseSummaryTitle} TEXT, "
        "${Consts.databaseSummaryText} TEXT, "
        "${Consts.databaseSummaryTime} INTEGER NOT NULL"
        ")");
  }

  // === Singleton
  static final DatabaseService _singleton = DatabaseService._constructor();
  factory DatabaseService() {
    return _singleton;
  }
  DatabaseService._constructor();
}
