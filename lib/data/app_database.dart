import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

/// Single shared connection to the app's on-device SQLite database. Every
/// repository goes through this instead of opening its own connection.
class AppDatabase {
  AppDatabase._(this._explicitPath);
  static final AppDatabase instance = AppDatabase._(null);

  /// Bypasses `path_provider` and opens the database at [path] instead of
  /// the real app-documents directory — for tests, where there's no device
  /// to resolve that path on. Pass `sqflite_common_ffi`'s
  /// `inMemoryDatabasePath` for a throwaway in-memory database.
  @visibleForTesting
  factory AppDatabase.withPath(String path) => AppDatabase._(path);

  static const _fileName = 'sukatech.db';
  static const _version = 4;

  final String? _explicitPath;
  Database? _database;

  Future<Database> get database async => _database ??= await _open();

  Future<Database> _open() async {
    final path = _explicitPath ?? join((await getApplicationDocumentsDirectory()).path, _fileName);
    return openDatabase(
      path,
      version: _version,
      onCreate: _createSchema,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute("ALTER TABLE users ADD COLUMN completed_lessons TEXT NOT NULL DEFAULT '[]'");
          await db.execute("ALTER TABLE users ADD COLUMN lesson_last_tabs TEXT NOT NULL DEFAULT '{}'");
        }
        if (oldVersion < 3) {
          await db.execute("ALTER TABLE users ADD COLUMN completed_lesson_tabs TEXT NOT NULL DEFAULT '[]'");
        }
        if (oldVersion < 4) {
          await db.execute("ALTER TABLE users ADD COLUMN unlocked_achievements TEXT NOT NULL DEFAULT '[]'");
          await db.execute("ALTER TABLE users ADD COLUMN max_consecutive_correct_answers INTEGER NOT NULL DEFAULT 0");
          await db.execute("ALTER TABLE users ADD COLUMN current_consecutive_correct_answers INTEGER NOT NULL DEFAULT 0");
          await db.execute("ALTER TABLE users ADD COLUMN unique_tools_selected TEXT NOT NULL DEFAULT '[]'");
          await db.execute("ALTER TABLE users ADD COLUMN correct_metric_english_conversions INTEGER NOT NULL DEFAULT 0");
          await db.execute("ALTER TABLE users ADD COLUMN correct_measurement_basics INTEGER NOT NULL DEFAULT 0");
        }
      },
    );
  }

  Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        title TEXT NOT NULL,
        lessons_completed INTEGER NOT NULL DEFAULT 0,
        quizzes_taken INTEGER NOT NULL DEFAULT 0,
        practice_completed INTEGER NOT NULL DEFAULT 0,
        xp_earned INTEGER NOT NULL DEFAULT 0,
        overall_progress_percent INTEGER NOT NULL DEFAULT 0,
        current_lesson_title TEXT NOT NULL DEFAULT '',
        current_lesson_progress_percent INTEGER NOT NULL DEFAULT 0,
        completed_lessons TEXT NOT NULL DEFAULT '[]',
        lesson_last_tabs TEXT NOT NULL DEFAULT '{}',
        completed_lesson_tabs TEXT NOT NULL DEFAULT '[]',
        unlocked_achievements TEXT NOT NULL DEFAULT '[]',
        max_consecutive_correct_answers INTEGER NOT NULL DEFAULT 0,
        current_consecutive_correct_answers INTEGER NOT NULL DEFAULT 0,
        unique_tools_selected TEXT NOT NULL DEFAULT '[]',
        correct_metric_english_conversions INTEGER NOT NULL DEFAULT 0,
        correct_measurement_basics INTEGER NOT NULL DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE settings (
        key TEXT PRIMARY KEY,
        value TEXT NOT NULL
      )
    ''');
    await db.execute('''
      CREATE TABLE achievements (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        unlocked INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }
}
