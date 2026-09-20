import 'dart:math';

import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../widgets/bottom_nav_bar.dart';

part 'lesson1_practice_data.dart';
part 'lesson1_practice_widgets.dart';

const _navy = Color(0xFF061D3F);
const _accent = Color(0xFFFFA500);
const _green = Color(0xFF05831C);
const _red = Color(0xFFD32F2F);
const _montserrat = 'Montserrat';

const _practiceXpKey = 'lesson_01_practice_intro_measurement_xp';
const _practicePerfectKey = 'lesson_01_practice_intro_measurement_perfect';

class Lesson1PracticeScreen extends StatefulWidget {
  const Lesson1PracticeScreen({super.key});

  @override
  State<Lesson1PracticeScreen> createState() => _ScreenState();
}

class _ScreenState extends State<Lesson1PracticeScreen>
    with SingleTickerProviderStateMixin {
  late List<_Q> _questions;
  int _index = 0;
  int _score = 0;
  bool _done = false;
  int _consecutive = 0;
  final Set<String> _dimAnswers = {};

  int? _selected;
  _SortState? _sortState;
  bool _sortSubmitted = false;

  late AnimationController _fbCtrl;
  late Animation<double> _fbScale;

  bool get _answered =>
      _q.type == _QType.metricVsEnglish ? _sortSubmitted : _selected != null;
  _Q get _q => _questions[_index];

  @override
  void initState() {
    super.initState();
    _questions = _buildSession(Random());
    _fbCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _fbScale = CurvedAnimation(parent: _fbCtrl, curve: Curves.elasticOut);
    _prepQ();
  }

  void _prepQ() {
    if (_q.type == _QType.metricVsEnglish) {
      _sortState = _SortState();
      _sortSubmitted = false;
    } else {
      _sortState = null;
      _selected = null;
    }
  }

  @override
  void dispose() {
    _fbCtrl.dispose();
    super.dispose();
  }

  void _onTap(int idx) {
    if (_selected != null) return;
    final ok = idx == _q.correctIndex;
    setState(() => _selected = idx);
    _fbCtrl.forward(from: 0);
    if (ok) {
      _score++;
      _consecutive++;
      if (_q.type == _QType.identifyDimension ||
          _q.type == _QType.whatIsMeasured) {
        _dimAnswers.add(_q.choices[_q.correctIndex].toLowerCase());
      }
    } else {
      _consecutive = 0;
    }
  }

  void _onAssign(String unit, String group) {
    if (_sortSubmitted) return;
    setState(() {
      if (group == 'unassign') {
        _sortState!.assignments[unit] = null;
      } else {
        _sortState!.assignments[unit] = group;
      }
    });
  }

  void _submitSort() {
    if (!_sortState!.isComplete) return;
    setState(() => _sortSubmitted = true);
    _fbCtrl.forward(from: 0);
    if (_sortState!.isAllCorrect) {
      _score++;
      _consecutive++;
    } else {
      _consecutive = 0;
    }
  }

  void _next() {
    if (_index < _questions.length - 1) {
      setState(() {
        _index++;
        _prepQ();
      });
      _fbCtrl.reset();
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    setState(() => _done = true);
    final perfect = _score == _questions.length;
    await UserStore.mutate((user) {
      final tabs = List<String>.from(user.completedLessonTabs);
      int xp = user.xpEarned;
      int practiced = user.practiceCompleted;
      if (!tabs.contains(_practiceXpKey)) {
        tabs.add(_practiceXpKey);
        xp += 10;
        practiced++;
      }
      if (perfect && !tabs.contains(_practicePerfectKey)) {
        tabs.add(_practicePerfectKey);
        xp += 10;
      }
      int basics = user.correctMeasurementBasics;
      for (final d in _dimAnswers) {
        final key = 'lesson_01_dim_$d';
        if (!tabs.contains(key)) {
          tabs.add(key);
          basics++;
        }
      }
      final maxC = _consecutive > user.maxConsecutiveCorrectAnswers
          ? _consecutive
          : user.maxConsecutiveCorrectAnswers;
      return user.copyWith(
        completedLessonTabs: tabs,
        xpEarned: xp,
        practiceCompleted: practiced,
        correctMeasurementBasics: basics,
        maxConsecutiveCorrectAnswers: maxC,
      );
    });
  }

  void _restart() {
    setState(() {
      _questions = _buildSession(Random());
      _index = 0;
      _score = 0;
      _done = false;
      _consecutive = 0;
      _dimAnswers.clear();
    });
    _fbCtrl.reset();
    _prepQ();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _resultScreen(context);
    return _questionScreen(context);
  }

  Widget _questionScreen(BuildContext context) {
    final q = _q;
    final progress = (_index + 1) / _questions.length;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 84,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  color: _navy,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 4,
                    right: 16,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Introduction to Measurement',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: _montserrat,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Interactive Practice',
                              style: TextStyle(
                                color: _accent,
                                fontSize: 10,
                                fontFamily: _montserrat,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Score: $_score',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontFamily: _montserrat,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress bar
                Container(
                  color: _navy,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Question ${_index + 1} of ${_questions.length}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 6,
                          backgroundColor: Colors.white24,
                          valueColor:
                              const AlwaysStoppedAnimation<Color>(_green),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TypeBadge(type: q.type),
                        const SizedBox(height: 12),
                        _buildVisual(q),
                        const SizedBox(height: 14),
                        _buildPrompt(q),
                        const SizedBox(height: 16),
                        if (q.type == _QType.metricVsEnglish)
                          _DragDropActivity(
                            sortState: _sortState!,
                            submitted: _sortSubmitted,
                            onAssign: _onAssign,
                          )
                        else
                          _Choices(
                            choices: q.choices,
                            correctIndex: q.correctIndex,
                            selected: _selected,
                            onTap: _onTap,
                          ),
                        if (q.type == _QType.metricVsEnglish &&
                            !_sortSubmitted) ...[
                          const SizedBox(height: 14),
                          _SubmitBtn(
                            enabled: _sortState!.isComplete,
                            onTap: _submitSort,
                          ),
                        ],
                        const SizedBox(height: 14),
                        if (_answered)
                          ScaleTransition(
                            scale: _fbScale,
                            child: _FeedbackPanel(
                              isCorrect: q.type == _QType.metricVsEnglish
                                  ? _sortState!.isAllCorrect
                                  : _selected == q.correctIndex,
                              explanation: q.explanation,
                            ),
                          ),
                        if (_answered) const SizedBox(height: 12),
                        if (_answered)
                          _NextBtn(
                            isLast: _index == _questions.length - 1,
                            onTap: _next,
                          ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DashboardBottomNavBar(currentTab: DashboardTab.practice),
        ],
      ),
    );
  }

  Widget _buildVisual(_Q q) {
    switch (q.type) {
      case _QType.identifyDimension:
      case _QType.whatIsMeasured:
        return _BoardCard(
          dimensionKey: q.dimensionKey,
          answered: _answered,
          correct: _selected == q.correctIndex,
        );
      case _QType.fillInBlank:
        return _FillBlankCard(blankWord: q.blankWord ?? '', answered: _answered);
      case _QType.metricVsEnglish:
        return const _MetricEnglishInfoCard();
      case _QType.carpenterDecision:
        return const _CarpenterCard();
    }
  }

  Widget _buildPrompt(_Q q) {
    if (q.type == _QType.fillInBlank) {
      return _FillBlankPrompt(
        prompt: q.prompt,
        answered: _answered,
        selectedWord: _answered ? q.choices[q.correctIndex] : null,
      );
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _navy.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _navy.withValues(alpha: 0.10)),
      ),
      child: Text(
        q.prompt,
        style: const TextStyle(
          color: _navy,
          fontSize: 15,
          fontFamily: _montserrat,
          fontWeight: FontWeight.w700,
          height: 1.45,
        ),
      ),
    );
  }

  Widget _resultScreen(BuildContext context) {
    final accuracy = (_score / _questions.length * 100).round();
    final isPerfect = _score == _questions.length;
    final String msg;
    final Color msgColor;
    if (accuracy >= 90) {
      msg = 'Excellent measurement skills! 🎉';
      msgColor = _green;
    } else if (accuracy >= 70) {
      msg = 'Good work! Review and try again. 💪';
      msgColor = _accent;
    } else {
      msg = 'Keep practicing! Review the lesson first. 📖';
      msgColor = _red;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 84,
            child: Column(
              children: [
                Container(
                  color: _navy,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 12,
                    bottom: 14,
                  ),
                  child: const Center(
                    child: Text(
                      'Practice Complete! 🏆',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: _montserrat,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 86,
                          height: 86,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: _navy),
                          child: const Center(
                            child: Icon(Icons.emoji_events_rounded,
                                color: _accent, size: 44),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$_score / ${_questions.length}',
                          style: const TextStyle(
                            color: _navy,
                            fontSize: 52,
                            fontFamily: _montserrat,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'SCORE',
                          style: TextStyle(
                            color: Color(0xFF8B9BB4),
                            fontSize: 12,
                            fontFamily: _montserrat,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _ResultChip(
                                label: 'Accuracy',
                                value: '$accuracy%',
                                color: accuracy >= 70 ? _green : _red,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ResultChip(
                                label: 'XP Earned',
                                value: '+${isPerfect ? 20 : 10} XP',
                                color: _accent,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: msgColor.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color: msgColor.withValues(alpha: 0.25)),
                          ),
                          child: Text(
                            msg,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: msgColor,
                              fontSize: 13,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        _PrimaryBtn(
                          label: 'TRY AGAIN',
                          bgColor: _navy,
                          fgColor: Colors.white,
                          onTap: _restart,
                        ),
                        const SizedBox(height: 10),
                        _PrimaryBtn(
                          label: 'BACK TO PRACTICE',
                          bgColor: Colors.white,
                          fgColor: _navy,
                          borderColor: _navy,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DashboardBottomNavBar(currentTab: DashboardTab.practice),
        ],
      ),
    );
  }
}
