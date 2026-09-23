import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sukatech/models/tutorial_step.dart';
import 'package:sukatech/widgets/tutorial_overlay.dart';

void main() {
  testWidgets('TutorialOverlay displays steps, navigates with Next, and finishes', (tester) async {
    bool finished = false;
    bool skipped = false;

    final steps = [
      const TutorialStep(
        title: 'Step One Title',
        description: 'Step One Description',
        targetRect: Rect.fromLTWH(20, 50, 100, 40),
      ),
      const TutorialStep(
        title: 'Step Two Title',
        description: 'Step Two Description',
        targetRect: Rect.fromLTWH(50, 200, 150, 60),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 409,
            height: 849,
            child: Stack(
              children: [
                TutorialOverlay(
                  steps: steps,
                  onFinish: () => finished = true,
                  onSkip: () => skipped = true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    // Initial step check
    expect(find.text('Step One Title'), findsOneWidget);
    expect(find.text('Step One Description'), findsOneWidget);
    expect(find.text('STEP 1 OF 2'), findsOneWidget);
    expect(find.text('Back'), findsNothing); // Step 0 has no back button

    // Tap Next
    await tester.tap(find.text('Next'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump(const Duration(milliseconds: 300));

    // Now on step 2
    expect(find.text('Step Two Title'), findsOneWidget);
    expect(find.text('Step Two Description'), findsOneWidget);
    expect(find.text('STEP 2 OF 2'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget); // Step 1 has back button

    // Tap Got It! 🎉
    await tester.tap(find.text('Got It! 🎉'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(finished, isTrue);
    expect(skipped, isFalse);
  });

  testWidgets('TutorialOverlay onSkip is called when Skip Tour is tapped', (tester) async {
    bool skipped = false;

    final steps = [
      const TutorialStep(
        title: 'Welcome',
        description: 'Explore the app.',
        targetRect: Rect.fromLTWH(10, 10, 50, 50),
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 409,
            height: 849,
            child: Stack(
              children: [
                TutorialOverlay(
                  steps: steps,
                  onFinish: () {},
                  onSkip: () => skipped = true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Skip Tour'));
    await tester.pump(const Duration(milliseconds: 300));

    expect(skipped, isTrue);
  });
}
