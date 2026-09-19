import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class LessonsPartsAndFunctions extends StatefulWidget {
  const LessonsPartsAndFunctions({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<LessonsPartsAndFunctions> createState() =>
      _LessonsPartsAndFunctionsState();
}

class _LessonsPartsAndFunctionsState extends State<LessonsPartsAndFunctions> {
  static const _tabCount = 8;
  static const _navy = Color(0xFF061D3F);
  static const _lessonTitle = 'Lesson 3: Parts and Functions';

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
        'lesson_03_tab_${_currentTab.toString().padLeft(2, '0')}';

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
      await UserStore.mutate((user) {
        final newTabs = Map<String, int>.from(user.lessonLastTabs);
        newTabs[_lessonTitle] = 7;

        final completed = List<String>.from(user.completedLessonsList);
        if (!completed.contains(_lessonTitle)) {
          completed.add(_lessonTitle);
        }

        final tabId = 'lesson_03_tab_07';
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
    if (_currentTab == 7) {
      return _buildKeyTakeawayTab(context);
    }
    if (_currentTab == 6) {
      return _buildChoosingToolTab(context);
    }
    if (_currentTab == 5) {
      return _buildVernierCaliperPart2Tab(context);
    }
    if (_currentTab == 4) {
      return _buildVernierCaliperTab(context);
    }
    if (_currentTab == 3) {
      return _buildSteelRuleTab(context);
    }
    if (_currentTab == 2) {
      return _buildTrySquareTab(context);
    }
    if (_currentTab == 1) {
      return _buildTapeMeasureTab(context);
    }
    return _buildIntroTab(context);
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
            'Parts and Function of\nMeasuring Tools',
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
              child: FractionallySizedBox(
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
          left: 100,
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
          top: 254,
          child: SizedBox(
            width: 345,
            child: Text(
              'After completing this lesson, you should be able to identify the different parts of common measuring tools, explain their functions, and describe the main purpose of each measuring tool.',
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
        const Positioned(
          left: 28,
          top: 378,
          child: Text(
            'Functions of Measuring Tools',
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
        Positioned(
          left: 23,
          top: 406,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: const Color(0xFFD1DBEA),
                  child: Row(
                    children: [
                      Container(
                        width: 181,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            right: BorderSide(color: Color(0xFFCBD5E1)),
                            bottom: BorderSide(color: Color(0xFFCBD5E1)),
                          ),
                        ),
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                          ),
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
                      ),
                    ],
                  ),
                ),
                _buildTableRow('Tape Measure', 'Measures long distances'),
                _buildTableRow('Try Square', 'Checks right angles'),
                _buildTableRow('Steel Rule', 'Measures straight lengths'),
                _buildTableRow(
                  'Vernier Caliper',
                  'Measures small dimensions',
                  isLast: true,
                ),
              ],
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

  Widget _buildTableRow(String tool, String use, {bool isLast = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFCBD5E1))),
      ),
      child: Row(
        children: [
          Container(
            width: 181,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFFCBD5E1))),
            ),
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
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              child: Text(
                use,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 13,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTapeMeasureTab(BuildContext context) {
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
            'Parts and Function of\nMeasuring Tools',
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
              child: FractionallySizedBox(
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
          top: 216,
          child: Text(
            'Parts and Functions',
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
        const Positioned(
          left: 26,
          top: 258,
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
        Positioned(
          left: 114,
          top: 284,
          child: Image.asset(
            'lib/assets/images/parts-tape.png',
            width: 183,
            height: 99,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 183,
              height: 99,
              color: Colors.grey[300],
              child: const Icon(Icons.image, color: Colors.grey),
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 389,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Hook - ',
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
                        'The small metal piece at the end of the tape. It holds onto the edge of an object while measuring.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.25,
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
          top: 448,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Blade - ',
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
                        'The long, thin metal strip with measurement markings. It shows the measurement of the object being measured.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.25,
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
          top: 507,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Lock Button - ',
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
                        'The button holds the blade in position and prevents it from moving while measuring or reading the measurement.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.25,
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
          top: 582,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Housing - ',
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
                        'The protective case that contains the blade. It protects the blade and makes the tape measure easy to hold.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.25,
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
          top: 637,
          child: SizedBox(
            width: 367,
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
                        'Hook = Holds | Blade = Measures | Lock = Keeps in place | Housing = Protects',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
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
            'Parts and Function of\nMeasuring Tools',
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
              child: FractionallySizedBox(
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
          top: 216,
          child: Text(
            'Parts and Functions',
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
        const Positioned(
          left: 26,
          top: 258,
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
        Positioned(
          left: 103.59,
          top: 219,
          child: Container(
            transform: Matrix4.identity()
              ..translate(0.0, 0.0)
              ..rotateZ(0.03),
            width: 223,
            height: 197,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/parts-try-square.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 25,
          top: 407,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Blade - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The long, flat metal part of the try square. It is used for measuring and checking the straightness and squareness of an edge.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 474,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Stock - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The thicker part that supports the blade. It provides a firm reference surface when checking a 90° angle.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.15,
                      letterSpacing: 0.39,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 541,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Rivets - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.15,
                      letterSpacing: 0.39,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Small metal fasteners that connect the blade and stock. It secures the blade and stock together',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.15,
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
          top: 605,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Remember:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.21,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Blade = Checks | Stock = Supports | Rivets = Connect',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
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
            'Parts and Function of\nMeasuring Tools',
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
              child: FractionallySizedBox(
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
          top: 216,
          child: Text(
            'Parts and Functions',
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
        const Positioned(
          left: 26,
          top: 258,
          child: Text(
            'Steel Rule',
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
        Positioned(
          left: 114,
          top: 294,
          child: Container(
            width: 199,
            height: 106,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/stee-rule-parts.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 434,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Graduation - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The lines and numbers marked along the rule. It indicates the measurement in units such as millimeters and centimeters.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 27,
          top: 501,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Edge - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The straight side of the steel rule. It used as a reference when measuring, marking, or drawing straight lines.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 21,
          top: 583,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Remember:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.21,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Graduations = Show measurement | Edge = Gives a straight reference',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.5,
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
            'Parts and Function of\nMeasuring Tools',
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
              child: FractionallySizedBox(
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
          top: 216,
          child: Text(
            'Parts and Functions',
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
        const Positioned(
          left: 26,
          top: 258,
          child: Text(
            'Vernier Caliper',
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
        Positioned(
          left: 41,
          top: 234,
          child: Container(
            width: 328,
            height: 248,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/venice-caliper-parts.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 481,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Outside Jaws - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The larger jaws located at the bottom of the caliper. It measure the outside diameter, width, or thickness of an object.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 27,
          top: 548,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Inside Jaws - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The smaller jaws located at the top. It measure the inside diameter or width of holes and openings.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 614,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Main Scale - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The fixed scale marked along the body of the caliper. It provides the main measurement reading.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                      letterSpacing: 0.42,
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

  Widget _buildVernierCaliperPart2Tab(BuildContext context) {
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
            'Parts and Function of\nMeasuring Tools',
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
              child: FractionallySizedBox(
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
          top: 216,
          child: Text(
            'Parts and Functions',
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
        const Positioned(
          left: 26,
          top: 258,
          child: Text(
            'Vernier Caliper',
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
        Positioned(
          left: 41,
          top: 234,
          child: Container(
            width: 328,
            height: 248,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('lib/assets/images/venice-caliper-parts.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 481,
          child: SizedBox(
            width: 369,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Vernier Scale - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The smaller movable scale that slides along the main scale. It provides a more precise measurement by allowing smaller divisions to be read.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 27,
          top: 548,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Depth Rod - ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.07,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'The thin rod that extends from the end of the caliper. It measures the depth of holes, slots, and recessed areas.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.07,
                      letterSpacing: 0.42,
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

  Widget _buildChoosingToolTab(BuildContext context) {
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
            'Parts and Function of\nMeasuring Tools',
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
              child: FractionallySizedBox(
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
          right: 36,
          top: 216,
          child: Text(
            'Choosing the Right Measuring Tool',
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
        const Positioned(
          left: 29,
          top: 288,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Choosing the correct measuring tool depends on the type and size of the measurement needed.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.53,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'Need to measure a long board or distance? ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.53,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'Use a Tape Measure.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.53,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Need to check if a corner is square or an edge is straight? ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.53,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'Use a Try Square.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.53,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'Need to measure a short, straight dimension? ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.53,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'Use a Steel Rule.\n\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.53,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Need a precise outside, inside, or depth measurement? ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.53,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'Use a Vernier Caliper.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500,
                      height: 1.53,
                      letterSpacing: 0.45,
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

  Widget _buildKeyTakeawayTab(BuildContext context) {
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
            'Parts and Function of\nMeasuring Tools',
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
              child: FractionallySizedBox(
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
          right: 36,
          top: 219,
          child: Text(
            'Key Takeaway',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0.72,
            ),
          ),
        ),
        const Positioned(
          left: 35,
          top: 285,
          child: SizedBox(
            width: 354,
            child: Text(
              '       Each measuring tool is designed for a specific purpose. The tape measure is useful for general and longer measurements, the try square checks 90° angles, the steel rule measures short straight dimensions, and the vernier caliper provides precise measurements of outside dimensions, inside dimensions, and depth. Knowing the parts and functions of each tool helps you choose and use the correct tool for accurate carpentry work.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.53,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 22,
          top: 581,
          child: SizedBox(
            width: 367,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Remember:\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.29,
                      letterSpacing: 0.42,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Know the tool. Know its parts. Know its function. Measure with accuracy.',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 14,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.29,
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
          left: 144,
          top: 681,
          child: Semantics(
            button: true,
            child: InkWell(
              onTap: () {
                // Navigate to practice
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: const Color(0xFFFFA500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'PRACTICE',
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
