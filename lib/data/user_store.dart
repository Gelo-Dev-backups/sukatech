import 'package:flutter/foundation.dart';

import '../models/user.dart';
import 'achievement_manager.dart';
import 'user_repository.dart';

/// The current learner, held outside the widget tree so every screen reads
/// (and can react to changes in) the same in-memory copy instead of each
/// querying the database independently.
///
/// [load] is awaited in `main()` before `runApp`, so [current] is always
/// non-null by the time any screen builds.
class UserStore {
  UserStore._();

  static final ValueNotifier<AppUser?> current = ValueNotifier(null);

  static Future<void> load() async {
    current.value = await UserRepository.instance.getOrCreateUser();
  }

  static int getQuizHighScore(int quizIndex) {
    final user = current.value;
    if (user == null) return 0;
    return user.lessonLastTabs['quiz_high_score_$quizIndex'] ?? 0;
  }

  static Future<void> recordQuizScore(int quizIndex, int score) async {
    await mutate((user) {
      final newTabs = Map<String, int>.from(user.lessonLastTabs);
      final key = 'quiz_high_score_$quizIndex';
      final prev = newTabs[key] ?? 0;
      if (score > prev) {
        newTabs[key] = score;
      }
      return user.copyWith(lessonLastTabs: newTabs);
    });
  }

  /// Applies [update] to the current user, persists it, then publishes the
  /// new value to every listener.
  static Future<void> mutate(AppUser Function(AppUser user) update) async {
    final existing = current.value;
    if (existing == null) return;
    var updated = update(existing);
    updated = AchievementManager.instance.evaluate(updated);
    await UserRepository.instance.update(updated);
    current.value = updated;
  }
}
