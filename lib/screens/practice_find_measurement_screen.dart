import 'dart:math';
import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../services/sound_service.dart';
import '../widgets/quiz_shared_widgets.dart';

enum MeasurementUnit { inch, cm }

enum PracticeUnitFilter { all, inch, cm }

/// Single tick measurement on the ruler blade.
class RulerTick {
  const RulerTick({
    required this.label,
    required this.ratio,
    required this.unit,
  });

  final String label;
  final double ratio;
  final MeasurementUnit unit;
}

const _allRulerTicks = <RulerTick>[
  // ── Imperial (Inch) Ticks (Bottom Scale) ────────────────────────────────
  RulerTick(label: '1 in.', ratio: 0.30186, unit: MeasurementUnit.inch),
  RulerTick(label: '1 1/8 in.', ratio: 0.32712, unit: MeasurementUnit.inch),
  RulerTick(label: '1 1/4 in.', ratio: 0.35362, unit: MeasurementUnit.inch),
  RulerTick(label: '1 3/8 in.', ratio: 0.38012, unit: MeasurementUnit.inch),
  RulerTick(label: '1 1/2 in.', ratio: 0.40828, unit: MeasurementUnit.inch),
  RulerTick(label: '1 5/8 in.', ratio: 0.43602, unit: MeasurementUnit.inch),
  RulerTick(label: '1 3/4 in.', ratio: 0.46211, unit: MeasurementUnit.inch),
  RulerTick(label: '1 7/8 in.', ratio: 0.48778, unit: MeasurementUnit.inch),
  RulerTick(label: '2 in.', ratio: 0.51014, unit: MeasurementUnit.inch),
  RulerTick(label: '2 1/8 in.', ratio: 0.53582, unit: MeasurementUnit.inch),
  RulerTick(label: '2 1/4 in.', ratio: 0.56149, unit: MeasurementUnit.inch),
  RulerTick(label: '2 3/8 in.', ratio: 0.58799, unit: MeasurementUnit.inch),
  RulerTick(label: '2 1/2 in.', ratio: 0.61698, unit: MeasurementUnit.inch),
  RulerTick(label: '2 5/8 in.', ratio: 0.64845, unit: MeasurementUnit.inch),
  RulerTick(label: '2 3/4 in.', ratio: 0.67826, unit: MeasurementUnit.inch),
  RulerTick(label: '2 7/8 in.', ratio: 0.70559, unit: MeasurementUnit.inch),
  RulerTick(label: '3 in.', ratio: 0.73168, unit: MeasurementUnit.inch),
  RulerTick(label: '3 1/8 in.', ratio: 0.75859, unit: MeasurementUnit.inch),
  RulerTick(label: '3 1/4 in.', ratio: 0.78592, unit: MeasurementUnit.inch),
  RulerTick(label: '3 3/8 in.', ratio: 0.81491, unit: MeasurementUnit.inch),
  RulerTick(label: '3 1/2 in.', ratio: 0.84472, unit: MeasurementUnit.inch),
  RulerTick(label: '3 5/8 in.', ratio: 0.87702, unit: MeasurementUnit.inch),
  RulerTick(label: '3 3/4 in.', ratio: 0.90890, unit: MeasurementUnit.inch),
  RulerTick(label: '3 7/8 in.', ratio: 0.93872, unit: MeasurementUnit.inch),
  RulerTick(label: '4 in.', ratio: 0.96646, unit: MeasurementUnit.inch),

  // ── Metric (cm) Ticks (Top Scale) ───────────────────────────────────────
  RulerTick(label: '1 cm', ratio: 0.18302, unit: MeasurementUnit.cm),
  RulerTick(label: '1.5 cm', ratio: 0.22277, unit: MeasurementUnit.cm),
  RulerTick(label: '2 cm', ratio: 0.28654, unit: MeasurementUnit.cm),
  RulerTick(label: '2.5 cm', ratio: 0.33872, unit: MeasurementUnit.cm),
  RulerTick(label: '3 cm', ratio: 0.38716, unit: MeasurementUnit.cm),
  RulerTick(label: '3.5 cm', ratio: 0.43147, unit: MeasurementUnit.cm),
  RulerTick(label: '4 cm', ratio: 0.48530, unit: MeasurementUnit.cm),
  RulerTick(label: '4.5 cm', ratio: 0.52836, unit: MeasurementUnit.cm),
  RulerTick(label: '5 cm', ratio: 0.57640, unit: MeasurementUnit.cm),
  RulerTick(label: '5.5 cm', ratio: 0.61615, unit: MeasurementUnit.cm),
  RulerTick(label: '6 cm', ratio: 0.66253, unit: MeasurementUnit.cm),
  RulerTick(label: '6.5 cm', ratio: 0.69772, unit: MeasurementUnit.cm),
  RulerTick(label: '7 cm', ratio: 0.74079, unit: MeasurementUnit.cm),
  RulerTick(label: '7.5 cm', ratio: 0.78509, unit: MeasurementUnit.cm),
  RulerTick(label: '8 cm', ratio: 0.82526, unit: MeasurementUnit.cm),
  RulerTick(label: '8.5 cm', ratio: 0.85590, unit: MeasurementUnit.cm),
  RulerTick(label: '9 cm', ratio: 0.90228, unit: MeasurementUnit.cm),
  RulerTick(label: '9.5 cm', ratio: 0.93375, unit: MeasurementUnit.cm),
  RulerTick(label: '10 cm', ratio: 0.97143, unit: MeasurementUnit.cm),
];

