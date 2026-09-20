import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'app_database.dart';

/// Persists simple app-wide key/value settings to SQLite so they survive
/// app restarts (not just screen changes).
class SettingsRepository {
  SettingsRepository._(this._db);
  static final SettingsRepository instance = SettingsRepository._(AppDatabase.instance);

  @visibleForTesting
  factory SettingsRepository.withDatabase(AppDatabase db) => SettingsRepository._(db);

  final AppDatabase _db;

  // ── Bool helpers ────────────────────────────────────────────────────────────

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

  // ── Double helpers (for volume sliders) ─────────────────────────────────────

  Future<double> getDouble(String key, {required double fallback}) async {
    final db = await _db.database;
    final rows = await db.query('settings', where: 'key = ?', whereArgs: [key]);
    if (rows.isEmpty) return fallback;
    return double.tryParse(rows.first['value'] as String) ?? fallback;
  }

  Future<void> setDouble(String key, double value) async {
    final db = await _db.database;
    await db.insert('settings', {
      'key': key,
      'value': value.toString(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
