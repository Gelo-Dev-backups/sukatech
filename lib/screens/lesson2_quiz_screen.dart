import 'dart:math';

import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../services/sound_service.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';
import '../widgets/quiz_shared_widgets.dart';

part 'lesson2_quiz_data.dart';
part 'lesson2_quiz_widgets.dart';

const _practiceXpKey = 'lesson_02_practice_measuring_tools_xp';

class Lesson2QuizScreen extends StatefulWidget {
  const Lesson2QuizScreen({super.key});

  @override
  State<Lesson2QuizScreen> createState() => _ScreenState();
}

class _ScreenState extends State<Lesson2QuizScreen>
    with SingleTickerProviderStateMixin {
  late List<_Q> _questions;
  int _index = 0;
  int _score = 0;
  bool _done = false;
  int _consecutive = 0;

  int? _selected;
  bool _activitySubmitted = false;

  // State for drag and drop / sorting
  String? _droppedTool;
  final Map<String, String?> _sortAssignments = {};

  late AnimationController _fbCtrl;
  late Animation<double> _fbScale;

  _Q get _q => _questions[_index];

  bool get _answered {
    if (_q is _QMultipleChoice) return _selected != null;

    if (_q is _QDragToTask) return _activitySubmitted;
    if (_q is _QSafetySort || _q is _QCategorySort) return _activitySubmitted;
    if (_q is _QFinalSequence) return _selected != null; // Handle step by step later if needed, but for now just use a simple state
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
    SoundService.instance.enterQuizMusic();
  }

  void _prepQ() {
    _selected = null;
    _activitySubmitted = false;
    _droppedTool = null;
    _sortAssignments.clear();

    if (_q is _QSafetySort) {
      for (final item in (_q as _QSafetySort).items.keys) {
        _sortAssignments[item] = null;
      }
    } else if (_q is _QCategorySort) {
      for (final list in (_q as _QCategorySort).categories.values) {
        for (final item in list) {
          _sortAssignments[item] = null;
        }
      }
    }
  }

  @override
  void dispose() {
    SoundService.instance.exitQuizMusic();
    _fbCtrl.dispose();
    super.dispose();
  }

  void _onTapChoice(int idx) {
    if (_selected != null) return;
    
    bool isCorrect = false;
    if (_q is _QMultipleChoice) {
      isCorrect = idx == (_q as _QMultipleChoice).correctIndex;
    } else if (_q is _QFinalSequence) {
      final q = _q as _QFinalSequence;
      final step = q.steps.first;
      isCorrect = idx == q.toolChoices.indexOf(step.correctTool);
    }
    
    setState(() => _selected = idx);
    _fbCtrl.forward(from: 0);
    _handleResult(isCorrect);
  }



  void _onDropTool(String? tool) {
    if (_activitySubmitted) return;
    setState(() {
      _droppedTool = tool;
    });
  }

  void _submitDragToTask() {
    if (_droppedTool == null || _activitySubmitted) return;
    setState(() => _activitySubmitted = true);
    _fbCtrl.forward(from: 0);
    final correct = _droppedTool == (_q as _QDragToTask).correctTool;
    _handleResult(correct);
  }

  void _onAssignSort(String item, String? category) {
    if (_activitySubmitted) return;
    setState(() {
      _sortAssignments[item] = category;
    });
  }

  void _submitSort() {
    if (_sortAssignments.values.any((v) => v == null)) return;
    if (_activitySubmitted) return;
    setState(() => _activitySubmitted = true);
    _fbCtrl.forward(from: 0);

    bool allCorrect = true;
    if (_q is _QSafetySort) {
      final qs = _q as _QSafetySort;
      for (final entry in _sortAssignments.entries) {
        final expected = qs.items[entry.key]! ? 'SAFE' : 'UNSAFE';
        if (entry.value != expected) allCorrect = false;
      }
    } else if (_q is _QCategorySort) {
      final qs = _q as _QCategorySort;
      for (final entry in _sortAssignments.entries) {
        bool found = false;
        for (final cat in qs.categories.entries) {
          if (cat.value.contains(entry.key) && cat.key == entry.value) {
            found = true;
            break;
          }
        }
        if (!found) allCorrect = false;
      }
    }

    _handleResult(allCorrect);
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

    if (_q is _QDragToTask) return _droppedTool == (_q as _QDragToTask).correctTool;
    if (_q is _QSafetySort || _q is _QCategorySort) {
      // Re-evaluate since we don't store sort accuracy separately
      if (_q is _QSafetySort) {
        final qs = _q as _QSafetySort;
        for (final entry in _sortAssignments.entries) {
          final expected = qs.items[entry.key]! ? 'SAFE' : 'UNSAFE';
          if (entry.value != expected) return false;
        }
        return true;
      } else {
        final qs = _q as _QCategorySort;
        for (final entry in _sortAssignments.entries) {
          bool found = false;
          for (final cat in qs.categories.entries) {
            if (cat.value.contains(entry.key) && cat.key == entry.value) {
              found = true;
              break;
            }
          }
          if (!found) return false;
        }
        return true;
      }
    }
    if (_q is _QFinalSequence) {
      final q = _q as _QFinalSequence;
      final step = q.steps.first;
      return _selected == q.toolChoices.indexOf(step.correctTool);
    }
    return false; // Default for unimplemented
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
                              'Measuring Tools',
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
                        _buildTypeBadge(),
                        const SizedBox(height: 12),
                        _buildActivity(),
                        if (_needsSubmitButton()) ...[
                          const SizedBox(height: 14),
                          QuizSubmitBtn(
                            enabled: _isActivityReadyToSubmit(),
                            onTap: _submitActivity,
                          ),
                        ],
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

  Widget _buildTypeBadge() {
    final (label, icon, color) = switch (_q.type) {
      _QType.dragToTask => ('Drag Tool to Task', Icons.touch_app_rounded, const Color(0xFF1565C0)),
      _QType.toolId => ('Tool Identification', Icons.search_rounded, const Color(0xFFE65100)),
      _QType.safetySort => ('Safety Challenge', Icons.security_rounded, const Color(0xFF00695C)),
      _QType.scenarioChoice => ('What Tool Would You Choose?', Icons.handyman_rounded, const Color(0xFF4E342E)),

      _QType.safetyScenario => ('Safety Scenario', Icons.warning_rounded, const Color(0xFFD84315)),
      _QType.toolSort => ('Tool Sorting', Icons.sort_rounded, const Color(0xFF0277BD)),
      _QType.finalChallenge => ('Final Carpenter Challenge', Icons.star_rounded, const Color(0xFFF9A825)),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.30)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontFamily: QuizStyles.montserrat,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivity() {
    if (_q is _QMultipleChoice) {
      final q = _q as _QMultipleChoice;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (q.visualKey != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Center(child: _ToolIcon(toolName: q.choices[q.correctIndex], size: 120)),
            ),
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



    if (_q is _QDragToTask) {
      final q = _q as _QDragToTask;
      return _DragToTaskActivity(
        task: q.task,
        toolChoices: q.toolChoices,
        correctTool: q.correctTool,
        submitted: _activitySubmitted,
        droppedTool: _droppedTool,
        onDrop: _onDropTool,
      );
    }

    if (_q is _QSafetySort) {
      final q = _q as _QSafetySort;
      return _GenericSortActivity(
        categories: const [
          (name: 'SAFE', color: QuizStyles.green, correctItems: []), // Populated later
          (name: 'UNSAFE', color: QuizStyles.red, correctItems: []),
        ].map((c) {
          final corrects = q.items.entries
              .where((e) => (c.name == 'SAFE' && e.value) || (c.name == 'UNSAFE' && !e.value))
              .map((e) => e.key)
              .toList();
          return (name: c.name, color: c.color, correctItems: corrects);
        }).toList(),
        unassignedItems: _sortAssignments.entries.where((e) => e.value == null).map((e) => e.key).toList(),
        assignments: _sortAssignments,
        submitted: _activitySubmitted,
        onAssign: _onAssignSort,
      );
    }

    if (_q is _QCategorySort) {
      final q = _q as _QCategorySort;
      final cats = q.categories.entries.map((e) {
        Color color;
        if (e.key.contains('LENGTH')) {
          color = const Color(0xFF1565C0);
        } else if (e.key.contains('CHECKS')) {
          color = const Color(0xFFE65100);
        } else {
          color = const Color(0xFF6A1B9A);
        }
        return (name: e.key, color: color, correctItems: e.value);
      }).toList();

      return _GenericSortActivity(
        categories: cats,
        unassignedItems: _sortAssignments.entries.where((e) => e.value == null).map((e) => e.key).toList(),
        assignments: _sortAssignments,
        submitted: _activitySubmitted,
        onAssign: _onAssignSort,
      );
    }

    if (_q is _QFinalSequence) {
      // Just treating it as a simple multiple choice for the first step to keep UI simple
      // A more complex sequence could be built, but we will just use the first step for this MVP
      final q = _q as _QFinalSequence;
      final step = q.steps.first;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: QuizStyles.navy.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: QuizStyles.navy.withValues(alpha: 0.10)),
            ),
            child: Text(
              step.prompt,
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
            choices: q.toolChoices,
            correctIndex: q.toolChoices.indexOf(step.correctTool),
            selected: _selected,
            onTap: _onTapChoice,
          ),
        ],
      );
    }

    return const Text('Unknown activity type.');
  }

  bool _needsSubmitButton() {
    if (_q is _QDragToTask && !_activitySubmitted) return true;
    if ((_q is _QSafetySort || _q is _QCategorySort) && !_activitySubmitted) return true;
    return false;
  }

  bool _isActivityReadyToSubmit() {
    if (_q is _QDragToTask) return _droppedTool != null;
    if (_q is _QSafetySort || _q is _QCategorySort) {
      return !_sortAssignments.values.any((v) => v == null);
    }
    return false;
  }

  void _submitActivity() {
    if (_q is _QDragToTask) _submitDragToTask();
    if (_q is _QSafetySort || _q is _QCategorySort) _submitSort();
  }

  String _getExplanation() {
    if (_q is _QMultipleChoice) return (_q as _QMultipleChoice).explanation;
    if (_q is _QDragToTask) return (_q as _QDragToTask).explanation;

    if (_q is _QSafetySort) return 'Always follow proper safety guidelines when handling measuring tools.';
    if (_q is _QCategorySort) return 'Each tool is specialized for specific types of measurements or checks.';
    if (_q is _QFinalSequence) return 'Carpenter challenge step complete!';
    return '';
  }

  Widget _resultScreen(BuildContext context) {
    final maxScore = _questions.length * 10;
    final accuracy = (_score / maxScore * 100).round();
    final String msg;
    final Color msgColor;
    if (accuracy >= 90) {
      msg = 'Excellent! You know your measuring tools. 🎉';
      msgColor = QuizStyles.green;
    } else if (accuracy >= 70) {
      msg = 'Good work! Review a few tools and try again. 💪';
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
                                value: '+10 XP', // Always 10 XP as per requirements
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

