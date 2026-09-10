import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../navigation/fade_route.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

typedef LessonMeasurementTools = LessonsMeasurementTools;

class LessonsMeasurementTools extends StatefulWidget {
  const LessonsMeasurementTools({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<LessonsMeasurementTools> createState() => _LessonsMeasurementToolsState();
}

class _LessonsMeasurementToolsState extends State<LessonsMeasurementTools> {
  static const _tabCount = 5;
  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);
  static const _lessonTitle = 'Lesson 2: Measuring Tools';

  late int _currentTab;
  late int _progressStep;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab.clamp(0, _tabCount);
    _progressStep = _currentTab;
  }

  @override
  Widget build(BuildContext context) {
    return DesignCanvas(
      width: 409,
      height: 849,
      backgroundColor: Colors.white,
      children: [
        // Top navy header bar
        const Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            width: 409,
            height: 122,
            child: DecoratedBox(decoration: BoxDecoration(color: _navy)),
          ),
        ),

        // Back button
        Positioned(
          left: 18,
          top: 55,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),

        // Screen title
        const Positioned(
          left: 70,
          right: 20,
          top: 69,
          child: Text(
            'Lesson 2 - Measuring Tools',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.54,
            ),
          ),
        ),

        // Lesson Progress label
        const Positioned(
          left: 28,
          top: 135,
          child: Text(
            'Lesson Progress',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 1.25,
              letterSpacing: 0.48,
            ),
          ),
        ),

        // Step count
        Positioned(
          left: 345,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        Positioned(
          left: 26,
          top: 163,
          child: Container(
            width: 356,
            height: 11,
            decoration: BoxDecoration(
              color: const Color(0xBAD9D9D9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor:
                    _tabCount == 0
                        ? 0
                        : (_progressStep / _tabCount).clamp(0.0, 1.0),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _accent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(
            width: 354,
            child: Divider(color: Color(0x3A000000)),
          ),
        ),

        // Lesson Heading
        const Positioned(
          left: 28,
          right: 28,
          top: 212,
          child: Text(
            'Lesson 2 - Measuring Tools',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 20,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0.60,
            ),
          ),
        ),

        // Lesson Image (measuring-tools)
        Positioned(
          left: 28,
          top: 252,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'lib/assets/images/measuring-tools.png',
              width: 351,
              height: 157,
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Learning Objective section heading
        const Positioned(
          left: 28,
          top: 441,
          child: Text(
            'Learning Objective',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: 0.48,
            ),
          ),
        ),

        // Objective bullet points
        const Positioned(
          left: 28,
          top: 467,
          child: SizedBox(
            width: 354,
            child: Text(
              'At the end of this lesson, learners should be able to:\n\n• Identify common measuring tools.\n• Tell the function of each tool.\n• Choose the correct tool for a task.\n• Use measuring tools safely.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Bottom divider above navigation button
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(
            width: 354,
            child: Divider(color: Color(0x3A000000)),
          ),
        ),

        // NEXT button
        Positioned(
          left: 270,
          top: 681,
          child: _IntroNavButton(
            label: 'NEXT',
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            disabled: _saving,
            onPressed: _advance,
          ),
        ),

        // Real Interactive Bottom Navigation Bar
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Future<void> _advance() async {
    if (_saving) return;
    setState(() => _saving = true);
    await _saveProgress(1);
    if (!mounted) return;
    setState(() => _saving = false);
    pushUnderDevelopment(context, title: 'Measuring Tools - Next Part');
  }

  Future<void> _saveProgress(int step) async {
    await UserStore.mutate((user) {
      final nextPercent = (step * 100 / _tabCount).round();
      return user.copyWith(
        currentLessonTitle: _lessonTitle,
        currentLessonProgressPercent:
            user.currentLessonProgressPercent > nextPercent
                ? user.currentLessonProgressPercent
                : nextPercent,
      );
    });
  }
}

class _IntroNavButton extends StatelessWidget {
  const _IntroNavButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.disabled = false,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 122,
      height: 48,
      child: ElevatedButton(
        onPressed: disabled ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          disabledBackgroundColor: backgroundColor.withValues(alpha: 0.6),
          disabledForegroundColor: foregroundColor.withValues(alpha: 0.7),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            maxLines: 1,
            softWrap: false,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }
}
