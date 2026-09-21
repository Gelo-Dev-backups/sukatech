import 'dart:math';
import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../services/sound_service.dart';
import '../widgets/quiz_shared_widgets.dart';

class ToolChoice {
  const ToolChoice({
    required this.name,
    required this.imageAsset,
  });

  final String name;
  final String imageAsset;
}

const _toolTapeMeasure = ToolChoice(
  name: 'Tape Measure',
  imageAsset: 'lib/assets/images/tape-measure.png',
);

const _toolSteelRule = ToolChoice(
  name: 'Steel Ruler',
  imageAsset: 'lib/assets/images/steel-rule.png',
);

const _toolTrySquare = ToolChoice(
  name: 'Try Square',
  imageAsset: 'lib/assets/images/try-square.png',
);

const _toolCaliper = ToolChoice(
  name: 'Vernier Caliper',
  imageAsset: 'lib/assets/images/venice-caliper.png',
);

const _toolFoldingRule = ToolChoice(
  name: 'Folding Rule',
  imageAsset: 'lib/assets/images/folding-rule.png',
);

const _toolStraightEdge = ToolChoice(
  name: 'Straight Edge',
  imageAsset: 'lib/assets/images/straight-edge.png',
);

const _toolChalkLine = ToolChoice(
  name: 'Chalk Line',
  imageAsset: 'lib/assets/images/chalk line.png',
);

const _toolCombiSquare = ToolChoice(
  name: 'Combination Square',
  imageAsset: 'lib/assets/images/Combi Square.png',
);

class ToolQuestion {
  const ToolQuestion({
    required this.scenario,
    required this.correctTool,
    required this.distractors,
    required this.explanation,
  });

  final String scenario;
  final ToolChoice correctTool;
  final List<ToolChoice> distractors;
  final String explanation;
}

const _allToolQuestions = <ToolQuestion>[
  ToolQuestion(
    scenario: 'Which tool is best for measuring the length of a long wooden board or wall?',
    correctTool: _toolTapeMeasure,
    distractors: [_toolTrySquare, _toolSteelRule, _toolCaliper],
    explanation:
        'A tape measure (pull-push rule) is flexible and extends several meters, making it ideal for measuring long lumber and distances.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for checking whether the corner of a cut piece of wood is a true 90° right angle?',
    correctTool: _toolTrySquare,
    distractors: [_toolSteelRule, _toolTapeMeasure, _toolChalkLine],
    explanation:
        'A try square has a fixed 90° blade and stock designed specifically to test squareness and scribe perpendicular lines.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for measuring a short length with rigid accuracy and guiding a pencil on a workbench?',
    correctTool: _toolSteelRule,
    distractors: [_toolTapeMeasure, _toolStraightEdge, _toolFoldingRule],
    explanation:
        'A steel ruler is rigid, flat, and graduated finely for accurate bench measurements and straight-line scoring.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for measuring the exact thickness of a small dowel or the depth of a mortise hole?',
    correctTool: _toolCaliper,
    distractors: [_toolSteelRule, _toolFoldingRule, _toolTrySquare],
    explanation:
        'A vernier caliper accurately measures outside diameters, inside diameters, and hole depths with high decimal precision.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for checking if an edge or tabletop surface is completely flat without bowing or warping?',
    correctTool: _toolStraightEdge,
    distractors: [_toolTrySquare, _toolTapeMeasure, _toolCaliper],
    explanation:
        'A straight edge has a precision reference edge used to detect humps, dips, and warping across surfaces.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for measuring vertical heights or overhead distances without the blade bending or sagging?',
    correctTool: _toolFoldingRule,
    distractors: [_toolTapeMeasure, _toolSteelRule, _toolCaliper],
    explanation:
        'A folding rule stays rigid and upright when unfolded, making it easier to measure heights without buckling.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for snapping a long, perfectly straight chalk guide line across a large sheet of plywood?',
    correctTool: _toolChalkLine,
    distractors: [_toolSteelRule, _toolTrySquare, _toolCaliper],
    explanation:
        'A chalk line reel holds a string coated in chalk that snaps a crisp, straight reference line across long spans.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for checking both 90° right angles and 45° miter angles on door moldings?',
    correctTool: _toolCombiSquare,
    distractors: [_toolStraightEdge, _toolFoldingRule, _toolCaliper],
    explanation:
        'A combination square head has 90° and 45° reference shoulders with an adjustable sliding steel blade.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for measuring the inside diameter of a drilled circular hole in hardwood?',
    correctTool: _toolCaliper,
    distractors: [_toolTapeMeasure, _toolStraightEdge, _toolSteelRule],
    explanation:
        'The top internal jaws of a vernier caliper are designed specifically to expand inside holes for precise internal readings.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for measuring the overall dimensions of a room to plan cabinetry and framing?',
    correctTool: _toolTapeMeasure,
    distractors: [_toolFoldingRule, _toolSteelRule, _toolTrySquare],
    explanation:
        'Tape measures offer the length and reach required to measure whole room dimensions quickly and easily.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for marking a line strictly square (90°) across the face of a framing timber stud?',
    correctTool: _toolTrySquare,
    distractors: [_toolTapeMeasure, _toolStraightEdge, _toolFoldingRule],
    explanation:
        'Placing the try square stock against the reference edge allows you to draw a true perpendicular crosscut line.',
  ),
  ToolQuestion(
    scenario: 'Which tool is best for marking precise millimeter layout increments directly on a small mortise and tenon joint?',
    correctTool: _toolSteelRule,
    distractors: [_toolChalkLine, _toolTapeMeasure, _toolStraightEdge],
    explanation:
        'Steel rules have fine graduations starting right from the edge, making them ideal for precise joint joinery layout.',
  ),
];

