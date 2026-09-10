import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sukatech/data/app_database.dart';
import 'package:sukatech/data/user_repository.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  // A fresh in-memory database per test, so tests can't leak state into
  // each other via a shared file on disk.
  late UserRepository repository;
  setUp(() {
    repository = UserRepository.withDatabase(AppDatabase.withPath(inMemoryDatabasePath));
  });

  group('UserRepository.getOrCreateUser', () {
    test('seeds a brand-new user with every progress figure at 0', () async {
      final user = await repository.getOrCreateUser();

      expect(user.name, 'Learner');
      expect(user.title, 'Measurement Master');
      expect(user.lessonsCompleted, 0);
      expect(user.quizzesTaken, 0);
      expect(user.practiceCompleted, 0);
      expect(user.xpEarned, 0);
      expect(user.overallProgressPercent, 0);
      expect(user.currentLessonProgressPercent, 0);
      // There is a starting lesson name — just no progress on it yet.
      expect(user.currentLessonTitle, isNotEmpty);
    });

    test('is idempotent: calling it again returns the same row, not a new one', () async {
      final first = await repository.getOrCreateUser();
      final second = await repository.getOrCreateUser();

      expect(second.id, first.id);
    });
  });

  group('UserRepository.update', () {
    test('persists changes, including resetting progress back to 0', () async {
      final user = await repository.getOrCreateUser();

      final withProgress = user.copyWith(
        lessonsCompleted: 5,
        quizzesTaken: 3,
        practiceCompleted: 2,
        xpEarned: 50,
        overallProgressPercent: 40,
        currentLessonProgressPercent: 30,
      );
      await repository.update(withProgress);
      final afterProgress = await repository.getOrCreateUser();
      expect(afterProgress.lessonsCompleted, 5);
      expect(afterProgress.overallProgressPercent, 40);

      final reset = afterProgress.copyWith(
        lessonsCompleted: 0,
        quizzesTaken: 0,
        practiceCompleted: 0,
        xpEarned: 0,
        overallProgressPercent: 0,
        currentLessonProgressPercent: 0,
      );
      await repository.update(reset);
      final afterReset = await repository.getOrCreateUser();

      expect(afterReset.lessonsCompleted, 0);
      expect(afterReset.quizzesTaken, 0);
      expect(afterReset.practiceCompleted, 0);
      expect(afterReset.xpEarned, 0);
      expect(afterReset.overallProgressPercent, 0);
      expect(afterReset.currentLessonProgressPercent, 0);
      // Resetting progress doesn't wipe who the user is.
      expect(afterReset.name, user.name);
      expect(afterReset.currentLessonTitle, user.currentLessonTitle);
    });
  });
}
