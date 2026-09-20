import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

typedef LessonMeasurementTools = LessonsMeasurementTools;
typedef LessonsMeasurementToolsPart1 = LessonsMeasurementTools;

/// Standalone entry point or tab representation for Lesson 2, Part 2 (Tape Measure).
class LessonsMeasurementToolsPart2 extends StatelessWidget {
  const LessonsMeasurementToolsPart2({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsMeasurementTools(initialTab: 1);
  }
}

/// Standalone entry point or tab representation for Lesson 2, Part 3 (Steel Rule).
class LessonsMeasurementToolsPart3 extends StatelessWidget {
  const LessonsMeasurementToolsPart3({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsMeasurementTools(initialTab: 2);
  }
}

/// Standalone entry point or tab representation for Lesson 2, Part 4 (Try Square).
class LessonsMeasurementToolsPart4 extends StatelessWidget {
  const LessonsMeasurementToolsPart4({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsMeasurementTools(initialTab: 3);
  }
}

/// Standalone entry point or tab representation for Lesson 2, Part 5 (Straight Edge).
class LessonsMeasurementToolsPart5 extends StatelessWidget {
  const LessonsMeasurementToolsPart5({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsMeasurementTools(initialTab: 4);
  }
}

/// Standalone entry point or tab representation for Lesson 2, Part 6 (Vernier Caliper).
class LessonsMeasurementToolsPart6 extends StatelessWidget {
  const LessonsMeasurementToolsPart6({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsMeasurementTools(initialTab: 5);
  }
}

/// Standalone entry point or tab representation for Lesson 2, Part 7 (Folding Rule).
class LessonsMeasurementToolsPart7 extends StatelessWidget {
  const LessonsMeasurementToolsPart7({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsMeasurementTools(initialTab: 6);
  }
}

/// Standalone entry point or tab representation for Lesson 2, Part 8 (Quick Review).
class LessonsMeasurementToolsPart8 extends StatelessWidget {
  const LessonsMeasurementToolsPart8({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsMeasurementTools(initialTab: 7);
  }
}

/// Standalone entry point or tab representation for Lesson 2, Part 9 (Lesson Summary).
class LessonsMeasurementToolsPart9 extends StatelessWidget {
  const LessonsMeasurementToolsPart9({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsMeasurementTools(initialTab: 8);
  }
}

class LessonsMeasurementTools extends StatefulWidget {
  const LessonsMeasurementTools({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<LessonsMeasurementTools> createState() =>
      _LessonsMeasurementToolsState();
}

class _LessonsMeasurementToolsState extends State<LessonsMeasurementTools> {
  static const _tabCount = 8;
  static const _navy = Color(0xFF061D3F);
  static const _progressGreen = Color(0xFF05831C);
  static const _lessonTitle = 'Lesson 2: Measuring Tools';

  late int _currentTab;
  late int _progressStep;
  bool _saving = false;

  int _stepForTab(int tab) {
    if (tab == 0) return 0;
    return tab.clamp(1, _tabCount);
  }

  @override
  void initState() {
    super.initState();
    // Always restore last active tab from UserStore (lesson-specific).
    // widget.initialTab is only used if no persisted tab exists yet.
    final savedTab = UserStore.current.value?.lessonLastTabs[_lessonTitle];
    final restoredTab = savedTab ?? widget.initialTab;
    _currentTab = restoredTab.clamp(0, _tabCount);
    _progressStep = _stepForTab(_currentTab);
  }

  void _selectTab(int tab) {
    setState(() {
      _currentTab = tab.clamp(0, _tabCount);
      _progressStep = _stepForTab(_currentTab);
    });
    _persistActiveTab(_currentTab);
  }

  Future<void> _persistActiveTab(int tab) async {
    await UserStore.mutate((user) {
      final newTabs = Map<String, int>.from(user.lessonLastTabs);
      newTabs[_lessonTitle] = tab;
      return user.copyWith(lessonLastTabs: newTabs);
    });
  }

  Future<void> _advance() async {
    if (_saving) return;

    if (_currentTab == 0) {
      setState(() => _saving = true);
      await _saveProgress(1, 1);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 1;
        _progressStep = 1;
      });
      return;
    }

    if (_currentTab == 1) {
      setState(() => _saving = true);
      await _saveProgress(2, 2);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 2;
        _progressStep = 2;
      });
      return;
    }

