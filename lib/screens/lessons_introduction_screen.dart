import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

typedef LessonsIntro = LessonsIntroScreen;

/// Standalone entry point or tab representation for Lesson 1, Tab 2 (Mensuration).
class LessonsIntroNextTabMensuration extends StatelessWidget {
  const LessonsIntroNextTabMensuration({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 1);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 3 (Carpentry Measurement).
class LessonsIntroNextTabCarpentryMeasurement extends StatelessWidget {
  const LessonsIntroNextTabCarpentryMeasurement({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 2);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 4 (Accurate Measurement Part 1).
class LessonsIntroNextTabCarpentryAccurate extends StatelessWidget {
  const LessonsIntroNextTabCarpentryAccurate({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 3);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 5 (Accurate Measurement Part 2).
class LessonsIntroNextTabCarpentryAccuratePart2 extends StatelessWidget {
  const LessonsIntroNextTabCarpentryAccuratePart2({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 4);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 6 (Carpentry Terms Part 1).
class LessonsIntroNextTabCarpentryTerms extends StatelessWidget {
  const LessonsIntroNextTabCarpentryTerms({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 5);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 7 (Carpentry Terms Part 2).
class LessonsIntroNextTabCarpentryTermsPart2 extends StatelessWidget {
  const LessonsIntroNextTabCarpentryTermsPart2({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 6);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 8 (Measurement Systems).
class LessonsIntroNextTabMeasurementSystems extends StatelessWidget {
  const LessonsIntroNextTabMeasurementSystems({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 7);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 9 (Measurement Systems Part 2).
class LessonsIntroNextTabMeasurementSystemsPart2 extends StatelessWidget {
  const LessonsIntroNextTabMeasurementSystemsPart2({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 8);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 10 (Measurement Systems Part 3).
class LessonsIntroNextTabMeasurementSystemsPart3 extends StatelessWidget {
  const LessonsIntroNextTabMeasurementSystemsPart3({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 9);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 11 (Measurement Systems Part 4).
class LessonsIntroNextTabMeasurementSystemsPart4 extends StatelessWidget {
  const LessonsIntroNextTabMeasurementSystemsPart4({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 10);
  }
}

/// Standalone entry point or tab representation for Lesson 1, Tab 12 (Lesson Summary).
class LessonsIntroNextTabLessonSummary extends StatelessWidget {
  const LessonsIntroNextTabLessonSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return const LessonsIntroScreen(initialTab: 11);
  }
}

class LessonsIntroScreen extends StatefulWidget {
  const LessonsIntroScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<LessonsIntroScreen> createState() => _LessonsIntroScreenState();
}

class _LessonsIntroScreenState extends State<LessonsIntroScreen> {
  static const _tabCount = 12;
  static const _navy = Color(0xFF061D3F);
  static const _lessonTitle = 'Lesson 1: Introduction to Measurement';

  late int _currentTab;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final savedTab = UserStore.current.value?.lessonLastTabs[_lessonTitle];
    final restoredTab = savedTab ?? widget.initialTab;
    _currentTab = restoredTab.clamp(0, _tabCount - 1);
  }

  void _selectTab(int tab) {
    setState(() {
      _currentTab = tab.clamp(0, _tabCount - 1);
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
      await _saveProgress(2, 1);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 1;
      });
      return;
    }

    if (_currentTab == 1) {
      setState(() => _saving = true);
      await _saveProgress(3, 2);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 2;
      });
      return;
    }

    if (_currentTab == 2) {
      setState(() => _saving = true);
      await _saveProgress(4, 3);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 3;
      });
      return;
    }

    if (_currentTab == 3) {
      setState(() => _saving = true);
      await _saveProgress(5, 4);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 4;
      });
      return;
    }

    if (_currentTab == 4) {
      setState(() => _saving = true);
      await _saveProgress(6, 5);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 5;
      });
      return;
    }

    if (_currentTab == 5) {
      setState(() => _saving = true);
      await _saveProgress(7, 6);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 6;
      });
      return;
    }

    if (_currentTab == 6) {
      setState(() => _saving = true);
      await _saveProgress(8, 7);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 7;
      });
      return;
    }

    if (_currentTab == 7) {
      setState(() => _saving = true);
      await _saveProgress(9, 8);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 8;
      });
      return;
    }

    if (_currentTab == 8) {
      setState(() => _saving = true);
      await _saveProgress(10, 9);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 9;
      });
      return;
    }

