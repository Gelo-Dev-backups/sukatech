import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../models/user.dart';
import '../navigation/fade_route.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';
import '../widgets/skeleton.dart';

/// Main app landing page, shown after HomeScreen's loading animation.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  static const List<String> assetPaths = [
    'lib/assets/images/BOOK.png',
    'lib/assets/images/QUIZ.png',
    'lib/assets/images/tools menu.png',
    'lib/assets/images/achivements men.png',
    'lib/assets/images/settings.png',
    'lib/assets/images/ruler.png',
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

  static List<Widget> _progressCard(AppUser user) => [
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
      percent: user.overallProgressPercent / 100,
    ),
    Positioned(
      left: 258,
      top: 178,
      child: Text('${user.overallProgressPercent}%', style: _valueStyle),
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
  ];

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
            color: Colors.white.withValues(alpha: 0.10),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.black.withValues(alpha: 0.12)),
              borderRadius: BorderRadius.circular(20),
            ),
            shadows: const [
              BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
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
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => pushUnderDevelopment(context, title: 'No $label'),
        ),
      ),
    ];
  }

  // --- Continue learning card ------------------------------------------

  // Nothing behind this card yet, so tapping it opens the same
  // "Under Construction" placeholder the bottom nav uses.
  static List<Widget> _continueLearningCard(BuildContext context, AppUser user) => [
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
    const Positioned(
      left: 324,
      top: 484,
      child: SkeletonImage(
        'lib/assets/images/ruler.png',
        width: 50,
        height: 38,
      ),
    ),
    Positioned(
      left: 18,
      top: 464,
      width: 377,
      height: 77,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => pushUnderDevelopment(context, title: 'No Lesson'),
      ),
    ),
  ];

  // --- Category grid ----------------------------------------------------

  static List<Widget> _categoryGrid(BuildContext context) => [
    ..._categoryCard(
      context: context,
      left: 15,
      top: 551,
      icon: const SkeletonImage('lib/assets/images/BOOK.png', width: 52, height: 52),
      label: 'LESSONS',
    ),
    ..._categoryCard(
      context: context,
      left: 147,
      top: 551,
      icon: const SkeletonImage('lib/assets/images/PENCILMENU.png', width: 52, height: 52),
      label: 'PRACTICE',
    ),
    ..._categoryCard(
      context: context,
      left: 279,
      top: 551,
      icon: const SkeletonImage('lib/assets/images/QUIZ.png', width: 52, height: 52),
      label: 'QUIZ',
      labelFontSize: 16,
    ),
    ..._categoryCard(
      context: context,
      left: 15,
      top: 658,
      icon: const SkeletonImage('lib/assets/images/tools menu.png', width: 52, height: 52),
      label: 'MEASUREMENT\nTOOLS',
      labelFontSize: 11,
    ),
    ..._categoryCard(
      context: context,
      left: 147,
      top: 658,
      icon: const SkeletonImage('lib/assets/images/achivements men.png', width: 52, height: 52),
      label: 'ACHIEVEMENTS',
      labelFontSize: 11,
    ),
    ..._categoryCard(
      context: context,
      left: 279,
      top: 658,
      icon: const SkeletonImage('lib/assets/images/settings.png', width: 52, height: 52),
      label: 'SETTINGS',
    ),
  ];

  /// A rounded tile with a centered icon and label under it. All six
  /// category tiles share this exact layout, just with different content.
  // Nothing behind these yet, so tapping one opens the same
  // "Under Construction" placeholder the bottom nav uses.
  static List<Widget> _categoryCard({
    required BuildContext context,
    required double left,
    required double top,
    required Widget icon,
    required String label,
    double labelFontSize = 14,
  }) {
    const cardWidth = 116.0;
    const cardHeight = 96.0;
    const iconSize = 52.0;
    return [
      Positioned(
        left: left,
        top: top,
        child: Container(
          width: cardWidth,
          height: cardHeight,
          decoration: ShapeDecoration(
            color: Colors.white.withValues(alpha: 0.10),
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.black.withValues(alpha: 0.11)),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
      Positioned(
        left: left + (cardWidth - iconSize) / 2,
        top: top + 10,
        child: SizedBox(width: iconSize, height: iconSize, child: icon),
      ),
      Positioned(
        left: left,
        top: top + cardHeight - 24,
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
              letterSpacing: 0.42,
            ),
          ),
        ),
      ),
      Positioned(
        left: left,
        top: top,
        width: cardWidth,
        height: cardHeight,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => pushUnderDevelopment(
            context,
            title: 'No ${label.replaceAll('\n', ' ')}',
          ),
        ),
      ),
    ];
  }
}
