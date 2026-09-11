import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../navigation/fade_route.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class LessonsIntroScreen extends StatefulWidget {
  const LessonsIntroScreen({super.key, this.initialTab = 0});

  final int initialTab;

  @override
  State<LessonsIntroScreen> createState() => _LessonsIntroScreenState();
}

class _LessonsIntroScreenState extends State<LessonsIntroScreen> {
  // Add each new lesson tab to this single count as the lesson grows.
  static const _tabCount = 7;
  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);
  static const _lessonTitle = 'Lesson 1: Introduction to Measurement';

  late int _currentTab;
  late int _progressStep;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Restore last active tab from UserStore if available (lesson-specific)
    final savedTab = UserStore.current.value?.lessonLastTabs[_lessonTitle];
    final restoredTab = savedTab ?? widget.initialTab;
    _currentTab = restoredTab.clamp(0, _tabCount + 4);
    _progressStep = _stepForTab(_currentTab);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentTab == 1) return _buildSecondTab(context);
    if (_currentTab == 2) return _buildThirdTab(context);
    if (_currentTab == 3) return _buildFourthTab(context);
    if (_currentTab == 4) return _buildAccurateContinuationTab(context);
    if (_currentTab == 5) return _buildMeasurementTermsTab(context);
    if (_currentTab == 6) return _buildMeasurementTermsContinuationTab(context);
    if (_currentTab == 7) return _buildMeasurementSystemsTab(context);
    if (_currentTab == 8) {
      return _buildMeasurementSystemsContinuationTab(context);
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
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
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
                    color: _accent,
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
          left: 49,
          top: 202,
          child: SizedBox(
            width: 311,
            child: Text(
              'INTRODUCTION TO\nCARPENTRY MEASUREMENT',
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
        const Positioned(left: 25, top: 248, child: _LessonImage()),
        const Positioned(
          left: 28,
          top: 467,
          child: SizedBox(
            width: 345,
            child: Text(
              'At the end of this lesson, learners should be able to:\n\nExplain the importance of accurate measurement in carpentry and identify common measurement terms and units used in carpentry.',
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
          top: 655,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 81,
          top: 678,
          child: _IntroButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            disabled: false,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
        Positioned(
          left: 207,
          top: 678,
          child: _IntroButton(
            label: 'NEXT',
            backgroundColor: _navy,
            foregroundColor: Colors.white,
            disabled: _saving,
            onPressed: _advance,
          ),
        ),
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Future<void> _advance() async {
    if (_saving) return;
    if (_currentTab >= _tabCount + 4) {
      Navigator.of(context).pop();
      return;
    }
    if (_currentTab > _tabCount + 4) {
      pushUnderDevelopment(context, title: 'Next Lesson');
      return;
    }

    final nextTab = _currentTab + 1;
    final nextStep = _stepForTab(nextTab);
    setState(() => _saving = true);
    await _saveProgress(nextStep, nextTab);
    if (!mounted) return;
    if (nextTab > _tabCount + 4) {
      setState(() => _saving = false);
      pushUnderDevelopment(context, title: 'Next Lesson');
      return;
    }
    setState(() {
      _progressStep = nextStep;
      _saving = false;
      _currentTab = nextTab;
    });
  }

  Future<void> _saveProgress(int step, int newTab) async {
    final completedTabId = 'lesson_01_tab_${_currentTab.toString().padLeft(2, '0')}';

    await UserStore.mutate((user) {
      final nextPercent = (step * 100 / _tabCount).round();
      final newTabs = Map<String, int>.from(user.lessonLastTabs);
      newTabs[_lessonTitle] = newTab;

      // Idempotent completion: only count lesson once
      final completed = List<String>.from(user.completedLessonsList);
      if (step >= _tabCount && !completed.contains(_lessonTitle)) {
        completed.add(_lessonTitle);
      }

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
        lessonsCompleted: completed.length,
        completedLessonsList: completed,
        lessonLastTabs: newTabs,
        completedLessonTabs: completedLessonTabs,
        xpEarned: xpEarned,
      );
    });
  }

  int _stepForTab(int tab) => tab == 4
      ? 4
      : tab == 5 || tab == 6
      ? 5
      : tab >= _tabCount + 4
      ? _tabCount
      : tab >= 7
      ? _tabCount - 1
      : tab + 1;

  void _selectTab(int tab) {
    setState(() {
      _currentTab = tab;
      _progressStep = _stepForTab(tab);
    });
    // Persist the active tab for this lesson
    UserStore.mutate((user) {
      final newTabs = Map<String, int>.from(user.lessonLastTabs);
      newTabs[_lessonTitle] = tab;
      return user.copyWith(lessonLastTabs: newTabs);
    });
  }

  Widget _buildSecondTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 25,
          top: 205,
          child: Text(
            'What is Carpentry Measurement?',
            style: _sectionTitleStyle,
          ),
        ),
        const Positioned(left: 112, top: 222, child: _MeasurementImage()),
        const Positioned(
          left: 26,
          top: 362,
          child: SizedBox(
            width: 383,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Carpentry measurement',
                    style: _sectionBodyBoldStyle,
                  ),
                  TextSpan(
                    text:
                        ' is the process of finding the size or dimensions of materials and objects used in carpentry.',
                    style: _bodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 27,
          top: 428,
          child: SizedBox(
            width: 367,
            child: Text(
              'Carpentry measurement is the process of finding the size or dimensions of materials and objects used in carpentry.',
              style: _bodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 25,
          top: 496,
          child: SizedBox(
            width: 362,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:\n', style: _exampleStyle),
                  TextSpan(
                    text:
                        'If a carpenter needs a piece of wood that is 2 meters long, the carpenter must measure the wood accurately before cutting it.',
                    style: _bodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 24,
          top: 594,
          child: SizedBox(
            width: 361,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'REMEMBER:\n', style: _exampleStyle),
                  TextSpan(
                    text: 'Measure first before you cut!',
                    style: _bodyStyle,
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
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(0),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildThirdTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 28,
          top: 205,
          child: Text('What is Mensuration?', style: _sectionTitleStyle),
        ),
        const Positioned(left: 120.37, top: 188, child: _MensurationImage()),
        const Positioned(
          left: 28,
          top: 333,
          child: SizedBox(
            width: 371,
            child: Text(
              'Mensuration is the process of measuring the size, length, area, volume, or other dimensions of an object.',
              style: _bodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 30,
          top: 399,
          child: SizedBox(
            width: 371,
            child: Text(
              'In carpentry, mensuration is important because carpenters need to determine the correct dimensions of materials and structures.',
              style: _bodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 27,
          top: 478,
          child: SizedBox(
            width: 362,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:\n', style: _exampleStyle),
                  TextSpan(
                    text:
                        'A carpenter may need to determine:\n1. The length of a wooden board\n2. The width of a table\n3. The height of a cabinet\n4. The thickness of a piece of wood',
                    style: _exampleBodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 24,
          top: 620,
          child: SizedBox(
            width: 362,
            child: Text(
              'Mensuration = measuring things and finding their dimensions.',
              textAlign: TextAlign.center,
              style: _calloutStyle,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 665,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(1),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildFourthTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 205,
          child: SizedBox(
            width: 369,
            child: Text(
              'Why is Accurate Measurement Important?',
              textAlign: TextAlign.center,
              style: _sectionTitleStyle,
            ),
          ),
        ),
        const Positioned(left: 84, top: 261, child: _AccurateImage()),
        const Positioned(
          left: 25,
          top: 390,
          child: SizedBox(
            width: 383,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Accurate measurement',
                    style: _sectionBodyBoldStyle,
                  ),
                  TextSpan(
                    text:
                        ' is very important in carpentry because it helps produce correct, safe, and quality work.',
                    style: _bodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 25,
          top: 473,
          child: SizedBox(
            width: 349,
            child: Text(
              'Accurate measurement helps to:\n\n1. Get the correct size\nMaterials can be cut according to the required dimensions.\n\n2. Prevent mistakes\nCorrect measurements reduce errors during cutting and construction.',
              style: _accurateBodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 665,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(2),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildAccurateContinuationTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 205,
          child: SizedBox(
            width: 369,
            child: Text(
              'Why is Accurate Measurement Important?',
              textAlign: TextAlign.center,
              style: _sectionTitleStyle,
            ),
          ),
        ),
        const Positioned(
          left: 35,
          top: 310,
          child: SizedBox(
            width: 341,
            child: Text(
              'Accurate measurement helps to:\n\n4. Make parts fit properly\nProper measurements help wooden parts fit together correctly.\n\n5. Produce quality work\nAccurate measurements result in neat and precise carpentry projects.',
              style: _accurateBodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 34,
          top: 537,
          child: SizedBox(
            width: 341,
            child: Text(
              'Remember:\nA small measurement error can affect the entire project.',
              textAlign: TextAlign.center,
              style: _accurateRememberStyle,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 665,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(3),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildMeasurementTermsTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Common Measurement Terms',
              textAlign: TextAlign.center,
              style: _sectionTitleStyle,
            ),
          ),
        ),
        const Positioned(
          left: 30,
          top: 253,
          child: SizedBox(
            width: 341,
            child: Text(
              'Carpenters use different terms when describing the size of an object.',
              style: _termsBodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 34,
          top: 314,
          child: SizedBox(
            width: 341,
            child: Text(
              'Length',
              textAlign: TextAlign.center,
              style: _termsHeadingStyle,
            ),
          ),
        ),
        const Positioned(left: 229, top: 347, child: _LengthTermsImage()),
        const Positioned(
          left: 30,
          top: 352,
          child: SizedBox(
            width: 189,
            child: Text(
              'Length is the distance from one end of an object to the other end.',
              style: _termsBodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 30,
          top: 428,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:', style: _termsExampleStyle),
                  TextSpan(
                    text: '\nThe length of a wooden board is ',
                    style: _termsBodyStyle,
                  ),
                  TextSpan(text: '2 meters.', style: _termsExampleStyle),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 33,
          top: 493,
          child: SizedBox(
            width: 341,
            child: Text(
              'Width',
              textAlign: TextAlign.center,
              style: _termsHeadingStyle,
            ),
          ),
        ),
        const Positioned(left: 228, top: 522, child: _WidthTermsImage()),
        const Positioned(
          left: 29,
          top: 527,
          child: SizedBox(
            width: 189,
            child: Text(
              'Width is the distance from one side of an object to the other side.',
              style: _termsBodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 29,
          top: 596,
          child: SizedBox(
            width: 341,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:', style: _termsExampleStyle),
                  TextSpan(
                    text:
                        '\nA wooden board may have a width of 20 centimeters.',
                    style: _termsBodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 667,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(4),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildMeasurementTermsContinuationTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Common Measurement Terms',
              textAlign: TextAlign.center,
              style: _sectionTitleStyle,
            ),
          ),
        ),
        const Positioned(
          left: 34,
          top: 264,
          child: SizedBox(
            width: 341,
            child: Text(
              'Height',
              textAlign: TextAlign.center,
              style: _termsHeadingStyle,
            ),
          ),
        ),
        const Positioned(left: 195, top: 305, child: _HeightTermsImage()),
        const Positioned(
          left: 30,
          top: 302,
          child: SizedBox(
            width: 189,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Height', style: _termsExampleStyle),
                  TextSpan(
                    text: ' is the distance from the ',
                    style: _termsBodyStyle,
                  ),
                  TextSpan(
                    text: 'bottom to the top',
                    style: _termsExampleStyle,
                  ),
                  TextSpan(text: ' of an object.', style: _termsBodyStyle),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 30,
          top: 378,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:', style: _termsExampleStyle),
                  TextSpan(
                    text: '\nA cabinet may have a height of ',
                    style: _termsBodyStyle,
                  ),
                  TextSpan(text: '1.5 meters.', style: _termsExampleStyle),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 33,
          top: 451,
          child: SizedBox(
            width: 341,
            child: Text(
              'Thickness',
              textAlign: TextAlign.center,
              style: _termsHeadingStyle,
            ),
          ),
        ),
        const Positioned(left: 217, top: 491, child: _ThicknessTermsImage()),
        const Positioned(
          left: 29,
          top: 485,
          child: SizedBox(
            width: 189,
            child: Text(
              'Thickness is the distance from one surface of an object to the other surface.',
              style: _termsBodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 29,
          top: 554,
          child: SizedBox(
            width: 341,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:', style: _termsExampleStyle),
                  TextSpan(
                    text: '\nA wooden board may have a thickness of ',
                    style: _termsBodyStyle,
                  ),
                  TextSpan(text: '25 millimeters.', style: _termsExampleStyle),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 667,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(5),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildMeasurementSystemsTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Measurement Systems',
              textAlign: TextAlign.center,
              style: _sectionTitleStyle,
            ),
          ),
        ),
        const Positioned(
          left: 24,
          top: 248,
          child: SizedBox(
            width: 360,
            child: Text(
              'There are two common measurement systems introduced in this lesson:',
              textAlign: TextAlign.center,
              style: _systemsIntroStyle,
            ),
          ),
        ),
        const Positioned(left: 39, top: 293, child: _MeasurementSystemsImage()),
        const Positioned(
          left: 32,
          top: 434,
          child: SizedBox(
            width: 369,
            child: Text('A. Metric System (SI)', style: _sectionBodyBoldStyle),
          ),
        ),
        const Positioned(
          left: 28,
          top: 464,
          child: SizedBox(
            width: 360,
            child: Text(
              'The Metric System, also called the International System of Units (SI), is commonly used for measurement.',
              style: _systemsBodyStyle,
            ),
          ),
        ),
        const Positioned(
          left: 26,
          top: 541,
          child: SizedBox(
            width: 360,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'The common units are:\n',
                    style: _systemsLabelStyle,
                  ),
                  TextSpan(
                    text: 'Millimeter (mm)\nCentimeter (cm)\nMeter (m)',
                    style: _systemsBodyStyle,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 667,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(6),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildMeasurementSystemsContinuationTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Measurement Systems',
              textAlign: TextAlign.center,
              style: _sectionTitleStyle,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 262,
          child: SizedBox(
            width: 357,
            child: Text('Millimeter (mm)', style: _sectionBodyBoldStyle),
          ),
        ),
        const Positioned(
          left: 30,
          top: 296,
          child: SizedBox(
            width: 192,
            child: Text(
              'A millimeter is a small unit of length. It is useful for measuring small dimensions, such as the thickness of materials.',
              style: _systemsBodyStyle,
            ),
          ),
        ),
        const Positioned(left: 227, top: 298, child: _MillimeterImage()),
        const Positioned(
          left: 28,
          top: 474,
          child: SizedBox(
            width: 357,
            child: Text('Centimeter (cm)', style: _sectionBodyBoldStyle),
          ),
        ),
        const Positioned(
          left: 30,
          top: 508,
          child: SizedBox(
            width: 192,
            child: Text(
              'A centimeter is larger than a millimeter. It can be used to measure smaller objects and dimensions.',
              style: _systemsBodyStyle,
            ),
          ),
        ),
        const Positioned(left: 218, top: 508, child: _CentimeterImage()),
        const Positioned(
          left: 30,
          top: 402,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:\n', style: _systemsLabelStyle),
                  TextSpan(
                    text: 'A board may be 25 mm thick.',
                    style: _systemsBodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 597,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:\n', style: _systemsLabelStyle),
                  TextSpan(
                    text: 'The width of a board may be 20 cm.',
                    style: _systemsBodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 667,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(7),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildMeasurementSystemsPart3Tab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Measurement Systems',
              textAlign: TextAlign.center,
              style: _sectionTitleStyle,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 262,
          child: SizedBox(
            width: 357,
            child: Text('Meter (m)', style: _sectionBodyBoldStyle),
          ),
        ),
        const Positioned(
          left: 28,
          top: 298,
          child: SizedBox(
            width: 192,
            child: Text(
              'A meter is used to measure longer distances or larger objects.',
              style: _systemsBodyStyle,
            ),
          ),
        ),
        const Positioned(left: 213, top: 291, child: _MeterSystemImage()),
        const Positioned(
          left: 32,
          top: 368,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:\n', style: _systemsLabelStyle),
                  TextSpan(
                    text: 'A wooden board may be 2 m long.',
                    style: _systemsBodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 450,
          child: SizedBox(
            width: 369,
            child: Text('B. English System', style: _sectionBodyBoldStyle),
          ),
        ),
        const Positioned(
          left: 35,
          top: 486,
          child: SizedBox(
            width: 360,
            child: Text(
              'English System is a measurement system that uses units such as inches, and feet.',
              style: _systemsIntroStyle,
            ),
          ),
        ),
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
                    style: _systemsLabelStyle,
                  ),
                  TextSpan(
                    text: 'Inch (in)\nFoot (ft)',
                    style: _systemsBodyStyle,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 667,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(8),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildMeasurementSystemsPart4Tab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 215,
          child: SizedBox(
            width: 369,
            child: Text(
              'Measurement Systems',
              textAlign: TextAlign.center,
              style: _sectionTitleStyle,
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 281,
          child: SizedBox(
            width: 357,
            child: Text('Inch (in)', style: _sectionBodyBoldStyle),
          ),
        ),
        const Positioned(
          left: 26,
          top: 317,
          child: SizedBox(
            width: 192,
            child: Text(
              'An inch is a unit used to measure length',
              style: _systemsBodyStyle,
            ),
          ),
        ),
        Positioned(left: 212, top: 322, child: const _InchImage()),
        const Positioned(
          left: 30,
          top: 383,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:\n', style: _systemsLabelStyle),
                  TextSpan(
                    text: 'A piece of wood may be 12 inches long.',
                    style: _systemsBodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 32,
          top: 474,
          child: SizedBox(
            width: 357,
            child: Text('Foot (ft)', style: _sectionBodyBoldStyle),
          ),
        ),
        const Positioned(
          left: 30,
          top: 508,
          child: SizedBox(
            width: 192,
            child: Text(
              'A foot is a larger unit than an inch and is commonly used to describe longer dimensions.',
              style: _systemsBodyStyle,
            ),
          ),
        ),
        Positioned(left: 222, top: 521, child: const _FootImage()),
        const Positioned(
          left: 30,
          top: 601,
          child: SizedBox(
            width: 335,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Example:\n', style: _systemsLabelStyle),
                  TextSpan(
                    text: 'A board may be 6 feet long.',
                    style: _systemsBodyStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 667,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(9),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  Widget _buildLessonSummaryTab(BuildContext context) {
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
        const Positioned(
          left: 28,
          top: 135,
          child: Text('Lesson Progress', style: _progressLabelStyle),
        ),
        Positioned(
          right: 28,
          top: 134,
          child: Text('$_progressStep/$_tabCount', style: _progressCountStyle),
        ),
        Positioned(
          left: 26,
          top: 163,
          child: _ProgressBar(step: _progressStep, tabCount: _tabCount),
        ),
        const Positioned(
          left: 28,
          top: 192,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        const Positioned(
          left: 20,
          top: 222,
          child: SizedBox(
            width: 369,
            child: Text(
              'Lesson Summary',
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
        const Positioned(
          left: 28,
          top: 267,
          child: SizedBox(
            width: 353,
            child: Text(
              'Before moving to the next lesson, remember:',
              style: _summaryLabelStyle,
            ),
          ),
        ),
        const Positioned(
          left: 44,
          top: 302,
          child: SizedBox(
            width: 311,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Carpentry measurement',
                    style: _summaryBoldStyle,
                  ),
                  TextSpan(
                    text:
                        ' helps determine the correct size and dimensions of materials.\n\n',
                    style: _summaryBodyStyle,
                  ),
                  TextSpan(text: 'Mensuration', style: _summaryBoldStyle),
                  TextSpan(
                    text:
                        ' is the process of measuring and finding the dimensions of objects.\n\n',
                    style: _summaryBodyStyle,
                  ),
                  TextSpan(
                    text: 'Accurate measurement',
                    style: _summaryBoldStyle,
                  ),
                  TextSpan(
                    text:
                        ' helps prevent mistakes, reduce waste, and produce quality carpentry work.\n\n',
                    style: _summaryBodyStyle,
                  ),
                  TextSpan(text: 'Common terms:', style: _summaryBoldStyle),
                  TextSpan(
                    text: ' Length, Width, Height, and Thickness.\n\n',
                    style: _summaryBodyStyle,
                  ),
                  TextSpan(text: 'Metric units:', style: _summaryBoldStyle),
                  TextSpan(
                    text: ' mm, cm, and m.\n\n',
                    style: _summaryBodyStyle,
                  ),
                  TextSpan(text: 'English units', style: _summaryBoldStyle),
                  TextSpan(text: ': in and ft.', style: _summaryBodyStyle),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 36,
          top: 618,
          child: SizedBox(
            width: 327,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "CARPENTER'S REMINDER\n",
                    style: _summaryBoldStyle,
                  ),
                  TextSpan(
                    text: '“Measure accurately before you cut!”',
                    style: _summaryItalicStyle,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 667,
          child: SizedBox(width: 354, child: Divider(color: Color(0x3A000000))),
        ),
        Positioned(
          left: 16,
          top: 681,
          child: _IntroNavButton(
            label: 'PREVIOUS',
            backgroundColor: Colors.white,
            foregroundColor: _navy,
            borderColor: _navy,
            onPressed: () => _selectTab(10),
          ),
        ),
        Positioned(
          left: 144,
          top: 681,
          child: _IntroNavButton(
            label: 'PRACTICE_FINAL',
            backgroundColor: _accent,
            foregroundColor: _navy,
            onPressed: () => pushUnderDevelopment(context, title: 'Practice'),
          ),
        ),
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
        const DashboardBottomNavBar(currentTab: DashboardTab.lesson),
      ],
    );
  }

  static const _progressCountStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    letterSpacing: 0.42,
  );

  static const _progressLabelStyle = TextStyle(
    color: _navy,
    fontSize: 16,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: 0.48,
  );

  static const _sectionTitleStyle = TextStyle(
    color: _navy,
    fontSize: 20,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    height: 1,
    letterSpacing: 0.60,
  );

  static const _bodyStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0.45,
  );

  static const _sectionBodyBoldStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: 0.45,
  );

  static const _exampleStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    height: 1.33,
    letterSpacing: 0.45,
  );

  static const _exampleBodyStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: 0.45,
  );

  static const _calloutStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    height: 1.07,
    letterSpacing: -0.15,
  );

  static const _accurateBodyStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    height: 1.20,
    letterSpacing: 0.45,
  );

  static const _accurateRememberStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    height: 1.33,
    letterSpacing: -0.15,
  );

  static const _termsHeadingStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    height: 1.20,
    letterSpacing: -0.15,
  );

  static const _termsBodyStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    height: 1.33,
    letterSpacing: -0.15,
  );

  static const _termsExampleStyle = TextStyle(
    color: _navy,
    fontSize: 15,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    height: 1.33,
    letterSpacing: -0.15,
  );

  static const _systemsIntroStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: -0.14,
  );

  static const _systemsBodyStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: -0.14,
  );

  static const _systemsLabelStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    height: 1.43,
    letterSpacing: -0.14,
  );

  static const _summaryLabelStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: -0.14,
  );

  static const _summaryBoldStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    height: 1.29,
    letterSpacing: -0.14,
  );

  static const _summaryBodyStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    height: 1.29,
    letterSpacing: -0.14,
  );

  static const _summaryItalicStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w700,
    height: 1.64,
    letterSpacing: -0.14,
  );
}

class _LessonImage extends StatelessWidget {
  const _LessonImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'lib/assets/images/learningobj-intro.jpg',
        width: 357,
        height: 176,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _MeasurementImage extends StatelessWidget {
  const _MeasurementImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'lib/assets/images/misuretool.png',
        width: 197,
        height: 155,
        fit: BoxFit.cover,
      ),
    );
  }
}

class _MensurationImage extends StatelessWidget {
  const _MensurationImage();

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.08,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          'lib/assets/images/mensuration.png',
          width: 217.94,
          height: 214.17,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _AccurateImage extends StatelessWidget {
  const _AccurateImage();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.asset(
        'lib/assets/images/accurate.png',
        width: 242,
        height: 106,
        fit: BoxFit.fill,
      ),
    );
  }
}

class _LengthTermsImage extends StatelessWidget {
  const _LengthTermsImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/length-terms.png',
      width: 136,
      height: 121,
      fit: BoxFit.cover,
    );
  }
}

class _WidthTermsImage extends StatelessWidget {
  const _WidthTermsImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/width-terms.png',
      width: 180,
      height: 77,
      fit: BoxFit.fill,
    );
  }
}

class _HeightTermsImage extends StatelessWidget {
  const _HeightTermsImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/height-terms.png',
      width: 196,
      height: 81,
      fit: BoxFit.cover,
    );
  }
}

class _ThicknessTermsImage extends StatelessWidget {
  const _ThicknessTermsImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/thickness-terms.png',
      width: 180,
      height: 58,
      fit: BoxFit.cover,
    );
  }
}

class _MeasurementSystemsImage extends StatelessWidget {
  const _MeasurementSystemsImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/measurement systems.png',
      width: 330,
      height: 141,
      fit: BoxFit.cover,
    );
  }
}

class _MillimeterImage extends StatelessWidget {
  const _MillimeterImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/milimeter.png',
      width: 162,
      height: 66,
      fit: BoxFit.cover,
    );
  }
}

class _CentimeterImage extends StatelessWidget {
  const _CentimeterImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/centimeter.png',
      width: 174,
      height: 71,
      fit: BoxFit.cover,
    );
  }
}

class _MeterSystemImage extends StatelessWidget {
  const _MeterSystemImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/meter.png',
      width: 169,
      height: 77,
      fit: BoxFit.cover,
    );
  }
}

class _InchImage extends StatelessWidget {
  const _InchImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/inches.png',
      width: 177,
      height: 71,
      fit: BoxFit.cover,
    );
  }
}

class _FootImage extends StatelessWidget {
  const _FootImage();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'lib/assets/images/foot.png',
      width: 171,
      height: 77,
      fit: BoxFit.cover,
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.step, required this.tabCount});

  final int step;
  final int tabCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 356,
      height: 11,
      decoration: BoxDecoration(
        color: const Color(0xBAD9D9D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: step / tabCount,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: const Color(0xBA05831C),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
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
    if (label == 'PRACTICE') return const SizedBox.shrink();
    final visibleLabel = label == 'PRACTICE_FINAL' ? 'PRACTICE' : label;
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
          side: borderColor == null ? null : BorderSide(color: borderColor!),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            visibleLabel,
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

class _IntroButton extends StatelessWidget {
  const _IntroButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.disabled,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool disabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (label == 'PRACTICE') return const SizedBox.shrink();
    final visibleLabel = label == 'PRACTICE_FINAL' ? 'PRACTICE' : label;
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
            visibleLabel,
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

