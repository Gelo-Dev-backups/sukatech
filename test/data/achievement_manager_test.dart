import 'package:flutter_test/flutter_test.dart';
import 'package:sukatech/data/achievement_manager.dart';
import 'package:sukatech/models/user.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AchievementManager unlock checks', () {
    const baseUser = AppUser(
      id: 1,
      name: 'Test User',
      title: 'Beginner',
      lessonsCompleted: 0,
      quizzesTaken: 0,
      practiceCompleted: 0,
      xpEarned: 0,
      overallProgressPercent: 0,
      currentLessonTitle: '',
      currentLessonProgressPercent: 0,
      completedLessonsList: [],
      lessonLastTabs: {},
      completedLessonTabs: [],
      unlockedAchievements: [],
      maxConsecutiveCorrectAnswers: 0,
      currentConsecutiveCorrectAnswers: 0,
      uniqueToolsSelected: [],
      correctMetricEnglishConversions: 0,
      correctMeasurementBasics: 0,
    );

    test('tool_anatomy unlocks when Lesson 3 quiz score >= 70', () {
      final user = baseUser.copyWith(
        lessonLastTabs: {'quiz_high_score_2': 70},
      );
      final evaluated = AchievementManager.instance.evaluate(user);
      expect(evaluated.unlockedAchievements, contains('tool_anatomy'));
      expect(evaluated.xpEarned, greaterThanOrEqualTo(75));
    });

    test('tool_anatomy unlocks when lesson_03_practice_parts_functions_xp tab is present', () {
      final user = baseUser.copyWith(
        completedLessonTabs: ['lesson_03_practice_parts_functions_xp'],
      );
      final evaluated = AchievementManager.instance.evaluate(user);
      expect(evaluated.unlockedAchievements, contains('tool_anatomy'));
    });

    test('tool_anatomy unlocks when tool_anatomy tab is present', () {
      final user = baseUser.copyWith(
        completedLessonTabs: ['tool_anatomy'],
      );
      final evaluated = AchievementManager.instance.evaluate(user);
      expect(evaluated.unlockedAchievements, contains('tool_anatomy'));
    });

    test('right_tool_right_job unlocks when uniqueToolsSelected has 10 items', () {
      final user = baseUser.copyWith(
        uniqueToolsSelected: List.generate(10, (i) => 'tool_scenario_$i'),
      );
      final evaluated = AchievementManager.instance.evaluate(user);
      expect(evaluated.unlockedAchievements, contains('right_tool_right_job'));
      expect(evaluated.xpEarned, greaterThanOrEqualTo(75));
    });

    test('perfect_measurement unlocks when perfect_measurement tab is present', () {
      final user = baseUser.copyWith(
        completedLessonTabs: ['perfect_measurement'],
      );
      final evaluated = AchievementManager.instance.evaluate(user);
      expect(evaluated.unlockedAchievements, contains('perfect_measurement'));
      expect(evaluated.xpEarned, greaterThanOrEqualTo(100));
    });

    test('perfect_measurement unlocks when any quiz has high score of 100', () {
      final user = baseUser.copyWith(
        lessonLastTabs: {'quiz_high_score_4': 100},
      );
      final evaluated = AchievementManager.instance.evaluate(user);
      expect(evaluated.unlockedAchievements, contains('perfect_measurement'));
    });

    test('sharp_mind unlocks when maxConsecutiveCorrectAnswers >= 10', () {
      final user = baseUser.copyWith(
        maxConsecutiveCorrectAnswers: 10,
      );
      final evaluated = AchievementManager.instance.evaluate(user);
      expect(evaluated.unlockedAchievements, contains('sharp_mind'));
      expect(evaluated.xpEarned, greaterThanOrEqualTo(100));
    });

    test('does not re-award already unlocked achievements', () {
      final user = baseUser.copyWith(
        unlockedAchievements: ['sharp_mind'],
        maxConsecutiveCorrectAnswers: 12,
        xpEarned: 200,
      );
      final evaluated = AchievementManager.instance.evaluate(user);
      expect(evaluated.unlockedAchievements, ['sharp_mind']);
      expect(evaluated.xpEarned, 200);
    });
  });
}
