part of 'lesson5_quiz_screen.dart';

enum _QType {
  concept,
  englishToEnglish,
  metricToMetric,
  englishToMetric,
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
    prompt: 'Why is unit conversion an important skill in carpentry?',
    choices: [
      'To make tools heavier',
      'To ensure accurate measurements when working with different plans or materials',
      'To increase the cost of materials',
      'To make the measuring tools look better'
    ],
    correctIndex: 1,
    explanation: 'Materials and plans often use different systems (Metric or English), so knowing how to convert ensures everything fits accurately.',
  ),
  _QMultipleChoice(
    type: _QType.concept,
    prompt: 'Which of the following is a primary unit of length in the English system?',
    choices: ['Meter', 'Millimeter', 'Inch', 'Centimeter'],
    correctIndex: 2,
    explanation: 'The inch is the fundamental unit of length in the English (Imperial) system.',
  ),
  
  // ENGLISH TO ENGLISH
  _QMultipleChoice(
    type: _QType.englishToEnglish,
    prompt: 'How many inches are there in 1 foot?',
    choices: ['10', '12', '14', '16'],
    correctIndex: 1,
    explanation: 'There are exactly 12 inches in 1 foot.',
  ),
  _QMultipleChoice(
    type: _QType.englishToEnglish,
    prompt: 'If a board is 2 feet long, what is its length in inches?',
    choices: ['20 inches', '22 inches', '24 inches', '26 inches'],
    correctIndex: 2,
    explanation: 'Since 1 foot = 12 inches, 2 feet is 2 x 12 = 24 inches.',
  ),
  
  // METRIC TO METRIC
  _QMultipleChoice(
    type: _QType.metricToMetric,
    prompt: 'How many millimeters (mm) are there in 1 centimeter (cm)?',
    choices: ['1', '10', '100', '1000'],
    correctIndex: 1,
    explanation: 'There are 10 millimeters in every centimeter.',
  ),
  _QMultipleChoice(
    type: _QType.metricToMetric,
    prompt: 'Convert 1.5 meters to centimeters.',
    choices: ['15 cm', '150 cm', '1500 cm', '0.15 cm'],
    correctIndex: 1,
    explanation: '1 meter = 100 centimeters. So, 1.5 meters x 100 = 150 cm.',
  ),
  
  // ENGLISH TO METRIC
  _QMultipleChoice(
    type: _QType.englishToMetric,
    prompt: 'Approximately how many centimeters are in 1 inch?',
    choices: ['2.54 cm', '1.25 cm', '5.00 cm', '10.0 cm'],
    correctIndex: 0,
    explanation: '1 inch is exactly equal to 2.54 centimeters.',
  ),
  _QMultipleChoice(
    type: _QType.englishToMetric,
    prompt: 'If a nail is 2 inches long, what is its length in millimeters?',
    choices: ['25.4 mm', '50.8 mm', '5.08 mm', '100 mm'],
    correctIndex: 1,
    explanation: '1 inch = 25.4 mm. Therefore, 2 inches x 25.4 = 50.8 mm.',
  ),
  
  // APPLICATION
  _QMultipleChoice(
    type: _QType.application,
    prompt: 'You need a piece of wood that is 30 cm long, but your tape measure only reads in inches. What measurement should you cut? (Hint: 1 inch ≈ 2.54 cm)',
    choices: ['Around 10 inches', 'Around 11.8 inches', 'Around 15 inches', 'Around 20 inches'],
    correctIndex: 1,
    explanation: '30 cm ÷ 2.54 cm/inch ≈ 11.81 inches.',
  ),
  _QMultipleChoice(
    type: _QType.application,
    prompt: 'If a project plan calls for 1/2 inch thickness, and you only have metric materials, which thickness is closest?',
    choices: ['5 mm', '10 mm', '12.7 mm', '20 mm'],
    correctIndex: 2,
    explanation: '1 inch = 25.4 mm. Half of an inch is 25.4 ÷ 2 = 12.7 mm.',
  ),
];

const _sessionOrder = [
  _QType.concept,
  _QType.englishToEnglish,
  _QType.metricToMetric,
  _QType.englishToMetric,
  _QType.application,
  _QType.concept,
  _QType.englishToEnglish,
  _QType.metricToMetric,
  _QType.englishToMetric,
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
