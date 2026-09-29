import 'dart:math';
import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../services/sound_service.dart';
import '../widgets/quiz_shared_widgets.dart';

class WoodMark {
  const WoodMark({required this.value, required this.ratio});
  final double value;
  final double ratio;

  String get label {
    if (value == value.roundToDouble()) {
      return '${value.toInt()} cm';
    }
    return '${value.toStringAsFixed(1)} cm';
  }
}

const _wholeRatios = <int, double>{
  2: 0.06884,
  3: 0.10397,
  4: 0.13909,
  5: 0.17422,
  6: 0.20934,
  7: 0.23744,
  8: 0.27889,
  9: 0.31401,
  10: 0.34492,
  11: 0.38005,
  12: 0.41517,
  13: 0.45030,
  14: 0.48613,
  15: 0.52125,
  16: 0.55638,
  17: 0.59115,
  18: 0.62662,
  19: 0.66175,
  20: 0.69617,
  21: 0.72989,
  22: 0.76537,
  23: 0.80119,
  24: 0.82754,
  25: 0.87074,
  26: 0.89708,
  27: 0.93010,
  28: 0.96488,
};

List<WoodMark> _buildAllWoodMarks() {
  final list = <WoodMark>[];
  for (int n = 2; n <= 28; n++) {
    final rWhole = _wholeRatios[n]!;
    list.add(WoodMark(value: n.toDouble(), ratio: rWhole));
    if (n < 28) {
      final rNext = _wholeRatios[n + 1]!;
      final rHalf = (rWhole + rNext) / 2.0;
      list.add(WoodMark(value: n + 0.5, ratio: rHalf));
    }
  }
  return list;
}

final _allWoodMarks = _buildAllWoodMarks();

class MeasureTheWoodPracticeScreen extends StatefulWidget {
  const MeasureTheWoodPracticeScreen({super.key});

  @override
  State<MeasureTheWoodPracticeScreen> createState() =>
      _MeasureTheWoodPracticeScreenState();
}

