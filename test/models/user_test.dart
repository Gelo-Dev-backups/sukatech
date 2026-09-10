import 'package:flutter_test/flutter_test.dart';
import 'package:sukatech/models/user.dart';

void main() {
  group('AppUser', () {
    test('fromMap reads every column', () {
      final user = AppUser.fromMap({
        'id': 1,
        'name': 'Learner',
        'title': 'Measurement Master',
        'lessons_completed': 3,
        'quizzes_taken': 2,
        'practice_completed': 1,
        'xp_earned': 40,
        'overall_progress_percent': 25,
        'current_lesson_title': 'Lesson 1: Introduction to Measurement',
        'current_lesson_progress_percent': 10,
      });

      expect(user.id, 1);
      expect(user.name, 'Learner');
      expect(user.title, 'Measurement Master');
      expect(user.lessonsCompleted, 3);
      expect(user.quizzesTaken, 2);
      expect(user.practiceCompleted, 1);
      expect(user.xpEarned, 40);
      expect(user.overallProgressPercent, 25);
      expect(user.currentLessonTitle, 'Lesson 1: Introduction to Measurement');
      expect(user.currentLessonProgressPercent, 10);
    });

    test('toMap round-trips through fromMap unchanged', () {
      const original = AppUser(
        id: 7,
        name: 'Learner',
        title: 'Measurement Master',
        lessonsCompleted: 5,
        quizzesTaken: 4,
        practiceCompleted: 3,
        xpEarned: 60,
        overallProgressPercent: 45,
        currentLessonTitle: 'Lesson 2: Rulers',
        currentLessonProgressPercent: 20,
      );

      final rebuilt = AppUser.fromMap(original.toMap());

      expect(rebuilt.id, original.id);
      expect(rebuilt.name, original.name);
      expect(rebuilt.title, original.title);
      expect(rebuilt.lessonsCompleted, original.lessonsCompleted);
      expect(rebuilt.quizzesTaken, original.quizzesTaken);
      expect(rebuilt.practiceCompleted, original.practiceCompleted);
      expect(rebuilt.xpEarned, original.xpEarned);
      expect(rebuilt.overallProgressPercent, original.overallProgressPercent);
      expect(rebuilt.currentLessonTitle, original.currentLessonTitle);
      expect(
        rebuilt.currentLessonProgressPercent,
        original.currentLessonProgressPercent,
      );
    });

    test('copyWith only changes the fields passed to it', () {
      const original = AppUser(
        id: 1,
        name: 'Learner',
        title: 'Measurement Master',
        lessonsCompleted: 12,
        quizzesTaken: 8,
        practiceCompleted: 15,
        xpEarned: 120,
        overallProgressPercent: 80,
        currentLessonTitle: 'Lesson 1: Introduction to Measurement',
        currentLessonProgressPercent: 60,
      );

      final reset = original.copyWith(
        lessonsCompleted: 0,
        quizzesTaken: 0,
        practiceCompleted: 0,
        xpEarned: 0,
        overallProgressPercent: 0,
        currentLessonProgressPercent: 0,
      );

      // The Reset Progress scenario: every progress figure goes to 0...
      expect(reset.lessonsCompleted, 0);
      expect(reset.quizzesTaken, 0);
      expect(reset.practiceCompleted, 0);
      expect(reset.xpEarned, 0);
      expect(reset.overallProgressPercent, 0);
      expect(reset.currentLessonProgressPercent, 0);
      // ...but identity fields are untouched.
      expect(reset.id, original.id);
      expect(reset.name, original.name);
      expect(reset.title, original.title);
      expect(reset.currentLessonTitle, original.currentLessonTitle);
    });
  });
}
