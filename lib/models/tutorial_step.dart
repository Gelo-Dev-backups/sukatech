import 'package:flutter/material.dart';

/// The geometry shape of the spotlight highlight cutout.
enum TutorialTargetShape {
  roundedRect,
  circle,
  rect,
}

/// Preferred placement of the floating instructional card relative to the target.
enum TutorialCardPosition {
  auto,
  above,
  below,
}

/// Defines a single step in a page tutorial.
class TutorialStep {
  const TutorialStep({
    required this.title,
    required this.description,
    required this.targetRect,
    this.icon = Icons.lightbulb_rounded,
    this.shape = TutorialTargetShape.roundedRect,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.all(6.0),
    this.preferredPosition = TutorialCardPosition.auto,
    this.actionText,
  });

  /// Step headline title.
  final String title;

  /// Instructional explanation text.
  final String description;

  /// Highlight target area in design canvas (409 x 849) coordinates.
  final Rect targetRect;

  /// Icon associated with the tutorial step.
  final IconData icon;

  /// Shape of the spotlight cutout and glowing halo.
  final TutorialTargetShape shape;

  /// Corner radius for [TutorialTargetShape.roundedRect].
  final double borderRadius;

  /// Extra padding surrounding the targetRect.
  final EdgeInsets padding;

  /// Preferred placement of the card relative to the target.
  final TutorialCardPosition preferredPosition;

  /// Custom button text for advancing (e.g. "Got It! 🎉").
  final String? actionText;

  /// Calculates the padded target rectangle.
  Rect get paddedRect => Rect.fromLTRB(
        targetRect.left - padding.left,
        targetRect.top - padding.top,
        targetRect.right + padding.right,
        targetRect.bottom + padding.bottom,
      );
}
