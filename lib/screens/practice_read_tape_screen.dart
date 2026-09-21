import 'dart:math';
import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../services/sound_service.dart';
import '../widgets/animated_progress_bar.dart';

enum MeasurementUnit { inch, cm }

enum PracticeUnitFilter { all, inch, cm }

class PracticeReadTapeQuestion {
  const PracticeReadTapeQuestion({
    required this.targetLabel,
    required this.ratio,
    required this.distractors,
    required this.unit,
  });

  final String targetLabel;
  final double ratio;
  final List<String> distractors;
  final MeasurementUnit unit;
}

const _allQuestionsPool = <PracticeReadTapeQuestion>[
  // ── Imperial (Inch) Questions ───────────────────────────────────────────
  PracticeReadTapeQuestion(
    targetLabel: '1 in.',
    ratio: 0.30186,
    distractors: ['7/8 in.', '1 1/8 in.', '1 1/4 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '1 1/8 in.',
    ratio: 0.32712,
    distractors: ['1 in.', '1 1/4 in.', '1 3/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '1 1/4 in.',
    ratio: 0.35362,
    distractors: ['1 1/8 in.', '1 3/8 in.', '1 1/2 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '1 3/8 in.',
    ratio: 0.38012,
    distractors: ['1 1/4 in.', '1 1/2 in.', '1 5/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '1 1/2 in.',
    ratio: 0.40828,
    distractors: ['1 3/8 in.', '1 5/8 in.', '1 3/4 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '1 5/8 in.',
    ratio: 0.43602,
    distractors: ['1 1/2 in.', '1 3/4 in.', '1 7/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '1 3/4 in.',
    ratio: 0.46211,
    distractors: ['1 5/8 in.', '1 7/8 in.', '2 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '1 7/8 in.',
    ratio: 0.48778,
    distractors: ['1 3/4 in.', '2 in.', '2 1/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 in.',
    ratio: 0.51014,
    distractors: ['1 7/8 in.', '2 1/8 in.', '2 1/4 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 1/8 in.',
    ratio: 0.53582,
    distractors: ['2 in.', '2 1/4 in.', '2 3/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 1/4 in.',
    ratio: 0.56149,
    distractors: ['2 1/8 in.', '2 3/8 in.', '2 1/2 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 3/8 in.',
    ratio: 0.58799,
    distractors: ['2 1/4 in.', '2 1/2 in.', '2 5/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 1/2 in.',
    ratio: 0.61698,
    distractors: ['2 3/8 in.', '2 5/8 in.', '2 3/4 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 5/8 in.',
    ratio: 0.64845,
    distractors: ['2 1/2 in.', '2 3/4 in.', '2 7/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 3/4 in.',
    ratio: 0.67826,
    distractors: ['2 5/8 in.', '2 7/8 in.', '3 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 7/8 in.',
    ratio: 0.70559,
    distractors: ['2 3/4 in.', '3 in.', '3 1/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 in.',
    ratio: 0.73168,
    distractors: ['2 7/8 in.', '3 1/8 in.', '3 1/4 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 1/8 in.',
    ratio: 0.75859,
    distractors: ['3 in.', '3 1/4 in.', '3 3/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 1/4 in.',
    ratio: 0.78592,
    distractors: ['3 1/8 in.', '3 3/8 in.', '3 1/2 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 3/8 in.',
    ratio: 0.81491,
    distractors: ['3 1/4 in.', '3 1/2 in.', '3 5/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 1/2 in.',
    ratio: 0.84472,
    distractors: ['3 3/8 in.', '3 5/8 in.', '3 3/4 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 5/8 in.',
    ratio: 0.87702,
    distractors: ['3 1/2 in.', '3 3/4 in.', '3 7/8 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 3/4 in.',
    ratio: 0.90890,
    distractors: ['3 5/8 in.', '3 7/8 in.', '4 in.'],
    unit: MeasurementUnit.inch,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 7/8 in.',
    ratio: 0.93872,
    distractors: ['3 3/4 in.', '4 in.', '3 5/8 in.'],
    unit: MeasurementUnit.inch,
  ),

  // ── Metric (cm) Questions ───────────────────────────────────────────────
  PracticeReadTapeQuestion(
    targetLabel: '1 cm',
    ratio: 0.18302,
    distractors: ['0.5 cm', '1.5 cm', '2 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '1.5 cm',
    ratio: 0.22277,
    distractors: ['1 cm', '2 cm', '2.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2 cm',
    ratio: 0.28654,
    distractors: ['1.5 cm', '2.5 cm', '3 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '2.5 cm',
    ratio: 0.33872,
    distractors: ['2 cm', '3 cm', '3.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3 cm',
    ratio: 0.38716,
    distractors: ['2.5 cm', '3.5 cm', '4 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '3.5 cm',
    ratio: 0.43147,
    distractors: ['3 cm', '4 cm', '4.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '4 cm',
    ratio: 0.48530,
    distractors: ['3.5 cm', '4.5 cm', '5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '4.5 cm',
    ratio: 0.52836,
    distractors: ['4 cm', '5 cm', '5.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '5 cm',
    ratio: 0.57640,
    distractors: ['4.5 cm', '5.5 cm', '6 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '5.5 cm',
    ratio: 0.61615,
    distractors: ['5 cm', '6 cm', '6.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '6 cm',
    ratio: 0.66253,
    distractors: ['5.5 cm', '6.5 cm', '7 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '6.5 cm',
    ratio: 0.69772,
    distractors: ['6 cm', '7 cm', '7.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '7 cm',
    ratio: 0.74079,
    distractors: ['6.5 cm', '7.5 cm', '8 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '7.5 cm',
    ratio: 0.78509,
    distractors: ['7 cm', '8 cm', '8.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '8 cm',
    ratio: 0.82526,
    distractors: ['7.5 cm', '8.5 cm', '9 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '8.5 cm',
    ratio: 0.85590,
    distractors: ['8 cm', '9 cm', '9.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '9 cm',
    ratio: 0.90228,
    distractors: ['8.5 cm', '9.5 cm', '10 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '9.5 cm',
    ratio: 0.93375,
    distractors: ['9 cm', '10 cm', '8.5 cm'],
    unit: MeasurementUnit.cm,
  ),
  PracticeReadTapeQuestion(
    targetLabel: '10 cm',
    ratio: 0.97143,
    distractors: ['9 cm', '9.5 cm', '8.5 cm'],
    unit: MeasurementUnit.cm,
  ),
];

class ReadTheTapePracticeScreen extends StatefulWidget {
  const ReadTheTapePracticeScreen({super.key});

  @override
  State<ReadTheTapePracticeScreen> createState() =>
      _ReadTheTapePracticeScreenState();
}

class _ReadTheTapePracticeScreenState extends State<ReadTheTapePracticeScreen> {
  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);
  static const _green = Color(0xFF05831C);
  static const _red = Color(0xFFD32F2F);
  static const _teal = Color(0xFF0284C7);
  static const _montserrat = 'Montserrat';

  PracticeUnitFilter _unitFilter = PracticeUnitFilter.all;
  late List<PracticeReadTapeQuestion> _sessionQuestions;
  late List<List<String>> _sessionChoices;
  int _currentIndex = 0;
  int? _selectedChoice;
  int _score = 0;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    final rng = Random();

    List<PracticeReadTapeQuestion> pool;
    if (_unitFilter == PracticeUnitFilter.inch) {
      pool = _allQuestionsPool
          .where((q) => q.unit == MeasurementUnit.inch)
          .toList();
    } else if (_unitFilter == PracticeUnitFilter.cm) {
      pool = _allQuestionsPool
          .where((q) => q.unit == MeasurementUnit.cm)
          .toList();
    } else {
      // Mixed: pick a balanced mixture of inches and cm
      final inchList = _allQuestionsPool
          .where((q) => q.unit == MeasurementUnit.inch)
          .toList()
        ..shuffle(rng);
      final cmList = _allQuestionsPool
          .where((q) => q.unit == MeasurementUnit.cm)
          .toList()
        ..shuffle(rng);
      pool = [...inchList.take(3), ...cmList.take(2)]..shuffle(rng);
    }

    final shuffled = List<PracticeReadTapeQuestion>.from(pool)..shuffle(rng);
    _sessionQuestions = shuffled.take(5).toList();

    _sessionChoices = _sessionQuestions.map((q) {
      final choices = [q.targetLabel, ...q.distractors]..shuffle(rng);
      return choices;
    }).toList();

    _currentIndex = 0;
    _selectedChoice = null;
    _score = 0;
    _answered = false;
  }

  void _onSelectChoice(int index) {
    if (_answered) return;

    final currentQ = _sessionQuestions[_currentIndex];
    final choices = _sessionChoices[_currentIndex];
    final isCorrect = choices[index] == currentQ.targetLabel;

    setState(() {
      _selectedChoice = index;
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
        _selectedChoice = null;
        _answered = false;
      });
    } else {
      _onCompleteSession();
    }
  }

  void _onCompleteSession() {
    final xpEarned = _score * 5;
    UserStore.mutate((user) => user.copyWith(
      xpEarned: user.xpEarned + xpEarned,
      practiceCompleted: user.practiceCompleted + 1,
    ));
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
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _score >= 3
                      ? _green.withValues(alpha: 0.12)
                      : _accent.withValues(alpha: 0.15),
                ),
                child: Icon(
                  _score >= 3 ? Icons.emoji_events_rounded : Icons.replay_rounded,
                  color: _score >= 3 ? _green : _accent,
                  size: 38,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Practice Complete!',
                style: TextStyle(
                  color: _navy,
                  fontSize: 20,
                  fontFamily: _montserrat,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You got $_score out of 5 correct',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
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
    final isMetric = currentQ.unit == MeasurementUnit.cm;

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
                                  'Read the Tape',
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
                    // Unit Filter Pill Row
                    _buildUnitFilterRow(),
                    const SizedBox(height: 12),

                    // Prompt Box with scale indicator
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: isMetric
                                      ? _teal.withValues(alpha: 0.12)
                                      : _navy.withValues(alpha: 0.10),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  isMetric ? 'METRIC (cm)' : 'IMPERIAL (in)',
                                  style: TextStyle(
                                    color: isMetric ? _teal : _navy,
                                    fontSize: 11,
                                    fontFamily: _montserrat,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isMetric
                                ? 'What measurement is shown on the metric scale (cm)?'
                                : 'What measurement is shown by the marker?',
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 14.5,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isMetric
                                ? 'Look at the top scale on the blade. Tap the answer below.'
                                : 'Tap the correct answer below.',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── Ruler with Marker Line ─────────────────────────────
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        // Image aspect ratio: 2415 x 809
                        final imageH = width * (809.0 / 2415.0);
                        const bladeTopRatio = 209.0 / 809.0;
                        const bladeBottomRatio = 587.0 / 809.0;
                        const bladeHeightRatio =
                            bladeBottomRatio - bladeTopRatio;

                        // Precise downward triangle marker geometry
                        const triangleH = 12.0;
                        const triangleW = 14.0;
                        // Let blade start at Y = 18 so triangle sits cleanly at top (Y: 6 to 18)
                        const bladeTopY = 18.0;

                        // Align the image so that yellow blade starts at bladeTopY
                        final imageTop = bladeTopY - (imageH * bladeTopRatio);
                        final bladeBottomY =
                            bladeTopY + (imageH * bladeHeightRatio);
                        final markerX = width * currentQ.ratio;

                        // Container height accommodates the blade plus red line extension and padding
                        final totalH = bladeBottomY + 18.0;

                        return Container(
                          height: totalH,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _navy.withValues(alpha: 0.08),
                            ),
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
                                // Tape measure blade
                                Positioned(
                                  top: imageTop,
                                  left: 0,
                                  right: 0,
                                  height: imageH,
                                  child: Image.asset(
                                    'lib/assets/images/tape-blade-practice.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),

                                // Red indicator line through the blade
                                Positioned(
                                  left: markerX - 1.25,
                                  top: bladeTopY,
                                  width: 2.5,
                                  height: (bladeBottomY - bladeTopY) + 8.0,
                                  child: Container(
                                    color: _red,
                                  ),
                                ),

                                // Red downward triangle marker touching top edge of blade
                                Positioned(
                                  left: markerX - (triangleW / 2),
                                  top: bladeTopY - triangleH,
                                  width: triangleW,
                                  height: triangleH,
                                  child: const CustomPaint(
                                    painter: _DownwardTrianglePainter(
                                      color: _red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),

                    // ── Choices Grid (2 x 2) ───────────────────────────────
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

                    // ── Feedback Panel & Next Button ───────────────────────
                    if (_answered) ...[
                      const SizedBox(height: 20),
                      _buildFeedbackPanel(currentQ, choices),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnitFilterRow() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          _unitFilterTab('All Units', PracticeUnitFilter.all),
          _unitFilterTab('Inches (in)', PracticeUnitFilter.inch),
          _unitFilterTab('Centimeters (cm)', PracticeUnitFilter.cm),
        ],
      ),
    );
  }

  Widget _unitFilterTab(String title, PracticeUnitFilter filter) {
    final isSelected = _unitFilter == filter;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          if (_unitFilter != filter) {
            setState(() {
              _unitFilter = filter;
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

  Widget _buildChoiceBtn(int index, String choiceText) {
    final currentQ = _sessionQuestions[_currentIndex];
    final isSelected = _selectedChoice == index;
    final isCorrect = choiceText == currentQ.targetLabel;

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFDDE0E8);
    Color textColor = _navy;

    if (_answered) {
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
          height: 54,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
              width: _answered && (isCorrect || isSelected) ? 2.0 : 1.2,
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
    PracticeReadTapeQuestion currentQ,
    List<String> choices,
  ) {
    final isCorrect = choices[_selectedChoice!] == currentQ.targetLabel;
    final color = isCorrect ? _green : _red;
    final isMetric = currentQ.unit == MeasurementUnit.cm;
    final targetText = isMetric
        ? currentQ.targetLabel
        : currentQ.targetLabel.replaceAll(' in.', ' inches');

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
                      'The marker shows $targetText.',
                      style: const TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 13,
                        fontFamily: _montserrat,
                        fontWeight: FontWeight.w500,
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

class _DownwardTrianglePainter extends CustomPainter {
  const _DownwardTrianglePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DownwardTrianglePainter oldDelegate) =>
      oldDelegate.color != color;
}
