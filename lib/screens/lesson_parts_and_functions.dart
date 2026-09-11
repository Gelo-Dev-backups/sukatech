import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../navigation/fade_route.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class LessonsPartsAndFunctions extends StatefulWidget {
  const LessonsPartsAndFunctions({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<LessonsPartsAndFunctions> createState() => _LessonsPartsAndFunctionsState();
}

class _LessonsPartsAndFunctionsState extends State<LessonsPartsAndFunctions> {
  static const _tabCount = 5;
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
    _currentTab = restoredTab.clamp(0, _tabCount);
    _progressStep = _stepForTab(_currentTab);
  }

  int _stepForTab(int tab) {
    if (tab == 0) return 1;
    return tab.clamp(1, _tabCount);
  }

  Future<void> _advance() async {
    if (_saving) return;

    if (_currentTab == 0) {
      // Advance past tab 0 (Introduction / DONE for now since it's only 1 tab)
      // Once we add more tabs, we will update this logic.
      setState(() => _saving = true);
      await UserStore.mutate((user) {
        final newTabs = Map<String, int>.from(user.lessonLastTabs);
        newTabs[_lessonTitle] = 1;

        final completed = List<String>.from(user.completedLessonsList);
        if (!completed.contains(_lessonTitle)) {
          completed.add(_lessonTitle);
        }

        final tabId = 'lesson_03_tab_01';
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
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFA500),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
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
                )
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
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                _buildTableRow('Vernier Caliper', 'Measures small dimensions', isLast: true),
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
        border: isLast ? null : const Border(
          bottom: BorderSide(color: Color(0xFFCBD5E1)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 181,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(
                right: BorderSide(color: Color(0xFFCBD5E1)),
              ),
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
}
