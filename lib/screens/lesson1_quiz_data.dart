part of 'lesson1_quiz_screen.dart';

enum _QType {
  identifyDimension,
  multipleChoice,
  metricVsEnglish,
  whatIsMeasured,
  carpenterDecision,
}

class _Q {
  const _Q({
    required this.type,
    required this.prompt,
    required this.choices,
    required this.correctIndex,
    required this.explanation,
    this.blankWord,
    this.dimensionKey,
  });

  final _QType type;
  final String prompt;
  final List<String> choices;
  final int correctIndex;
  final String explanation;
  final String? blankWord;
  final String? dimensionKey;
}

class _RawQ {
  const _RawQ({
    required this.type,
    required this.prompt,
    required this.choices,
    required this.explanation,
    this.blankWord,
    this.dimensionKey,
  });

  final _QType type;
  final String prompt;
  final List<String> choices; // choices[0] = correct
  final String explanation;
  final String? blankWord;
  final String? dimensionKey;

  _Q shuffle(Random rng) {
    if (choices.isEmpty) {
      return _Q(
        type: type,
        prompt: prompt,
        choices: const [],
        correctIndex: 0,
        explanation: explanation,
        blankWord: blankWord,
        dimensionKey: dimensionKey,
      );
    }
    final s = List<String>.from(choices)..shuffle(rng);
    return _Q(
      type: type,
      prompt: prompt,
      choices: s,
      correctIndex: s.indexOf(choices[0]),
      explanation: explanation,
      blankWord: blankWord,
      dimensionKey: dimensionKey,
    );
  }
}

