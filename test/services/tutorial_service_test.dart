import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sukatech/services/tutorial_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('isCompleted defaults to false for all pages', () async {
    final service = TutorialService.instance;
    for (final page in TutorialPage.values) {
      expect(await service.isCompleted(page), isFalse);
    }
  });

  test('markCompleted marks page as true in SharedPreferences', () async {
    final service = TutorialService.instance;
    await service.markCompleted(TutorialPage.dashboard);

    expect(await service.isCompleted(TutorialPage.dashboard), isTrue);
    expect(await service.isCompleted(TutorialPage.lessons), isFalse);
  });

  test('resetPage clears only the specific page', () async {
    final service = TutorialService.instance;
    await service.markCompleted(TutorialPage.dashboard);
    await service.markCompleted(TutorialPage.practice);

    await service.resetPage(TutorialPage.dashboard);

    expect(await service.isCompleted(TutorialPage.dashboard), isFalse);
    expect(await service.isCompleted(TutorialPage.practice), isTrue);
  });

  test('resetAll clears all tutorial flags across all pages', () async {
    final service = TutorialService.instance;
    for (final page in TutorialPage.values) {
      await service.markCompleted(page);
      expect(await service.isCompleted(page), isTrue);
    }

    await service.resetAll();

    for (final page in TutorialPage.values) {
      expect(await service.isCompleted(page), isFalse);
    }
  });
}
