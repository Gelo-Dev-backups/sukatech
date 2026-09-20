part of 'lesson2_quiz_screen.dart';

enum _QType {
  connectTool,
  dragToTask,
  toolId,
  safetySort,
  scenarioChoice,
  mainUseMatch,
  workstationConnect,
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

class _QConnectPairs extends _Q {
  _QConnectPairs({
    required super.type,
    required this.pairs,
    required this.prompt,
  });
  // Map of Left (e.g. Tool) -> Right (e.g. Function)
  final Map<String, String> pairs;
  final String prompt;
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
  // Category Name -> List of Tools
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
  // 1. CONNECT THE TOOL
  _QConnectPairs(
    type: _QType.connectTool,
    prompt: 'Connect each tool to its function.',
    pairs: {
      'Tape Measure': 'Measures long distances',
      'Steel Rule': 'Measures short distances',
      'Try Square': 'Checks 90° angles',
      'Straight Edge': 'Checks straightness',
      'Vernier Caliper': 'Accurate small measurements',
      'Folding Rule': 'Measures length and folds for storage',
    },
  ),

  // 2. DRAG AND DROP TOOL TO TASK
  _QDragToTask(
    type: _QType.dragToTask,
    task: 'Measure the length of a large wooden board.',
    correctTool: 'Tape Measure',
    toolChoices: ['Tape Measure', 'Try Square', 'Straight Edge', 'Vernier Caliper'],
    explanation: 'A tape measure is used for long measurements.',
  ),
  _QDragToTask(
    type: _QType.dragToTask,
    task: 'Check whether the corner of this piece of wood is 90°.',
    correctTool: 'Try Square',
    toolChoices: ['Tape Measure', 'Steel Rule', 'Try Square', 'Folding Rule'],
    explanation: 'A try square is designed specifically to check and mark 90° angles.',
  ),
  _QDragToTask(
    type: _QType.dragToTask,
    task: 'Check whether this board edge is straight.',
    correctTool: 'Straight Edge',
    toolChoices: ['Straight Edge', 'Try Square', 'Vernier Caliper', 'Tape Measure'],
    explanation: 'A straight edge is used to check if an edge or surface is straight.',
  ),
  _QDragToTask(
    type: _QType.dragToTask,
    task: 'Measure the thickness of a small material accurately.',
    correctTool: 'Vernier Caliper',
    toolChoices: ['Steel Rule', 'Vernier Caliper', 'Tape Measure', 'Folding Rule'],
    explanation: 'A vernier caliper provides precise measurements for small objects.',
  ),
  _QDragToTask(
    type: _QType.dragToTask,
    task: 'Measure a short length using a rigid metal measuring tool.',
    correctTool: 'Steel Rule',
    toolChoices: ['Straight Edge', 'Steel Rule', 'Vernier Caliper', 'Try Square'],
    explanation: 'A steel rule is a rigid metal tool used to measure short distances.',
  ),
  _QDragToTask(
    type: _QType.dragToTask,
    task: 'Measure a length using a rule that folds into sections.',
    correctTool: 'Folding Rule',
    toolChoices: ['Tape Measure', 'Steel Rule', 'Folding Rule', 'Straight Edge'],
    explanation: 'A folding rule has sections that fold together for storage.',
  ),

  // 3. TOOL IDENTIFICATION
  _QMultipleChoice(
    type: _QType.toolId,
    prompt: 'Which tool is this?',
    visualKey: 'tape_measure',
    choices: ['Tape Measure', 'Steel Rule', 'Try Square', 'Straight Edge'],
    correctIndex: 0,
    explanation: 'This is a Tape Measure. Main use: Long measurements.',
  ),
  _QMultipleChoice(
    type: _QType.toolId,
    prompt: 'Which tool is this?',
    visualKey: 'steel_rule',
    choices: ['Vernier Caliper', 'Straight Edge', 'Steel Rule', 'Folding Rule'],
    correctIndex: 2,
    explanation: 'This is a Steel Rule. Main use: Short measurements.',
  ),
  _QMultipleChoice(
    type: _QType.toolId,
    prompt: 'Which tool is this?',
    visualKey: 'try_square',
    choices: ['Straight Edge', 'Try Square', 'Tape Measure', 'Steel Rule'],
    correctIndex: 1,
    explanation: 'This is a Try Square. Main use: 90° Angle.',
  ),
  _QMultipleChoice(
    type: _QType.toolId,
    prompt: 'Which tool is this?',
    visualKey: 'vernier_caliper',
    choices: ['Folding Rule', 'Tape Measure', 'Vernier Caliper', 'Try Square'],
    correctIndex: 2,
    explanation: 'This is a Vernier Caliper. Main use: Accurate small measurements.',
  ),

