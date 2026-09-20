part of 'lesson3_quiz_screen.dart';

enum _QType {
  dragToTask,
  toolId,
  safetySort,
  scenarioChoice,

  safetyScenario,
  toolSort,
  finalChallenge,
}

abstract class _Q {
  _Q({required this.type});
  final _QType type;
}

class _QMultipleChoice extends _Q {
  _QMultipleChoice({
    required super.type,
    required this.prompt,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    this.visualKey,
  });
  final String prompt;
  final List<String> choices;
  final int correctIndex;
  final String explanation;
  final String? visualKey;
}



class _QDragToTask extends _Q {
  _QDragToTask({
    required super.type,
    required this.task,
    required this.correctTool,
    required this.toolChoices,
    required this.explanation,
  });
  final String task;
  final String correctTool;
  final List<String> toolChoices;
  final String explanation;
}

class _QSafetySort extends _Q {
  _QSafetySort({
    required super.type,
    required this.items,
  });
  // Item text -> true if safe, false if unsafe
  final Map<String, bool> items;
}

class _QCategorySort extends _Q {
  _QCategorySort({
    required super.type,
    required this.categories,
  });
  // Category Name -> List of Parts
  final Map<String, List<String>> categories;
}

class _QFinalSequence extends _Q {
  _QFinalSequence({
    required super.type,
    required this.steps,
    required this.toolChoices,
  });
  // List of step prompts, correct tool for each step
  final List<({String prompt, String correctTool})> steps;
  final List<String> toolChoices;
}

// ---------------------------------------------------------
// DATA POOL
// ---------------------------------------------------------

final _pool = <_Q>[
  // 2. DRAG AND DROP TOOL TO TASK
  _QDragToTask(
    type: _QType.dragToTask,
    task: 'Provides a firm reference surface when checking a 90° angle.',
    correctTool: 'Stock',
    toolChoices: ['Blade (Square)', 'Stock', 'Rivets'],
    explanation: 'The stock of the Try Square supports the blade and provides a reference surface.',
  ),
  
  // 3. IDENTIFICATION (Multiple Choice with Text)
  _QMultipleChoice(
    type: _QType.toolId,
    prompt: 'Which part of the Vernier Caliper is used to measure the depth of holes, slots, and recessed areas?',
    choices: ['Outside Jaws', 'Inside Jaws', 'Vernier Scale', 'Depth Rod'],
    correctIndex: 3,
    explanation: 'The Depth Rod extends from the end of the caliper to measure depths.',
  ),
  
  // 4. SORTING CHALLENGE (True/False or Categorizing) -> Let's use it as a true/false for statements
  _QSafetySort(
    type: _QType.safetySort,
    items: {
      'The Vernier Scale slides along the main scale.': true,
      'The Try Square stock checks the straightness of an edge.': false,
      'The Steel Rule edge is used as a reference for straight lines.': true,
      'The Tape Measure hook retracts the blade.': false,
    },
  ),
  
  // 5. SCENARIO CHOICE
  _QMultipleChoice(
    type: _QType.scenarioChoice,
    prompt: 'You need to measure the inside diameter of a pipe. Which part of the Vernier Caliper should you use?',
    choices: ['Main Scale', 'Outside Jaws', 'Inside Jaws', 'Depth Rod'],
    correctIndex: 2,
    explanation: 'The Inside Jaws are the smaller jaws located at the top of the Vernier Caliper, used for measuring inside diameters.',
  ),



  // 8. SCENARIO
  _QMultipleChoice(
    type: _QType.safetyScenario,
    prompt: 'Why is it important to use the lock button on a tape measure?',
    choices: [
      'To make the blade retract faster',
      'To prevent the blade from moving while reading the measurement',
      'To switch between inches and centimeters',
      'To protect the hook from breaking'
    ],
    correctIndex: 1,
    explanation: 'The lock button holds the blade in position and prevents it from moving while measuring.',
  ),

  // 9. TOOL SORTING (Categorizing parts to their tools)
  _QCategorySort(
    type: _QType.toolSort,
    categories: {
      'TAPE MEASURE': ['Hook', 'Lock Button', 'Housing'],
      'VERNIER CALIPER': ['Inside Jaws', 'Depth Rod', 'Vernier Scale'],
      'TRY SQUARE': ['Stock', 'Rivets'],
    },
  ),

  // NEW QUESTIONS TO REACH 10
  _QMultipleChoice(
    type: _QType.toolId,
    prompt: 'Which part of the Try Square connects the stock and the blade?',
    choices: ['Rivets', 'Vernier Scale', 'Lock Button', 'Housing'],
    correctIndex: 0,
    explanation: 'Rivets secure the blade tightly to the stock of the Try Square.',
  ),
  _QMultipleChoice(
    type: _QType.scenarioChoice,
    prompt: 'You need to lock the Vernier Caliper in place to read the measurement carefully. Which part should you use?',
    choices: ['Main Scale', 'Vernier Scale', 'Lock Screw', 'Depth Rod'],
    correctIndex: 2,
    explanation: 'The Lock Screw secures the jaws in position to prevent movement while reading.',
  ),
  _QMultipleChoice(
    type: _QType.safetyScenario,
    prompt: 'When using a Try Square, why is it important to handle it gently?',
    choices: [
      'So the metal doesn\'t get too warm',
      'To prevent the rivets from loosening and losing the 90° angle',
      'Because it looks better when clean',
      'To make it slide easier on wood'
    ],
    correctIndex: 1,
    explanation: 'Dropping or mishandling a Try Square can loosen the rivets, making it inaccurate.',
  ),

  // 10. FINAL CHALLENGE
  _QFinalSequence(
    type: _QType.finalChallenge,
    steps: [
      (prompt: 'Which part of the Steel Rule indicates the measurement in units?', correctTool: 'Graduation'),
    ],
    toolChoices: ['Edge', 'Graduation', 'Stock', 'Blade'],
  ),
];

const _sessionOrder = [
  _QType.dragToTask,
  _QType.toolId,
  _QType.safetySort,
  _QType.scenarioChoice,
  _QType.toolId,
  _QType.safetyScenario,
  _QType.scenarioChoice,
  _QType.safetyScenario,
  _QType.toolSort,
  _QType.finalChallenge,
];

List<_Q> _buildSession(Random rng) {
  final byType = <_QType, List<_Q>>{};
  for (final q in _pool) {
    byType.putIfAbsent(q.type, () => []).add(q);
  }
  for (final list in byType.values) {
    list.shuffle(rng);
  }
  final counters = <_QType, int>{};
  final result = <_Q>[];
  for (final type in _sessionOrder) {
    final list = byType[type] ?? [];
    final idx = counters[type] ?? 0;
    if (idx < list.length) {
      result.add(list[idx]);
      counters[type] = idx + 1;
    }
  }
  result.shuffle(rng); return result;
}
