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