  // 4. SAFETY CHALLENGE (Sorting)
  _QSafetySort(
    type: _QType.safetySort,
    items: {
      'Let the tape snap back quickly.': false,
      'Keep fingers away from the metal edge.': true,
      'Use a damaged tape measure.': false,
      'Store the tape measure properly.': true,
    },
  ),
  _QSafetySort(
    type: _QType.safetySort,
    items: {
      'Handle the edges carefully.': true,
      'Use the steel rule as a cutting tool.': false,
      'Keep it clean.': true,
      'Bend the steel rule.': false,
    },
  ),
  _QSafetySort(
    type: _QType.safetySort,
    items: {
      'Use the try square as a hammer.': false,
      'Keep it clean.': true,
      'Drop the try square.': false,
      'Store it properly.': true,
    },
  ),
  _QSafetySort(
    type: _QType.safetySort,
    items: {
      'Force the jaws of the caliper.': false,
      'Use it on moving objects.': false,
      'Keep it clean.': true,
      'Store it carefully.': true,
    },
  ),
  _QSafetySort(
    type: _QType.safetySort,
    items: {
      'Keep fingers away from the folding joints.': true,
      'Force the rule to fold.': false,
      'Fold and store it properly.': true,
      'Ignore the folding joints.': false,
    },
  ),

  // 5. WHAT TOOL WOULD YOU CHOOSE?
  _QMultipleChoice(
    type: _QType.scenarioChoice,
    prompt: 'You need to measure the length of a large wooden board. Which tool would you choose?',
    choices: ['Try Square', 'Tape Measure', 'Vernier Caliper', 'Straight Edge'],
    correctIndex: 1,
    explanation: 'A Tape Measure is the best tool for measuring long distances and large objects.',
  ),
  _QMultipleChoice(
    type: _QType.scenarioChoice,
    prompt: 'You need to check whether a corner is exactly 90°. Which tool would you choose?',
    choices: ['Straight Edge', 'Folding Rule', 'Try Square', 'Steel Rule'],
    correctIndex: 2,
    explanation: 'A Try Square is specifically designed to check and mark 90° angles.',
  ),
  _QMultipleChoice(
    type: _QType.scenarioChoice,
    prompt: 'You need to check if a board is straight. Which tool would you choose?',
    choices: ['Tape Measure', 'Vernier Caliper', 'Try Square', 'Straight Edge'],
    correctIndex: 3,
    explanation: 'A Straight Edge is used to check if an edge or surface is perfectly straight.',
  ),
  _QMultipleChoice(
    type: _QType.scenarioChoice,
    prompt: 'You need to accurately measure the thickness of a small object. Which tool would you choose?',
    choices: ['Vernier Caliper', 'Steel Rule', 'Tape Measure', 'Straight Edge'],
    correctIndex: 0,
    explanation: 'A Vernier Caliper provides the most accurate measurement for small objects and thickness.',
  ),
  _QMultipleChoice(
    type: _QType.scenarioChoice,
    prompt: 'You need to measure a short distance with a rigid metal tool. Which tool would you choose?',
    choices: ['Folding Rule', 'Tape Measure', 'Steel Rule', 'Vernier Caliper'],
    correctIndex: 2,
    explanation: 'A Steel Rule is a rigid metal tool used to measure short distances.',
  ),
  _QMultipleChoice(
    type: _QType.scenarioChoice,
    prompt: 'You need a measuring rule that can fold into sections. Which tool would you choose?',
    choices: ['Steel Rule', 'Folding Rule', 'Tape Measure', 'Try Square'],
    correctIndex: 1,
    explanation: 'A Folding Rule has sections that fold together for easy storage and measuring.',
  ),

