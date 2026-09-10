import 'package:flutter/foundation.dart';

import '../models/user.dart';
import 'app_database.dart';

/// Reads and writes the single on-device learner profile.
class UserRepository {
  UserRepository._(this._db);
  static final UserRepository instance = UserRepository._(AppDatabase.instance);

  @visibleForTesting
  factory UserRepository.withDatabase(AppDatabase db) => UserRepository._(db);

  final AppDatabase _db;

  /// Returns the on-device user, creating one the very first time the app
  /// runs (there's only ever one row in `users`). Every progress figure
  /// starts at 0 — there's nothing to have earned yet on a fresh install.
  Future<AppUser> getOrCreateUser() async {
    final db = await _db.database;
    final rows = await db.query('users', limit: 1);
    if (rows.isNotEmpty) return AppUser.fromMap(rows.first);

    final id = await db.insert('users', {
      'name': 'Learner',
      'title': 'Measurement Master',
      'lessons_completed': 0,
      'quizzes_taken': 0,
      'practice_completed': 0,
      'xp_earned': 0,
      'overall_progress_percent': 0,
      'current_lesson_title': 'Lesson 1: Introduction to Measurement',
      'current_lesson_progress_percent': 0,
    });
    final created = await db.query('users', where: 'id = ?', whereArgs: [id]);
    return AppUser.fromMap(created.first);
  }

  Future<void> update(AppUser user) async {
    final db = await _db.database;
    await db.update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }
}
