import 'package:shared_preferences/shared_preferences.dart';

/// The pages that support a guided onboarding tutorial.
enum TutorialPage {
  dashboard,
  lessons,
  practice,
  quiz,
  converter,
  achievements,
  profile,
}

/// Manages persistent state for whether a user has seen the tutorial
/// on each page of the application.
class TutorialService {
  TutorialService._();

  static final TutorialService instance = TutorialService._();

  static const String _prefix = 'tutorial_seen_';

  String _keyFor(TutorialPage page) => '$_prefix${page.name}';

  /// Returns true if the user has already completed or dismissed
  /// the tutorial for [page].
  Future<bool> isCompleted(TutorialPage page) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyFor(page)) ?? false;
  }

  /// Marks the tutorial for [page] as completed so it won't show again.
  Future<void> markCompleted(TutorialPage page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyFor(page), true);
  }

  /// Resets the tutorial status for [page].
  Future<void> resetPage(TutorialPage page) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyFor(page));
  }

  /// Resets all tutorials across all pages so they will show again.
  Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (final page in TutorialPage.values) {
      await prefs.remove(_keyFor(page));
    }
  }
}
