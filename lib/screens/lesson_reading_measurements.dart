import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class LessonsReadingMeasurements extends StatefulWidget {
  const LessonsReadingMeasurements({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<LessonsReadingMeasurements> createState() =>
      _LessonsReadingMeasurementsState();
}

class _LessonsReadingMeasurementsState
    extends State<LessonsReadingMeasurements> {
  static const _tabCount = 11; // Will increase as we add more tabs
  static const _navy = Color(0xFF061D3F);
  static const _lessonTitle = 'Lesson 4: Reading Measurements';

  late int _currentTab;
  late int _progressStep;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final savedTab = UserStore.current.value?.lessonLastTabs[_lessonTitle];
    final restoredTab = savedTab ?? widget.initialTab;
    _currentTab = restoredTab.clamp(0, _tabCount - 1);
    _progressStep = _stepForTab(_currentTab);
  }

  int _stepForTab(int tab) {
    return (tab + 1).clamp(1, _tabCount);
  }

  void _selectTab(int tab) {
    setState(() {
      _currentTab = tab.clamp(0, _tabCount - 1);
      _progressStep = _stepForTab(_currentTab);
    });
    UserStore.mutate((user) {
      final newTabs = Map<String, int>.from(user.lessonLastTabs);
      newTabs[_lessonTitle] = tab;
      return user.copyWith(lessonLastTabs: newTabs);
    });
  }

  Future<void> _saveProgress(int step, int newTab) async {
    final completedTabId =
        'lesson_04_tab_${_currentTab.toString().padLeft(2, '0')}';

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

      int finalPercent = user.currentLessonProgressPercent > nextPercent
          ? user.currentLessonProgressPercent
          : nextPercent;
      if (finalPercent > 100) finalPercent = 100;

      return user.copyWith(
        currentLessonTitle: _lessonTitle,
        currentLessonProgressPercent: finalPercent,
        lessonLastTabs: newTabs,
        completedLessonTabs: completedLessonTabs,
        xpEarned: xpEarned,
      );
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
        _progressStep = 2;
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
        _progressStep = 3;
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
        _progressStep = 4;
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
        _progressStep = 5;
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
        _progressStep = 6;
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
        _progressStep = 7;
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
        _progressStep = 8;
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
        _progressStep = 9;
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
        _progressStep = 10;
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
        _progressStep = 11;
      });
      return;
    }

    if (_currentTab == 10) {
      setState(() => _saving = true);
      await UserStore.mutate((user) {
        final newTabs = Map<String, int>.from(user.lessonLastTabs);
        newTabs[_lessonTitle] = 10;

        final completed = List<String>.from(user.completedLessonsList);
        if (!completed.contains(_lessonTitle)) {
          completed.add(_lessonTitle);
        }

        final tabId = 'lesson_04_tab_10';
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
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTab == 10) {
      return _buildKeyPointsTab(context);
    }
    if (_currentTab == 9) {
      return _buildAccuracyTab(context);
    }
    if (_currentTab == 8) {
      return _buildEnglishMeasurementTab(context);
    }
    if (_currentTab == 7) {
      return _buildMetricMeasurementTab(context);
    }
    if (_currentTab == 6) {
      return _buildDecimalMeasurementsTab(context);
    }
    if (_currentTab == 5) {
      return _buildTypesOfMeasurementsTab(context);
    }
    if (_currentTab == 4) {
      return _buildVernierCaliperTab(context);
    }
    if (_currentTab == 3) {
      return _buildTrySquareTab(context);
    }
    if (_currentTab == 2) {
      return _buildSteelRuleTab(context);
    }
    if (_currentTab == 1) {
      return _buildPullPushRuleTab(context);
    }
    if (_currentTab == 0) {
      return _buildIntroTab(context);
    }
    return _buildIntroTab(context); // Fallback
  }

  Widget _buildIntroTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 212,
          child: Text(
            'Learning Objective',
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
        const Positioned(
          left: 33,
          top: 248,
          child: SizedBox(
            width: 345,
            child: Text(
              'At the end of this lesson, the students should be able to:\n\n     Read and interpret measurements accurately using common measuring tools and identify whole-number, fractional, decimal, metric, and English measurements.',
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
        ),
        const Positioned(
          left: 32,
          top: 405,
          child: Text(
            'Introduction',
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
        const Positioned(
          left: 32,
          top: 437,
          child: SizedBox(
            width: 345,
            child: Text(
              'In carpentry, accurate measurement is essential before cutting, marking, or assembling materials. A carpenter must be able to read measuring tools correctly to ensure that materials are prepared according to the required size.\n\nCommon measuring tools used in carpentry include the tape measure, steel rule, try square, and vernier caliper.',
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
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildPullPushRuleTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 206,
          child: Text(
            'I. Reading Common\nMeasuring Tool',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.1,
              letterSpacing: 0.66,
            ),
          ),
        ),
        const Positioned(
          left: 20,
          right: 20,
          top: 272,
          child: Text(
            'How to Read a Pull Push Rule',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        Positioned(
          left: 110,
          top: 299,
          child: Container(
            width: 189,
            height: 98,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/pull-push.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 20,
          top: 405,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Step 1: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Place the hook at the starting edge of the material.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 2: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Extend the blade along the material.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 3: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Keep the blade straight and properly aligned.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 4: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Identify the number closest to the end of the material.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 5: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Count the smaller markings after the whole number.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 6: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Combine the whole number with the appropriate fraction or decimal.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 7: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Record the measurement together with its unit.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 25,
          top: 594,
          child: SizedBox(
            width: 366,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'If the end of the material is halfway between ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '5 inches and 6 inches: Measurement = 5 ½ inches',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(0),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildSteelRuleTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 206,
          child: Text(
            'I. Reading Common\nMeasuring Tool',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 0.91,
              letterSpacing: 0.66,
            ),
          ),
        ),
        const Positioned(
          left: 25,
          right: 25,
          top: 273,
          child: Text(
            'How to Read a Steel Rule',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        Positioned(
          left: 155,
          top: 298,
          child: Container(
            width: 109,
            height: 109,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/steel-rule.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 20,
          top: 411,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Step 1: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Place the end of the rule at the starting point.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 2: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Make sure the rule is straight and properly aligned.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 3: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Look at the measurement markings.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 4: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Identify the marking where the material ends.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 5: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Read the measurement.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 6: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Record the measurement with the correct unit.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 544,
          child: SizedBox(
            width: 366,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'If the edge of the material reaches the ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '15 cm mark:\nMeasurement = 15 cm\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'If it reaches the ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '18 cm and 5 mm mark:\nMeasurement = 18.5 cm',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(1),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildTrySquareTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 206,
          child: Text(
            'I. Reading Common\nMeasuring Tool',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 0.91,
              letterSpacing: 0.66,
            ),
          ),
        ),
        const Positioned(
          left: 25,
          right: 25,
          top: 273,
          child: Text(
            'How to Use a Try Square',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        Positioned(
          left: 126,
          top: 266,
          child: Container(
            width: 158,
            height: 158,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/try-square.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 411,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Step 1: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Place the stock firmly against the edge of the material.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 2: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Make sure the stock is flat against the surface.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 3: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Hold the try square securely.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 4: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Use the blade as a guide when making a mark.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 5: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Check that the marked line forms a 90-degree angle with the edge.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 16,
          top: 532,
          child: SizedBox(
            width: 366,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'If you need to mark a line across a piece of wood, place the stock against the edge and mark along the blade.\nThe line should form a ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '90° angle',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: ' with the edge.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 23,
          top: 603,
          child: SizedBox(
            width: 366,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Remember:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'A try square is mainly used for checking squareness and marking, rather than measuring length.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(2),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildVernierCaliperTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 206,
          child: Text(
            'I. Reading Common\nMeasuring Tool',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 0.91,
              letterSpacing: 0.66,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 266,
          child: SizedBox(
            width: 353,
            child: Text(
              'How to Read a Vernier Caliper',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 1.43,
                letterSpacing: 0.42,
              ),
            ),
          ),
        ),
        Positioned(
          left: 138,
          top: 276,
          child: Container(
            width: 135,
            height: 135,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/veniercaliper.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 419,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Step 1: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Place the object between the appropriate jaws.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 2: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Adjust the jaws until they make proper contact with the object.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 3: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Read the measurement on the main scale.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 4: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Read the additional measurement indicated by the vernier scale.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 5: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Combine the main-scale and vernier-scale readings.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Step 6: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'Record the final measurement with the correct unit.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 21,
          top: 589,
          child: SizedBox(
            width: 366,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'If the main scale reads ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '20 mm',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: ' and the vernier scale adds ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '0.5 mm:\nMeasurement = 20.5 mm',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(3),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildTypesOfMeasurementsTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 215,
          child: Text(
            'II. Types of Measurements',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 0.91,
              letterSpacing: 0.66,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 263,
          child: Text(
            'A. Whole - Number Measurements',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 295,
          child: SizedBox(
            width: 357,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'A ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'whole-number measurement',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' is a measurement expressed using a complete number without a fraction or decimal.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 354,
          child: SizedBox(
            width: 357,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Examples:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '5 cm\n10 cm\n25 cm\n30 inches',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 144,
          top: 354,
          child: SizedBox(
            width: 255,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Examples:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: 'If the material reaches exactly the ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '20 cm mark: Measurement = 20 cm',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 452,
          child: Text(
            'B. Fractional Measurements',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 483,
          child: SizedBox(
            width: 357,
            child: Text(
              'A fraction represents a part of a whole. Fractions are commonly found when reading measurements in inches.',
              style: TextStyle(
                color: _navy,
                fontSize: 12,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 1.42,
                letterSpacing: 0.36,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 542,
          child: SizedBox(
            width: 357,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Common Fractions\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '1/2 inch\n1/4 inch\n1/8 inch\n3/4 inch\n3/8 inch',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 173,
          top: 542,
          child: SizedBox(
            width: 198,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Examples:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text:
                        'If the measurement is between 8 inches and 9 inches, and the mark is halfway between them: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 11,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.55,
                      letterSpacing: 0.33,
                    ),
                  ),
                  TextSpan(
                    text: 'Measurement = 20 cm 8 1/2 inches',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 11,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.55,
                      letterSpacing: 0.33,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(4),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildDecimalMeasurementsTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 215,
          child: Text(
            'II. Types of Measurements',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 0.91,
              letterSpacing: 0.66,
            ),
          ),
        ),
        const Positioned(
          left: 33,
          top: 263,
          child: Text(
            'C. Decimal Measurements',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 295,
          child: SizedBox(
            width: 357,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'A ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'decimal measurement',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: ' uses a decimal point to express a part of a unit.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 348,
          child: SizedBox(
            width: 357,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Examples:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: '5.5 cm\n10.25 cm\n15.5 mm\n20.75 inches',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 33,
          top: 451,
          child: SizedBox(
            width: 255,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Examples:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'If the measurement reads ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: '12.5 cm:\nMeasurement = 12.5 cm\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Since:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: '0.5 cm = 5 mm\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'then:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: '12.5 cm = 12 cm and 5 mm',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(5),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildMetricMeasurementTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 205,
          child: Text(
            'III. Reading Metric \nMeasurement',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 21,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 0.95,
              letterSpacing: 0.63,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 324,
          child: Text(
            'Common Metric Units',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 435,
          child: Text(
            'Important Conversions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 271,
          child: SizedBox(
            width: 357,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'The ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'metric system',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: ' is commonly used for measuring materials',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 42,
          top: 352,
          child: SizedBox(
            width: 343,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Millimeter (mm)',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: ' – used for small measurements.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Centimeter (cm)',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: ' – used for short measurements.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Meter (m)',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: ' – used for longer measurements.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 42,
          top: 463,
          child: SizedBox(
            width: 343,
            child: Text(
              '10 mm = 1 cm\n100 cm = 1 m\n1,000 mm = 1 m',
              style: TextStyle(
                color: _navy,
                fontSize: 13,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.62,
                letterSpacing: 0.39,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 37,
          top: 543,
          child: SizedBox(
            width: 343,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'If a measurement is ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.75,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '25 cm',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.75,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: ', convert it to millimeters:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.75,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '25 × 10 = 250 mm\nTherefore:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.75,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '25 cm = 250 mm',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.75,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(6),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildEnglishMeasurementTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 205,
          child: Text(
            'IV. Reading English \nMeasurements',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 21,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 0.95,
              letterSpacing: 0.63,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 324,
          child: Text(
            'Common Metric Units',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 420,
          child: Text(
            'Important Conversions',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 271,
          child: SizedBox(
            width: 357,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'The ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'English measurement system',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: ' commonly uses inches and feet.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 42,
          top: 352,
          child: SizedBox(
            width: 343,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Inch (in.) – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'used for smaller measurements.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Foot (ft.) – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'used for longer measurements.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.62,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 42,
          top: 448,
          child: SizedBox(
            width: 343,
            child: Text(
              '12 inches = 1 foot',
              style: TextStyle(
                color: _navy,
                fontSize: 13,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.62,
                letterSpacing: 0.39,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 34,
          top: 495,
          child: SizedBox(
            width: 348,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.77,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'If a piece of wood measures 3 feet, convert it to inches:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.92,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '3 × 12 = 36 inches\nTherefore:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.92,
                      letterSpacing: 0.36,
                    ),
                  ),
                  TextSpan(
                    text: '3 feet = 36 inches',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.92,
                      letterSpacing: 0.36,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(7),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildAccuracyTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 205,
          child: Text(
            'V. Accuracy in Reading \nMeasurements',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 21,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 0.95,
              letterSpacing: 0.63,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 273,
          child: SizedBox(
            width: 357,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Accuracy means getting the',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: ' correct measurement ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'without unnecessary mistakes.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 29,
          top: 320,
          child: SizedBox(
            width: 368,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Examples:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Start from the ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'zero mark.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Keep the measuring tool properly aligned.\nRead the markings carefully.\nIdentify whether the measurement is ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'metric or English.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Check the smaller divisions.\nWrite the correct unit.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.31,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 33,
          top: 473,
          child: SizedBox(
            width: 348,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Example:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.77,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Do not write:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.54,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: '25\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.54,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Instead, write:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.54,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: '25 cm\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.54,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'because the unit tells us what the measurement represents.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.54,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(8),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'NEXT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildKeyPointsTab(BuildContext context) {
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
        const Positioned(
          left: 70,
          right: 20,
          top: 59,
          child: Text(
            'Lesson 4: Reading\nMeasurements',
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
              child: AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutCubic,
                alignment: Alignment.centerLeft,
                widthFactor: _progressStep / _tabCount,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: const Color(0xFF05831C),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 36,
          top: 207,
          child: SizedBox(
            width: 326,
            child: Text(
              'VI. Key Points to Remember',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 22,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                height: 1.09,
                letterSpacing: 0.66,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 34,
          top: 276,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Pull Push Rule – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'used to measure length, width, height, and distance.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Steel Rule – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'used to measure and mark short lengths accurately.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Try Square – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'used to check and mark 90° angles.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Vernier Caliper – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'used to measure small dimensions precisely.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Whole Number – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'a complete number such as 20 cm.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Fraction –',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: ' a part of a whole such as 5 1/2 inches.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Decimal – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'a measurement containing a decimal point such as 12.5 cm.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'Metric – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'uses millimeters, centimeters, and meters.\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'English – ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text: 'uses inches and feet.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.38,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 21,
          top: 549,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Important Safety and Care Reminder:\n                          ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.36,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Always use the correct measuring tool. Handle tools carefully, keep them clean, and store them properly. Accurate measurement prevents errors.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.36,
                      letterSpacing: 0.42,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () => _selectTab(9),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(width: 1, color: _navy),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PREVIOUS',
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
            ),
          ),
        ),
        Positioned(
          left: 270,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: _saving ? null : _advance,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'DONE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                      letterSpacing: 0.48,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }
}
