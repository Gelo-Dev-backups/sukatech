import 'dart:math';
import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../services/sound_service.dart';
import '../widgets/quiz_shared_widgets.dart';

enum ChallengeSkill {
  tapeReading,
  woodMeasurement,
  unitConversion,
  toolSelection,
  carpentryMath,
}

class ChallengeQuestion {
  const ChallengeQuestion({
    required this.skill,
    required this.skillTitle,
    required this.jobOrderTitle,
    required this.prompt,
    required this.correctAnswer,
    required this.distractors,
    required this.explanation,
    this.ratio,
    this.unit = 'in',
    this.imageAsset,
  });

  final ChallengeSkill skill;
  final String skillTitle;
  final String jobOrderTitle;
  final String prompt;
  final String correctAnswer;
  final List<String> distractors;
  final String explanation;
  final double? ratio; // For tape / wood visual previews
  final String unit;
  final String? imageAsset; // For tool selection preview
}

const _allChallengePool = <ChallengeQuestion>[
  // ── Skill 1: Tape Reading ───────────────────────────────────────────────
  ChallengeQuestion(
    skill: ChallengeSkill.tapeReading,
    skillTitle: 'TAPE READING',
    jobOrderTitle: 'Read Fractional Inch on Blade',
    prompt: 'Inspect the tape measure marker. What exact imperial measurement is indicated?',
    correctAnswer: '2 1/2 in.',
    distractors: ['2 3/8 in.', '2 5/8 in.', '2 3/4 in.'],
    ratio: 0.61698,
    unit: 'in',
    explanation: 'The marker aligns halfway between 2 and 3 inches on the 1/2-inch tick (2 1/2 in.).',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.tapeReading,
    skillTitle: 'TAPE READING',
    jobOrderTitle: 'Read Quarter Inch on Blade',
    prompt: 'What measurement is indicated by the downward arrow on the tape measure?',
    correctAnswer: '2 1/4 in.',
    distractors: ['2 1/8 in.', '2 3/8 in.', '2 1/2 in.'],
    ratio: 0.56149,
    unit: 'in',
    explanation: 'The marker points to the 1/4-inch tick (2 2/8 in.) past the 2-inch mark.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.tapeReading,
    skillTitle: 'TAPE READING',
    jobOrderTitle: 'Read Whole Inch on Blade',
    prompt: 'What whole-inch measurement does the red pointer align with?',
    correctAnswer: '3 in.',
    distractors: ['2 7/8 in.', '3 1/8 in.', '3 1/4 in.'],
    ratio: 0.73168,
    unit: 'in',
    explanation: 'The indicator line points directly to the 3-inch major graduation mark.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.tapeReading,
    skillTitle: 'TAPE READING',
    jobOrderTitle: 'Read Metric Scale (cm)',
    prompt: 'Look at the metric scale at the top of the blade. What measurement is shown?',
    correctAnswer: '6 cm',
    distractors: ['5.5 cm', '6.5 cm', '7 cm'],
    ratio: 0.61411,
    unit: 'cm',
    explanation: 'The indicator marker aligns cleanly with the 6 centimeter (60 mm) mark.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.tapeReading,
    skillTitle: 'TAPE READING',
    jobOrderTitle: 'Read Half-Centimeter on Blade',
    prompt: 'What metric measurement is shown halfway between 7 and 8 cm on the tape?',
    correctAnswer: '7.5 cm',
    distractors: ['7 cm', '8 cm', '7.2 cm'],
    ratio: 0.76017,
    unit: 'cm',
    explanation: 'The tick halfway between 7 and 8 cm represents 7.5 centimeters (75 mm).',
  ),

  // ── Skill 2: Wood Measurement ───────────────────────────────────────────
  ChallengeQuestion(
    skill: ChallengeSkill.woodMeasurement,
    skillTitle: 'WOOD MEASURING',
    jobOrderTitle: 'Inspect Timber Cut Length',
    prompt: 'A timber stud is aligned from zero with a pencil mark at 5 cm. What is the length of this wood piece?',
    correctAnswer: '5 cm',
    distractors: ['4 cm', '4.5 cm', '5.5 cm'],
    ratio: 0.5300,
    unit: 'cm',
    explanation: 'The timber begins at 0 and the cut line marks exactly 5 cm (50 mm).',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.woodMeasurement,
    skillTitle: 'WOOD MEASURING',
    jobOrderTitle: 'Half-Centimeter Wood Mark',
    prompt: 'A shelf bracket requires a wood block cut at 3.5 cm. Which measurement is shown on the tape?',
    correctAnswer: '3.5 cm',
    distractors: ['3 cm', '4 cm', '2.5 cm'],
    ratio: 0.3800,
    unit: 'cm',
    explanation: '3.5 cm sits exactly midway between the 3 cm and 4 cm graduation ticks.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.woodMeasurement,
    skillTitle: 'WOOD MEASURING',
    jobOrderTitle: 'Blueprint Millimeter Spec',
    prompt: 'A plan specifies cutting a block at 7 cm. How many millimeters of wood does this equal?',
    correctAnswer: '70 mm',
    distractors: ['7 mm', '700 mm', '50 mm'],
    unit: 'mm',
    explanation: 'Each centimeter equals 10 millimeters, so 7 cm × 10 = 70 mm.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.woodMeasurement,
    skillTitle: 'WOOD MEASURING',
    jobOrderTitle: 'Trim Cut Calculation',
    prompt: 'A carpenter marks wood at 6.5 cm. If 1 cm is trimmed off the end, what is the new length?',
    correctAnswer: '5.5 cm',
    distractors: ['5 cm', '6 cm', '4.5 cm'],
    unit: 'cm',
    explanation: '6.5 cm − 1.0 cm = 5.5 cm.',
  ),

  // ── Skill 3: Unit Conversion ────────────────────────────────────────────
  ChallengeQuestion(
    skill: ChallengeSkill.unitConversion,
    skillTitle: 'UNIT CONVERSION',
    jobOrderTitle: 'Inches to Feet Conversion',
    prompt: 'A cutting list requires a 36-inch piece of 2x4 lumber. How many feet is this?',
    correctAnswer: '3 ft.',
    distractors: ['2.5 ft.', '3.5 ft.', '4 ft.'],
    unit: 'ft',
    explanation: '36 inches ÷ 12 inches per foot = 3 feet.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.unitConversion,
    skillTitle: 'UNIT CONVERSION',
    jobOrderTitle: 'Meters to Centimeters',
    prompt: 'You have a 2-meter length of pine baseboard molding. How many centimeters long is it?',
    correctAnswer: '200 cm',
    distractors: ['20 cm', '2,000 cm', '100 cm'],
    unit: 'cm',
    explanation: '1 meter = 100 cm, therefore 2 meters × 100 = 200 cm.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.unitConversion,
    skillTitle: 'UNIT CONVERSION',
    jobOrderTitle: 'Inches to Millimeters Spec',
    prompt: 'An imported fastener measures 2 inches in length. What is its size in millimeters? (1 in. = 25.4 mm)',
    correctAnswer: '50.8 mm',
    distractors: ['25.4 mm', '5.08 mm', '100 mm'],
    unit: 'mm',
    explanation: '2 inches × 25.4 mm/inch = 50.8 mm.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.unitConversion,
    skillTitle: 'UNIT CONVERSION',
    jobOrderTitle: 'Feet to Inches Layout',
    prompt: 'A project plan calls for 1.5 feet of plywood. How many inches should you measure on your tape?',
    correctAnswer: '18 in.',
    distractors: ['15 in.', '16 in.', '20 in.'],
    unit: 'in',
    explanation: '1.5 feet × 12 inches/ft = 18 inches (1 foot + 6 inches).',
  ),

  // ── Skill 4: Tool Selection ─────────────────────────────────────────────
  ChallengeQuestion(
    skill: ChallengeSkill.toolSelection,
    skillTitle: 'TOOL SELECTION',
    jobOrderTitle: 'Corner Squareness Check',
    prompt: 'You need to check if the corner of an assembled cabinet face frame is a true 90° right angle. Which tool is best?',
    correctAnswer: 'Try Square',
    distractors: ['Steel Ruler', 'Tape Measure', 'Folding Rule'],
    imageAsset: 'lib/assets/images/try-square.png',
    explanation: 'A try square has a rigid 90° blade and stock specifically designed to test right angles and squareness.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.toolSelection,
    skillTitle: 'TOOL SELECTION',
    jobOrderTitle: 'Small Thickness Precision',
    prompt: 'You need to measure the exact diameter of a round wooden dowel down to the decimal millimeter. Which tool is best?',
    correctAnswer: 'Vernier Caliper',
    distractors: ['Tape Measure', 'Straight Edge', 'Folding Rule'],
    imageAsset: 'lib/assets/images/venice-caliper.png',
    explanation: 'A vernier caliper provides extreme precision when measuring outside diameters, inside holes, and depths.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.toolSelection,
    skillTitle: 'TOOL SELECTION',
    jobOrderTitle: 'Long Span Measurement',
    prompt: 'You need to measure a 6-meter span across a room to frame a partition wall. Which tool is best?',
    correctAnswer: 'Tape Measure',
    distractors: ['Try Square', 'Steel Ruler', 'Vernier Caliper'],
    imageAsset: 'lib/assets/images/tape-measure.png',
    explanation: 'A flexible tape measure (pull-push rule) extends several meters, making it ideal for room spans and framing.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.toolSelection,
    skillTitle: 'TOOL SELECTION',
    jobOrderTitle: 'Surface Flatness Inspection',
    prompt: 'You need to test if a joined tabletop surface is completely flat without any dips or bowing. Which tool is best?',
    correctAnswer: 'Straight Edge',
    distractors: ['Try Square', 'Folding Rule', 'Caliper'],
    imageAsset: 'lib/assets/images/straight-edge.png',
    explanation: 'A straight edge features a precision-machined edge used to detect humps, dips, or warps across surfaces.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.toolSelection,
    skillTitle: 'TOOL SELECTION',
    jobOrderTitle: 'Full Plywood Line Marking',
    prompt: 'You need to mark a long, straight guide line across an 8-foot plywood sheet before cutting. Which tool is best?',
    correctAnswer: 'Chalk Line',
    distractors: ['Steel Ruler', 'Try Square', 'Vernier Caliper'],
    imageAsset: 'lib/assets/images/chalk line.png',
    explanation: 'A chalk line reel holds a string coated with chalk that snaps a crisp, long reference line across full sheets.',
  ),

  // ── Skill 5: Carpentry Math ─────────────────────────────────────────────
  ChallengeQuestion(
    skill: ChallengeSkill.carpentryMath,
    skillTitle: 'CARPENTRY MATH',
    jobOrderTitle: 'Cutting List Remainder',
    prompt: 'You have a 48-inch board. You cut three identical 12-inch shelves from it. How many inches of board remain?',
    correctAnswer: '12 in.',
    distractors: ['6 in.', '14 in.', '16 in.'],
    unit: 'in',
    explanation: '3 shelves × 12 in. = 36 inches used. 48 in. − 36 in. = 12 inches remaining.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.carpentryMath,
    skillTitle: 'CARPENTRY MATH',
    jobOrderTitle: 'Workbench Perimeter',
    prompt: 'Calculate the perimeter of a rectangular workbench top that is 4 feet long and 2 feet wide.',
    correctAnswer: '12 ft.',
    distractors: ['8 ft.', '14 ft.', '16 ft.'],
    unit: 'ft',
    explanation: 'Perimeter = 2 × (Length + Width) = 2 × (4 + 2) = 2 × 6 = 12 feet.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.carpentryMath,
    skillTitle: 'CARPENTRY MATH',
    jobOrderTitle: 'Adding Fractional Inches',
    prompt: 'Add the two measurements: 1/4 inch + 3/8 inch. What is the total length?',
    correctAnswer: '5/8 in.',
    distractors: ['4/12 in.', '1/2 in.', '7/8 in.'],
    unit: 'in',
    explanation: 'Convert 1/4 to 2/8. Then 2/8 + 3/8 = 5/8 inch.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.carpentryMath,
    skillTitle: 'CARPENTRY MATH',
    jobOrderTitle: 'Subtracting Fractional Inches',
    prompt: 'Subtract 3/8 inch from 7/8 inch. What is the simplified result?',
    correctAnswer: '1/2 in.',
    distractors: ['4/8 in.', '1/4 in.', '3/4 in.'],
    unit: 'in',
    explanation: '7/8 − 3/8 = 4/8 inch. Simplified by dividing numerator and denominator by 4 gives 1/2 inch.',
  ),
  ChallengeQuestion(
    skill: ChallengeSkill.carpentryMath,
    skillTitle: 'CARPENTRY MATH',
    jobOrderTitle: 'Lumber Board Feet Calculation',
    prompt: 'Calculate the board feet for a piece of lumber: 1 inch thick, 6 inches wide, and 8 feet long. (Formula: T" × W" × L\' / 12)',
    correctAnswer: '4 BF',
    distractors: ['2 BF', '6 BF', '8 BF'],
    unit: 'BF',
    explanation: '(1 × 6 × 8) / 12 = 48 / 12 = 4 Board Feet.',
  ),
];

