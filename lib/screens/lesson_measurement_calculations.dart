import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class LessonsMeasurementCalculations extends StatefulWidget {
  const LessonsMeasurementCalculations({super.key});

  @override
  State<LessonsMeasurementCalculations> createState() =>
      _LessonsMeasurementCalculationsState();
}

class _LessonsMeasurementCalculationsState
    extends State<LessonsMeasurementCalculations> {
  static const _tabCount = 12;
  static const _navy = Color(0xFF061D3F);
  static const _lessonTitle = 'Measurement Calculations';

  int _currentTab = 0;
  bool _saving = false;

  int get _progressStep => _currentTab + 1;

  void _selectTab(int index) {
    setState(() {
      _currentTab = index;
    });
  }

  Future<void> _advance() async {
    if (_currentTab < _tabCount - 1) {
      _selectTab(_currentTab + 1);
      return;
    }

    if (_saving) return;

    setState(() {
      _saving = true;
    });

    try {
      await UserStore.mutate((user) {
        final Map<String, int> updatedTabs = Map.of(user.lessonLastTabs);
        updatedTabs[_lessonTitle] = _tabCount;

        final Set<String> updatedCompleted = Set.of(user.completedLessonTabs);
        for (int i = 0; i < _tabCount; i++) {
          updatedCompleted.add('${_lessonTitle}_$i');
        }

        final bool wasAlreadyCompleted = user.completedLessonsList.contains(
          _lessonTitle,
        );
        final int newXpEarned = user.xpEarned + (wasAlreadyCompleted ? 0 : 50);

        final List<String> newCompletedLessonsList = List.of(
          user.completedLessonsList,
        );
        if (!wasAlreadyCompleted) {
          newCompletedLessonsList.add(_lessonTitle);
        }

        return user.copyWith(
          lessonLastTabs: updatedTabs,
          completedLessonTabs: updatedCompleted.toList(),
          currentLessonTitle: _lessonTitle,
          currentLessonProgressPercent: 100,
          completedLessonsList: newCompletedLessonsList,
          xpEarned: newXpEarned,
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (_currentTab) {
      case 0:
        return _buildTab1(context);
      case 1:
        return _buildTab2(context);
      case 2:
        return _buildTab3(context);
      case 3:
        return _buildTab4(context);
      case 4:
        return _buildTab5(context);
      case 5:
        return _buildTab6(context);
      case 6:
        return _buildTab7(context);
      case 7:
        return _buildTab8(context);
      case 8:
        return _buildTab9(context);
      case 9:
        return _buildTab10(context);
      case 10:
        return _buildTab11(context);
      case 11:
        return _buildTab12(context);
      default:
        return _buildEmptyTab(context);
    }
  }

  Widget _buildTab1(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
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
        Positioned(
          left: 46,
          top: 252,
          child: Container(
            width: 319,
            height: 199,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: const DecorationImage(
                image: AssetImage('lib/assets/images/learningobj.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 45,
          top: 478,
          child: SizedBox(
            width: 345,
            child: Text(
              'After completing this lesson, you should be able to perform basic calculations involving measurements and solve simple carpentry problems using appropriate formulas.',
              style: TextStyle(
                color: _navy,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.5,
                letterSpacing: 0.48,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTab2(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 59,
          right: 59,
          top: 206,
          child: Text(
            'Why Are Measurement \nCalculations Important?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 22,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              height: 1.2,
              letterSpacing: 0.66,
            ),
          ),
        ),
        const Positioned(
          left: 21,
          right: 21,
          top: 274,
          child: Text(
            'In carpentry, measuring a material is only the first step. Carpenters also need to add, subtract, multiply, and divide measurements to determine the amount of material needed.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              height: 1.20,
              letterSpacing: 0.45,
            ),
          ),
        ),
        const Positioned(
          left: 27,
          right: 27,
          top: 392,
          child: Text(
            '• Finding the total length of materials\n• Determining the remaining length of a board\n• Finding the amount of material needed for several pieces\n• Dividing materials into equal parts\n• Calculating the perimeter and area of a project',
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              height: 1.38,
              letterSpacing: 0.48,
            ),
          ),
        ),
        const Positioned(
          left: 21,
          right: 21,
          top: 585,
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
                      'Always check that the measurements use the same unit before calculating.',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.21,
                    letterSpacing: 0.42,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTab3(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 28,
          right: 28,
          top: 216,
          child: Text(
            'Basic Operations',
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
          top: 273,
          child: SizedBox(
            width: 354,
            child: Text(
              'Addition (+)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 38,
          top: 304,
          child: SizedBox(
            width: 354,
            child: Text(
              'Addition is used when combining measurements.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 348,
          child: SizedBox(
            width: 331,
            child: Text(
              'Example:\n 120 cm + 80 cm = 200 cm',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 34,
          top: 401,
          child: SizedBox(
            width: 325,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Carpentry Use:',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' Finding the total length of two or more pieces of material.',
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
        const Positioned(
          left: 27,
          top: 472,
          child: SizedBox(
            width: 354,
            child: Text(
              'Subtraction (−)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 38,
          top: 502,
          child: SizedBox(
            width: 354,
            child: Text(
              'Subtraction is used when finding the remaining or missing measurement.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 20,
          top: 549,
          child: SizedBox(
            width: 354,
            child: Text(
              'Example: \n200 cm − 75 cm = 125 cm',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 41,
          top: 602,
          child: SizedBox(
            width: 341,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Carpentry Use: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'Finding how much material remains after cutting',
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
      ],
    );
  }

  Widget _buildTab4(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 28,
          right: 28,
          top: 216,
          child: Text(
            'Basic Operations',
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
          top: 273,
          child: SizedBox(
            width: 354,
            child: Text(
              'Multiplication (×)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 38,
          top: 304,
          child: SizedBox(
            width: 354,
            child: Text(
              'Multiplication is used when the same measurement is repeated.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 28,
          top: 351,
          child: SizedBox(
            width: 331,
            child: Text(
              'Example:\n50 cm × 4 = 200 cm',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 34,
          top: 401,
          child: SizedBox(
            width: 325,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Carpentry Use: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Finding the total material needed for several equal pieces.',
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
        const Positioned(
          left: 26,
          top: 467,
          child: SizedBox(
            width: 354,
            child: Text(
              'Division (÷)',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 38,
          top: 496,
          child: SizedBox(
            width: 341,
            child: Text(
              'Division is used when a measurement needs to be divided into equal parts.',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 19,
          top: 543,
          child: SizedBox(
            width: 354,
            child: Text(
              'Example: \n240 cm ÷ 4 = 60 cm',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 1.20,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 41,
          top: 592,
          child: SizedBox(
            width: 341,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Carpentry Use: ',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.20,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'Dividing materials into equal lengths.',
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
      ],
    );
  }

  Widget _buildTab5(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 29,
          right: 29,
          top: 216,
          child: Text(
            'Working with Different Units',
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
          left: 43,
          top: 278,
          child: SizedBox(
            width: 335,
            child: Text(
              'Before performing calculations, measurements should be converted into the same unit.',
              textAlign: TextAlign.center,
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
        Positioned(
          left: 22,
          top: 356,
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
                          'Unit',
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
                          '1 meter (m)',
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
                            '100 centimeters (cm)',
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
                          '1 centimeter (cm)',
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
                            '10 millimeters (mm)',
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
          left: 22,
          right: 22,
          top: 515,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example: ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.94,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: '1 m + 50 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.94,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: 'Convert 1 m to centimeters:',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.94,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: ' 1 m = 100 cm\n100 cm + 50 cm = 150 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.94,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: 'Answer',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.94,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: ': 150 cm or 1.5 m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.94,
                    letterSpacing: 0.48,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTab6(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 70,
          right: 70,
          top: 216,
          child: Text(
            'Fractions in Carpentry',
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
          left: 19,
          right: 19,
          top: 278,
          child: Text(
            'Fractions are commonly used when measurements are smaller than a whole unit.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              height: 1.20,
              letterSpacing: 0.45,
            ),
          ),
        ),
        const Positioned(
          left: 39,
          right: 39,
          top: 349,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example:\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.67,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: '½ m, ¼ m, ¾ m, 1½ m, 2¼ m\n½ m + ¼ m = ¾ m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.67,
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
          top: 450,
          child: Text(
            'Since 1 m = 100 cm:',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              height: 1.20,
              letterSpacing: 0.45,
            ),
          ),
        ),
        const Positioned(
          left: 53,
          right: 53,
          top: 474,
          child: Text(
            '½ m = 50 cm\n¼ m = 25 cm\n¾ m = 75 cm',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _navy,
              fontSize: 16,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              height: 1.38,
              letterSpacing: 0.48,
            ),
          ),
        ),
        const Positioned(
          left: 19,
          right: 19,
          top: 554,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example solution: ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 1.93,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: '½ m + 25 cm\n½ m = 50 cm → 50 cm + 25 cm = 75 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.93,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'Answer:',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.93,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 75 cm or ¾ m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.93,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTab7(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 110,
          right: 110,
          top: 220,
          child: Text(
            'Mixed Numbers',
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
          right: 27,
          top: 304,
          child: SizedBox(
            height: 43,
            child: Text(
              'A mixed number consists of a whole number and a fraction.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w400,
                height: 1.13,
                letterSpacing: 0.48,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 35,
          right: 35,
          top: 375,
          child: Text(
            'Example: \n1½ m, 2¼ m, 3¾ m',
            textAlign: TextAlign.center,
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
          left: 35,
          right: 35,
          top: 466,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example equation:\n ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w600,
                    height: 2.13,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: '1½ m + 50 cm\n150 cm + 50 cm = 200 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: 'Answer:',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 2.13,
                    letterSpacing: 0.48,
                  ),
                ),
                TextSpan(
                  text: ' 200 cm or 2 m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 16,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
                    letterSpacing: 0.48,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTab8(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 38,
          right: 38,
          top: 220,
          child: Text(
            'Simple Carpentry Problems',
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
          top: 281,
          child: SizedBox(
            width: 331,
            child: Text(
              'Example 1 – Finding Total Length',
              style: TextStyle(
                color: _navy,
                fontSize: 16,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 2,
                letterSpacing: 0.48,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 32,
          right: 32,
          top: 331,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'Board A = 150 cm; Board B = 80 cm\n150 cm + 80 cm = 230 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' Answer:',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 230 cm',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
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
          top: 468,
          child: SizedBox(
            width: 357,
            child: Text(
              'Example 2 – Finding Remaining Material',
              style: TextStyle(
                color: _navy,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                height: 2.13,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 32,
          right: 32,
          top: 518,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'A board is 300 cm long and 125 cm is cut.\n300 cm − 125 cm = 175 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' Answer:',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 175 cm remaining',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTab9(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 38,
          right: 38,
          top: 220,
          child: Text(
            'Simple Carpentry Problems',
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
          top: 286,
          child: SizedBox(
            width: 331,
            child: Text(
              'Example 3 – Multiple Pieces',
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
        ),
        const Positioned(
          left: 31,
          right: 31,
          top: 331,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      '5 pieces of wood are each 40 cm long.\n40 cm × 5 = 200 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' Answer:',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 200 cm or 2 m',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
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
          top: 475,
          child: SizedBox(
            width: 331,
            child: Text(
              'Example 4 – Equal Pieces',
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
        ),
        const Positioned(
          left: 26,
          right: 26,
          top: 520,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text:
                      'A 240 cm board is cut into 6 equal pieces.\n240 cm ÷ 6 = 40 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' Answer: ',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'Each piece is 40 cm long.',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 2.13,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTab10(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 49,
          right: 49,
          top: 220,
          child: Text(
            'Basic Carpentry Formulas',
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
          top: 286,
          child: SizedBox(
            width: 331,
            child: Text(
              'Perimeter of a Rectangle',
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
        ),
        const Positioned(
          left: 28,
          right: 28,
          top: 339,
          child: Text(
            'Perimeter is the total distance around a rectangle.',
            textAlign: TextAlign.center,
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
        const Positioned(
          left: 68,
          top: 415,
          child: SizedBox(
            width: 132,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'P ',
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
                    text: '= Perimeter\n',
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
                    text: 'L ',
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
                    text: '= Length\n',
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
                    text: 'W ',
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
                    text: '= Width',
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
          left: 225,
          top: 415,
          child: SizedBox(
            width: 133,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Formula: \n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.67,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'P = 2(L + W)',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.67,
                      letterSpacing: 0.45,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const Positioned(
          left: 27,
          right: 27,
          top: 511,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example equation:\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.73,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'L = 100 cm, W = 50 cm\nP = 2(100 + 50) = 300 cm\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.73,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' Answer:',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.73,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 300 cm',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.73,
                    letterSpacing: 0.45,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTab11(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 49,
          right: 49,
          top: 220,
          child: Text(
            'Basic Carpentry Formulas',
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
          top: 286,
          child: SizedBox(
            width: 331,
            child: Text(
              'Area of a Rectangle',
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
        ),
        const Positioned(
          left: 28,
          right: 28,
          top: 339,
          child: Text(
            'Area is the amount of surface covered by a rectangle.',
            textAlign: TextAlign.center,
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
        const Positioned(
          left: 69,
          top: 401,
          child: SizedBox(
            width: 132,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'A ',
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
                    text: '= Area\n',
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
                    text: 'L ',
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
                    text: '= Length\n',
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
                    text: 'W ',
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
                    text: '= Width',
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
          left: 226,
          top: 401,
          child: SizedBox(
            width: 133,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Formula: \n',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      height: 1.67,
                      letterSpacing: 0.45,
                    ),
                  ),
                  TextSpan(
                    text: 'A = L × W',
                    style: TextStyle(
                      color: _navy,
                      fontSize: 15,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      height: 1.67,
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
          right: 28,
          top: 483,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Example:\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.73,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: 'L = 120 cm, W = 40 cm\nA = 120 × 40 = 4,800 cm²\n',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.73,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' Answer:',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    height: 1.73,
                    letterSpacing: 0.45,
                  ),
                ),
                TextSpan(
                  text: ' 4,800 cm²',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 15,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.73,
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
          right: 28,
          top: 603,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Important: ',
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
                  text: 'Area is written in square units, such as cm² or m².',
                  style: TextStyle(
                    color: _navy,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                    letterSpacing: 0.42,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildTab12(BuildContext context) {
    return _buildTabWrapper(
      context,
      children: [
        const Positioned(
          left: 36,
          right: 36,
          top: 219,
          child: Text(
            'Quick Review',
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
          left: 28,
          right: 28,
          top: 289,
          child: Text(
            'Addition (+) → Combine measurements\nSubtraction (−) → Find what remains\nMultiplication (×) → Find the total of equal measurements\nDivision (÷) → Divide measurements into equal parts\nConvert measurements into the same unit before calculating.\nWrite the correct unit in your answer.\nFor area, use square units (cm², m²).\nFor perimeter, use regular units such as cm or m.',
            style: TextStyle(
              color: _navy,
              fontSize: 15,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              height: 1.67,
              letterSpacing: 0.45,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTabWrapper(
    BuildContext context, {
    required List<Widget> children,
  }) {
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
            'Lesson 6 - Measurement\nCalculations',
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
        ...children,
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
            label: _currentTab == _tabCount - 1 ? 'Finish' : 'Next',
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
                      : Text(
                          _currentTab == _tabCount - 1 ? 'DONE' : 'NEXT',
                          style: const TextStyle(
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
        if (_currentTab == _tabCount - 1)
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
                onTap: _saving ? null : () => _selectTab(_currentTab - 1),
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
    return const DesignCanvas(
      width: 409,
      height: 849,
      backgroundColor: Colors.white,
      children: [],
    );
  }
}
