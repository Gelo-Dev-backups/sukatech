import 'package:flutter/material.dart';

import '../screens/under_development_screen.dart';

// ─── Shared curve ────────────────────────────────────────────────────────────

const _kCurve    = Curves.easeOutCubic;
const _kRevCurve = Curves.easeInCubic;
const _kDur      = Duration(milliseconds: 320);
const _kRevDur   = Duration(milliseconds: 260);

// ─── Cross-fade route (tab / sibling navigation) ─────────────────────────────
//
// Used when switching top-level tabs (Home → Lessons → Practice …).
// There is no slide or scale — the outgoing page fades out while the incoming
// page fades in, giving a calm, non-directional feel that suits tab switching.

Route<T> crossFadeRoute<T>(WidgetBuilder builder) {
  return PageRouteBuilder<T>(
    transitionDuration:        const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    pageBuilder: (context, _, _) => builder(context),
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      // Outgoing screen fades out.
      final fadeOut = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeOut),
      );
      // Incoming screen fades in.
      final fadeIn = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );
      return FadeTransition(
        opacity: fadeOut,
        child: FadeTransition(opacity: fadeIn, child: child),
      );
    },
  );
}

// ─── Slide route (deep push navigation) ──────────────────────────────────────
//
// Used when navigating deeper: opening a lesson, starting a quiz, entering a
// practice activity, etc. Slides in from the right (iOS-style) and slides back
// out to the right on pop. A subtle fade accompanies the slide so it doesn't
// look too abrupt on Android.

Route<T> slideRoute<T>(WidgetBuilder builder) {
  return PageRouteBuilder<T>(
    transitionDuration:        _kDur,
    reverseTransitionDuration: _kRevDur,
    pageBuilder: (context, _, _) => builder(context),
    transitionsBuilder: (_, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: _kCurve,
        reverseCurve: _kRevCurve,
      );

      // Incoming page slides in from the right.
      final slideIn = Tween<Offset>(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).animate(curved);

      // Outgoing page slides slightly left as the new one arrives (parallax).
      final slideOut = Tween<Offset>(
        begin: Offset.zero,
        end: const Offset(-0.25, 0.0),
      ).animate(CurvedAnimation(parent: secondaryAnimation, curve: _kCurve));

      // Subtle fade accompanies the slide.
      final fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animation,
          curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
        ),
      );

      return SlideTransition(
        position: slideOut,
        child: SlideTransition(
          position: slideIn,
          child: FadeTransition(opacity: fadeIn, child: child),
        ),
      );
    },
  );
}

// ─── Backwards-compatible alias ───────────────────────────────────────────────
//
// Existing call-sites that already use fadeRoute() keep working without changes.
// They get the slide behaviour (deep push) which is appropriate for all
// the places that were already using it.

Route<T> fadeRoute<T>(WidgetBuilder builder) => slideRoute<T>(builder);

// ─── Helpers ──────────────────────────────────────────────────────────────────

/// Push a placeholder screen for a feature that isn't built yet.
void pushUnderDevelopment(BuildContext context, {String title = 'No page'}) {
  Navigator.of(
    context,
  ).push(slideRoute((_) => UnderDevelopmentScreen(title: title)));
}