    if (_currentTab == 2) {
      setState(() => _saving = true);
      await _saveProgress(3, 3);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 3;
        _progressStep = 3;
      });
      return;
    }

    if (_currentTab == 3) {
      setState(() => _saving = true);
      await _saveProgress(4, 4);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 4;
        _progressStep = 4;
      });
      return;
    }

    if (_currentTab == 4) {
      setState(() => _saving = true);
      await _saveProgress(5, 5);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 5;
        _progressStep = 5;
      });
      return;
    }

    if (_currentTab == 5) {
      setState(() => _saving = true);
      await _saveProgress(6, 6);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 6;
        _progressStep = 6;
      });
      return;
    }

    if (_currentTab == 6) {
      setState(() => _saving = true);
      await _saveProgress(7, 7);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 7;
        _progressStep = 7;
      });
      return;
    }

    if (_currentTab == 7) {
      setState(() => _saving = true);
      await _saveProgress(8, 8);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 8;
        _progressStep = 8;
      });
      return;
    }

    // Advanced past tab 8 (Part 9 - Lesson Summary / DONE)
    setState(() => _saving = true);
    await UserStore.mutate((user) {
      final newTabs = Map<String, int>.from(user.lessonLastTabs);
      newTabs[_lessonTitle] = 8;

      final completed = List<String>.from(user.completedLessonsList);

      if (!completed.contains(_lessonTitle)) {
        completed.add(_lessonTitle);
      }

      final tabId = 'lesson_02_tab_08';
      final completedLessonTabs = List<String>.from(user.completedLessonTabs);
      int xpEarned = user.xpEarned;
      if (!completedLessonTabs.contains(tabId)) {
        completedLessonTabs.add(tabId);
        xpEarned += 10;
      }

      return user.copyWith(
        currentLessonTitle: _lessonTitle,
        currentLessonProgressPercent: 100,
        lessonsCompleted: completed.length,
        completedLessonsList: completed,
        lessonLastTabs: newTabs,
        completedLessonTabs: completedLessonTabs,
        xpEarned: xpEarned,
      );
    });
    if (!mounted) return;
    setState(() => _saving = false);
    Navigator.of(context).pop();
  }

  Future<void> _saveProgress(int step, int newTab) async {
    final completedTabId =
        'lesson_02_tab_${_currentTab.toString().padLeft(2, '0')}';

    await UserStore.mutate((user) {
      final nextPercent = (step * 100 / _tabCount).round();
      final newTabs = Map<String, int>.from(user.lessonLastTabs);
      newTabs[_lessonTitle] = newTab;

      final completedLessonTabs = List<String>.from(user.completedLessonTabs);
      int xpEarned = user.xpEarned;
      if (!completedLessonTabs.contains(completedTabId)) {
        completedLessonTabs.add(completedTabId);
        xpEarned += 10;
      }

      return user.copyWith(
        currentLessonTitle: _lessonTitle,
        currentLessonProgressPercent:
            user.currentLessonProgressPercent > nextPercent
            ? user.currentLessonProgressPercent
            : nextPercent,
        lessonLastTabs: newTabs,
        completedLessonTabs: completedLessonTabs,
        xpEarned: xpEarned,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTab == 1) {
      return _buildTapeMeasureTab(context);
    }
    if (_currentTab == 2) {
      return _buildSteelRuleTab(context);
    }
    if (_currentTab == 3) {
      return _buildTrySquareTab(context);
    }
    if (_currentTab == 4) {
      return _buildStraightEdgeTab(context);
    }
    if (_currentTab == 5) {
      return _buildVernierCaliperTab(context);
    }
    if (_currentTab == 6) {
      return _buildFoldingRuleTab(context);
    }
    if (_currentTab == 7) {
      return _buildQuickReviewTab(context);
    }
    if (_currentTab == 8) {
      return _buildSummaryTab(context);
    }
    return _buildIntroTab(context);
  }

  /// Tab 0: Lesson Objectives & Overview
  Widget _buildIntroTab(BuildContext context) {
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
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
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

        // Objective text
        const Positioned(
          left: 28,
          top: 467,
          child: SizedBox(
            width: 354,
            child: Text(
              'At the end of this lesson, learners should be able to:\n',
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

        // Objective bullet points
        const Positioned(
          left: 38,
          top: 477,
          child: SizedBox(
            width: 340,
            child: Text(
              '\n1. Identify common measuring tools.\n2. Tell the function of each tool.\n3. Choose the correct tool for a task.\n4. Use measuring tools safely.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 2.0,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Bottom divider above navigation button
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
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

  /// Tab 1 (Part 2): 1. Tape Measure
  Widget _buildTapeMeasureTab(BuildContext context) {
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

        // Back button — exits lesson
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

        // Step count (1/5)
        Positioned(
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Measuring Tools section category heading
        const Positioned(
          left: 0,
          right: 0,
          top: 216,
          child: Text(
            'Measuring Tools',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
        ),

        // 1. Tape Measure title
        const Positioned(
          left: 31,
          top: 273,
          child: Text(
            '1. Tape Measure',
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

        // Tool description
        const Positioned(
          left: 32,
          top: 306,
          child: SizedBox(
            width: 202,
            child: Text(
              'A tool used to measure long distances and large objects.',
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

        // Tape Measure Image
        Positioned(
          left: 246,
          top: 268,
          child: Image.asset(
            'lib/assets/images/tape-measure.png',
            width: 122,
            height: 106,
            fit: BoxFit.contain,
          ),
        ),

        // Uses section
        const Positioned(
          left: 32,
          top: 369,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Uses:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Measuring the length of wood\n• Measuring tables and rooms\n• Measuring height and width\n• Marking measurements before cutting',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Safety Tips section
        const Positioned(
          left: 31,
          top: 483,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Safety Tips:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Do not let the tape snap back quickly.\n• Keep fingers away from the metal edge.\n• Do not use a damaged tape measure.\n• Store it properly after use.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Remember callout
        const Positioned(
          left: 28,
          right: 28,
          top: 600,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Remember\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -0.15,
                  ),
                ),
                TextSpan(
                  text: 'Tape Measure = Long Measurements',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Bottom divider above navigation buttons
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // PREVIOUS button
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            disabled: _saving,
            onPressed: () => _selectTab(0),
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

  /// Tab 2 (Part 3): 2. Steel Rule
  Widget _buildSteelRuleTab(BuildContext context) {
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

        // Back button — exits lesson
        Positioned(
          left: 18,
          top: 55,
          child: IconButton(
            onPressed: () => _selectTab(1),
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

        // Step count (2/5)
        Positioned(
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Measuring Tools section category heading
        const Positioned(
          left: 0,
          right: 0,
          top: 216,
          child: Text(
            'Measuring Tools',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
        ),

        // 2. Steel Rule title
        const Positioned(
          left: 31,
          top: 273,
          child: Text(
            '2. Steel Rule',
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

        // Tool description
        const Positioned(
          left: 40,
          top: 306,
          child: SizedBox(
            width: 203,
            child: Text(
              'A rigid metal tool used to measure short distances.',
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

        // Tool Image (steel-rule)
        Positioned(
          left: 256,
          top: 265,
          child: Image.asset(
            'lib/assets/images/steel-rule.png',
            width: 113,
            height: 113,
            fit: BoxFit.contain,
          ),
        ),

        // Uses section
        const Positioned(
          left: 31,
          top: 372,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Uses:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Measuring small pieces of wood\n• Measuring metal or plastic\n• Making straight measurement marks\n• Measuring short lengths',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Safety Tips section
        const Positioned(
          left: 31,
          top: 483,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Safety Tips:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Handle the edges carefully.\n• Do not bend the rule.\n• Keep it clean.\n• Do not use it as a cutting tool.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Remember callout
        const Positioned(
          left: 28,
          right: 28,
          top: 600,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Remember\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -0.15,
                  ),
                ),
                TextSpan(
                  text: 'Steel Rule = Short Measurements',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Bottom divider above navigation buttons
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // PREVIOUS button
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            disabled: _saving,
            onPressed: () => _selectTab(1),
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

  /// Tab 3 (Part 4): Try Square
  Widget _buildTrySquareTab(BuildContext context) {
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

        // Back button — exits lesson
        Positioned(
          left: 18,
          top: 55,
          child: IconButton(
            onPressed: () => _selectTab(2),
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

        // Step count (3/5)
        Positioned(
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Measuring Tools section category heading
        const Positioned(
          left: 0,
          right: 0,
          top: 216,
          child: Text(
            'Measuring Tools',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
        ),

        // Try Square title
        const Positioned(
          left: 31,
          top: 273,
          child: Text(
            'Try Square',
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

        // Tool description
        const Positioned(
          left: 40,
          top: 306,
          child: SizedBox(
            width: 203,
            child: Text(
              'Used to check and mark 90° angles.',
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

        // Tool Image (try-square)
        Positioned(
          left: 233,
          top: 225,
          child: Image.asset(
            'lib/assets/images/try-square.png',
            width: 176,
            height: 176,
            fit: BoxFit.contain,
          ),
        ),

        // Uses section
        const Positioned(
          left: 31,
          top: 361,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Uses:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Checking if a corner is square\n• Marking straight lines\n• Checking the ends of wood\n• Checking joints and corners',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Safety Tips section
        const Positioned(
          left: 31,
          top: 477,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Safety Tips:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Keep it clean.\n• Do not drop it.\n• Do not use it as a hammer.\n• Store it properly.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Remember callout
        const Positioned(
          left: 28,
          right: 28,
          top: 590,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Remember\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -0.15,
                  ),
                ),
                TextSpan(
                  text: 'Try Square = 90° Angle',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Bottom divider above navigation buttons
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // PREVIOUS button
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            disabled: _saving,
            onPressed: () => _selectTab(2),
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

  /// Tab 4 (Part 5): 4. Straight Edge
  Widget _buildStraightEdgeTab(BuildContext context) {
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

        // Back button — exits lesson
        Positioned(
          left: 18,
          top: 55,
          child: IconButton(
            onPressed: () => _selectTab(3),
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

        // Step count (4/5)
        Positioned(
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Measuring Tools section category heading
        const Positioned(
          left: 0,
          right: 0,
          top: 216,
          child: Text(
            'Measuring Tools',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
        ),

        // 4. Straight Edge title
        const Positioned(
          left: 31,
          top: 273,
          child: Text(
            '4. Straight Edge',
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

        // Tool description
        const Positioned(
          left: 40,
          top: 306,
          child: SizedBox(
            width: 203,
            child: Text(
              'Used to check if an edge or surface is straight.',
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

        // Tool Image (straight-edge)
        Positioned(
          left: 227,
          top: 254,
          child: Image.asset(
            'lib/assets/images/straight-edge.png',
            width: 172,
            height: 119,
            fit: BoxFit.contain,
          ),
        ),

        // Uses section
        const Positioned(
          left: 31,
          top: 361,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Uses:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Checking straight boards\n• Checking flat surfaces\n• Checking alignment\n• Finding bends or gaps',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Safety Tips section
        const Positioned(
          left: 31,
          top: 477,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Safety Tips:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Do not bend or drop it.\n• Keep the edge clean.\n• Store it carefully.\n• Do not use it as a lever.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Remember callout
        const Positioned(
          left: 28,
          right: 28,
          top: 600,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Remember\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -0.15,
                  ),
                ),
                TextSpan(
                  text: 'Straight Edge = Checks Straightness',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Bottom divider above navigation buttons
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // PREVIOUS button
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            disabled: _saving,
            onPressed: () => _selectTab(3),
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

  /// Tab 5 (Part 6): 5. Vernier Caliper
  Widget _buildVernierCaliperTab(BuildContext context) {
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

        // Back button — exits lesson
        Positioned(
          left: 18,
          top: 55,
          child: IconButton(
            onPressed: () => _selectTab(4),
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

        // Step count (5/5)
        Positioned(
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Measuring Tools section category heading
        const Positioned(
          left: 0,
          right: 0,
          top: 216,
          child: Text(
            'Measuring Tools',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
        ),

        // 5. Vernier Caliper title
        const Positioned(
          left: 31,
          top: 273,
          child: Text(
            '5. Vernier Caliper',
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

        // Tool description
        const Positioned(
          left: 36,
          top: 304,
          child: SizedBox(
            width: 203,
            child: Text(
              'Used to make accurate measurements of small objects.',
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

        // Tool Image (venice-caliper)
        Positioned(
          left: 239,
          top: 250,
          child: Image.asset(
            'lib/assets/images/venice-caliper.png',
            width: 140,
            height: 140,
            fit: BoxFit.contain,
          ),
        ),

        // Uses section
        const Positioned(
          left: 31,
          top: 361,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Uses:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Measuring the thickness of materials\n• Measuring the diameter of a rod\n• Measuring the inside of a hole\n• Measuring depth',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Safety Tips section
        const Positioned(
          left: 31,
          top: 477,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Safety Tips:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Do not force the jaws.\n• Keep it clean.\n• Do not drop it.\n• Do not use it on moving objects.\n• Store it carefully.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Remember callout
        const Positioned(
          left: 20,
          right: 20,
          top: 600,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Remember\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -0.15,
                  ),
                ),
                TextSpan(
                  text: 'Vernier Caliper = Accurate Small Measurements',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.42,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Bottom divider above navigation buttons
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // PREVIOUS button
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            disabled: _saving,
            onPressed: () => _selectTab(4),
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

  /// Tab 6 (Part 7): 6. Folding Rule
  Widget _buildFoldingRuleTab(BuildContext context) {
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

        // Back button — exits lesson
        Positioned(
          left: 18,
          top: 55,
          child: IconButton(
            onPressed: () => _selectTab(5),
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

        // Step count (6/6)
        Positioned(
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Measuring Tools section category heading
        const Positioned(
          left: 0,
          right: 0,
          top: 216,
          child: Text(
            'Measuring Tools',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
        ),

        // 6. Folding Rule title
        const Positioned(
          left: 31,
          top: 273,
          child: Text(
            '6. Folding Rule',
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

        // Tool description
        const Positioned(
          left: 36,
          top: 304,
          child: SizedBox(
            width: 203,
            child: Text(
              'Used to measure length. It has sections that fold together.',
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

        // Tool Image (folding-rule)
        Positioned(
          left: 235,
          top: 254,
          child: Image.asset(
            'lib/assets/images/folding-rule.png',
            width: 145,
            height: 145,
            fit: BoxFit.contain,
          ),
        ),

        // Uses section
        const Positioned(
          left: 31,
          top: 361,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Uses:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Measuring wood\n• Measuring short and medium lengths\n• Carpentry work\n• Marking measurements',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Safety Tips section
        const Positioned(
          left: 31,
          top: 477,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Safety Tips:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '• Be careful with the folding joints.\n• Keep fingers away from the joints.\n• Do not force the rule.\n• Fold and store it properly.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Remember callout
        const Positioned(
          left: 20,
          right: 20,
          top: 600,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Remember\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                    letterSpacing: -0.15,
                  ),
                ),
                TextSpan(
                  text: 'Folding Rule = Foldable Measuring',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),

        // Bottom divider above navigation buttons
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // PREVIOUS button
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            disabled: _saving,
            onPressed: () => _selectTab(5),
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

  /// Tab 7 (Part 8): Quick Review
  Widget _buildQuickReviewTab(BuildContext context) {
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

        // Back button — exits lesson
        Positioned(
          left: 18,
          top: 55,
          child: IconButton(
            onPressed: () => _selectTab(6),
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

        // Step count (7/7)
        Positioned(
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Quick Review title
        const Positioned(
          left: 0,
          right: 0,
          top: 216,
          child: Text(
            'Quick Review',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
        ),

        // Quick Review subtitle
        const Positioned(
          left: 26,
          right: 26,
          top: 262,
          child: Text(
            'These tools are used to measure length, check angles, and ensure accuracy and straightness in construction and woodworking.',
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Summary Comparison Table
        Positioned(
          left: 23,
          top: 341,
          child: Container(
            width: 364,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 0,
                  offset: Offset(0, 0),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: -1,
                ),
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                  spreadRadius: -2,
                ),
              ],
            ),
            child: Table(
              border: TableBorder.all(color: const Color(0xFFCBD5E1), width: 1),
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Table Header
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFD1DBEA)),
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Tool',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Main Use',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                // Row 1: Tape Measure
                _buildQuickReviewTableRow(
                  tool: 'Tape Measure',
                  use: 'Measures long distances',
                ),
                // Row 2: Try Square
                _buildQuickReviewTableRow(
                  tool: 'Try Square',
                  use: 'Checks 90° angles',
                ),
                // Row 3: Straight Edge
                _buildQuickReviewTableRow(
                  tool: 'Straight Edge',
                  use: 'Checks straightness',
                ),
                // Row 4: Vernier Caliper
                _buildQuickReviewTableRow(
                  tool: 'Vernier Caliper',
                  use: 'Measures small objects accurately',
                ),
                // Row 5: Folding Rule
                _buildQuickReviewTableRow(
                  tool: 'Folding Rule',
                  use: 'Measures length and folds\nfor storage',
                ),
              ],
            ),
          ),
        ),

        // Bottom divider above navigation buttons
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // PREVIOUS button
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            disabled: _saving,
            onPressed: () => _selectTab(6),
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

  TableRow _buildQuickReviewTableRow({
    required String tool,
    required String use,
  }) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          alignment: Alignment.centerLeft,
          child: Text(
            tool,
            style: const TextStyle(
              color: _navy,
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            use,
            style: const TextStyle(
              color: _navy,
              fontSize: 13,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 1.25,
            ),
          ),
        ),
      ],
    );
  }

  /// Tab 8 (Part 9): Lesson Summary
  Widget _buildSummaryTab(BuildContext context) {
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

        // Back button — exits lesson
        Positioned(
          left: 18,
          top: 55,
          child: IconButton(
            onPressed: () => _selectTab(7),
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

        // Step count (8/8)
        Positioned(
          right: 28,
          top: 134,
          child: Text(
            '$_progressStep/$_tabCount',
            textAlign: TextAlign.right,
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
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Lesson Summary heading
        const Positioned(
          left: 0,
          right: 0,
          top: 216,
          child: Text(
            'Lesson Summary',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.72,
            ),
          ),
        ),

        // Summary content text
        const Positioned(
          left: 28,
          top: 270,
          child: SizedBox(
            width: 354,
            child: Text(
              '      In this lesson, we learned about common measuring tools and their functions. We learned that each tool is used for a specific purpose. A tape measure is used for long measurements, a steel rule and folding rule are used for measuring lengths, a try square checks 90° angles, a straight edge checks straightness, and a vernier caliper makes accurate measurements of small objects.\n\nWe also learned the importance of choosing the correct measuring tool and using it safely. Proper handling, cleaning, and storage of tools help keep them in good condition and prevent accidents.',
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.64,
                letterSpacing: 0.42,
              ),
            ),
          ),
        ),

        // Bottom divider above navigation buttons
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // PREVIOUS button
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            disabled: _saving,
            onPressed: () => _selectTab(7),
          ),
        ),

        // DONE button
        Positioned(
          left: 270,
          top: 681,
          child: _IntroNavButton(
            label: 'DONE',
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
}

class _IntroNavButton extends StatelessWidget {
  const _IntroNavButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.borderColor,
    this.disabled = false,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color? borderColor;
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
            side: borderColor != null
                ? BorderSide(color: borderColor!, width: 1)
                : BorderSide.none,
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

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.step, required this.tabCount});

  final int step;
  final int tabCount;

  @override
  Widget build(BuildContext context) {
    final percent = tabCount == 0 ? 0.0 : (step / tabCount).clamp(0.0, 1.0);
    return SizedBox(
      width: 356,
      height: 11,
      child: Stack(
        children: [
          Container(
            width: 356,
            height: 11,
            decoration: BoxDecoration(
              color: const Color(0xBAD9D9D9),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          if (percent > 0)
            Container(
              width: (356 * percent).clamp(11.0, 356.0),
              height: 11,
              decoration: BoxDecoration(
                color: _LessonsMeasurementToolsState._progressGreen,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
        ],
      ),
    );
  }
}
