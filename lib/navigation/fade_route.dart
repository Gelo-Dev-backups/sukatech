import 'package:flutter/material.dart';

import '../screens/under_development_screen.dart';

/// A same-feel page transition used for every screen-to-screen hand-off
/// (splash -> onboarding/home, onboarding -> home), so it isn't redefined
/// per call site.
Route<T> fadeRoute<T>(WidgetBuilder builder) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 200),
    pageBuilder: (context, _, _) => builder(context),
    transitionsBuilder: (_, animation, _, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

/// Pushes the shared placeholder for a feature that isn't built yet, so the
/// user can still back out to wherever they tapped from.
void pushUnderDevelopment(BuildContext context, {String title = 'No page'}) {
  Navigator.of(
    context,
  ).push(fadeRoute((_) => UnderDevelopmentScreen(title: title)));
}
