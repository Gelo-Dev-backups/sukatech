import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class LessonsUnitConversion extends StatefulWidget {
  const LessonsUnitConversion({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<LessonsUnitConversion> createState() => _LessonsUnitConversionState();
}

class _LessonsUnitConversionState extends State<LessonsUnitConversion> {
  static const _tabCount = 10;
  static const _navy = Color(0xFF061D3F);
  static const _lessonTitle = 'Unit Conversion';

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
        'lesson_05_tab_${_currentTab.toString().padLeft(2, '0')}';

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

    if (_currentTab < _tabCount - 1) {
      setState(() => _saving = true);
      final nextTab = _currentTab + 1;
      final nextStep = _progressStep + 1;
      await _saveProgress(nextStep, nextTab);
      if (!mounted) return;
      setState(() {
        _saving = false;
        _currentTab = nextTab;
        _progressStep = nextStep;
      });
      return;
    }

    if (_currentTab == _tabCount - 1) {
      setState(() => _saving = true);
      await UserStore.mutate((user) {
        final newTabs = Map<String, int>.from(user.lessonLastTabs);
        newTabs[_lessonTitle] = _tabCount - 1;

        final completed = List<String>.from(user.completedLessonsList);
        if (!completed.contains(_lessonTitle)) {
          completed.add(_lessonTitle);
        }

        final tabId =
            'lesson_05_tab_${(_tabCount - 1).toString().padLeft(2, '0')}';
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
    if (_currentTab == 9) {
      return _buildLearningOutcomeTab(context);
    }
    if (_currentTab == 8) {
      return _buildApplicationTab(context);
    }
    if (_currentTab == 7) {
      return _buildConversionRuleTab(context);
    }
    if (_currentTab == 6) {
      return _buildExamplesTab(context);
    }
    if (_currentTab == 5) {
      return _buildHowToConvertTab(context);
    }
    if (_currentTab == 4) {
      return _buildEnglishSystemTab(context);
    }
    if (_currentTab == 3) {
      return _buildMetricSystemTab(context);
    }
    if (_currentTab == 2) {
      return _buildWhyUnitConversionTab(context);
    }
    if (_currentTab == 1) {
      return _buildWhatIsUnitConversionTab(context);
    }
    if (_currentTab == 0) {
      return _buildIntroTab(context);
    }
    return _buildEmptyTab(context);
  }

  Widget _buildWhatIsUnitConversionTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 52,
          top: 216,
          child: Text(
            'What is Unit Conversion?',
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
          left: 27,
          top: 292,
          child: SizedBox(
            width: 354,
            child: Text(
              'Unit conversion is the process of changing a measurement from one unit to another without changing its actual value.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 1.07,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 31,
          top: 378,
          child: Text(
            'For example:',
            textAlign: TextAlign.center,
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
        const Positioned(
          left: 41,
          top: 408,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: '100 centimeters = 1 meter\n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Both measurements represent the same length, but they use different units.',
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
        const Positioned(
          left: 28,
          top: 499,
          child: Text(
            'Why Is Conversion Needed?',
            textAlign: TextAlign.center,
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
        const Positioned(
          left: 34,
          top: 527,
          child: SizedBox(
            width: 354,
            child: Text(
              'Unit conversion is important because different tools, plans, materials, and people may use different units of measurement.',
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _saving ? null : _advance,
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

  Widget _buildWhyUnitConversionTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 52,
          top: 216,
          child: Text(
            'What is Unit Conversion?',
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
          left: 31,
          top: 289,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'In ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'carpentry and other Industrial Arts activities',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: ', accurate conversion helps learners:',
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
        const Positioned(
          left: 33,
          top: 356,
          child: SizedBox(
            width: 354,
            child: Text(
              'Follow working drawings correctly.\nMeasure materials accurately.\nAvoid mistakes when cutting or assembling materials.\nUse measuring tools properly.\nCommunicate measurements clearly.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 1.33,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 484,
          child: Text(
            'For example:',
            textAlign: TextAlign.center,
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
        const Positioned(
          left: 44,
          top: 506,
          child: SizedBox(
            width: 354,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'If a working drawing gives a measurement of 3 meters, but your measuring tool or activity requires centimeters, you need to convert: \n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: '3 m × 100 = 300 cm',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.33,
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _saving ? null : _advance,
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

  Widget _buildMetricSystemTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 44,
          top: 216,
          child: Text(
            'Common Conversion Units',
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
          top: 280,
          child: Text(
            'Metric System',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 1.11,
              letterSpacing: 0.54,
            ),
          ),
        ),
        const Positioned(
          left: 46,
          top: 317,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'The metric system commonly uses ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'millimeters (mm), centimeters (cm), and meters (m).',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 23,
          top: 412,
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
                          'Conversion',
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
                            'Equivalent',
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
                Container(
                  color: Colors.white,
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
                          '10 mm',
                          style: TextStyle(
                            color: _navy,
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
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
                            '1 cm',
                            style: TextStyle(
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
                ),
                Container(
                  color: Colors.white,
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
                          '100 cm',
                          style: TextStyle(
                            color: _navy,
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
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
                            '1 m',
                            style: TextStyle(
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
                ),
                Container(
                  color: Colors.white,
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
                          ),
                        ),
                        child: const Text(
                          '1,000 mm',
                          style: TextStyle(
                            color: _navy,
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          child: const Text(
                            '1 m',
                            style: TextStyle(
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _saving ? null : _advance,
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

  Widget _buildEnglishSystemTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 44,
          top: 216,
          child: Text(
            'Common Conversion Units',
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
          right: 28,
          top: 283,
          child: Text(
            'English system',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 1.11,
              letterSpacing: 0.54,
            ),
          ),
        ),
        const Positioned(
          left: 45,
          top: 322,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'The English system commonly uses inches ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: '(in), feet (ft), and yards (yd).',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.33,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          left: 23,
          top: 399,
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
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                          ),
                          child: const Text(
                            'Conversion',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          child: const Text(
                            'Equivalent',
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
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFCBD5E1)),
                              right: BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                          ),
                          child: const Text(
                            '12 in',
                            style: TextStyle(
                              color: _navy,
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
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
                              top: BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                          ),
                          child: const Text(
                            '1 ft',
                            style: TextStyle(
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
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(color: Color(0xFFCBD5E1)),
                              right: BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                          ),
                          child: const Text(
                            '3 ft',
                            style: TextStyle(
                              color: _navy,
                              fontSize: 13,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
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
                              top: BorderSide(color: Color(0xFFCBD5E1)),
                            ),
                          ),
                          child: const Text(
                            '1 yd',
                            style: TextStyle(
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
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          left: 37,
          right: 37,
          top: 563,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Note: \n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.25,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text:
                      'Use the yard conversion only if it has been discussed in the lesson.',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: 0.48,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _advance,
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
        if (_currentTab > 0)
          Positioned(
            left: 28,
            top: 681,
            child: Semantics(
              button: true,
              label: 'Previous',
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _selectTab(_currentTab - 1),
                child: Container(
                  width: 122,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: _navy),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildHowToConvertTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 44,
          right: 44,
          top: 216,
          child: Text(
            'Common Conversion Units',
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
          right: 33,
          top: 287,
          child: Text(
            'How to Convert Measurements',
            textAlign: TextAlign.center,
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
        const Positioned(
          left: 34,
          right: 34,
          top: 324,
          child: Text(
            'Step 1: Identify the given unit.',
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
          left: 39,
          right: 39,
          top: 344,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example: ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: '250 cm',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          left: 33,
          right: 33,
          top: 390,
          child: Text(
            'Step 2: Identify the unit you need.',
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
          left: 39,
          right: 39,
          top: 412,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example: ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'meters (m)',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          left: 37,
          right: 37,
          top: 458,
          child: Text(
            'Step 3: Use the correct conversion relationship.',
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
          left: 38,
          right: 38,
          top: 515,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Since: \n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: '100 cm = 1 m\nDivide by 100:\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: '250 cm ÷ 100 = 2.5 m\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'Therefore',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ': 250 cm = 2.5 m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _advance,
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
        if (_currentTab > 0)
          Positioned(
            left: 28,
            top: 681,
            child: Semantics(
              button: true,
              label: 'Previous',
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _selectTab(_currentTab - 1),
                child: Container(
                  width: 122,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: _navy),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildExamplesTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 44,
          right: 44,
          top: 216,
          child: Text(
            'Common Conversion Units',
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
          right: 32,
          top: 287,
          child: Text(
            'Examples:',
            textAlign: TextAlign.center,
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
        const Positioned(
          left: 36,
          right: 36,
          top: 325,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example 1: 250 cm → m\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'Since',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 100 cm = 1 m: 250 ÷ 100 = 2.5\n√ Answer: 2.5 m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
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
        const Positioned(
          left: 37,
          right: 37,
          top: 403,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example 2: 3 m → cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'Since',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 1 m = 100 cm: 3 × 100 = 300\n√ Answer: 300 cm',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
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
        const Positioned(
          left: 36,
          right: 36,
          top: 481,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example 3: 48 in → ft\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'Since',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 12 in = 1 ft: 48 ÷ 12 = 4\n√ Answer: 4 ft',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
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
        const Positioned(
          left: 36,
          right: 36,
          top: 559,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example 4: 1,500 mm → m\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'Since',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 1,000 mm = 1 m: 1,500 ÷ 1,000 = 1.5\n√ Answer: 1.5 m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _advance,
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
        if (_currentTab > 0)
          Positioned(
            left: 28,
            top: 681,
            child: Semantics(
              button: true,
              label: 'Previous',
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _selectTab(_currentTab - 1),
                child: Container(
                  width: 122,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: _navy),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildConversionRuleTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 107,
          right: 107,
          top: 216,
          child: Text(
            'Conversion Rule',
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
          left: 84,
          right: 84,
          top: 261,
          child: Text(
            'A simple rule to remember:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              height: 1.25,
              letterSpacing: 0.48,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          right: 32,
          top: 282,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Larger unit → Smaller unit: ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.25,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: 'Multiply',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.25,
                    letterSpacing: 0.48,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Positioned(
          left: 32,
          right: 32,
          top: 314,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example:\n2 m → cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: '2 × 100 =',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 200 cm\nSmaller unit → Larger unit: ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'Divide\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: '200 cm → m\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: '200 ÷ 100',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.33,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' = 2 m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
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
        const Positioned(
          left: 24,
          right: 24,
          top: 448,
          child: Text(
            'Learners can use a Unit Converter to practice converting measurements.',
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
          left: 40,
          right: 40,
          top: 491,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Steps:\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.40,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text:
                      '1. Enter a value.\n2. Choose the "From" unit.\n3. Choose the "To" unit.\n4. Tap "Convert."\n5. View the answer.\n6. Check if the answer is reasonable.',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.40,
                    letterSpacing: 0.45,
                  ),
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _advance,
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
        if (_currentTab > 0)
          Positioned(
            left: 28,
            top: 681,
            child: Semantics(
              button: true,
              label: 'Previous',
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _selectTab(_currentTab - 1),
                child: Container(
                  width: 122,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: _navy),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildApplicationTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 44,
          right: 44,
          top: 216,
          child: Text(
            'Unit Conversion',
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
          right: 28,
          top: 277,
          child: Text(
            'Application in Carpentry',
            textAlign: TextAlign.center,
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
        const Positioned(
          left: 28,
          right: 28,
          top: 305,
          child: Text(
            'Unit conversion is useful when working with wood, tools, and working drawings.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              height: 1.43,
              letterSpacing: 0.42,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          right: 28,
          top: 363,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'For example, a carpenter may receive a measurement of 2.5 meters, but the measuring tool may require centimeters.\n\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                    letterSpacing: 0.42,
                  ),
                ),
                TextSpan(
                  text: '2.5 m x 100 = 250 cm\n\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                    letterSpacing: 0.42,
                  ),
                ),
                TextSpan(
                  text: 'Therefore, the carpenter should measure ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                    letterSpacing: 0.42,
                  ),
                ),
                TextSpan(
                  text: '250 cm.',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.43,
                    letterSpacing: 0.42,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const Positioned(
          left: 28,
          right: 28,
          top: 553,
          child: Text(
            'Accurate conversion helps prevent wrong measurements, wasted materials, and incorrect construction.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              height: 1.43,
              letterSpacing: 0.42,
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _advance,
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
        if (_currentTab > 0)
          Positioned(
            left: 28,
            top: 681,
            child: Semantics(
              button: true,
              label: 'Previous',
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _selectTab(_currentTab - 1),
                child: Container(
                  width: 122,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: _navy),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildLearningOutcomeTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
            'Learning Outcome',
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
          left: 26,
          right: 26,
          top: 283,
          child: Text(
            '    At the end of the lesson, learners are expected to understand the importance of unit conversion and accurately convert common metric and English measurements. They should be able to select the correct conversion factor, solve basic conversion problems, and use a unit converter to verify their answers. These skills can be applied to carpentry measurements, working drawings, and other practical activities.',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 1.56,
              letterSpacing: 0.48,
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
            label: 'Done',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _advance,
              child: Container(
                width: 122,
                height: 48,
                decoration: ShapeDecoration(
                  color: _navy,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Center(
                  child: _saving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
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
        Positioned(
          left: 144,
          top: 681,
          child: Semantics(
            button: true,
            label: 'Practice',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {},
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
        if (_currentTab > 0)
          Positioned(
            left: 28,
            top: 681,
            child: Semantics(
              button: true,
              label: 'Previous',
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => _selectTab(_currentTab - 1),
                child: Container(
                  width: 122,
                  height: 48,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: _navy),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildEmptyTab(BuildContext context) {
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          top: 400,
          child: Text(
            'Content coming soon...',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _advance,
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
          top: 67,
          child: Text(
            'Lesson 5 - Unit Conversion',
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
          left: 90,
          top: 212,
          child: Text(
            'Learning Objective',
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
          left: 41,
          top: 289,
          child: SizedBox(
            width: 345,
            child: Text(
              'At the end of the lesson, learners should be able to:\n',
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
        ),
        const Positioned(
          left: 49,
          top: 320,
          child: SizedBox(
            width: 320,
            child: Text(
              '\n1. Explain why unit conversion is needed in measurement.\n2. Identify common metric and English units used in carpentry.\n3. Convert measurements accurately from one unit to another.\n4. Use a converter to check or obtain the correct converted measurement.',
              style: TextStyle(
                color: _navy,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                height: 2,
                letterSpacing: 0.48,
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
            label: 'Next',
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _advance,
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
}
