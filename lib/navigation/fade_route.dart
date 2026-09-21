import 'package:flutter/material.dart';

import '../screens/under_development_screen.dart';

/// A premium, smooth page transition used for every screen-to-screen hand-off.
/// Combines a gentle slide up, subtle scale (0.985 -> 1.0), and curved fade
/// for a fluid, polished native feel without abrupt cuts or jarring motion.
Route<T> fadeRoute<T>(WidgetBuilder builder) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    pageBuilder: (context, _, _) => builder(context),
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      final curvedAnimation = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );

      final slide = Tween<Offset>(
        begin: const Offset(0.0, 0.035),
        end: Offset.zero,
      ).animate(curvedAnimation);

      final scale = Tween<double>(
        begin: 0.985,
        end: 1.0,
      ).animate(curvedAnimation);

      return SlideTransition(
        position: slide,
        child: ScaleTransition(
          scale: scale,
          child: FadeTransition(
            opacity: curvedAnimation,
            child: child,
          ),
        ),
      );
    },
  );
}

/// Pushes the shared placeholder for a feature that isn't built yet, so the
/// user can still back out to wherever they tapped from.
void pushUnderDevelopment(BuildContext context, {String title = 'No page'}) {
  Navigator.of(
    context,
  ).push(fadeRoute((_) => UnderDevelopmentScreen(title: title)));
}
