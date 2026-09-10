import 'package:flutter/material.dart';

import '../navigation/fade_route.dart';
import 'lesson_measurement_tools.dart';
import 'lessons_intro_screen.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class LessonsScreen extends StatelessWidget {
  const LessonsScreen({super.key});

  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);

  static const _lessons = [
    (
      title: 'Introduction to\nMeasurement',
      duration: '10 MIN',
      difficulty: 'Easy',
      icon: Icons.straighten_rounded,
    ),
    (
      title: 'Measuring Tools',
      duration: '10 MIN',
      difficulty: 'Easy',
      icon: Icons.handyman_rounded,
    ),
    (
      title: 'Reading\nMeasurements',
      duration: '10 MIN',
      difficulty: 'Medium',
      icon: Icons.rule_rounded,
    ),
    (
      title: 'Measuring Lumber',
      duration: '10 MIN',
      difficulty: 'Medium',
      icon: Icons.view_agenda_rounded,
    ),
    (
      title: 'Layout and\nMarking',
      duration: '10 MIN',
      difficulty: 'Hard',
      icon: Icons.edit_rounded,
    ),
    (
      title: 'Measurement\nCalculations',
      duration: '10 MIN',
      difficulty: 'Hard',
      icon: Icons.calculate_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DesignCanvas(
      width: 409,
      height: 849,
      backgroundColor: Colors.white,
      children: [
        const Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            width: 409,
            height: 122,
            child: DecoratedBox(decoration: BoxDecoration(color: _navy)),
          ),
        ),
        const Positioned(
          left: 26,
          top: 64,
          child: Icon(Icons.menu_book_rounded, color: Colors.white, size: 30),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 68,
          child: Text(
            'Lessons',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.60,
            ),
          ),
        ),
        const Positioned(
          right: 28,
          top: 62,
          child: Icon(
            Icons.local_library_rounded,
            color: Colors.white,
            size: 32,
          ),
        ),
        for (var index = 0; index < _lessons.length; index++)
          _lessonCard(context, index, _lessons[index]),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _lessonCard(
    BuildContext context,
    int index,
    ({String title, String duration, String difficulty, IconData icon}) lesson,
  ) {
    final top = 142.0 + (index * 102.0);
    final difficultyColor = lesson.difficulty == 'Easy'
        ? const Color(0xFF16833A)
        : lesson.difficulty == 'Medium'
        ? _accent
        : const Color(0xFFE33B32);

    return Positioned(
      left: 16,
      top: top,
      child: Semantics(
        button: true,
        label: 'Open ${lesson.title.replaceAll('\n', ' ')}',
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            if (index == 0) {
              Navigator.of(
                context,
              ).push(fadeRoute((_) => const LessonsIntroScreen()));
              return;
            }
            if (index == 1) {
              Navigator.of(
                context,
              ).push(fadeRoute((_) => const LessonsMeasurementTools()));
              return;
            }
            pushUnderDevelopment(
              context,
              title: lesson.title.replaceAll('\n', ' '),
            );
          },
          child: Container(
            width: 377,
            height: 93,
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 96,
                  height: 68,
                  decoration: BoxDecoration(
                    color: _navy,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(lesson.icon, color: _accent, size: 38),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lesson.title,
                        style: const TextStyle(
                          color: _navy,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 1.12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule_rounded,
                            size: 14,
                            color: _navy,
                          ),
                          const SizedBox(width: 4),
                          Text(lesson.duration, style: _metadataStyle),
                          const SizedBox(width: 12),
                          Icon(Icons.circle, size: 8, color: difficultyColor),
                          const SizedBox(width: 4),
                          Text(
                            lesson.difficulty,
                            style: _metadataStyle.copyWith(
                              color: difficultyColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: _navy,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _metadataStyle = TextStyle(
    color: _navy,
    fontSize: 9,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    letterSpacing: 0.27,
  );
}
