import 'dart:math';
import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../services/sound_service.dart';
import '../widgets/quiz_shared_widgets.dart';

enum ConversionCategory { all, english, metric, metricEnglish }

class ConversionQuestion {
  const ConversionQuestion({
    required this.promptTitle,
    required this.leftSide,
    required this.targetUnit,
    required this.correctValue,
    required this.correctChoice,
    required this.distractors,
    required this.explanation,
    required this.category,
  });

  final String promptTitle;
  final String leftSide;
  final String targetUnit;
  final String correctValue;
  final String correctChoice;
  final List<String> distractors;
  final String explanation;
  final ConversionCategory category;
}

const _allConversionQuestions = <ConversionQuestion>[
  // ── English System Conversions (in, ft, yd) ──────────────────────────────
  ConversionQuestion(
    promptTitle: '24 inches = ? feet',
    leftSide: '24 in.',
    targetUnit: 'ft.',
    correctValue: '2',
    correctChoice: '2 ft.',
    distractors: ['1 ft.', '1.5 ft.', '3 ft.'],
    explanation: '24 in. ÷ 12 = 2 ft. (12 inches = 1 foot)',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '12 inches = ? feet',
    leftSide: '12 in.',
    targetUnit: 'ft.',
    correctValue: '1',
    correctChoice: '1 ft.',
    distractors: ['0.5 ft.', '1.5 ft.', '2 ft.'],
    explanation: '12 inches = 1 foot',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '36 inches = ? feet',
    leftSide: '36 in.',
    targetUnit: 'ft.',
    correctValue: '3',
    correctChoice: '3 ft.',
    distractors: ['2 ft.', '2.5 ft.', '4 ft.'],
    explanation: '36 in. ÷ 12 = 3 ft.',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '48 inches = ? feet',
    leftSide: '48 in.',
    targetUnit: 'ft.',
    correctValue: '4',
    correctChoice: '4 ft.',
    distractors: ['3 ft.', '3.5 ft.', '5 ft.'],
    explanation: '48 in. ÷ 12 = 4 ft.',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '18 inches = ? feet',
    leftSide: '18 in.',
    targetUnit: 'ft.',
    correctValue: '1.5',
    correctChoice: '1.5 ft.',
    distractors: ['1 ft.', '2 ft.', '2.5 ft.'],
    explanation: '18 in. ÷ 12 = 1.5 ft. (1 foot 6 inches)',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '6 inches = ? feet',
    leftSide: '6 in.',
    targetUnit: 'ft.',
    correctValue: '0.5',
    correctChoice: '0.5 ft.',
    distractors: ['0.25 ft.', '1 ft.', '1.5 ft.'],
    explanation: '6 in. ÷ 12 = 0.5 ft. (half a foot)',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '2 feet = ? inches',
    leftSide: '2 ft.',
    targetUnit: 'in.',
    correctValue: '24',
    correctChoice: '24 in.',
    distractors: ['18 in.', '20 in.', '36 in.'],
    explanation: '2 ft. × 12 = 24 inches',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '3 feet = ? inches',
    leftSide: '3 ft.',
    targetUnit: 'in.',
    correctValue: '36',
    correctChoice: '36 in.',
    distractors: ['24 in.', '30 in.', '40 in.'],
    explanation: '3 ft. × 12 = 36 inches',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '4 feet = ? inches',
    leftSide: '4 ft.',
    targetUnit: 'in.',
    correctValue: '48',
    correctChoice: '48 in.',
    distractors: ['36 in.', '40 in.', '52 in.'],
    explanation: '4 ft. × 12 = 48 inches',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '1.5 feet = ? inches',
    leftSide: '1.5 ft.',
    targetUnit: 'in.',
    correctValue: '18',
    correctChoice: '18 in.',
    distractors: ['15 in.', '20 in.', '24 in.'],
    explanation: '1.5 ft. × 12 = 18 inches',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '3 feet = ? yards',
    leftSide: '3 ft.',
    targetUnit: 'yd.',
    correctValue: '1',
    correctChoice: '1 yd.',
    distractors: ['2 yd.', '3 yd.', '0.5 yd.'],
    explanation: '3 feet = 1 yard',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '6 feet = ? yards',
    leftSide: '6 ft.',
    targetUnit: 'yd.',
    correctValue: '2',
    correctChoice: '2 yd.',
    distractors: ['1.5 yd.', '3 yd.', '4 yd.'],
    explanation: '6 ft. ÷ 3 = 2 yards',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '9 feet = ? yards',
    leftSide: '9 ft.',
    targetUnit: 'yd.',
    correctValue: '3',
    correctChoice: '3 yd.',
    distractors: ['2 yd.', '2.5 yd.', '4 yd.'],
    explanation: '9 ft. ÷ 3 = 3 yards',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '36 inches = ? yards',
    leftSide: '36 in.',
    targetUnit: 'yd.',
    correctValue: '1',
    correctChoice: '1 yd.',
    distractors: ['2 yd.', '0.5 yd.', '3 yd.'],
    explanation: '36 in. ÷ 36 = 1 yard (3 feet = 36 inches = 1 yard)',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '1 yard = ? feet',
    leftSide: '1 yd.',
    targetUnit: 'ft.',
    correctValue: '3',
    correctChoice: '3 ft.',
    distractors: ['2 ft.', '4 ft.', '12 ft.'],
    explanation: '1 yard = 3 feet',
    category: ConversionCategory.english,
  ),
  ConversionQuestion(
    promptTitle: '2 yards = ? feet',
    leftSide: '2 yd.',
    targetUnit: 'ft.',
    correctValue: '6',
    correctChoice: '6 ft.',
    distractors: ['4 ft.', '5 ft.', '8 ft.'],
    explanation: '2 yd. × 3 = 6 feet',
    category: ConversionCategory.english,
  ),

  // ── Metric System Conversions (mm, cm, m, km) ───────────────────────────
  ConversionQuestion(
    promptTitle: '1 cm = ? mm',
    leftSide: '1 cm',
    targetUnit: 'mm',
    correctValue: '10',
    correctChoice: '10 mm',
    distractors: ['5 mm', '100 mm', '1 mm'],
    explanation: '1 centimeter = 10 millimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '5 cm = ? mm',
    leftSide: '5 cm',
    targetUnit: 'mm',
    correctValue: '50',
    correctChoice: '50 mm',
    distractors: ['25 mm', '500 mm', '5 mm'],
    explanation: '5 cm × 10 = 50 millimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '12 cm = ? mm',
    leftSide: '12 cm',
    targetUnit: 'mm',
    correctValue: '120',
    correctChoice: '120 mm',
    distractors: ['100 mm', '12 mm', '200 mm'],
    explanation: '12 cm × 10 = 120 millimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '20 mm = ? cm',
    leftSide: '20 mm',
    targetUnit: 'cm',
    correctValue: '2',
    correctChoice: '2 cm',
    distractors: ['1 cm', '20 cm', '0.2 cm'],
    explanation: '20 mm ÷ 10 = 2 centimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '50 mm = ? cm',
    leftSide: '50 mm',
    targetUnit: 'cm',
    correctValue: '5',
    correctChoice: '5 cm',
    distractors: ['0.5 cm', '50 cm', '10 cm'],
    explanation: '50 mm ÷ 10 = 5 centimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '100 mm = ? cm',
    leftSide: '100 mm',
    targetUnit: 'cm',
    correctValue: '10',
    correctChoice: '10 cm',
    distractors: ['1 cm', '50 cm', '100 cm'],
    explanation: '100 mm ÷ 10 = 10 centimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '25 mm = ? cm',
    leftSide: '25 mm',
    targetUnit: 'cm',
    correctValue: '2.5',
    correctChoice: '2.5 cm',
    distractors: ['2 cm', '3 cm', '0.25 cm'],
    explanation: '25 mm ÷ 10 = 2.5 centimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '1 meter = ? cm',
    leftSide: '1 m',
    targetUnit: 'cm',
    correctValue: '100',
    correctChoice: '100 cm',
    distractors: ['10 cm', '1000 cm', '50 cm'],
    explanation: '1 meter = 100 centimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '2 meters = ? cm',
    leftSide: '2 m',
    targetUnit: 'cm',
    correctValue: '200',
    correctChoice: '200 cm',
    distractors: ['100 cm', '20 cm', '2000 cm'],
    explanation: '2 m × 100 = 200 centimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '1.5 meters = ? cm',
    leftSide: '1.5 m',
    targetUnit: 'cm',
    correctValue: '150',
    correctChoice: '150 cm',
    distractors: ['15 cm', '1500 cm', '105 cm'],
    explanation: '1.5 m × 100 = 150 centimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '50 cm = ? meters',
    leftSide: '50 cm',
    targetUnit: 'm',
    correctValue: '0.5',
    correctChoice: '0.5 m',
    distractors: ['0.05 m', '1 m', '5 m'],
    explanation: '50 cm ÷ 100 = 0.5 meters (half a meter)',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '200 cm = ? meters',
    leftSide: '200 cm',
    targetUnit: 'm',
    correctValue: '2',
    correctChoice: '2 m',
    distractors: ['1 m', '20 m', '0.2 m'],
    explanation: '200 cm ÷ 100 = 2 meters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '1 meter = ? mm',
    leftSide: '1 m',
    targetUnit: 'mm',
    correctValue: '1,000',
    correctChoice: '1,000 mm',
    distractors: ['100 mm', '10 mm', '10,000 mm'],
    explanation: '1 meter = 1,000 millimeters',
    category: ConversionCategory.metric,
  ),
  ConversionQuestion(
    promptTitle: '1,000 meters = ? km',
    leftSide: '1,000 m',
    targetUnit: 'km',
    correctValue: '1',
    correctChoice: '1 km',
    distractors: ['0.1 km', '10 km', '100 km'],
    explanation: '1,000 meters = 1 kilometer',
    category: ConversionCategory.metric,
  ),

  // ── English ↔ Metric Conversions ─────────────────────────────────────────
  ConversionQuestion(
    promptTitle: '1 inch = ? cm',
    leftSide: '1 in.',
    targetUnit: 'cm',
    correctValue: '2.54',
    correctChoice: '2.54 cm',
    distractors: ['1.54 cm', '3.14 cm', '5.08 cm'],
    explanation: '1 inch is exactly equal to 2.54 centimeters.',
    category: ConversionCategory.metricEnglish,
  ),
  ConversionQuestion(
    promptTitle: '2 inches = ? cm',
    leftSide: '2 in.',
    targetUnit: 'cm',
    correctValue: '5.08',
    correctChoice: '5.08 cm',
    distractors: ['4.54 cm', '5.54 cm', '2.54 cm'],
    explanation: '2 in. × 2.54 = 5.08 centimeters.',
    category: ConversionCategory.metricEnglish,
  ),
  ConversionQuestion(
    promptTitle: '10 inches = ? cm',
    leftSide: '10 in.',
    targetUnit: 'cm',
    correctValue: '25.4',
    correctChoice: '25.4 cm',
    distractors: ['20.4 cm', '24.5 cm', '50.8 cm'],
    explanation: '10 in. × 2.54 = 25.4 centimeters.',
    category: ConversionCategory.metricEnglish,
  ),
  ConversionQuestion(
    promptTitle: '1 inch = ? mm',
    leftSide: '1 in.',
    targetUnit: 'mm',
    correctValue: '25.4',
    correctChoice: '25.4 mm',
    distractors: ['2.54 mm', '254 mm', '10 mm'],
    explanation: '1 inch = 25.4 millimeters (2.54 cm × 10).',
    category: ConversionCategory.metricEnglish,
  ),
  ConversionQuestion(
    promptTitle: '2 inches = ? mm',
    leftSide: '2 in.',
    targetUnit: 'mm',
    correctValue: '50.8',
    correctChoice: '50.8 mm',
    distractors: ['25.4 mm', '5.08 mm', '100 mm'],
    explanation: '2 in. × 25.4 = 50.8 millimeters.',
    category: ConversionCategory.metricEnglish,
  ),
  ConversionQuestion(
    promptTitle: '1/2 inch = ? mm',
    leftSide: '1/2 in.',
    targetUnit: 'mm',
    correctValue: '12.7',
    correctChoice: '12.7 mm',
    distractors: ['10 mm', '5 mm', '25.4 mm'],
    explanation: '1 inch = 25.4 mm. Half of an inch is 25.4 ÷ 2 = 12.7 mm.',
    category: ConversionCategory.metricEnglish,
  ),
  ConversionQuestion(
    promptTitle: '1 foot = ? cm',
    leftSide: '1 ft.',
    targetUnit: 'cm',
    correctValue: '30.48',
    correctChoice: '30.48 cm',
    distractors: ['25.4 cm', '35.2 cm', '32.5 cm'],
    explanation: '1 foot = 12 in. × 2.54 = 30.48 centimeters.',
    category: ConversionCategory.metricEnglish,
  ),
];

