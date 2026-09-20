part of 'lesson4_quiz_screen.dart';

enum _QType {
  englishScale,
  metricScale,
  vernierCaliper,
  trySquare,
  generalReading,
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

// ---------------------------------------------------------
// DATA POOL
// ---------------------------------------------------------

final _pool = <_Q>[
  // ENGLISH SCALE
  _QMultipleChoice(
    type: _QType.englishScale,
    prompt: 'What does the longest graduation mark on an English tape measure represent?',
    choices: ['1/2 inch', '1 inch', '1/4 inch', '1/8 inch'],
    correctIndex: 1,
    explanation: 'The longest mark denotes full inches.',
  ),
  _QMultipleChoice(
    type: _QType.englishScale,
    prompt: 'What does the shortest graduation mark on a standard English tape measure represent?',
    choices: ['1/16 inch', '1/8 inch', '1/4 inch', '1/32 inch'],
    correctIndex: 0,
    explanation: 'The shortest marks on standard tape measures are 1/16 of an inch.',
  ),
  
  // METRIC SCALE
  _QMultipleChoice(
    type: _QType.metricScale,
    prompt: 'How many millimeters are in one centimeter?',
    choices: ['100', '10', '1000', '1'],
    correctIndex: 1,
    explanation: 'There are 10 millimeters in a centimeter. The 10 small marks equal 1 cm.',
  ),
  _QMultipleChoice(
    type: _QType.metricScale,
    prompt: 'When reading a steel rule, what do the smallest graduations usually represent in the metric system?',
    choices: ['Centimeters', 'Meters', 'Millimeters', 'Inches'],
    correctIndex: 2,
    explanation: 'The smallest marks on a metric steel rule represent millimeters.',
  ),
  
  // VERNIER CALIPER
  _QMultipleChoice(
    type: _QType.vernierCaliper,
    prompt: 'How do you properly calculate the final reading on a Vernier Caliper?',
    choices: [
      'Multiply the main scale by the vernier scale',
      'Add the main scale reading to the vernier scale reading',
      'Subtract the vernier scale from the main scale',
      'Read only the vernier scale'
    ],
    correctIndex: 1,
    explanation: 'The total reading is the sum of the main scale and the coinciding mark on the vernier scale.',
  ),
  _QMultipleChoice(
    type: _QType.vernierCaliper,
    prompt: 'Which tool provides the most accurate reading for small thicknesses?',
    choices: ['Steel Rule', 'Tape Measure', 'Vernier Caliper', 'Try Square'],
    correctIndex: 2,
    explanation: 'A Vernier Caliper provides precision measurements for small thicknesses and diameters.',
  ),
  
  // TRY SQUARE
  _QMultipleChoice(
    type: _QType.trySquare,
    prompt: 'When measuring or marking with a try square, what are you typically checking?',
    choices: [
      'That the surface is smooth',
      'That the angle is exactly 90 degrees',
      'That the board is long enough',
      'That the thickness is uniform'
    ],
    correctIndex: 1,
    explanation: 'A try square is specifically used to check and mark exact 90-degree angles.',
  ),
  _QMultipleChoice(
    type: _QType.trySquare,
    prompt: 'How should the stock of the try square be placed against the material?',
    choices: [
      'Held slightly above the surface',
      'Pressed firmly and flush against a straight edge',
      'Balanced on the corner',
      'Tilted at a 45-degree angle'
    ],
    correctIndex: 1,
    explanation: 'The stock must be pressed firmly against a straight reference edge to ensure an accurate 90° line.',
  ),
  
  // GENERAL READING
  _QMultipleChoice(
    type: _QType.generalReading,
    prompt: 'What is the very first step in reading a measurement accurately?',
    choices: [
      'Marking the wood with a pencil',
      'Aligning the zero mark perfectly with the edge',
      'Locking the tool',
      'Guessing the length'
    ],
    correctIndex: 1,
    explanation: 'Always start by properly aligning the zero mark with the edge of the object being measured.',
  ),
  _QMultipleChoice(
    type: _QType.generalReading,
    prompt: 'If a measurement is halfway between 1 inch and 2 inches, what is the correct reading?',
    choices: ['1 1/4 inches', '1 3/4 inches', '1 1/2 inches', '1 5/8 inches'],
    correctIndex: 2,
    explanation: 'Halfway between 1 and 2 inches is exactly 1 1/2 inches.',
  ),
];

const _sessionOrder = [
  _QType.englishScale,
  _QType.metricScale,
  _QType.vernierCaliper,
  _QType.trySquare,
  _QType.generalReading,
  _QType.englishScale,
  _QType.metricScale,
  _QType.vernierCaliper,
  _QType.trySquare,
  _QType.generalReading,
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
  return result;
}
