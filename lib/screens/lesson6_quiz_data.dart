part of 'lesson6_quiz_screen.dart';

enum _QType {
  concept,
  fractions,
  perimeter,
  boardFeet,
  application,
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
  // CONCEPTS
  _QMultipleChoice(
    type: _QType.concept,
    prompt: 'What does the term "Board Foot" measure?',
    choices: [
      'The length of a board',
      'The volume of lumber',
      'The weight of a board',
      'The width of a board'
    ],
    correctIndex: 1,
    explanation: 'A board foot is a unit of volume for lumber, representing a piece 1 inch thick, 12 inches wide, and 1 foot long.',
  ),
  _QMultipleChoice(
    type: _QType.concept,
    prompt: 'Why is it important to find a common denominator when adding or subtracting fractions?',
    choices: [
      'To make the numbers smaller',
      'To ensure you are adding equal parts of a whole',
      'Because it is a rule in metric conversions',
      'To convert inches to centimeters'
    ],
    correctIndex: 1,
    explanation: 'A common denominator ensures that you are adding or subtracting parts that are the same size.',
  ),
  
  // FRACTIONS
  _QMultipleChoice(
    type: _QType.fractions,
    prompt: 'Add the following measurements: 1/4 inch + 3/8 inch.',
    choices: ['4/12 inch', '5/8 inch', '1/2 inch', '7/8 inch'],
    correctIndex: 1,
    explanation: 'Convert 1/4 to 2/8. Then, 2/8 + 3/8 = 5/8 inch.',
  ),
  _QMultipleChoice(
    type: _QType.fractions,
    prompt: 'Subtract 1/4 inch from 3/4 inch.',
    choices: ['1/4 inch', '1/2 inch', '3/8 inch', '1 inch'],
    correctIndex: 1,
    explanation: '3/4 - 1/4 = 2/4. Simplified, 2/4 is equal to 1/2 inch.',
  ),
  
  // PERIMETER
  _QMultipleChoice(
    type: _QType.perimeter,
    prompt: 'Calculate the perimeter of a rectangular board that is 2 feet wide and 4 feet long.',
    choices: ['6 feet', '8 feet', '12 feet', '16 feet'],
    correctIndex: 2,
    explanation: 'Perimeter = 2 * (Width + Length). 2 * (2 + 4) = 12 feet.',
  ),
  _QMultipleChoice(
    type: _QType.perimeter,
    prompt: 'What is the perimeter of a square wooden tile with a side length of 6 inches?',
    choices: ['12 inches', '18 inches', '24 inches', '36 inches'],
    correctIndex: 2,
    explanation: 'A square has 4 equal sides. Perimeter = 4 * 6 inches = 24 inches.',
  ),
  
  // BOARD FEET
  _QMultipleChoice(
    type: _QType.boardFeet,
    prompt: 'Calculate the board feet for a piece of lumber: 1 inch thick, 6 inches wide, and 12 feet long. (Formula: T" x W" x L\' / 12)',
    choices: ['3 board feet', '6 board feet', '12 board feet', '72 board feet'],
    correctIndex: 1,
    explanation: '(1 * 6 * 12) / 12 = 6 board feet.',
  ),
  _QMultipleChoice(
    type: _QType.boardFeet,
    prompt: 'Calculate the board feet for a piece of lumber: 2 inches thick, 4 inches wide, and 8 feet long.',
    choices: ['2 board feet', '5.33 board feet', '8 board feet', '10.66 board feet'],
    correctIndex: 1,
    explanation: '(2 * 4 * 8) / 12 = 64 / 12 = 5.33 board feet.',
  ),
  
  // APPLICATION
  _QMultipleChoice(
    type: _QType.application,
    prompt: 'You have a board that is 10 1/2 inches long. You cut off a piece that is 3 1/4 inches long. How much board is left?',
    choices: ['7 1/4 inches', '6 1/2 inches', '7 3/4 inches', '7 inches'],
    correctIndex: 0,
    explanation: '10 1/2 (or 10 2/4) - 3 1/4 = 7 1/4 inches.',
  ),
  _QMultipleChoice(
    type: _QType.application,
    prompt: 'If you place three boards side-by-side, each measuring 5 1/8 inches wide, what is the total width?',
    choices: ['15 1/8 inches', '15 3/8 inches', '15.5 inches', '10 1/4 inches'],
    correctIndex: 1,
    explanation: '5 1/8 + 5 1/8 + 5 1/8 = 15 3/8 inches.',
  ),
];

const _sessionOrder = [
  _QType.concept,
  _QType.fractions,
  _QType.perimeter,
  _QType.boardFeet,
  _QType.application,
  _QType.concept,
  _QType.fractions,
  _QType.perimeter,
  _QType.boardFeet,
  _QType.application,
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
