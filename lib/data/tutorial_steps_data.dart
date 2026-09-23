import 'package:flutter/material.dart';

import '../models/tutorial_step.dart';
import '../services/tutorial_service.dart';

/// Predefined tutorial steps for each screen in the app.
class TutorialStepsData {
  TutorialStepsData._();

  static List<TutorialStep> getStepsFor(TutorialPage page) {
    switch (page) {
      case TutorialPage.dashboard:
        return _dashboardSteps;
      case TutorialPage.lessons:
        return _lessonsSteps;
      case TutorialPage.practice:
        return _practiceSteps;
      case TutorialPage.quiz:
        return _quizSteps;
      case TutorialPage.converter:
        return _converterSteps;
      case TutorialPage.achievements:
        return _achievementsSteps;
      case TutorialPage.profile:
        return _profileSteps;
    }
  }

  // ── Dashboard ──────────────────────────────────────────────────────────────
  static const List<TutorialStep> _dashboardSteps = [
    TutorialStep(
      title: 'Welcome to SUKATECH!',
      description:
          'Your interactive carpentry measurement companion. Check your profile, rank title, and quick settings anytime from the top bar.',
      targetRect: Rect.fromLTWH(18, 56, 373, 50),
      icon: Icons.waving_hand_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 18,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Overall Progress & Mastery',
      description:
          'See your overall measurement completion percentage and earned XP. As you finish lessons and pass quizzes, your carpentry rank grows!',
      targetRect: Rect.fromLTWH(14, 110, 381, 140),
      icon: Icons.military_tech_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Real-Time Learning Stats',
      description:
          'Quickly check your stats: total completed lessons, hands-on practice runs, and passed knowledge quizzes at a glance.',
      targetRect: Rect.fromLTWH(14, 292, 381, 80),
      icon: Icons.insights_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 16,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Continue Learning',
      description:
          'Never lose your spot! Tap this card anytime to jump straight back into your current lesson or interactive practice drill.',
      targetRect: Rect.fromLTWH(14, 388, 381, 110),
      icon: Icons.play_circle_filled_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 18,
      preferredPosition: TutorialCardPosition.above,
    ),
    TutorialStep(
      title: 'Curriculum Categories',
      description:
          'Explore structured modules: Measuring Tools, Reading Measurements, Unit Conversions, Calculations, and Hands-on Drills.',
      targetRect: Rect.fromLTWH(14, 510, 381, 240),
      icon: Icons.grid_view_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.above,
    ),
    TutorialStep(
      title: 'Quick Unit Converter',
      description:
          'Need a fast calculation on the job? Tap this raised center button anytime for instant Metric, Imperial, and lumber conversions!',
      targetRect: Rect.fromLTWH(174, 765, 60, 60),
      icon: Icons.calculate_rounded,
      shape: TutorialTargetShape.circle,
      preferredPosition: TutorialCardPosition.above,
    ),
    TutorialStep(
      title: 'Easy Bottom Navigation',
      description:
          'Switch seamlessly between Home, Lessons, Awards, Practice drills, Quizzes, and your Profile using this bottom bar.',
      targetRect: Rect.fromLTWH(0, 765, 409, 84),
      icon: Icons.explore_rounded,
      shape: TutorialTargetShape.rect,
      preferredPosition: TutorialCardPosition.above,
      actionText: 'Get Started! 🚀',
    ),
  ];

  // ── Lessons ────────────────────────────────────────────────────────────────
  static const List<TutorialStep> _lessonsSteps = [
    TutorialStep(
      title: 'Carpentry Lessons Catalog',
      description:
          '6 in-depth lessons covering Measurement Basics, Tools, Parts & Functions, Reading Tapes, Unit Conversion, and Calculations.',
      targetRect: Rect.fromLTWH(18, 56, 373, 50),
      icon: Icons.menu_book_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 18,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Interactive Lesson Modules',
      description:
          'Tap any lesson card to start reading! Each module includes clear illustrations, detailed explanations, and practical carpentry tips.',
      targetRect: Rect.fromLTWH(16, 142, 377, 94),
      icon: Icons.auto_stories_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Difficulty & Pages Info',
      description:
          'Each lesson shows difficulty level (Easy, Medium, Hard) and page counts. Complete them at your own pace to unlock quiz challenges!',
      targetRect: Rect.fromLTWH(16, 244, 377, 94),
      icon: Icons.speed_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
      actionText: 'Got It! 📖',
    ),
  ];

