import 'dart:math';

import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../services/sound_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';
import '../widgets/quiz_shared_widgets.dart';

part 'lesson5_quiz_data.dart';
part 'lesson5_quiz_widgets.dart';

const _practiceXpKey = 'lesson_05_practice_unit_conversion_xp';

class Lesson5QuizScreen extends StatefulWidget {
  const Lesson5QuizScreen({super.key});

  @override
  State<Lesson5QuizScreen> createState() => _ScreenState();
}

class _ScreenState extends State<Lesson5QuizScreen>
    with SingleTickerProviderStateMixin {
  late List<_Q> _questions;
  int _index = 0;
  int _score = 0;
  bool _done = false;
  int _consecutive = 0;

  int? _selected;

  late AnimationController _fbCtrl;
  late Animation<double> _fbScale;

  _Q get _q => _questions[_index];

  bool get _answered {
    if (_q is _QMultipleChoice) return _selected != null;
    return false;
  }

  @override
  void initState() {
    super.initState();
    _questions = _buildSession(Random());
    _fbCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 380));
    _fbScale = CurvedAnimation(parent: _fbCtrl, curve: Curves.elasticOut);
    _prepQ();
    SoundService.instance.playBackgroundMusic();
  }

  void _prepQ() {
    _selected = null;
  }

  @override
  void dispose() {
    SoundService.instance.stopBackgroundMusic();
    _fbCtrl.dispose();
    super.dispose();
  }

  void _onTapChoice(int idx) {
    if (_selected != null) return;
    
    bool isCorrect = false;
    if (_q is _QMultipleChoice) {
      isCorrect = idx == (_q as _QMultipleChoice).correctIndex;
    }
    
    setState(() => _selected = idx);
    _fbCtrl.forward(from: 0);
    _handleResult(isCorrect);
  }

  void _handleResult(bool isCorrect) {
    if (isCorrect) {
      SoundService.instance.playCorrect();
      _score += 10;
      _consecutive++;
    } else {
      SoundService.instance.playWrong();
      _consecutive = 0;
    }
  }

  bool _isAnswerCorrect() {
    if (_q is _QMultipleChoice) return _selected == (_q as _QMultipleChoice).correctIndex;
    return false;
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
    SoundService.instance.playQuizComplete();
    
    await UserStore.mutate((user) {
      final tabs = List<String>.from(user.completedLessonTabs);
      int xp = user.xpEarned;
      int practiced = user.practiceCompleted;
      
      bool gainedXp = false;
      if (!tabs.contains(_practiceXpKey)) {
        tabs.add(_practiceXpKey);
        xp += 10;
        practiced++;
        gainedXp = true;
      }
      
      if (gainedXp) {
        SoundService.instance.playGainXp();
      }
      final maxC = _consecutive > user.maxConsecutiveCorrectAnswers
          ? _consecutive
          : user.maxConsecutiveCorrectAnswers;
      return user.copyWith(
        completedLessonTabs: tabs,
        xpEarned: xp,
        practiceCompleted: practiced,
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
    });
    _fbCtrl.reset();
    _prepQ();
    SoundService.instance.playBackgroundMusic();
  }

  @override
  Widget build(BuildContext context) {
    if (_done) return _resultScreen(context);
    return _questionScreen(context);
  }

  Widget _questionScreen(BuildContext context) {
    final progress = (_index + 1) / _questions.length;
    return DesignCanvas(width: 409, height: 849,
      backgroundColor: Colors.white,
      children: [
          Positioned.fill(
            bottom: 84,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Container(
                  color: QuizStyles.navy,
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
                              'Unit Conversion',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontFamily: QuizStyles.montserrat,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Interactive Quiz',
                              style: TextStyle(
                                color: QuizStyles.accent,
                                fontSize: 10,
                                fontFamily: QuizStyles.montserrat,
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
                            fontFamily: QuizStyles.montserrat,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Progress bar
                Container(
                  color: QuizStyles.navy,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Challenge ${_index + 1} of ${_questions.length}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                              fontFamily: QuizStyles.montserrat,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${(progress * 100).round()}%',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 10,
                              fontFamily: QuizStyles.montserrat,
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
                              const AlwaysStoppedAnimation<Color>(QuizStyles.green),
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: _TypeBadge(type: _q.type),
                        ),
                        const SizedBox(height: 12),
                        _buildActivity(),
                        const SizedBox(height: 14),
                        if (_answered)
                          ScaleTransition(
                            scale: _fbScale,
                            child: QuizFeedbackPanel(
                              isCorrect: _isAnswerCorrect(),
                              explanation: _getExplanation(),
                            ),
                          ),
                        if (_answered) const SizedBox(height: 12),
                        if (_answered)
                          QuizNextBtn(
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
          const DashboardBottomNavBar(currentTab: DashboardTab.quiz),
        ],
    );
  }

  Widget _buildActivity() {
    if (_q is _QMultipleChoice) {
      final q = _q as _QMultipleChoice;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (q.visualKey != null) ...[
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: QuizStyles.navy.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: QuizStyles.navy.withValues(alpha: 0.1)),
              ),
              child: Center(
                child: Text('Image: ${q.visualKey}',
                    style: const TextStyle(color: QuizStyles.navy)),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: QuizStyles.navy.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: QuizStyles.navy.withValues(alpha: 0.10)),
            ),
            child: Text(
              q.prompt,
              style: const TextStyle(
                color: QuizStyles.navy,
                fontSize: 15,
                fontFamily: QuizStyles.montserrat,
                fontWeight: FontWeight.w700,
                height: 1.45,
              ),
            ),
          ),
          const SizedBox(height: 16),
          QuizChoices(
            choices: q.choices,
            correctIndex: q.correctIndex,
            selected: _selected,
            onTap: _onTapChoice,
          ),
        ],
      );
    }
    return const Text('Unknown activity type.');
  }

  String _getExplanation() {
    if (_q is _QMultipleChoice) return (_q as _QMultipleChoice).explanation;
    return '';
  }

  Widget _resultScreen(BuildContext context) {
    final maxScore = _questions.length * 10;
    final accuracy = (_score / maxScore * 100).round();
    final String msg;
    final Color msgColor;
    if (accuracy >= 90) {
      msg = 'Excellent! You know your measurements well. 🎉';
      msgColor = QuizStyles.green;
    } else if (accuracy >= 70) {
      msg = 'Good work! Review the lesson and try again. 💪';
      msgColor = QuizStyles.accent;
    } else {
      msg = 'Keep practicing! Review the lesson and try again. 📖';
      msgColor = QuizStyles.red;
    }

    return DesignCanvas(width: 409, height: 849,
      backgroundColor: Colors.white,
      children: [
          Positioned.fill(
            bottom: 84,
            child: Column(
              children: [
                Container(
                  color: QuizStyles.navy,
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
                        fontFamily: QuizStyles.montserrat,
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
                              shape: BoxShape.circle, color: QuizStyles.navy),
                          child: const Center(
                            child: Icon(Icons.handyman_rounded,
                                color: QuizStyles.accent, size: 40),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          '$_score / ${(_questions.length * 10)}',
                          style: const TextStyle(
                            color: QuizStyles.navy,
                            fontSize: 52,
                            fontFamily: QuizStyles.montserrat,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Text(
                          'SCORE',
                          style: TextStyle(
                            color: Color(0xFF8B9BB4),
                            fontSize: 12,
                            fontFamily: QuizStyles.montserrat,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: QuizResultChip(
                                label: 'Accuracy',
                                value: '$accuracy%',
                                color: accuracy >= 70 ? QuizStyles.green : QuizStyles.red,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: QuizResultChip(
                                label: 'XP Earned',
                                value: '+10 XP', 
                                color: QuizStyles.accent,
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
                              fontFamily: QuizStyles.montserrat,
                              fontWeight: FontWeight.w600,
                              height: 1.4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        QuizPrimaryBtn(
                          label: 'TRY AGAIN',
                          bgColor: QuizStyles.navy,
                          fgColor: Colors.white,
                          onTap: _restart,
                        ),
                        const SizedBox(height: 10),
                        QuizPrimaryBtn(
                          label: 'BACK TO LESSON',
                          bgColor: Colors.white,
                          fgColor: QuizStyles.navy,
                          borderColor: QuizStyles.navy,
                          onTap: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const DashboardBottomNavBar(currentTab: DashboardTab.quiz),
        ],
    );
  }
}