class UnitConversionPracticeScreen extends StatefulWidget {
  const UnitConversionPracticeScreen({super.key});

  @override
  State<UnitConversionPracticeScreen> createState() =>
      _UnitConversionPracticeScreenState();
}

class _UnitConversionPracticeScreenState
    extends State<UnitConversionPracticeScreen> {
  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);
  static const _green = Color(0xFF05831C);
  static const _red = Color(0xFFD32F2F);
  static const _teal = Color(0xFF0284C7);
  static const _amber = Color(0xFFD97706);
  static const _montserrat = 'Montserrat';

  ConversionCategory _selectedCategory = ConversionCategory.all;
  late List<ConversionQuestion> _sessionQuestions;
  late List<List<String>> _sessionChoices;
  int _currentIndex = 0;
  int? _selectedChoiceIndex;
  int _score = 0;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    final rng = Random();

    List<ConversionQuestion> pool;
    if (_selectedCategory == ConversionCategory.english) {
      pool = _allConversionQuestions
          .where((q) => q.category == ConversionCategory.english)
          .toList();
    } else if (_selectedCategory == ConversionCategory.metric) {
      pool = _allConversionQuestions
          .where((q) => q.category == ConversionCategory.metric)
          .toList();
    } else if (_selectedCategory == ConversionCategory.metricEnglish) {
      pool = _allConversionQuestions
          .where((q) => q.category == ConversionCategory.metricEnglish)
          .toList();
    } else {
      // Mixed: pick length conversions across English, Metric, and Metric-English
      final engList = _allConversionQuestions
          .where((q) => q.category == ConversionCategory.english)
          .toList()
        ..shuffle(rng);
      final metList = _allConversionQuestions
          .where((q) => q.category == ConversionCategory.metric)
          .toList()
        ..shuffle(rng);
      final mixList = _allConversionQuestions
          .where((q) => q.category == ConversionCategory.metricEnglish)
          .toList()
        ..shuffle(rng);
      pool = [
        ...engList.take(2),
        ...metList.take(2),
        ...mixList.take(1),
      ]..shuffle(rng);
    }

    final shuffled = List<ConversionQuestion>.from(pool)..shuffle(rng);
    _sessionQuestions = shuffled.take(5).toList();

    _sessionChoices = _sessionQuestions.map((q) {
      final choices = [q.correctChoice, ...q.distractors]..shuffle(rng);
      return choices;
    }).toList();

    _currentIndex = 0;
    _selectedChoiceIndex = null;
    _score = 0;
    _answered = false;
  }

  void _onSelectOption(int index) {
    if (_answered) return;
    setState(() {
      _selectedChoiceIndex = index;
    });
  }

  void _onCheck() {
    if (_selectedChoiceIndex == null || _answered) return;

    final currentQ = _sessionQuestions[_currentIndex];
    final choices = _sessionChoices[_currentIndex];
    final isCorrect = choices[_selectedChoiceIndex!] == currentQ.correctChoice;

    UserStore.recordAnswer(isCorrect);
    setState(() {
      _answered = true;
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
    final xpEarned = _score * 5;
    final isPerfect = _score == 5;
    UserStore.mutate((user) {
      final tabs = List<String>.from(user.completedLessonTabs);
      if (isPerfect && !tabs.contains('perfect_measurement')) {
        tabs.add('perfect_measurement');
      }
      return user.copyWith(
        xpEarned: user.xpEarned + xpEarned,
        practiceCompleted: user.practiceCompleted + 1,
        correctMetricEnglishConversions:
            user.correctMetricEnglishConversions + _score,
        completedLessonTabs: tabs,
      );
    });
    SoundService.instance.playQuizComplete();
    if (xpEarned > 0) {
      SoundService.instance.playGainXp();
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _score >= 3
                      ? _green.withValues(alpha: 0.12)
                      : _accent.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _score >= 3 ? Icons.emoji_events_rounded : Icons.replay_rounded,
                  color: _score >= 3 ? _green : _accent,
                  size: 40,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Practice Complete!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _navy,
                  fontSize: 20,
                  fontFamily: _montserrat,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You scored $_score out of 5',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 14,
                  fontFamily: _montserrat,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accent.withValues(alpha: 0.5)),
                ),
                child: Text(
                  '+$xpEarned XP Earned',
                  style: const TextStyle(
                    color: Color(0xFFB45309),
                    fontSize: 13,
                    fontFamily: _montserrat,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 24),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // ── Top Header (Matching Quiz Screen header) ───────────────────
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
                                  'Unit Conversion',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontFamily: _montserrat,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  'Practice Activity',
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
                              '${_currentIndex + 1}/5',
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
                                'Question ${_currentIndex + 1} of 5',
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Category Filter Tabs (All, English, Metric, Eng ↔ Met)
                    _buildCategoryFilterRow(),
                    const SizedBox(height: 12),

                    // Prompt Box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
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
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: _getCategoryColor(currentQ.category)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              _getCategoryLabel(currentQ.category),
                              style: TextStyle(
                                color: _getCategoryColor(currentQ.category),
                                fontSize: 11,
                                fontFamily: _montserrat,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              currentQ.promptTitle,
                              style: const TextStyle(
                                color: _navy,
                                fontSize: 16,
                                fontFamily: _montserrat,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Equation Card ──────────────────────────────────────
                    _buildEquationCard(currentQ, choices),
                    const SizedBox(height: 20),

                    // ── 2x2 Option Buttons ─────────────────────────────────
                    Row(
                      children: [
                        Expanded(child: _buildChoiceBtn(0, choices[0])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildChoiceBtn(1, choices[1])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildChoiceBtn(2, choices[2])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildChoiceBtn(3, choices[3])),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // ── Check Button or Feedback Panel ─────────────────────
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
                        onPressed: _selectedChoiceIndex != null ? _onCheck : null,
                        child: const Text(
                          'Check',
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

  Color _getCategoryColor(ConversionCategory cat) {
    switch (cat) {
      case ConversionCategory.english:
        return _teal;
      case ConversionCategory.metric:
        return _green;
      case ConversionCategory.metricEnglish:
        return _amber;
      case ConversionCategory.all:
        return _navy;
    }
  }

  String _getCategoryLabel(ConversionCategory cat) {
    switch (cat) {
      case ConversionCategory.english:
        return 'ENGLISH';
      case ConversionCategory.metric:
        return 'METRIC';
      case ConversionCategory.metricEnglish:
        return 'ENG ↔ METRIC';
      case ConversionCategory.all:
        return 'CONVERSION';
    }
  }

  Widget _buildCategoryFilterRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _filterTab('All', ConversionCategory.all),
          _filterTab('English', ConversionCategory.english),
          _filterTab('Metric', ConversionCategory.metric),
          _filterTab('Eng ↔ Met', ConversionCategory.metricEnglish),
        ],
      ),
    );
  }

  Widget _filterTab(String title, ConversionCategory category) {
    final isSelected = _selectedCategory == category;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (_selectedCategory != category) {
            setState(() {
              _selectedCategory = category;
              _startNewSession();
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? _navy : const Color(0xFF6B7280),
              fontFamily: _montserrat,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 11.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEquationCard(
    ConversionQuestion currentQ,
    List<String> choices,
  ) {
    String boxText = '?';
    Color boxBg = const Color(0xFFFEF3C7);
    Color boxBorder = const Color(0xFFFDE68A);
    Color boxTextColor = _amber;

    if (_selectedChoiceIndex != null) {
      final selectedText = choices[_selectedChoiceIndex!];
      final numPart = selectedText.split(' ').first;
      boxText = numPart;

      if (_answered) {
        final isCorrect = selectedText == currentQ.correctChoice;
        if (isCorrect) {
          boxBg = _green.withValues(alpha: 0.14);
          boxBorder = _green;
          boxTextColor = _green;
        } else {
          boxBg = _red.withValues(alpha: 0.14);
          boxBorder = _red;
          boxTextColor = _red;
        }
      } else {
        boxBg = _amber.withValues(alpha: 0.18);
        boxBorder = _amber;
        boxTextColor = _navy;
      }
    }

    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _navy.withValues(alpha: 0.08),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left side
          Text(
            currentQ.leftSide,
            style: const TextStyle(
              color: _navy,
              fontSize: 22,
              fontFamily: _montserrat,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 14),

          // Equals sign "="
          const Text(
            '=',
            style: TextStyle(
              color: _navy,
              fontSize: 24,
              fontFamily: _montserrat,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 14),

          // Question mark / Answer box
          Container(
            width: 68,
            height: 68,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: boxBg,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: boxBorder,
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              boxText,
              style: TextStyle(
                color: boxTextColor,
                fontSize: 22,
                fontFamily: _montserrat,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Target unit
          Text(
            currentQ.targetUnit,
            style: const TextStyle(
              color: _navy,
              fontSize: 20,
              fontFamily: _montserrat,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceBtn(int index, String choiceText) {
    final currentQ = _sessionQuestions[_currentIndex];
    final isSelected = _selectedChoiceIndex == index;
    final isCorrect = choiceText == currentQ.correctChoice;

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
        onTap: _answered ? null : () => _onSelectOption(index),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 56,
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
              fontSize: 16,
              fontFamily: _montserrat,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeedbackPanel(
    ConversionQuestion currentQ,
    List<String> choices,
  ) {
    final isCorrect =
        choices[_selectedChoiceIndex!] == currentQ.correctChoice;
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
                      isCorrect ? 'Correct!' : 'Not quite.',
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
                    _currentIndex < 4 ? 'Next' : 'Finish',
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