  // ── Practice ───────────────────────────────────────────────────────────────
  static const List<TutorialStep> _practiceSteps = [
    TutorialStep(
      title: 'Hands-On Practice Mode',
      description:
          'Put theory into practice! Interactive drills simulate real carpentry measurement tasks to build your precision and confidence.',
      targetRect: Rect.fromLTWH(18, 56, 373, 50),
      icon: Icons.edit_note_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 18,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Read the Tape Measure',
      description:
          'Practice reading sixteenths, eighths, quarters, and inches on high-resolution interactive tape measures.',
      targetRect: Rect.fromLTWH(16, 142, 377, 94),
      icon: Icons.straighten_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Locate & Mark Measurements',
      description:
          'Test your precision by finding exact measurement points on tape measures, measuring lumber pieces, and choosing the right tools.',
      targetRect: Rect.fromLTWH(16, 244, 377, 94),
      icon: Icons.carpenter_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
      actionText: 'Start Practicing! 🔨',
    ),
  ];

  // ── Quiz ───────────────────────────────────────────────────────────────────
  static const List<TutorialStep> _quizSteps = [
    TutorialStep(
      title: 'Knowledge Quizzes',
      description:
          'Test your mastery on each carpentry lesson topic. Each quiz contains 10 questions covering key measurement principles.',
      targetRect: Rect.fromLTWH(18, 56, 373, 60),
      icon: Icons.fact_check_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 18,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Score 70% or Higher to Pass',
      description:
          'Pass quizzes with a score of 70% or higher to unlock special achievements, earn XP, and climb the ranks of carpentry mastery!',
      targetRect: Rect.fromLTWH(16, 142, 377, 94),
      icon: Icons.stars_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
      actionText: 'Ready for Quizzes! 🎯',
    ),
  ];

  // ── Unit Converter ─────────────────────────────────────────────────────────
  static const List<TutorialStep> _converterSteps = [
    TutorialStep(
      title: 'Carpentry Unit Converter',
      description:
          'A dedicated calculator built for carpenters and builders. Convert between Metric and Imperial units instantaneously.',
      targetRect: Rect.fromLTWH(18, 56, 373, 50),
      icon: Icons.calculate_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 18,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Measurement Categories',
      description:
          'Switch categories: Length, Volume, Weight, Lumber dimensions (nominal vs actual), Angle degrees, and Nail/Screw gauges.',
      targetRect: Rect.fromLTWH(0, 130, 409, 56),
      icon: Icons.category_rounded,
      shape: TutorialTargetShape.rect,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Instant Conversion & Quick Swap',
      description:
          'Type in any number and pick your units. Tap the swap button to invert conversion directions instantly.',
      targetRect: Rect.fromLTWH(16, 198, 377, 310),
      icon: Icons.sync_alt_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Carpentry Reference Guide',
      description:
          'View quick reference conversion charts and lumber sizing formulas for fast lookups on the worksite.',
      targetRect: Rect.fromLTWH(16, 530, 377, 215),
      icon: Icons.menu_book_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.above,
      actionText: 'Got It! 📐',
    ),
  ];

  // ── Achievements ───────────────────────────────────────────────────────────
  static const List<TutorialStep> _achievementsSteps = [
    TutorialStep(
      title: 'Awards & Badges',
      description:
          'Celebrate your carpentry milestones! Earn prestigious badges as you finish lessons, maintain answer streaks, and score 100%.',
      targetRect: Rect.fromLTWH(18, 56, 373, 94),
      icon: Icons.emoji_events_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 18,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Unlock Criteria',
      description:
          'Browse through all available achievements. Tap any badge to see its requirements, description, and your unlock status.',
      targetRect: Rect.fromLTWH(16, 178, 377, 90),
      icon: Icons.lock_open_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
      actionText: 'Aim for Trophies! 🏆',
    ),
  ];

  // ── Profile ────────────────────────────────────────────────────────────────
  static const List<TutorialStep> _profileSteps = [
    TutorialStep(
      title: 'Learner Profile & Rank',
      description:
          'Customize your learner name and view your current mastery title: from Measurement Novice to Measurement Master!',
      targetRect: Rect.fromLTWH(18, 54, 373, 120),
      icon: Icons.person_pin_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Lifetime Learning Record',
      description:
          'Review your total completed lessons, quizzes taken, and practice sessions finished throughout your learning journey.',
      targetRect: Rect.fromLTWH(14, 189, 382, 123),
      icon: Icons.bar_chart_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.below,
    ),
    TutorialStep(
      title: 'Audio Settings & Replay Tours',
      description:
          'Adjust background music volume, sound effects volume, reset your progress, or replay app tutorials anytime!',
      targetRect: Rect.fromLTWH(14, 328, 382, 380),
      icon: Icons.settings_suggest_rounded,
      shape: TutorialTargetShape.roundedRect,
      borderRadius: 20,
      preferredPosition: TutorialCardPosition.above,
      actionText: 'Explore SUKATECH! 🌟',
    ),
  ];
}