class MeasurementChallengePracticeScreen extends StatefulWidget {
  const MeasurementChallengePracticeScreen({super.key});

  @override
  State<MeasurementChallengePracticeScreen> createState() =>
      _MeasurementChallengePracticeScreenState();
}

class _MeasurementChallengePracticeScreenState
    extends State<MeasurementChallengePracticeScreen> {
  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);
  static const _green = Color(0xFF05831C);
  static const _red = Color(0xFFD32F2F);
  static const _teal = Color(0xFF0284C7);
  static const _amber = Color(0xFFD97706);
  static const _montserrat = 'Montserrat';

  late List<ChallengeQuestion> _sessionQuestions;
  late List<List<String>> _sessionChoices;
  int _currentIndex = 0;
  int? _selectedChoiceIndex;
  int _score = 0;
  bool _answered = false;
  final List<bool> _skillResults = [];

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    final rng = Random();

    // Select exactly 1 question from each of the 5 skills to test full mastery
    final skills = [
      ChallengeSkill.tapeReading,
      ChallengeSkill.woodMeasurement,
      ChallengeSkill.unitConversion,
      ChallengeSkill.toolSelection,
      ChallengeSkill.carpentryMath,
    ];

    final questions = <ChallengeQuestion>[];
    for (final skill in skills) {
      final pool = _allChallengePool.where((q) => q.skill == skill).toList()
        ..shuffle(rng);
      questions.add(pool.first);
    }

    _sessionQuestions = questions;
    _sessionChoices = _sessionQuestions.map((q) {
      final choices = [q.correctAnswer, ...q.distractors]..shuffle(rng);
      return choices;
    }).toList();

    _currentIndex = 0;
    _selectedChoiceIndex = null;
    _score = 0;
    _answered = false;
    _skillResults.clear();
  }

  Color _getSkillColor(ChallengeSkill skill) {
    switch (skill) {
      case ChallengeSkill.tapeReading:
        return const Color(0xFF0284C7);
      case ChallengeSkill.woodMeasurement:
        return const Color(0xFF0D9488);
      case ChallengeSkill.unitConversion:
        return const Color(0xFFD97706);
      case ChallengeSkill.toolSelection:
        return const Color(0xFF7C3AED);
      case ChallengeSkill.carpentryMath:
        return const Color(0xFF05831C);
    }
  }

  IconData _getSkillIcon(ChallengeSkill skill) {
    switch (skill) {
      case ChallengeSkill.tapeReading:
        return Icons.straighten_rounded;
      case ChallengeSkill.woodMeasurement:
        return Icons.carpenter_rounded;
      case ChallengeSkill.unitConversion:
        return Icons.sync_alt_rounded;
      case ChallengeSkill.toolSelection:
        return Icons.handyman_rounded;
      case ChallengeSkill.carpentryMath:
        return Icons.calculate_rounded;
    }
  }

  void _onSelectChoice(int index) {
    if (_answered) return;
    setState(() {
      _selectedChoiceIndex = index;
    });
  }

  void _onSubmit() {
    if (_selectedChoiceIndex == null || _answered) return;

    final currentQ = _sessionQuestions[_currentIndex];
    final choices = _sessionChoices[_currentIndex];
    final isCorrect = choices[_selectedChoiceIndex!] == currentQ.correctAnswer;

    UserStore.recordAnswer(isCorrect);
    UserStore.mutate((user) => user.copyWith(
      currentLessonTitle: 'Measurement Challenge Practice',
      currentLessonProgressPercent: ((_currentIndex + 1) * 20).clamp(0, 100),
    ));
    setState(() {
      _answered = true;
      _skillResults.add(isCorrect);
      if (isCorrect) {
        _score++;
        SoundService.instance.playCorrect();
      } else {
        SoundService.instance.playWrong();
      }
    });
  }

  void _onNext() {
    if (_currentIndex < 4) {
      setState(() {
        _currentIndex++;
        _selectedChoiceIndex = null;
        _answered = false;
      });
    } else {
      _onCompleteSession();
    }
  }

  void _onCompleteSession() {
    final xpEarned = _score == 5
        ? 40
        : _score >= 3
            ? _score * 6
            : _score * 5;

    final isPerfect = _score == 5;
    UserStore.mutate((user) {
      final tabs = List<String>.from(user.completedLessonTabs);
      if (isPerfect && !tabs.contains('perfect_measurement')) {
        tabs.add('perfect_measurement');
      }
      return user.copyWith(
        xpEarned: user.xpEarned + xpEarned,
        practiceCompleted: user.practiceCompleted + 1,
        completedLessonTabs: tabs,
        currentLessonTitle: 'Measurement Challenge Practice',
        currentLessonProgressPercent: 100,
      );
    });
    SoundService.instance.playQuizComplete();
    if (xpEarned > 0) {
      SoundService.instance.playGainXp();
    }

    String rankTitle;
    String rankSub;
    IconData rankIcon;
    Color rankColor;

    if (_score == 5) {
      rankTitle = 'Master Carpenter!';
      rankSub = 'Perfect score! You mastered all 5 core skills!';
      rankIcon = Icons.emoji_events_rounded;
      rankColor = _amber;
    } else if (_score >= 4) {
      rankTitle = 'Senior Craftsman!';
      rankSub = 'Excellent performance across carpentry challenges!';
      rankIcon = Icons.military_tech_rounded;
      rankColor = _green;
    } else if (_score >= 3) {
      rankTitle = 'Journeyman Builder!';
      rankSub = 'Solid work! Keep refining your measurement speed!';
      rankIcon = Icons.thumb_up_rounded;
      rankColor = _teal;
    } else {
      rankTitle = 'Apprentice Builder';
      rankSub = 'Good effort! Review the lessons and try again!';
      rankIcon = Icons.replay_rounded;
      rankColor = _navy;
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          contentPadding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: rankColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                child: Icon(rankIcon, color: rankColor, size: 44),
              ),
              const SizedBox(height: 16),
              Text(
                rankTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: _navy,
                  fontSize: 20,
                  fontFamily: _montserrat,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                rankSub,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 13,
                  fontFamily: _montserrat,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 14),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '+$xpEarned XP Earned • $_score/5 Correct',
                  style: const TextStyle(
                    color: Color(0xFFB45309),
                    fontSize: 13.5,
                    fontFamily: _montserrat,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Skill Checklist
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Column(
                  children: List.generate(_sessionQuestions.length, (i) {
                    final passed = i < _skillResults.length && _skillResults[i];
                    final q = _sessionQuestions[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 3),
                      child: Row(
                        children: [
                          Icon(
                            passed
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: passed ? _green : _red,
                            size: 17,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              q.skillTitle,
                              style: TextStyle(
                                color: passed ? _navy : const Color(0xFF6B7280),
                                fontSize: 12,
                                fontFamily: _montserrat,
                                fontWeight:
                                    passed ? FontWeight.w700 : FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: _navy, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        setState(() {
                          _startNewSession();
                        });
                      },
                      child: const Text(
                        'Try Again',
                        style: TextStyle(
                          color: _navy,
                          fontFamily: _montserrat,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _navy,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(
                          fontFamily: _montserrat,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQ = _sessionQuestions[_currentIndex];
    final choices = _sessionChoices[_currentIndex];
    final progress = (_currentIndex + 1) / 5.0;
    final skillColor = _getSkillColor(currentQ.skill);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ── Top Header ─────────────────────────────────────────────────
            Container(
              color: _navy,
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 16, 6),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () => Navigator.of(context).pop(),
                            icon: const Icon(
                              Icons.arrow_back_ios_new_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Measurement Challenge',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: _montserrat,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Mastery Practice',
                                  style: TextStyle(
                                    color: _accent,
                                    fontSize: 11,
                                    fontFamily: _montserrat,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Round ${_currentIndex + 1}/5',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: _montserrat,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Challenge ${_currentIndex + 1} of 5',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10.5,
                                  fontFamily: _montserrat,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${(progress * 100).round()}%',
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 10.5,
                                  fontFamily: _montserrat,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          AnimatedProgressBar(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: Colors.white24,
                            progressColor: _green,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

        // ── Main Content Area ──────────────────────────────────────────
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
            child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Skill Category Badge
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: skillColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: skillColor.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getSkillIcon(currentQ.skill),
                                size: 14,
                                color: skillColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'STAGE ${_currentIndex + 1}: ${currentQ.skillTitle}',
                                style: TextStyle(
                                  color: skillColor,
                                  fontSize: 11,
                                  fontFamily: _montserrat,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Prompt Box
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _navy.withValues(alpha: 0.08),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentQ.jobOrderTitle,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            currentQ.prompt,
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 15.5,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ── Dynamic Visual Preview if applicable ───────────────
                    if (currentQ.skill == ChallengeSkill.tapeReading &&
                        currentQ.ratio != null) ...[
                      _buildTapeBladePreview(currentQ),
                      const SizedBox(height: 16),
                    ] else if (currentQ.skill == ChallengeSkill.woodMeasurement &&
                        currentQ.ratio != null) ...[
                      _buildWoodTapePreview(currentQ),
                      const SizedBox(height: 16),
                    ] else if (currentQ.skill == ChallengeSkill.toolSelection &&
                        currentQ.imageAsset != null) ...[
                      _buildToolVisualCard(currentQ),
                      const SizedBox(height: 16),
                    ],

                    // ── 2x2 Options Grid ───────────────────────────────────
                    Row(
                      children: [
                        Expanded(child: _buildChoiceCard(0, choices[0])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildChoiceCard(1, choices[1])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildChoiceCard(2, choices[2])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildChoiceCard(3, choices[3])),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Submit Button or Feedback Panel ────────────────────
                    if (!_answered)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _navy,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: _navy.withValues(alpha: 0.35),
                          disabledForegroundColor: Colors.white70,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: _selectedChoiceIndex != null ? _onSubmit : null,
                        child: const Text(
                          'Submit Answer',
                          style: TextStyle(
                            fontFamily: _montserrat,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            letterSpacing: 0.4,
                          ),
                        ),
                      )
                    else
                      _buildFeedbackPanel(currentQ, choices),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTapeBladePreview(ChallengeQuestion q) {
    final isMetric = q.unit == 'cm';
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final imageH = width * (809.0 / 2415.0);
        const bladeTopRatio = 209.0 / 809.0;
        const bladeBottomRatio = 587.0 / 809.0;
        const bladeHeightRatio = bladeBottomRatio - bladeTopRatio;

        const triangleH = 12.0;
        const triangleW = 14.0;
        const bladeTopY = 18.0;

        final imageTop = bladeTopY - (imageH * bladeTopRatio);
        final bladeBottomY = bladeTopY + (imageH * bladeHeightRatio);
        final markerX = width * (q.ratio ?? 0.5);
        final totalH = bladeBottomY + 16.0;

        return Container(
          height: totalH,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _navy.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: imageTop,
                  width: width,
                  height: imageH,
                  child: Image.asset(
                    'lib/assets/images/tape-blade-practice.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  left: markerX - 1.25,
                  top: bladeTopY,
                  bottom: 8,
                  width: 2.5,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _red,
                      boxShadow: [
                        BoxShadow(
                          color: _red.withValues(alpha: 0.45),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: markerX - (triangleW / 2),
                  top: bladeTopY - triangleH,
                  width: triangleW,
                  height: triangleH,
                  child: CustomPaint(
                    painter: _IndicatorTrianglePainter(
                      color: _red,
                      pointingDown: !isMetric,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWoodTapePreview(ChallengeQuestion q) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final markerX = width * (q.ratio ?? 0.5);

        return Container(
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: _navy.withValues(alpha: 0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'lib/assets/images/practice-wood-tape.png',
                    fit: BoxFit.fill,
                  ),
                ),
                Positioned(
                  left: markerX - 1.5,
                  top: 0,
                  bottom: 0,
                  width: 3,
                  child: Container(
                    color: _red,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolVisualCard(ChallengeQuestion q) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _navy.withValues(alpha: 0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Center(
        child: Image.asset(
          q.imageAsset!,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildChoiceCard(int index, String choiceText) {
    final currentQ = _sessionQuestions[_currentIndex];
    final isSelected = _selectedChoiceIndex == index;
    final isCorrect = choiceText == currentQ.correctAnswer;

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFDDE0E8);
    Color textColor = _navy;

    if (isSelected && !_answered) {
      bgColor = _navy.withValues(alpha: 0.06);
      borderColor = _navy;
      textColor = _navy;
    } else if (_answered) {
      if (isCorrect) {
        bgColor = _green.withValues(alpha: 0.12);
        borderColor = _green;
        textColor = _green;
      } else if (isSelected) {
        bgColor = _red.withValues(alpha: 0.12);
        borderColor = _red;
        textColor = _red;
      } else {
        textColor = _navy.withValues(alpha: 0.4);
      }
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: _answered ? null : () => _onSelectChoice(index),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 60,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: (isSelected || (_answered && isCorrect)) ? 2.0 : 1.2,
            ),
            boxShadow: !_answered
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            choiceText,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: 15,
              fontFamily: _montserrat,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackPanel(ChallengeQuestion currentQ, List<String> choices) {
    final isCorrect =
        choices[_selectedChoiceIndex!] == currentQ.correctAnswer;
    final color = isCorrect ? _green : _red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.30),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                isCorrect ? Icons.check_circle_rounded : Icons.cancel_rounded,
                color: color,
                size: 26,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isCorrect ? 'Stage Passed!' : 'Challenge Missed!',
                      style: TextStyle(
                        color: color,
                        fontSize: 15,
                        fontFamily: _montserrat,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentQ.explanation,
                      style: const TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 13,
                        fontFamily: _montserrat,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _navy,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 10,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              onPressed: _onNext,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentIndex < 4 ? 'Next Stage' : 'Challenge Results',
                    style: const TextStyle(
                      fontFamily: _montserrat,
                      fontWeight: FontWeight.w700,
                      fontSize: 13.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right_rounded, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _IndicatorTrianglePainter extends CustomPainter {
  const _IndicatorTrianglePainter({
    required this.color,
    this.pointingDown = true,
  });

  final Color color;
  final bool pointingDown;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (pointingDown) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
      path.close();
    } else {
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
      path.close();
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _IndicatorTrianglePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.pointingDown != pointingDown;
  }
}