class FindTheMeasurementPracticeScreen extends StatefulWidget {
  const FindTheMeasurementPracticeScreen({super.key});

  @override
  State<FindTheMeasurementPracticeScreen> createState() =>
      _FindTheMeasurementPracticeScreenState();
}

class _FindTheMeasurementPracticeScreenState
    extends State<FindTheMeasurementPracticeScreen> {
  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);
  static const _green = Color(0xFF05831C);
  static const _red = Color(0xFFD32F2F);
  static const _teal = Color(0xFF0284C7);
  static const _montserrat = 'Montserrat';

  PracticeUnitFilter _unitFilter = PracticeUnitFilter.all;
  late List<RulerTick> _sessionTargetTicks;
  int _currentIndex = 0;
  late RulerTick _currentMarkerTick;
  int _score = 0;
  bool _answered = false;

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    final rng = Random();

    List<RulerTick> pool;
    if (_unitFilter == PracticeUnitFilter.inch) {
      pool = _allRulerTicks
          .where((t) => t.unit == MeasurementUnit.inch)
          .toList();
    } else if (_unitFilter == PracticeUnitFilter.cm) {
      pool = _allRulerTicks
          .where((t) => t.unit == MeasurementUnit.cm)
          .toList();
    } else {
      final inches = _allRulerTicks
          .where((t) => t.unit == MeasurementUnit.inch)
          .toList()
        ..shuffle(rng);
      final cms = _allRulerTicks
          .where((t) => t.unit == MeasurementUnit.cm)
          .toList()
        ..shuffle(rng);
      pool = [...inches.take(3), ...cms.take(2)]..shuffle(rng);
    }

    final shuffled = List<RulerTick>.from(pool)..shuffle(rng);
    _sessionTargetTicks = shuffled.take(5).toList();

    _currentIndex = 0;
    _score = 0;
    _answered = false;
    _resetMarkerPosition();
  }

  List<RulerTick> get _currentCandidateTicks {
    final target = _sessionTargetTicks[_currentIndex];
    return _allRulerTicks.where((t) => t.unit == target.unit).toList();
  }

  void _resetMarkerPosition() {
    final target = _sessionTargetTicks[_currentIndex];
    final candidates = _currentCandidateTicks;
    final targetIndex = candidates.indexOf(target);

    // Place marker noticeably away from target tick
    int startIdx = (targetIndex + 5) % candidates.length;
    if (candidates[startIdx] == target) {
      startIdx = (targetIndex + 2) % candidates.length;
    }
    _currentMarkerTick = candidates[startIdx];
  }

  RulerTick _findClosestCandidateTick(double ratio) {
    final candidates = _currentCandidateTicks;
    RulerTick best = candidates[0];
    double bestDiff = (ratio - best.ratio).abs();

    for (int i = 1; i < candidates.length; i++) {
      final diff = (ratio - candidates[i].ratio).abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = candidates[i];
      }
    }
    return best;
  }

  void _updateMarkerPosition(double localX, double cardWidth) {
    if (_answered || cardWidth <= 0) return;
    final ratio = (localX / cardWidth).clamp(0.16, 0.98);
    final closest = _findClosestCandidateTick(ratio);
    if (closest != _currentMarkerTick) {
      setState(() {
        _currentMarkerTick = closest;
      });
    }
  }

  void _onCheck() {
    if (_answered) return;

    final target = _sessionTargetTicks[_currentIndex];
    final isCorrect = _currentMarkerTick == target;

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
    final targetTick = _sessionTargetTicks[_currentIndex];
    final progress = (_currentIndex + 1) / 5.0;
    final isMetric = targetTick.unit == MeasurementUnit.cm;

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
                                  'Find the Measurement',
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

                    // Instruction Box
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                      child: Text(
                        isMetric
                            ? 'Move the marker to the measurement on the top metric scale (cm).'
                            : 'Move the marker to the measurement on the bottom inch scale (in).',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 13.5,
                          fontFamily: _montserrat,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Target Measurement Box
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 36,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: isMetric ? const Color(0xFF0D47A1) : _navy,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: (isMetric ? _teal : _accent)
                                .withValues(alpha: 0.35),
                            width: 1.2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _navy.withValues(alpha: 0.25),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isMetric ? 'METRIC (TOP SCALE)' : 'IMPERIAL (BOTTOM SCALE)',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                  fontFamily: _montserrat,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              targetTick.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontFamily: _montserrat,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),

                    // ── Interactive Ruler Card ─────────────────────────────
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        // Image aspect ratio: 2415 x 809
                        final imageH = width * (809.0 / 2415.0);
                        const bladeTopRatio = 209.0 / 809.0;
                        const bladeBottomRatio = 587.0 / 809.0;
                        const bladeHeightRatio =
                            bladeBottomRatio - bladeTopRatio;

                        // Comfortably position blade inside card
                        const bladeTopY = 24.0;
                        final imageTop = bladeTopY - (imageH * bladeTopRatio);
                        final bladeBottomY =
                            bladeTopY + (imageH * bladeHeightRatio);

                        final markerX = width * _currentMarkerTick.ratio;
                        final targetX = width * targetTick.ratio;

                        // Total card height accommodates both top (for cm) and bottom (for inch) markers
                        final totalH = bladeBottomY + 34.0;

                        final isCorrect =
                            _answered && _currentMarkerTick == targetTick;
                        final markerColor = !_answered
                            ? _red
                            : (isCorrect ? _green : _red);

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
                                clipBehavior: Clip.none,
                                children: [
                                  // Tape measure blade image
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

                                  // ── Marker for METRIC (Top Scale) ─────────
                                  if (isMetric) ...[
                                    // Ghost Target Marker on top (shown when user is wrong)
                                    if (_answered && !isCorrect) ...[
                                      Positioned(
                                        left: targetX - 1.25,
                                        top: bladeTopY - 8.0,
                                        width: 2.5,
                                        height: 28.0,
                                        child: Container(color: _green),
                                      ),
                                      Positioned(
                                        left: targetX - 8.0,
                                        top: bladeTopY - 8.0,
                                        width: 16.0,
                                        height: 16.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: _green,
                                              width: 2.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: targetX - 7.0,
                                        top: bladeTopY - 18.0,
                                        width: 14.0,
                                        height: 10.0,
                                        child: const CustomPaint(
                                          painter: _DownwardTrianglePainter(
                                            color: _green,
                                          ),
                                        ),
                                      ),
                                    ],

                                    // User Sightline through top tick
                                    Positioned(
                                      left: markerX - 1.25,
                                      top: bladeTopY - 8.0,
                                      width: 2.5,
                                      height: 28.0,
                                      child: Container(color: markerColor),
                                    ),

                                    // User Circle Ring on top tick
                                    Positioned(
                                      left: markerX - 8.0,
                                      top: bladeTopY - 8.0,
                                      width: 16.0,
                                      height: 16.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: markerColor,
                                            width: 2.5,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // User Downward Pointer Triangle touching top tick
                                    Positioned(
                                      left: markerX - 7.0,
                                      top: bladeTopY - 18.0,
                                      width: 14.0,
                                      height: 10.0,
                                      child: CustomPaint(
                                        painter: _DownwardTrianglePainter(
                                          color: markerColor,
                                        ),
                                      ),
                                    ),
                                  ],

                                  // ── Marker for IMPERIAL (Bottom Scale) ─────
                                  if (!isMetric) ...[
                                    // Ghost Target Marker on bottom (shown when user is wrong)
                                    if (_answered && !isCorrect) ...[
                                      Positioned(
                                        left: targetX - 1.25,
                                        top: bladeBottomY - 20.0,
                                        width: 2.5,
                                        height: 28.0,
                                        child: Container(color: _green),
                                      ),
                                      Positioned(
                                        left: targetX - 8.0,
                                        top: bladeBottomY - 8.0,
                                        width: 16.0,
                                        height: 16.0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: _green,
                                              width: 2.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: targetX - 7.0,
                                        top: bladeBottomY + 8.0,
                                        width: 14.0,
                                        height: 10.0,
                                        child: const CustomPaint(
                                          painter: _UpwardTrianglePainter(
                                            color: _green,
                                          ),
                                        ),
                                      ),
                                    ],

                                    // User Sightline through bottom tick
                                    Positioned(
                                      left: markerX - 1.25,
                                      top: bladeBottomY - 20.0,
                                      width: 2.5,
                                      height: 28.0,
                                      child: Container(color: markerColor),
                                    ),

                                    // User Circle Ring on bottom tick
                                    Positioned(
                                      left: markerX - 8.0,
                                      top: bladeBottomY - 8.0,
                                      width: 16.0,
                                      height: 16.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: markerColor,
                                            width: 2.5,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // User Upward Pointer Triangle touching bottom tick
                                    Positioned(
                                      left: markerX - 7.0,
                                      top: bladeBottomY + 8.0,
                                      width: 14.0,
                                      height: 10.0,
                                      child: CustomPaint(
                                        painter: _UpwardTrianglePainter(
                                          color: markerColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 22),

                    // ── Check Button or Feedback Panel ─────────────────────
                    if (!_answered)
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _navy,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                        ),
                        onPressed: _onCheck,
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
                      _buildFeedbackPanel(targetTick, _currentMarkerTick),
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

  Widget _buildFeedbackPanel(RulerTick targetTick, RulerTick userTick) {
    final isCorrect = _currentMarkerTick == targetTick;
    final color = isCorrect ? _green : _red;
    final isMetric = targetTick.unit == MeasurementUnit.cm;
    final targetText = isMetric
        ? targetTick.label
        : targetTick.label.replaceAll(' in.', ' inches');
    final userText = isMetric
        ? userTick.label
        : userTick.label.replaceAll(' in.', ' inches');

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
                          ? 'You found $targetText!'
                          : 'You placed the marker at $userText. The target was $targetText.',
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

class _UpwardTrianglePainter extends CustomPainter {
  const _UpwardTrianglePainter({required this.color});
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _UpwardTrianglePainter oldDelegate) =>
      oldDelegate.color != color;
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
