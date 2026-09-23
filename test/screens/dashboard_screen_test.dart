import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sukatech/data/user_store.dart';
import 'package:sukatech/models/user.dart';
import 'package:sukatech/screens/dashboard_screen.dart';
import 'package:sukatech/screens/lessons_introduction_screen.dart';
import 'package:sukatech/screens/practice_find_measurement_screen.dart';
import 'package:sukatech/screens/practice_read_tape_screen.dart';
import 'package:sukatech/screens/practice_unit_conversion_screen.dart';
import 'package:sukatech/screens/under_development_screen.dart';

AppUser makeTestUser({
  required String currentLessonTitle,
  int currentLessonProgressPercent = 0,
}) {
  return AppUser(
    id: 1,
    name: 'Learner',
    title: 'Measurement Master',
    lessonsCompleted: 0,
    quizzesTaken: 0,
    practiceCompleted: 0,
    xpEarned: 0,
    overallProgressPercent: 0,
    currentLessonTitle: currentLessonTitle,
    currentLessonProgressPercent: currentLessonProgressPercent,
    completedLessonsList: const [],
    lessonLastTabs: const {},
    completedLessonTabs: const [],
    unlockedAchievements: const [],
    maxConsecutiveCorrectAnswers: 0,
    currentConsecutiveCorrectAnswers: 0,
    uniqueToolsSelected: const [],
    correctMetricEnglishConversions: 0,
    correctMeasurementBasics: 0,
  );
}

void main() {
  testWidgets('Continue Learning routes to FindTheMeasurementPracticeScreen', (tester) async {
    tester.view.physicalSize = const Size(409, 849);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    UserStore.current.value = makeTestUser(
      currentLessonTitle: 'Find the Measurement Practice',
      currentLessonProgressPercent: 40,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Find the Measurement Practice'), findsOneWidget);
    expect(find.text('40%'), findsOneWidget);

    // Tap the Continue Learning card via its key
    await tester.tap(find.byKey(const ValueKey('continue_learning_inkwell')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // Verify it navigated to FindTheMeasurementPracticeScreen and NOT UnderDevelopmentScreen
    expect(find.byType(FindTheMeasurementPracticeScreen), findsOneWidget);
    expect(find.byType(UnderDevelopmentScreen), findsNothing);
  });

  testWidgets('Continue Learning routes to ReadTheTapePracticeScreen', (tester) async {
    tester.view.physicalSize = const Size(409, 849);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    UserStore.current.value = makeTestUser(
      currentLessonTitle: 'Read the Tape Practice',
      currentLessonProgressPercent: 0,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Read the Tape Practice'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('continue_learning_inkwell')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(ReadTheTapePracticeScreen), findsOneWidget);
    expect(find.byType(UnderDevelopmentScreen), findsNothing);
  });

  testWidgets('Continue Learning routes to UnitConversionPracticeScreen', (tester) async {
    tester.view.physicalSize = const Size(409, 849);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    UserStore.current.value = makeTestUser(
      currentLessonTitle: 'Unit Conversion Practice',
      currentLessonProgressPercent: 20,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Unit Conversion Practice'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('continue_learning_inkwell')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(UnitConversionPracticeScreen), findsOneWidget);
    expect(find.byType(UnderDevelopmentScreen), findsNothing);
  });

  testWidgets('Continue Learning routes to LessonsIntroScreen for Introduction lesson', (tester) async {
    tester.view.physicalSize = const Size(409, 849);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());

    UserStore.current.value = makeTestUser(
      currentLessonTitle: 'Lesson 1: Introduction to Measurement',
      currentLessonProgressPercent: 50,
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DashboardScreen(),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Lesson 1: Introduction to Measurement'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('continue_learning_inkwell')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(LessonsIntroScreen), findsOneWidget);
    expect(find.byType(UnderDevelopmentScreen), findsNothing);
  });
}