const _pool = <_RawQ>[
  // IDENTIFY DIMENSION
  _RawQ(
    type: _QType.identifyDimension,
    prompt: 'The carpenter measures the board from END to END along its longest direction. What dimension is this?',
    choices: ['Length', 'Width', 'Thickness', 'Height'],
    explanation: 'Length is the distance from one end of an object to the other — the longest dimension.',
    dimensionKey: 'length',
  ),
  _RawQ(
    type: _QType.identifyDimension,
    prompt: 'The carpenter measures the board from SIDE to SIDE (across its face). What dimension is this?',
    choices: ['Width', 'Length', 'Height', 'Thickness'],
    explanation: 'Width is the side-to-side measurement across the face of a board.',
    dimensionKey: 'width',
  ),
  _RawQ(
    type: _QType.identifyDimension,
    prompt: 'The carpenter measures HOW DEEP the board is from its front face to its back face. What dimension is this?',
    choices: ['Thickness', 'Width', 'Length', 'Height'],
    explanation: 'Thickness is how deep or thick the material is — front surface to back surface.',
    dimensionKey: 'thickness',
  ),
  _RawQ(
    type: _QType.identifyDimension,
    prompt: 'The carpenter measures from the BOTTOM of the cabinet to the TOP. What dimension is this?',
    choices: ['Height', 'Width', 'Length', 'Thickness'],
    explanation: 'Height is the measurement from the bottom to the top of an object.',
    dimensionKey: 'height',
  ),
  _RawQ(
    type: _QType.identifyDimension,
    prompt: 'The board is placed flat. The arrow points along its longest side. What dimension does it show?',
    choices: ['Length', 'Thickness', 'Width', 'Height'],
    explanation: 'Length is the longest dimension, measured end to end along a board.',
    dimensionKey: 'length',
  ),

  // FILL IN THE BLANK
  _RawQ(
    type: _QType.multipleChoice,
    prompt: 'A wooden board is 25 ___ thick.\n(Hint: Use a small metric unit for thickness.)',
    choices: ['mm', 'cm', 'm', 'ft'],
    explanation: 'Millimeters (mm) are ideal for small dimensions such as material thickness.',
    blankWord: 'mm',
  ),
  _RawQ(
    type: _QType.multipleChoice,
    prompt: 'A wooden plank is 2 ___ long.\n(Hint: Use a large metric unit for length.)',
    choices: ['m', 'mm', 'cm', 'in'],
    explanation: 'Meters (m) are used for larger measurements like the full length of a long board.',
    blankWord: 'm',
  ),
  _RawQ(
    type: _QType.multipleChoice,
    prompt: 'A board has a width of 20 ___.\n(Hint: Use a medium metric unit for width.)',
    choices: ['cm', 'mm', 'm', 'ft'],
    explanation: 'Centimeters (cm) are used for moderate measurements like board widths.',
    blankWord: 'cm',
  ),
  _RawQ(
    type: _QType.multipleChoice,
    prompt: 'A piece of wood is 12 ___ long.\n(Hint: Use an English unit for shorter measurements.)',
    choices: ['in', 'mm', 'cm', 'm'],
    explanation: 'Inches (in) are used in the English system for shorter measurements.',
    blankWord: 'in',
  ),
  _RawQ(
    type: _QType.multipleChoice,
    prompt: 'A board is 6 ___ long.\n(Hint: Use an English unit for longer boards.)',
    choices: ['ft', 'mm', 'cm', 'm'],
    explanation: 'Feet (ft) are used in the English system for longer boards.',
    blankWord: 'ft',
  ),
  _RawQ(
    type: _QType.multipleChoice,
    prompt: 'A nail is 50 ___ long.\n(Hint: Use the smallest metric unit for hardware.)',
    choices: ['mm', 'cm', 'm', 'ft'],
    explanation: 'Millimeters (mm) are best for small objects like nails and screws.',
    blankWord: 'mm',
  ),

  // METRIC VS ENGLISH
  _RawQ(
    type: _QType.metricVsEnglish,
    prompt: 'Sort these units into the correct measurement system.',
    choices: [],
    explanation: 'Metric/SI: mm, cm, m — used worldwide.\nEnglish: in, ft — common in carpentry in some countries.',
  ),

  // WHAT IS BEING MEASURED?
  _RawQ(
    type: _QType.whatIsMeasured,
    prompt: 'You want to know how far the board stretches from one end to the other.',
    choices: ['Length', 'Width', 'Height', 'Thickness'],
    explanation: 'Length measures how far an object extends from end to end.',
  ),
  _RawQ(
    type: _QType.whatIsMeasured,
    prompt: 'You want to know how far the board stretches from one side to the other (across its face).',
    choices: ['Width', 'Length', 'Height', 'Thickness'],
    explanation: 'Width is the side-to-side measurement across the face of an object.',
  ),
  _RawQ(
    type: _QType.whatIsMeasured,
    prompt: 'You want to know how tall the cabinet stands from the floor to its top.',
    choices: ['Height', 'Width', 'Length', 'Thickness'],
    explanation: 'Height measures how tall something is from bottom to top.',
  ),
  _RawQ(
    type: _QType.whatIsMeasured,
    prompt: 'You want to know how thick the wooden board is.',
    choices: ['Thickness', 'Height', 'Width', 'Length'],
    explanation: 'Thickness tells you how deep or thick the material is.',
  ),

  // CARPENTER DECISION
  _RawQ(
    type: _QType.carpenterDecision,
    prompt: 'A carpenter needs a board exactly 2 meters long. What MUST he do before cutting?',
    choices: [
      'Measure the board accurately',
      'Cut immediately without measuring',
      'Guess the length by eye',
      'Ignore the measurement requirement',
    ],
    explanation: '"Measure twice, cut once." Always measure accurately before cutting to avoid waste.',
  ),
  _RawQ(
    type: _QType.carpenterDecision,
    prompt: 'A carpenter used a wrong measurement. What is the likely outcome?',
    choices: [
      'Material may be wasted',
      'The project will improve automatically',
      'The board will always fit',
      'Nothing bad will happen',
    ],
    explanation: 'Incorrect measurements lead to wasted material and extra cost.',
  ),
  _RawQ(
    type: _QType.carpenterDecision,
    prompt: 'Which habit should every carpenter follow before cutting any material?',
    choices: [
      'Measure before cutting',
      'Cut first, measure after',
      'Skip measuring to save time',
      'Estimate the size from memory',
    ],
    explanation: 'A good carpenter always measures before cutting — this prevents costly mistakes.',
  ),
  _RawQ(
    type: _QType.carpenterDecision,
    prompt: 'Carpenter A measures carefully. Carpenter B guesses. Who gets a better result?',
    choices: [
      'Carpenter A who measured carefully',
      'Carpenter B who guessed',
      'Both get the same result',
      'Neither will succeed',
    ],
    explanation: 'Careful measurement always leads to a better, more accurate final product.',
  ),
];

const _sessionOrder = [
  _QType.identifyDimension,
  _QType.multipleChoice,
  _QType.metricVsEnglish,
  _QType.identifyDimension,
  _QType.multipleChoice,
  _QType.carpenterDecision,
  _QType.multipleChoice,
  _QType.whatIsMeasured,
  _QType.identifyDimension,
  _QType.carpenterDecision,
];

List<_Q> _buildSession(Random rng) {
  final byType = <_QType, List<_RawQ>>{};
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
      result.add(list[idx].shuffle(rng));
      counters[type] = idx + 1;
    }
  }
  result.shuffle(rng); return result;
}

const _metricUnits = {'mm', 'cm', 'm'};
const _englishUnits = {'in', 'ft'};
const _allUnits = ['mm', 'cm', 'm', 'in', 'ft'];

class _SortState {
  _SortState() : assignments = {for (final u in _allUnits) u: null};
  final Map<String, String?> assignments;
  bool get isComplete => assignments.values.every((v) => v != null);
  bool get isAllCorrect {
    for (final e in assignments.entries) {
      final correct = _metricUnits.contains(e.key) ? 'metric' : 'english';
      if (e.value != correct) return false;
    }
    return true;
  }
  List<String> get unassigned =>
      _allUnits.where((u) => assignments[u] == null).toList();
  List<String> groupUnits(String group) =>
      _allUnits.where((u) => assignments[u] == group).toList();
}
