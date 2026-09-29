import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sukatech/widgets/design_canvas.dart';

void main() {
  Widget buildTestCanvas() {
    return const MaterialApp(
      home: DesignCanvas(
        width: 409,
        height: 849,
        backgroundColor: Colors.white,
        children: [
          Positioned(
            left: 10,
            top: 10,
            key: Key('top_left_item'),
            child: Text('Top Left Item'),
          ),
          Positioned(
            right: 10,
            top: 10,
            key: Key('top_right_item'),
            child: Text('Top Right Item'),
          ),
          Positioned(
            left: 20,
            top: 400,
            key: Key('center_item'),
            child: Text('Center Item'),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            key: Key('bottom_nav_bar'),
            child: SizedBox(
              height: 84,
              child: Text('Bottom Navigation Bar'),
            ),
          ),
        ],
      ),
    );
  }

  group('DesignCanvas Responsiveness Tests', () {
    testWidgets('renders properly on small Android phone (360 x 640)', (tester) async {
      tester.view.physicalSize = const Size(360, 640);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestCanvas());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('top_left_item')), findsOneWidget);
      expect(find.byKey(const Key('top_right_item')), findsOneWidget);
      expect(find.byKey(const Key('center_item')), findsOneWidget);
      expect(find.byKey(const Key('bottom_nav_bar')), findsOneWidget);

      // Verify the bottom nav bar is on screen and within bounds
      final bottomBarRect = tester.getRect(find.byKey(const Key('bottom_nav_bar')));
      expect(bottomBarRect.bottom, lessThanOrEqualTo(640.1));
      expect(bottomBarRect.top, greaterThanOrEqualTo(0.0));
    });

    testWidgets('renders properly on tall Android phone (412 x 915)', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestCanvas());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('top_left_item')), findsOneWidget);
      expect(find.byKey(const Key('top_right_item')), findsOneWidget);
      expect(find.byKey(const Key('center_item')), findsOneWidget);
      expect(find.byKey(const Key('bottom_nav_bar')), findsOneWidget);

      final topLeftRect = tester.getRect(find.byKey(const Key('top_left_item')));
      expect(topLeftRect.left, greaterThanOrEqualTo(0.0));

      final topRightRect = tester.getRect(find.byKey(const Key('top_right_item')));
      expect(topRightRect.right, lessThanOrEqualTo(412.1));

      final bottomBarRect = tester.getRect(find.byKey(const Key('bottom_nav_bar')));
      expect(bottomBarRect.bottom, lessThanOrEqualTo(915.1));
    });

    testWidgets('renders properly on tablet portrait (768 x 1024 iPad)', (tester) async {
      tester.view.physicalSize = const Size(768, 1024);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestCanvas());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('top_left_item')), findsOneWidget);
      expect(find.byKey(const Key('top_right_item')), findsOneWidget);
      expect(find.byKey(const Key('center_item')), findsOneWidget);
      expect(find.byKey(const Key('bottom_nav_bar')), findsOneWidget);

      // All elements must be within screen dimensions
      final topLeftRect = tester.getRect(find.byKey(const Key('top_left_item')));
      expect(topLeftRect.top, greaterThanOrEqualTo(0.0));
      expect(topLeftRect.left, greaterThanOrEqualTo(0.0));

      final bottomBarRect = tester.getRect(find.byKey(const Key('bottom_nav_bar')));
      expect(bottomBarRect.bottom, lessThanOrEqualTo(1024.1));
    });

    testWidgets('renders properly on tablet landscape (1024 x 768)', (tester) async {
      tester.view.physicalSize = const Size(1024, 768);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestCanvas());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('top_left_item')), findsOneWidget);
      expect(find.byKey(const Key('top_right_item')), findsOneWidget);
      expect(find.byKey(const Key('center_item')), findsOneWidget);
      expect(find.byKey(const Key('bottom_nav_bar')), findsOneWidget);

      final bottomBarRect = tester.getRect(find.byKey(const Key('bottom_nav_bar')));
      expect(bottomBarRect.bottom, lessThanOrEqualTo(768.1));
    });

    testWidgets('renders properly on desktop big screen (1920 x 1080)', (tester) async {
      tester.view.physicalSize = const Size(1920, 1080);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(buildTestCanvas());
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('top_left_item')), findsOneWidget);
      expect(find.byKey(const Key('top_right_item')), findsOneWidget);
      expect(find.byKey(const Key('center_item')), findsOneWidget);
      expect(find.byKey(const Key('bottom_nav_bar')), findsOneWidget);

      final topLeftRect = tester.getRect(find.byKey(const Key('top_left_item')));
      expect(topLeftRect.left, greaterThanOrEqualTo(0.0));
      expect(topLeftRect.right, lessThanOrEqualTo(1920.0));

      final bottomBarRect = tester.getRect(find.byKey(const Key('bottom_nav_bar')));
      expect(bottomBarRect.bottom, lessThanOrEqualTo(1080.1));
    });
  });
}
