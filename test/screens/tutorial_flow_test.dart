import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sukatech/data/user_store.dart';
import 'package:sukatech/models/user.dart';
import 'package:sukatech/screens/dashboard_screen.dart';
import 'package:sukatech/screens/profile_screen.dart';
import 'package:sukatech/services/tutorial_service.dart';

AppUser _makeTestUser() {
  return const AppUser(
    id: 1,
    name: 'Learner',
    title: 'Measurement Master',
    lessonsCompleted: 0,
    quizzesTaken: 0,
    practiceCompleted: 0,
    xpEarned: 0,
    overallProgressPercent: 0,
    currentLessonTitle: 'Lesson 1: Introduction to Measurement',
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
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    UserStore.current.value = _makeTestUser();
  });

  testWidgets('Dashboard shows tutorial on first launch and marks completed on Skip', (tester) async {
    tester.view.physicalSize = const Size(409, 849);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Tutorial overlay appears with first step
    expect(find.text('Welcome to SUKATECH!'), findsOneWidget);
    expect(find.text('STEP 1 OF 7'), findsOneWidget);

    // Skip the tour
    await tester.tap(find.text('Skip Tour'));
    await tester.pump(const Duration(milliseconds: 300));

    // Tutorial overlay is dismissed
    expect(find.text('Welcome to SUKATECH!'), findsNothing);

    // Verify it is marked completed in TutorialService
    expect(await TutorialService.instance.isCompleted(TutorialPage.dashboard), isTrue);
  });

  testWidgets('ProfileScreen Replay App Tutorials resets all completed tutorials', (tester) async {
    tester.view.physicalSize = const Size(409, 849);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    // Mark tutorials as already completed
    await TutorialService.instance.markCompleted(TutorialPage.dashboard);
    await TutorialService.instance.markCompleted(TutorialPage.profile);

    expect(await TutorialService.instance.isCompleted(TutorialPage.dashboard), isTrue);
    expect(await TutorialService.instance.isCompleted(TutorialPage.profile), isTrue);

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ProfileScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 100));

    // Because profile was already completed, tutorial should NOT show automatically
    expect(find.text('STEP 1 OF 3'), findsNothing);

    // Tap Replay App Tutorials
    await tester.tap(find.text('Replay App Tutorials'));
    await tester.pump(const Duration(milliseconds: 100));

    // All tutorials should now be reset to false
    expect(await TutorialService.instance.isCompleted(TutorialPage.dashboard), isFalse);
    expect(await TutorialService.instance.isCompleted(TutorialPage.profile), isFalse);

    // And the profile tutorial overlay should now be visible!
    expect(find.text('Learner Profile & Rank'), findsOneWidget);
  });
}
