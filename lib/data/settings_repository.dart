import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

/// Persists simple app-wide toggles (dark mode, sound, ...) as key/value
/// rows, so they survive an app restart instead of just a screen change.
class SettingsRepository {
  SettingsRepository._(this._db);
  static final SettingsRepository instance = SettingsRepository._(AppDatabase.instance);

  @visibleForTesting
  factory SettingsRepository.withDatabase(AppDatabase db) => SettingsRepository._(db);

  final AppDatabase _db;

  Future<bool> getBool(String key, {required bool fallback}) async {
    final db = await _db.database;
    final rows = await db.query('settings', where: 'key = ?', whereArgs: [key]);
    if (rows.isEmpty) return fallback;
    return rows.first['value'] == '1';
  }

  Future<void> setBool(String key, bool value) async {
    final db = await _db.database;
    await db.insert('settings', {
      'key': key,
      'value': value ? '1' : '0',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