  // 6. MAIN USE MATCH
  _QConnectPairs(
    type: _QType.mainUseMatch,
    prompt: 'Match each tool to its MAIN use.',
    pairs: {
      'Tape Measure': 'Long Measurements',
      'Steel Rule': 'Short Measurements',
      'Try Square': '90° Angle',
      'Straight Edge': 'Checks Straightness',
      'Vernier Caliper': 'Accurate Small Measurements',
      'Folding Rule': 'Foldable Measuring',
    },
  ),

  // 7. TOOL FUNCTION CONNECT-THE-DOTS (Workstation)
  _QConnectPairs(
    type: _QType.workstationConnect,
    prompt: 'Connect the tool to the appropriate workstation task.',
    pairs: {
      'Tape Measure': 'Long board',
      'Try Square': '90° corner',
      'Straight Edge': 'Straight board',
      'Vernier Caliper': 'Small diameter / inside hole',
      'Steel Rule': 'Small wood piece',
      'Folding Rule': 'Foldable measuring task',
    },
  ),

  // 8. SAFETY SCENARIO
  _QMultipleChoice(
    type: _QType.safetyScenario,
    prompt: 'A student is using a tape measure and allows the metal tape to snap back quickly. What should the student do?',
    choices: [
      'Let it snap back faster',
      'Control the tape and prevent it from snapping back quickly',
      'Throw the tape away',
      'Use the tape while damaged'
    ],
    correctIndex: 1,
    explanation: 'The tape should not be allowed to snap back quickly, as it can cause injury or damage the tool.',
  ),
  _QMultipleChoice(
    type: _QType.safetyScenario,
    prompt: 'A student is using a Vernier Caliper. What should the student avoid doing?',
    choices: [
      'Keeping it clean',
      'Storing it carefully',
      'Forcing the jaws',
      'Using it for small measurements'
    ],
    correctIndex: 2,
    explanation: 'Forcing the jaws can damage the precision mechanism of the Vernier Caliper.',
  ),
  _QMultipleChoice(
    type: _QType.safetyScenario,
    prompt: 'A student is using a Folding Rule. What should the student be careful of?',
    choices: [
      'Keeping the rule flat',
      'The folding joints and fingers near the joints',
      'Measuring long distances',
      'Storing it in a toolbox'
    ],
    correctIndex: 1,
    explanation: 'Be careful with the folding joints to avoid pinching fingers or breaking the rule.',
  ),

  // 9. TOOL SORTING
  _QCategorySort(
    type: _QType.toolSort,
    categories: {
      'MEASURES LENGTH': ['Tape Measure', 'Steel Rule', 'Folding Rule'],
      'CHECKS / MARKS': ['Try Square', 'Straight Edge'],
      'ACCURATE SMALL MEASUREMENTS': ['Vernier Caliper'],
    },
  ),

  // 10. FINAL CARPENTER CHALLENGE
  _QFinalSequence(
    type: _QType.finalChallenge,
    steps: [
      (prompt: 'The board is long. Which tool should you use to measure it?', correctTool: 'Tape Measure'),
      (prompt: 'You want to check if the corner is 90°.', correctTool: 'Try Square'),
      (prompt: 'You want to check if the board edge is straight.', correctTool: 'Straight Edge'),
      (prompt: 'You need to accurately measure a small thickness.', correctTool: 'Vernier Caliper'),
      (prompt: 'You need a rule that folds for storage.', correctTool: 'Folding Rule'),
    ],
    toolChoices: ['Tape Measure', 'Steel Rule', 'Try Square', 'Straight Edge', 'Vernier Caliper', 'Folding Rule'],
  ),
];

const _sessionOrder = [
  _QType.connectTool,
  _QType.dragToTask,
  _QType.toolId,
  _QType.safetySort,
  _QType.scenarioChoice,
  _QType.mainUseMatch,
  _QType.workstationConnect,
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