class ChooseTheRightToolPracticeScreen extends StatefulWidget {
  const ChooseTheRightToolPracticeScreen({super.key});

  @override
  State<ChooseTheRightToolPracticeScreen> createState() =>
      _ChooseTheRightToolPracticeScreenState();
}

class _ChooseTheRightToolPracticeScreenState
    extends State<ChooseTheRightToolPracticeScreen> {
  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);
  static const _green = Color(0xFF05831C);
  static const _red = Color(0xFFD32F2F);
  static const _montserrat = 'Montserrat';

  late List<ToolQuestion> _sessionQuestions;
  late List<List<ToolChoice>> _sessionChoices;
  int _currentIndex = 0;
  int? _selectedChoiceIndex;
  int _score = 0;
  bool _answered = false;
  final Set<String> _sessionCorrectScenarios = {};

  @override
  void initState() {
    super.initState();
    _startNewSession();
  }

  void _startNewSession() {
    final rng = Random();
    final shuffled = List<ToolQuestion>.from(_allToolQuestions)..shuffle(rng);
    _sessionQuestions = shuffled.take(5).toList();

    _sessionChoices = _sessionQuestions.map((q) {
      final choices = [q.correctTool, ...q.distractors]..shuffle(rng);
      return choices;
    }).toList();

    _currentIndex = 0;
    _selectedChoiceIndex = null;
    _score = 0;
    _answered = false;
    _sessionCorrectScenarios.clear();
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
    final isCorrect =
        choices[_selectedChoiceIndex!].name == currentQ.correctTool.name;

    UserStore.recordAnswer(isCorrect);
    if (isCorrect) {
      _sessionCorrectScenarios.add(currentQ.scenario);
    }

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
      final tools = Set<String>.from(user.uniqueToolsSelected)
        ..addAll(_sessionCorrectScenarios);
      final tabs = List<String>.from(user.completedLessonTabs);
      if (isPerfect && !tabs.contains('perfect_measurement')) {
        tabs.add('perfect_measurement');
      }
      return user.copyWith(
        xpEarned: user.xpEarned + xpEarned,
        practiceCompleted: user.practiceCompleted + 1,
        uniqueToolsSelected: tools.toList(),
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
            // ── Top Header (Standard SukaTech Practice header) ──────────────
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
                                  'Choose the Right Tool',
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Scenario / Question Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 18,
                      ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _navy.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'SCENARIO',
                              style: TextStyle(
                                color: _navy,
                                fontSize: 11,
                                fontFamily: _montserrat,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            currentQ.scenario,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: _navy,
                              fontSize: 16,
                              fontFamily: _montserrat,
                              fontWeight: FontWeight.w700,
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ── 2x2 Tool Cards Grid ────────────────────────────────
                    Row(
                      children: [
                        Expanded(child: _buildToolCard(0, choices[0])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildToolCard(1, choices[1])),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildToolCard(2, choices[2])),
                        const SizedBox(width: 12),
                        Expanded(child: _buildToolCard(3, choices[3])),
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
                          'Submit',
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

  Widget _buildToolCard(int index, ToolChoice choice) {
    final currentQ = _sessionQuestions[_currentIndex];
    final isSelected = _selectedChoiceIndex == index;
    final isCorrect = choice.name == currentQ.correctTool.name;

    Color bgColor = Colors.white;
    Color borderColor = const Color(0xFFDDE0E8);
    Color textColor = _navy;
    Widget? badge;

    if (isSelected && !_answered) {
      bgColor = _navy.withValues(alpha: 0.05);
      borderColor = _navy;
      textColor = _navy;
    } else if (_answered) {
      if (isCorrect) {
        bgColor = _green.withValues(alpha: 0.10);
        borderColor = _green;
        textColor = _green;
        badge = Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: _green,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.check, size: 14, color: Colors.white),
        );
      } else if (isSelected) {
        bgColor = _red.withValues(alpha: 0.10);
        borderColor = _red;
        textColor = _red;
        badge = Container(
          padding: const EdgeInsets.all(2),
          decoration: const BoxDecoration(
            color: _red,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.close, size: 14, color: Colors.white),
        );
      } else {
        textColor = _navy.withValues(alpha: 0.4);
      }
    }

    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _answered ? null : () => _onSelectChoice(index),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 152,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: borderColor,
              width: (isSelected || (_answered && isCorrect)) ? 2.0 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: badge,
                ),
              Positioned.fill(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Center(
                        child: Image.asset(
                          choice.imageAsset,
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        choice.name,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textColor,
                          fontSize: 13.5,
                          fontFamily: _montserrat,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
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
    );
  }

  Widget _buildFeedbackPanel(ToolQuestion currentQ, List<ToolChoice> choices) {
    final isCorrect =
        choices[_selectedChoiceIndex!].name == currentQ.correctTool.name;
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
