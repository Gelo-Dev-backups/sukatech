import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sukatech/widgets/confirmation_modal.dart';

void main() {
  Widget harness(ValueChanged<bool> onResult) {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              final result = await showConfirmationModal(
                context,
                title: 'Reset Progress?',
                message: 'This clears your stats.',
                confirmLabel: 'Reset',
                isDestructive: true,
              );
              onResult(result);
            },
            child: const Text('Open'),
          ),
        ),
      ),
    );
  }

  testWidgets('shows the title, message and both actions', (tester) async {
    await tester.pumpWidget(harness((_) {}));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Reset Progress?'), findsOneWidget);
    expect(find.text('This clears your stats.'), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });

  testWidgets('Cancel closes the dialog and resolves false', (tester) async {
    bool? result;
    await tester.pumpWidget(harness((value) => result = value));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Cancel'));
    await tester.pumpAndSettle();

    expect(result, false);
    expect(find.text('Reset Progress?'), findsNothing);
  });

  testWidgets('Confirm closes the dialog and resolves true', (tester) async {
    bool? result;
    await tester.pumpWidget(harness((value) => result = value));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reset'));
    await tester.pumpAndSettle();

    expect(result, true);
    expect(find.text('Reset Progress?'), findsNothing);
  });

  testWidgets('dismissing via the barrier resolves false', (tester) async {
    bool? result;
    await tester.pumpWidget(harness((value) => result = value));
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    // Tap outside the dialog to dismiss it.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(result, false);
  });
}
