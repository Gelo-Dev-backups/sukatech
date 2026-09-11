import 'package:flutter/material.dart';

import '../data/course_data.dart';
import '../data/user_store.dart';
import '../models/user.dart';
import '../navigation/fade_route.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';
import '../widgets/skeleton.dart';
import 'achievements_screen.dart';
import 'lesson_measurement_tools.dart';
import 'lessons_intro_screen.dart';
import 'lessons_screen.dart';

/// Main app landing page, shown after HomeScreen's loading animation.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const List<String> assetPaths = [
    'lib/assets/images/mountaine wf;ag.svg',
  ];

  static const _navy = Color(0xFF061D3F);
  static const _progressGreen = Color(0xFF05831C);
  static const _trackGrey = Color(0xBAD9D9D9);

  static const _valueStyle = TextStyle(
    color: _navy,
    fontSize: 20,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    letterSpacing: 0.60,
  );

  static const _statLabelStyle = TextStyle(
    color: _navy,
    fontSize: 9,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    letterSpacing: 0.27,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: UserStore.current,
      builder: (context, user, _) {
        // main() awaits UserStore.load() before runApp, so this is always
        // populated by the time any screen builds.
        final currentUser = user!;
        return DesignCanvas(
          width: 409,
          height: 849,
          backgroundColor: Colors.white,
          children: [
            ..._header(currentUser),
            ..._progressCard(currentUser),
            const Positioned(
              left: 26,
              top: 270,
              child: Text(
                'Dashboard',
                style: TextStyle(
                  color: _navy,
                  fontSize: 16,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.48,
                ),
              ),
            ),
            ..._statsRow(context, currentUser),
            ..._continueLearningCard(context, currentUser),
            ..._categoryGrid(context),
            const DashboardBottomNavBar(currentTab: DashboardTab.home),
          ],
        );
      },
    );
  }

  // --- Header -------------------------------------------------------

  static List<Widget> _header(AppUser user) => [
    Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: 409,
        height: 255,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, 0.46),
            end: Alignment(0.50, 1.30),
            colors: [_navy, Colors.white, Colors.white],
          ),
        ),
      ),
    ),
    const Positioned(
      left: 26,
      top: 65,
      child: SizedBox(
        width: 38,
        height: 32,
        child: Icon(Icons.home_rounded, color: Colors.white, size: 28),
      ),
    ),
    Positioned(
      left: 100,
      top: 70,
      child: Text(
        'Welcome, ${user.name}! 👋',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.54,
        ),
      ),
    ),
    const Positioned(
      left: 346,
      top: 64,
      child: SizedBox(
        width: 34,
        height: 34,
        child: Icon(Icons.settings_rounded, color: Colors.white, size: 28),
      ),
    ),
  ];

  // --- Overall progress card -----------------------------------------

  static List<Widget> _progressCard(AppUser user) {
    final totalLessons = CourseData.totalLessons;
    // Completed lessons contribute 100 points each.
    // The active lesson contributes its partial percent as points,
    // but only if it is NOT already in completedLessonsList (avoid double-count).
    final int completedPoints = user.completedLessonsList.length * 100;
    final bool currentAlreadyDone =
        user.completedLessonsList.contains(user.currentLessonTitle);
    final int partialPoints =
        currentAlreadyDone ? 0 : user.currentLessonProgressPercent;
    final int calculatedProgress =
        ((completedPoints + partialPoints) / (totalLessons * 100) * 100)
            .clamp(0, 100)
            .toInt();
                                   
    return [
    Positioned(
      left: 14,
      top: 124,
      child: Container(
        width: 382,
        height: 132,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          shadows: const [
            BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
          ],
        ),
      ),
    ),
    Positioned(
      left: 227,
      top: 138,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: const SkeletonSvg(
          'lib/assets/images/mountaine wf;ag.svg',
          width: 169,
          height: 118,
          fit: BoxFit.cover,
        ),
      ),
    ),
    const Positioned(
      left: 34,
      top: 144,
      child: Text(
        'Overall Progress',
        style: TextStyle(
          color: _navy,
          fontSize: 18,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.54,
        ),
      ),
    ),
    ..._progressBar(
      left: 34,
      top: 183,
      width: 219,
      height: 13,
      percent: calculatedProgress / 100,
    ),
    Positioned(
      left: 258,
      top: 178,
      child: Text('$calculatedProgress%', style: _valueStyle),
    ),
    const Positioned(
      left: 36,
      top: 213,
      child: Text(
        'Great job! Keep it up!',
        style: TextStyle(
          color: _navy,
          fontSize: 14,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.42,
        ),
      ),
    ),
  ];
  }

  /// A rounded track + a proportional fill, sharing one shape so the fill
  /// width is always derived from [percent] instead of a hand-tuned number.
  static List<Widget> _progressBar({
    required double left,
    required double top,
    required double width,
    required double height,
    required double percent,
  }) {
    final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(20));
    return [
      Positioned(
        left: left,
        top: top,
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(color: _trackGrey, shape: shape),
        ),
      ),
      Positioned(
        left: left,
        top: top,
        child: Container(
          width: width * percent,
          height: height,
          decoration: ShapeDecoration(color: _progressGreen, shape: shape),
        ),
      ),
    ];
  }

  // --- Streak stats row -----------------------------------------------

  static List<Widget> _statsRow(BuildContext context, AppUser user) => [
    ..._statBadge(
      context: context,
      cardLeft: 18,
      circleLeft: 51,
      circleColor: const Color(0xFF419D52),
      icon: Icons.menu_book_rounded,
      value: '${user.lessonsCompleted}',
      valueLeft: 63,
      label: 'Lessons Completed',
      labelLeft: 26,
    ),
    ..._statBadge(
      context: context,
      cardLeft: 149,
      circleLeft: 182,
      circleColor: const Color(0xFF4369B2),
      icon: Icons.fact_check_rounded,
      value: '${user.quizzesTaken}',
      valueLeft: 197,
      label: 'Quizzes Passed',
      labelLeft: 168,
    ),
    ..._statBadge(
      context: context,
      cardLeft: 279,
      circleLeft: 314,
      circleColor: const Color(0xFFF7CA5B),
      icon: Icons.star_rounded,
      value: '${user.xpEarned}',
      valueLeft: 319,
      label: 'XP Earned',
      labelLeft: 312,
    ),
  ];

  // Nothing behind these yet, so tapping one opens the same
  // "Under Construction" placeholder the bottom nav uses.
  static List<Widget> _statBadge({
    required BuildContext context,
    required double cardLeft,
    required double circleLeft,
    required Color circleColor,
    required IconData icon,
    required String value,
    required double valueLeft,
    required String label,
    required double labelLeft,
  }) {
    const cardTop = 304.0;
    const cardSize = 116.0;
    const circleTop = 318.0;
    const circleSize = 45.0;
    const iconSize = 24.0;
    return [
      Positioned(
        left: cardLeft,
        top: cardTop,
        child: Container(
          width: cardSize,
          height: cardSize,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.black.withValues(alpha: 0.08)),
              borderRadius: BorderRadius.circular(20),
            ),
            shadows: const [
              BoxShadow(color: Color(0x1F000000), blurRadius: 4, offset: Offset(0, 4)),
            ],
          ),
        ),
      ),
      Positioned(
        left: circleLeft,
        top: circleTop,
        child: Container(
          width: circleSize,
          height: circleSize,
          decoration: ShapeDecoration(color: circleColor, shape: const OvalBorder()),
        ),
      ),
      Positioned(
        left: circleLeft + (circleSize - iconSize) / 2,
        top: circleTop + (circleSize - iconSize) / 2,
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
      Positioned(left: valueLeft, top: 367, child: Text(value, style: _valueStyle)),
      Positioned(left: labelLeft, top: 392, child: Text(label, style: _statLabelStyle)),
      Positioned(
        left: cardLeft,
        top: cardTop,
        width: cardSize,
        height: cardSize,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => pushUnderDevelopment(context, title: 'No $label'),
          ),
        ),
      ),
    ];
  }

  // --- Continue learning card ------------------------------------------

  static List<Widget> _continueLearningCard(BuildContext context, AppUser user) {
    IconData lessonIcon = Icons.menu_book_rounded;
    if (user.currentLessonTitle.contains('Measuring Tools')) {
      lessonIcon = Icons.square_foot_rounded;
    } else if (user.currentLessonTitle.contains('Parts')) {
      lessonIcon = Icons.widgets_rounded;
    } else if (user.currentLessonTitle.contains('Reading')) {
      lessonIcon = Icons.straighten_rounded;
    } else if (user.currentLessonTitle.contains('Marking')) {
      lessonIcon = Icons.draw_rounded;
    } else if (user.currentLessonTitle.contains('Calculation')) {
      lessonIcon = Icons.calculate_rounded;
    }

    return [
      const Positioned(
        left: 26,
        top: 433,
        child: Text(
          'Continue Learning',
          style: TextStyle(
            color: _navy,
            fontSize: 14,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
            letterSpacing: 0.42,
          ),
        ),
      ),
      Positioned(
        left: 18,
        top: 464,
        child: Container(
          width: 377,
          height: 77,
          decoration: ShapeDecoration(
            color: const Color(0xFFF6F6F6),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.black.withValues(alpha: 0.12)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      Positioned(
        left: 30,
        top: 478,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF0F3260),
                Color(0xFF061D3F),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFFFA500).withValues(alpha: 0.30),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: _navy.withValues(alpha: 0.18),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              lessonIcon,
              color: const Color(0xFFFFA500),
              size: 24,
            ),
          ),
        ),
      ),
      Positioned(
        left: 88,
        top: 478,
        child: SizedBox(
          width: 220,
          child: Text(
            user.currentLessonTitle,
            style: const TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 1.2,
              letterSpacing: 0.42,
            ),
          ),
        ),
      ),
    ..._progressBar(
      left: 88,
      top: 511,
      width: 191,
      height: 11,
      percent: user.currentLessonProgressPercent / 100,
    ),
    Positioned(
      left: 286,
      top: 509,
      child: Text(
        '${user.currentLessonProgressPercent}%',
        style: const TextStyle(
          color: _navy,
          fontSize: 12,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.36,
        ),
      ),
    ),
    Positioned(
      left: 332,
      top: 480,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: _navy,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: _navy.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Center(
          child: Icon(
            Icons.play_arrow_rounded,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    ),
    Positioned(
      left: 18,
      top: 464,
      width: 377,
      height: 77,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (user.currentLessonTitle.contains('Measuring Tools')) {
              Navigator.of(context).push(
                fadeRoute((_) => const LessonsMeasurementTools()),
              );
            } else if (user.currentLessonTitle.contains('Introduction')) {
              Navigator.of(context).push(
                fadeRoute((_) => const LessonsIntroScreen()),
              );
            } else {
              pushUnderDevelopment(context, title: user.currentLessonTitle);
            }
          },
        ),
      ),
    ),
  ];
  }

  // --- Category grid ----------------------------------------------------

  static List<Widget> _categoryGrid(BuildContext context) => [
    ..._categoryCard(
      context: context,
      left: 15,
      top: 551,
      icon: Icons.menu_book_rounded,
      badgeColor: const Color(0xFF061D3F),
      label: 'LESSONS',
      onTap: () => Navigator.of(context).push(
        fadeRoute((_) => const LessonsScreen()),
      ),
    ),
    ..._categoryCard(
      context: context,
      left: 147,
      top: 551,
      icon: Icons.architecture_rounded,
      badgeColor: const Color(0xFFD97706),
      label: 'PRACTICE',
      onTap: () => pushUnderDevelopment(context, title: 'Practice'),
    ),
    ..._categoryCard(
      context: context,
      left: 279,
      top: 551,
      icon: Icons.quiz_rounded,
      badgeColor: const Color(0xFF7C3AED),
      label: 'QUIZ',
      labelFontSize: 16,
      onTap: () => pushUnderDevelopment(context, title: 'Quiz'),
    ),
    ..._categoryCard(
      context: context,
      left: 15,
      top: 658,
      icon: Icons.square_foot_rounded,
      badgeColor: const Color(0xFF0284C7),
      label: 'MEASUREMENT\nTOOLS',
      labelFontSize: 11,
      onTap: () => Navigator.of(context).push(
        fadeRoute((_) => const LessonsMeasurementTools()),
      ),
    ),
    ..._categoryCard(
      context: context,
      left: 147,
      top: 658,
      icon: Icons.emoji_events_rounded,
      badgeColor: const Color(0xFFF59E0B),
      label: 'ACHIEVEMENTS',
      labelFontSize: 11,
      onTap: () => Navigator.of(context).push(fadeRoute((_) => const AchievementsScreen())),
    ),
    ..._categoryCard(
      context: context,
      left: 279,
      top: 658,
      icon: Icons.settings_rounded,
      badgeColor: const Color(0xFF64748B),
      label: 'SETTINGS',
      onTap: () => pushUnderDevelopment(context, title: 'Settings'),
    ),
  ];

  /// A rounded tile with a centered icon badge and label under it. All six
  /// category tiles share this exact layout with matching card styling.
  static List<Widget> _categoryCard({
    required BuildContext context,
    required double left,
    required double top,
    required IconData icon,
    required Color badgeColor,
    required String label,
    required VoidCallback onTap,
    double labelFontSize = 14,
  }) {
    const cardWidth = 116.0;
    const cardHeight = 96.0;
    const circleSize = 42.0;
    const iconSize = 22.0;
    final isDoubleLine = label.contains('\n');
    final labelTop = isDoubleLine ? top + cardHeight - 34 : top + cardHeight - 26;

    return [
      Positioned(
        left: left,
        top: top,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: Colors.black.withValues(alpha: 0.08),
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x1F000000),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        left: left + (cardWidth - circleSize) / 2,
        top: top + 10,
        child: Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: badgeColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: badgeColor.withValues(alpha: 0.30),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: Colors.white, size: iconSize),
          ),
        ),
      ),
      Positioned(
        left: left,
        top: labelTop,
        child: SizedBox(
          width: cardWidth,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: labelFontSize,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.35,
              height: 1.1,
            ),
          ),
        ),
      ),
      Positioned(
        left: left,
        top: top,
        width: cardWidth,
        height: cardHeight,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
          ),
        ),
      ),
    ];
  }
}