    if (_currentTab == 9) {
      setState(() => _saving = true);
      await _saveProgress(11, 10);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 10;
      });
      return;
    }

    if (_currentTab == 10) {
      setState(() => _saving = true);
      await _saveProgress(12, 11);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = 11;
      });
      return;
    }

    // Advanced past tab 11 (Tab 12 - Lesson Summary / DONE)
    setState(() => _saving = true);
    await UserStore.mutate((user) {
      final newTabs = Map<String, int>.from(user.lessonLastTabs);
      newTabs[_lessonTitle] = 11;

      final completed = List<String>.from(user.completedLessonsList);
      if (!completed.contains(_lessonTitle)) {
        completed.add(_lessonTitle);
      }

      final tabId = 'lesson_01_tab_11';
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
        'lesson_01_tab_${_currentTab.toString().padLeft(2, '0')}';

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
      return _buildMensurationTab(context);
    }
    if (_currentTab == 2) {
      return _buildCarpentryMeasurementTab(context);
    }
    if (_currentTab == 3) {
      return _buildAccurateMeasurementTab(context);
    }
    if (_currentTab == 4) {
      return _buildAccurateMeasurementPart2Tab(context);
    }
    if (_currentTab == 5) {
      return _buildCarpentryTermsTab(context);
    }
    if (_currentTab == 6) {
      return _buildCarpentryTermsPart2Tab(context);
    }
    if (_currentTab == 7) {
      return _buildMeasurementSystemsTab(context);
    }
    if (_currentTab == 8) {
      return _buildMeasurementSystemsPart2Tab(context);
    }
    if (_currentTab == 9) {
      return _buildMeasurementSystemsPart3Tab(context);
    }
    if (_currentTab == 10) {
      return _buildMeasurementSystemsPart4Tab(context);
    }
    if (_currentTab == 11) {
      return _buildLessonSummaryTab(context);
    }
    return _buildIntroTab(context);
  }

  /// Tab 0: Lesson Objectives & Overview (0/10)
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '0/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 0, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Title
        const Positioned(
          left: 62,
          top: 202,
          child: Text(
            'INTRODUCTION TO \nCARPENTRY MEASUREMENT',
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

        // Illustration image
        Positioned(
          left: 28,
          top: 266,
          child: Container(
            width: 357,
            height: 176,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/learningobj.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),

        // Learning Objective section heading
        const Positioned(
          left: 31,
          top: 459,
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

        // Learning Objective text
        const Positioned(
          left: 31,
          top: 485,
          child: SizedBox(
            width: 345,
            height: 157,
            child: Text(
              '''At the end of this lesson, learners should be able to:

          Explain the importance of accurate measurement in carpentry and identify common measurement terms and units used in carpentry.''',
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

        // Bottom divider
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

  /// Tab 1: What is Mensuration? (2/10)
  Widget _buildMensurationTab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '2/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 2, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // What is Mensuration? heading
        const Positioned(
          left: 28,
          top: 205,
          child: Text(
            'What is Mensuration?',
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

        // Rotated illustration image
        Positioned(
          left: 136.58,
          top: 206.58,
          child: Container(
            transform: Matrix4.rotationZ(0.08),
            width: 182.76,
            height: 179.60,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/mensuration.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

        // Paragraph 1
        const Positioned(
          left: 28,
          top: 333,
          child: SizedBox(
            width: 341,
            height: 61,
            child: Text(
              '      Mensuration is the process of measuring the size, length, area, volume, or other dimensions of an object.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Paragraph 2
        const Positioned(
          left: 30,
          top: 399,
          child: SizedBox(
            width: 339,
            height: 61,
            child: Text(
              '      In carpentry, mensuration is important because carpenters need to determine the correct dimensions of materials and structures.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Example Section
        const Positioned(
          left: 27,
          top: 478,
          child: SizedBox(
            width: 362,
            height: 124,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 0.60,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        'A carpenter may need to determine:\n 1. The length of a wooden board\n 2. The width of a table\n 3. The height of a cabinet\n 4. The thickness of a piece of wood',
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

        // Callout
        const Positioned(
          left: 24,
          top: 600,
          child: SizedBox(
            width: 362,
            height: 124,
            child: Text(
              'Mensuration = measuring things and finding their dimensions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w800,
                height: 1.07,
                letterSpacing: -0.15,
              ),
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 665,
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

  /// Tab 2: What is Carpentry Measurement? (3/10)
  Widget _buildCarpentryMeasurementTab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '3/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 3, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // What is Carpentry Measurement? heading
        const Positioned(
          left: 0,
          right: 0,
          top: 205,
          child: Text(
            'What is Carpentry Measurement?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 19,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.05,
              letterSpacing: 0.57,
            ),
          ),
        ),

        // Illustration image
        Positioned(
          left: 131,
          top: 242,
          child: Container(
            width: 147,
            height: 116,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/tape-measure.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Definition paragraph 1
        const Positioned(
          left: 27,
          top: 368,
          child: SizedBox(
            width: 355,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Carpentry measurement',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' is the process of finding the size or dimensions of materials and objects used in carpentry.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Definition paragraph 2
        const Positioned(
          left: 28,
          top: 434,
          child: SizedBox(
            width: 354,
            child: Text(
              '      Carpentry measurement is the process of finding the size or dimensions of materials and objects used in carpentry.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Example Section
        const Positioned(
          left: 26,
          top: 505,
          child: SizedBox(
            width: 356,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        '       If a carpenter needs a piece of wood that is 2 meters long, the carpenter must measure the wood accurately before cutting it.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // REMEMBER Callout
        const Positioned(
          left: 24,
          top: 600,
          child: SizedBox(
            width: 361,
            height: 79,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'REMEMBER : \n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: '      Measure first before you cut!',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 665,
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

  /// Tab 3: Why is Accurate Measurement Important? (4/10)
  Widget _buildAccurateMeasurementTab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '4/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 4, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Heading
        const Positioned(
          left: 20,
          top: 205,
          child: SizedBox(
            width: 369,
            child: Text(
              'Why is Accurate Measurement Important?',
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
        ),

        // Illustration image
        Positioned(
          left: 84,
          top: 261,
          child: Container(
            width: 242,
            height: 106,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/accurate.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Paragraph 1
        const Positioned(
          left: 28,
          top: 394,
          child: SizedBox(
            width: 349,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Accurate measurement',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' is very important in carpentry because it helps produce correct, safe, and quality work.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // List section
        const Positioned(
          left: 28,
          top: 478,
          child: SizedBox(
            width: 349,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Accurate measurement helps to:\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.20,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: '1. Get the correct size\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Materials can be cut according to the required dimensions.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: '2. Prevent mistakes\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Correct measurements reduce errors during cutting and construction.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 665,
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

  /// Tab 4: Why is Accurate Measurement Important? (Part 2) (5/10)
  Widget _buildAccurateMeasurementPart2Tab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '5/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 5, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Heading
        const Positioned(
          left: 20,
          top: 205,
          child: SizedBox(
            width: 369,
            child: Text(
              'Why is Accurate Measurement Important?',
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
        ),

        // Points 4 & 5 section
        const Positioned(
          left: 35,
          top: 310,
          child: SizedBox(
            width: 341,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Accurate measurement helps to:\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.20,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: '4. Make parts fit properly\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Proper measurements help wooden parts fit together correctly.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: '5. Produce quality work\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Accurate measurements result in neat and precise carpentry projects.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.20,
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
          left: 34,
          top: 537,
          child: SizedBox(
            width: 341,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Remember:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text:
                        'A small measurement error can affect the entire project.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 16.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 665,
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

  /// Tab 5: Common Measurement Terms Part 1 (6/10)
  Widget _buildCarpentryTermsTab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '6/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 6, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Screen heading
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Common Measurement Terms',
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
        ),

        // Intro paragraph
        const Positioned(
          left: 30,
          top: 253,
          child: SizedBox(
            width: 341,
            child: Text(
              'Carpenters use different terms when describing the size of an object.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 1.33,
                letterSpacing: -0.15,
              ),
            ),
          ),
        ),

        // Term 1: Length
        const Positioned(
          left: 30,
          top: 314,
          child: Text(
            'Length',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              height: 1.20,
              letterSpacing: -0.15,
            ),
          ),
        ),

        // Length definition
        const Positioned(
          left: 30,
          top: 345,
          child: SizedBox(
            width: 189,
            child: Text(
              'Length is the distance from one end of an object to the other end.',
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 1.33,
                letterSpacing: -0.15,
              ),
            ),
          ),
        ),

        // Length example
        const Positioned(
          left: 30,
          top: 418,
          child: SizedBox(
            width: 195,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: 'The length of a wooden board is ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: '2 meters.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Length illustration image
        Positioned(
          left: 229,
          top: 335,
          child: Container(
            width: 145,
            height: 130,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/length-terms.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Term 2: Width
        const Positioned(
          left: 30,
          top: 493,
          child: Text(
            'Width',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              height: 1.20,
              letterSpacing: -0.15,
            ),
          ),
        ),

        // Width definition
        const Positioned(
          left: 29,
          top: 520,
          child: SizedBox(
            width: 189,
            child: Text(
              'Width is the distance from one side of an object to the other side.',
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 1.33,
                letterSpacing: -0.15,
              ),
            ),
          ),
        ),

        // Width example
        const Positioned(
          left: 29,
          top: 585,
          child: SizedBox(
            width: 195,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: 'A wooden board may have a width of ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: '20 centimeters.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Width illustration image
        Positioned(
          left: 228,
          top: 515,
          child: Container(
            width: 155,
            height: 90,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/width-terms.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 667,
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

  /// Tab 6: Common Measurement Terms Part 2 (Height & Thickness) (7/10)
  Widget _buildCarpentryTermsPart2Tab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '7/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 7, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Screen heading
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Common Measurement Terms',
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
        ),

        // Term 1: Height
        const Positioned(
          left: 30,
          top: 264,
          child: Text(
            'Height',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              height: 1.20,
              letterSpacing: -0.15,
            ),
          ),
        ),

        // Height definition
        const Positioned(
          left: 30,
          top: 295,
          child: SizedBox(
            width: 175,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Height',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: ' is the distance from the ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: 'bottom to the top',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: ' of an object.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Height example
        const Positioned(
          left: 30,
          top: 368,
          child: SizedBox(
            width: 180,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: 'A cabinet may have a height of ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: '1.5 meters.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Height illustration image
        Positioned(
          left: 195,
          top: 295,
          child: Container(
            width: 196,
            height: 95,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/height-terms.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Term 2: Thickness
        const Positioned(
          left: 30,
          top: 451,
          child: Text(
            'Thickness',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w800,
              height: 1.20,
              letterSpacing: -0.15,
            ),
          ),
        ),

        // Thickness definition
        const Positioned(
          left: 29,
          top: 480,
          child: SizedBox(
            width: 175,
            child: Text(
              'Thickness is the distance between the two opposite surfaces of an object.',
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 1.33,
                letterSpacing: -0.15,
              ),
            ),
          ),
        ),

        // Thickness example
        const Positioned(
          left: 29,
          top: 550,
          child: SizedBox(
            width: 180,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: 'A wooden board may have a thickness of ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                  TextSpan(
                    text: '25 millimeters.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: -0.15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Thickness illustration image
        Positioned(
          left: 212,
          top: 485,
          child: Container(
            width: 185,
            height: 70,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/thickness-terms.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 667,
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

  /// Tab 7: Measurement Systems - Metric System (SI) (8/10)
  Widget _buildMeasurementSystemsTab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '8/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 8, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Screen heading
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Measurement Systems',
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
        ),

        // Intro paragraph
        const Positioned(
          left: 24,
          top: 248,
          child: SizedBox(
            width: 360,
            child: Text(
              'There are two common measurement systems introduced in this lesson:',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.43,
                letterSpacing: -0.14,
              ),
            ),
          ),
        ),

        // Measurement Systems illustration image
        Positioned(
          left: 39,
          top: 293,
          child: Container(
            width: 330,
            height: 141,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/measurement systems.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Subheading: A. Metric System (SI)
        const Positioned(
          left: 32,
          top: 444,
          child: SizedBox(
            width: 369,
            child: Text(
              'A. Metric System (SI)',
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
        ),

        // Description
        const Positioned(
          left: 28,
          top: 474,
          child: SizedBox(
            width: 354,
            child: Text(
              '        The Metric System, also called the International System of Units (SI), is commonly used for measurement.',
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.43,
                letterSpacing: -0.14,
              ),
            ),
          ),
        ),

        // Units
        const Positioned(
          left: 26,
          top: 535,
          child: SizedBox(
            width: 356,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'The common units are:\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.43,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: '• Millimeter (mm)\n• Centimeter (cm)\n• Meter (m)',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.6,
                      letterSpacing: -0.14,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 667,
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

  /// Tab 8: Measurement Systems - Millimeter & Centimeter (9/10)
  Widget _buildMeasurementSystemsPart2Tab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '9/10',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 9, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Screen heading
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Measurement Systems',
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
        ),

        // Millimeter (mm) title
        const Positioned(
          left: 32,
          top: 262,
          child: SizedBox(
            width: 357,
            child: Text(
              'Millimeter (mm)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Millimeter description
        const Positioned(
          left: 28,
          top: 296,
          child: SizedBox(
            width: 192,
            child: Text(
              '         A millimeter is a small unit of length. It is useful for measuring small dimensions, such as the thickness of materials.',
              style: TextStyle(
                color: _navy,
                fontSize: 13,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.54,
                letterSpacing: -0.13,
              ),
            ),
          ),
        ),

        // Millimeter image
        Positioned(
          left: 227,
          top: 298,
          child: Container(
            width: 162,
            height: 66,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/milimeter.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Millimeter Example
        const Positioned(
          left: 30,
          top: 402,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                  TextSpan(
                    text: 'A board may be 25 mm thick.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Centimeter (cm) title
        const Positioned(
          left: 32,
          top: 474,
          child: SizedBox(
            width: 357,
            child: Text(
              'Centimeter (cm)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Centimeter description
        const Positioned(
          left: 30,
          top: 508,
          child: SizedBox(
            width: 192,
            child: Text(
              '       A centimeter is larger than a millimeter. It can be used to measure smaller objects and dimensions.',
              style: TextStyle(
                color: _navy,
                fontSize: 13,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.54,
                letterSpacing: -0.13,
              ),
            ),
          ),
        ),

        // Centimeter image
        Positioned(
          left: 218,
          top: 508,
          child: Container(
            width: 174,
            height: 71,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/centimeter.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Centimeter Example
        const Positioned(
          left: 28,
          top: 597,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                  TextSpan(
                    text: 'The width of a board may be 20 cm.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 667,
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

  /// Tab 9: Measurement Systems - Meter & English System (10/11)
  Widget _buildMeasurementSystemsPart3Tab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '10/12',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 10, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Screen heading
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Measurement Systems',
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
        ),

        // Meter (m) title
        const Positioned(
          left: 32,
          top: 262,
          child: SizedBox(
            width: 357,
            child: Text(
              'Meter (m)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Meter description
        const Positioned(
          left: 28,
          top: 298,
          child: SizedBox(
            width: 192,
            child: Text(
              '        A meter is used to measure longer distances or larger objects.',
              style: TextStyle(
                color: _navy,
                fontSize: 13,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.54,
                letterSpacing: -0.13,
              ),
            ),
          ),
        ),

        // Meter illustration image
        Positioned(
          left: 220,
          top: 291,
          child: Container(
            width: 160,
            height: 68,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/meter.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Meter Example
        const Positioned(
          left: 32,
          top: 368,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                  TextSpan(
                    text: 'A wooden board may be 2 m long.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Subheading: B. English System
        const Positioned(
          left: 32,
          top: 450,
          child: SizedBox(
            width: 369,
            child: Text(
              'B. English System ',
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
        ),

        // English System description
        const Positioned(
          left: 35,
          top: 486,
          child: SizedBox(
            width: 360,
            height: 39,
            child: Text(
              '      English System is a measurement system that uses units such as inches, and feet.',
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.43,
                letterSpacing: -0.14,
              ),
            ),
          ),
        ),

        // Common units rich text
        const Positioned(
          left: 25,
          top: 553,
          child: SizedBox(
            width: 360,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'The common units are:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.43,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: '• Inch (in)\n• Foot (ft)',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.57,
                      letterSpacing: -0.14,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 667,
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
            onPressed: () => _selectTab(8),
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

  /// Tab 10: Measurement Systems - Inch & Foot (11/11)
  Widget _buildMeasurementSystemsPart4Tab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '11/12',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 11, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Screen heading
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Measurement Systems',
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
        ),

        // Inch (in) title
        const Positioned(
          left: 32,
          top: 281,
          child: SizedBox(
            width: 357,
            child: Text(
              'Inch (in)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Inch description
        const Positioned(
          left: 26,
          top: 317,
          child: SizedBox(
            width: 192,
            child: Text(
              '     An inch is a unit used to measure length',
              style: TextStyle(
                color: _navy,
                fontSize: 13,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.54,
                letterSpacing: -0.13,
              ),
            ),
          ),
        ),

        // Inch illustration image
        Positioned(
          left: 212,
          top: 322,
          child: Container(
            width: 177,
            height: 71,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/inches.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Inch Example
        const Positioned(
          left: 30,
          top: 383,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                  TextSpan(
                    text: 'A piece of wood may be 12 inches long.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Foot (ft) title
        const Positioned(
          left: 32,
          top: 474,
          child: SizedBox(
            width: 357,
            child: Text(
              'Foot (ft)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),

        // Foot description
        const Positioned(
          left: 30,
          top: 508,
          child: SizedBox(
            width: 192,
            child: Text(
              '     A foot is a larger unit than an inch and is commonly used to describe longer dimensions.',
              style: TextStyle(
                color: _navy,
                fontSize: 13,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.54,
                letterSpacing: -0.13,
              ),
            ),
          ),
        ),

        // Foot illustration image
        Positioned(
          left: 222,
          top: 521,
          child: Container(
            width: 171,
            height: 77,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/foot.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Foot Example
        const Positioned(
          left: 30,
          top: 601,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                  TextSpan(
                    text: 'A board may be 6 feet long.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.69,
                      letterSpacing: -0.13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 667,
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
            onPressed: () => _selectTab(9),
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

  /// Tab 11: Lesson Summary (12/12)
  Widget _buildLessonSummaryTab(BuildContext context) {
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
            'Introduction to Measurement',
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
        const Positioned(
          right: 28,
          top: 134,
          child: Text(
            '12/12',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.42,
            ),
          ),
        ),

        // Progress bar
        const Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: 12, tabCount: _tabCount),
        ),

        // Divider under progress
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),

        // Screen heading: ⭐ Lesson Summary ⭐
        const Positioned(
          left: 20,
          top: 222,
          child: SizedBox(
            width: 369,
            child: Text(
              '⭐ Lesson Summary ⭐',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 24,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 0.83,
                letterSpacing: 0.72,
              ),
            ),
          ),
        ),

        // Subheading: Before moving to the next lesson, remember:
        const Positioned(
          left: 28,
          top: 267,
          child: SizedBox(
            width: 353,
            child: Text(
              'Before moving to the next lesson, remember:',
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 1.29,
                letterSpacing: -0.14,
              ),
            ),
          ),
        ),

        // Summary bullet points
        const Positioned(
          left: 36,
          top: 300,
          child: SizedBox(
            width: 337,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Carpentry measurement',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: ' helps determine the correct size and dimensions of materials.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: 'Mensuration',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: ' is the process of measuring and finding the dimensions of objects.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: 'Accurate measurement',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: ' helps prevent mistakes, reduce waste, and produce quality carpentry work.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: 'Common terms: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: 'Length, Width, Height, and Thickness.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: 'Metric units: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: 'mm, cm, and m.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: 'English units: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: 'in and ft.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13.5,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.3,
                      letterSpacing: -0.14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Carpenter's Reminder callout
        const Positioned(
          left: 36,
          top: 608,
          child: SizedBox(
            width: 337,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "🔨 CARPENTER'S REMINDER\n",
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: -0.14,
                    ),
                  ),
                  TextSpan(
                    text: '“Measure accurately before you cut!”',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                      letterSpacing: -0.14,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),

        // Divider above buttons
        const Positioned(
          left: 28,
          top: 667,
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
            onPressed: () => _selectTab(10),
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
                color: const Color(0xFF05831C),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
        ],
      ),
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
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.48,
            ),
          ),
        ),
      ),
    );
  }
}