class _MeasureTheWoodPracticeScreenState
    extends State<MeasureTheWoodPracticeScreen> {
  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);
  static const _green = Color(0xFF05831C);
  static const _red = Color(0xFFD32F2F);
  static const _teal = Color(0xFF0284C7);
  static const _montserrat = 'Montserrat';

  late List<WoodMark> _sessionQuestions;
  int _currentIndex = 0;
  late WoodMark _currentMark;
  int _score = 0;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    final rng = Random();

    // Pool of questions with both whole cm and half cm (.5 cm)
    final candidateMarks = _allWoodMarks.where((m) => m.value >= 3.0).toList();
    final halfCmMarks = candidateMarks.where((m) => m.value % 1.0 != 0).toList()
      ..shuffle(rng);
    final wholeCmMarks = candidateMarks.where((m) => m.value % 1.0 == 0).toList()
      ..shuffle(rng);

    // Pick 5 questions ensuring a good mixture of .5 cm and whole cm
    final selected = [
      ...halfCmMarks.take(3),
      ...wholeCmMarks.take(2),
    ]..shuffle(rng);

    _sessionQuestions = selected;
    _currentIndex = 0;
    _score = 0;
    _answered = false;
    _resetMarkerPosition();
  }

  void _resetMarkerPosition() {
    final currentQ = _sessionQuestions[_currentIndex];
    final targetIdx = _allWoodMarks.indexOf(currentQ);
    // Start at a noticeable offset from the target mark
    int startIdx = (targetIdx + 8) % _allWoodMarks.length;
    if (_allWoodMarks[startIdx] == currentQ) {
      startIdx = (targetIdx + 4) % _allWoodMarks.length;
    }
    _currentMark = _allWoodMarks[startIdx];
  }

  WoodMark _findClosestMark(double ratio) {
    WoodMark best = _allWoodMarks[0];
    double bestDiff = (ratio - best.ratio).abs();

    for (int i = 1; i < _allWoodMarks.length; i++) {
      final diff = (ratio - _allWoodMarks[i].ratio).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = _allWoodMarks[i];
      }
    }
    return best;
  }

  void _updateMarkerPosition(double localX, double cardWidth) {
    if (_answered || cardWidth <= 0) return;
    final ratio = (localX / cardWidth).clamp(0.05, 0.98);
    final closest = _findClosestMark(ratio);
    if (closest != _currentMark) {
      setState(() {
        _currentMark = closest;
      });
    }
  }

  void _onMarkHere() {
    if (_answered) return;

    final currentQ = _sessionQuestions[_currentIndex];
    final isCorrect = _currentMark == currentQ;

    UserStore.recordAnswer(isCorrect);
    UserStore.mutate((user) => user.copyWith(
      currentLessonTitle: 'Measure the Wood Practice',
      currentLessonProgressPercent: ((_currentIndex + 1) * 20).clamp(0, 100),
    ));
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
        _answered = false;
        _resetMarkerPosition();
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
        completedLessonTabs: tabs,
        currentLessonTitle: 'Measure the Wood Practice',
        currentLessonProgressPercent: 100,
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
                                      'Measure the Wood',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontFamily: _montserrat,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Practice Activity (Metric cm)',
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: _teal.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'METRIC SCALE (cm)',
                                  style: TextStyle(
                                    color: _teal,
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
                            'The wood needs to be cut at ${currentQ.label}.\nWhere should you mark?',
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 15,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Drag the marker or slider to position the cut line, then tap Mark Here.',
                            style: TextStyle(
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

                    // ── Wood Plank with Tape Measure & Marker ──────────────
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final markerX = width * _currentMark.ratio;
                        final targetX = width * currentQ.ratio;

                        // Dimensions for wood plank canvas
                        const woodHeight = 78.0;
                        const flagHeight = 32.0;
                        const flagWidth = 72.0;
                        const arrowHeight = 24.0;
                        const totalCanvasHeight =
                            flagHeight + arrowHeight + woodHeight + 20.0;

                        // Keep flag horizontally within card bounds
                        final flagLeft =
                            (markerX - (flagWidth / 2)).clamp(6.0, width - flagWidth - 6.0);

                        final isCorrect =
                            _answered && _currentMark == currentQ;

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onHorizontalDragStart: (details) {
                            _updateMarkerPosition(
                              details.localPosition.dx,
                              width,
                            );
                          },
                          onHorizontalDragUpdate: (details) {
                            _updateMarkerPosition(
                              details.localPosition.dx,
                              width,
                            );
                          },
                          onTapDown: (details) {
                            _updateMarkerPosition(
                              details.localPosition.dx,
                              width,
                            );
                          },
                          child: Container(
                            height: totalCanvasHeight,
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
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                // Wood plank + tape measure image
                                Positioned(
                                  left: 8,
                                  right: 8,
                                  bottom: 12,
                                  height: woodHeight,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'lib/assets/images/practice-wood-tape.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),

                                // Ghost target marker (shown when user was incorrect)
                                if (_answered && !isCorrect) ...[
                                  // Green dashed pencil mark at target on the wood
                                  Positioned(
                                    left: targetX - 1.5,
                                    bottom: 12,
                                    width: 3.0,
                                    height: woodHeight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: _green,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                                  // Target flag badge
                                  Positioned(
                                    left: (targetX - (flagWidth / 2))
                                        .clamp(6.0, width - flagWidth - 6.0),
                                    top: 10,
                                    width: flagWidth,
                                    height: flagHeight,
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: _green,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: _green.withValues(alpha: 0.3),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        currentQ.label,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontFamily: _montserrat,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],

                                // User Marker Flag
                                Positioned(
                                  left: flagLeft,
                                  top: 10,
                                  width: flagWidth,
                                  height: flagHeight,
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: _answered
                                            ? (isCorrect ? _green : _red)
                                            : _navy,
                                        width: 1.8,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.08),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      _currentMark.label,
                                      style: TextStyle(
                                        color: _answered
                                            ? (isCorrect ? _green : _red)
                                            : _navy,
                                        fontFamily: _montserrat,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 13.5,
                                      ),
                                    ),
                                  ),
                                ),

                                // Red indicator line down to the tape
                                Positioned(
                                  left: markerX - 1.25,
                                  top: 10 + flagHeight,
                                  width: 2.5,
                                  height: arrowHeight + (woodHeight * 0.45),
                                  child: Container(
                                    color: _answered
                                        ? (isCorrect ? _green : _red)
                                        : _red,
                                  ),
                                ),

                                // Downward arrowhead pointing at tape
                                Positioned(
                                  left: markerX - 6,
                                  top: 10 + flagHeight + arrowHeight - 4,
                                  width: 12,
                                  height: 9,
                                  child: CustomPaint(
                                    painter: _DownwardTrianglePainter(
                                      color: _answered
                                          ? (isCorrect ? _green : _red)
                                          : _red,
                                    ),
                                  ),
                                ),

                                // Graphite cut pencil mark on the wood when answered
                                if (_answered)
                                  Positioned(
                                    left: markerX - 1.5,
                                    bottom: 12,
                                    width: 3.0,
                                    height: woodHeight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isCorrect
                                            ? const Color(0xFF1E293B)
                                            : _red,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 14),

                    // Slider Control (2.0 to 28.0 in steps of 0.5)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: _navy.withValues(alpha: 0.08)),
                      ),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.straighten_rounded,
                              size: 20,
                              color: _navy,
                            ),
                          ),
                          Expanded(
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: _navy,
                                inactiveTrackColor: _navy.withValues(alpha: 0.12),
                                thumbColor: _navy,
                                overlayColor: _navy.withValues(alpha: 0.15),
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 9,
                                ),
                              ),
                              child: Slider(
                                value: _currentMark.value,
                                min: 2.0,
                                max: 28.0,
                                divisions: 52, // step of 0.5 cm
                                onChanged: _answered
                                    ? null
                                    : (val) {
                                        // Round to nearest 0.5
                                        final targetVal =
                                            (val * 2).round() / 2.0;
                                        final match = _allWoodMarks.firstWhere(
                                          (m) => (m.value - targetVal).abs() < 0.1,
                                          orElse: () => _currentMark,
                                        );
                                        setState(() {
                                          _currentMark = match;
                                        });
                                      },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              _currentMark.label,
                              style: const TextStyle(
                                color: _navy,
                                fontFamily: _montserrat,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ── Mark Here Button or Feedback Panel ─────────────────
                    if (!_answered)
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _navy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: _onMarkHere,
                        icon: const Icon(Icons.edit_rounded, size: 20),
                        label: const Text(
                          'Mark Here',
                          style: TextStyle(
                            fontFamily: _montserrat,
                            fontWeight: FontWeight.w700,
                            fontSize: 15.5,
                            letterSpacing: 0.4,
                          ),
                        ),
                      )
                    else
                      _buildFeedbackPanel(currentQ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackPanel(WoodMark currentQ) {
    final isCorrect = _currentMark == currentQ;
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
                      isCorrect
                          ? 'You marked the cut line at ${currentQ.label}.'
                          : 'You marked at ${_currentMark.label}. The cut needed to be at ${currentQ.label}.',
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
