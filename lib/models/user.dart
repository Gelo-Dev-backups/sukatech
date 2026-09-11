import 'dart:convert';

/// The single on-device learner profile, backed by the `users` table.
class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.title,
    required this.lessonsCompleted,
    required this.quizzesTaken,
    required this.practiceCompleted,
    required this.xpEarned,
    required this.overallProgressPercent,
    required this.currentLessonTitle,
    required this.currentLessonProgressPercent,
    required this.completedLessonsList,
    required this.lessonLastTabs,
    required this.completedLessonTabs,
    required this.unlockedAchievements,
    required this.maxConsecutiveCorrectAnswers,
    required this.currentConsecutiveCorrectAnswers,
    required this.uniqueToolsSelected,
    required this.correctMetricEnglishConversions,
    required this.correctMeasurementBasics,
  });

  final int id;
  final String name;
  final String title;
  final int lessonsCompleted;
  final int quizzesTaken;
  final int practiceCompleted;
  final int xpEarned;
  final int overallProgressPercent;
  final String currentLessonTitle;
  final int currentLessonProgressPercent;
  final List<String> completedLessonsList;
  final Map<String, int> lessonLastTabs;
  final List<String> completedLessonTabs;
  final List<String> unlockedAchievements;
  final int maxConsecutiveCorrectAnswers;
  final int currentConsecutiveCorrectAnswers;
  final List<String> uniqueToolsSelected;
  final int correctMetricEnglishConversions;
  final int correctMeasurementBasics;

  factory AppUser.fromMap(Map<String, Object?> map) {
    return AppUser(
      id: map['id'] as int,
      name: map['name'] as String,
      title: map['title'] as String,
      lessonsCompleted: map['lessons_completed'] as int,
      quizzesTaken: map['quizzes_taken'] as int,
      practiceCompleted: map['practice_completed'] as int,
      xpEarned: map['xp_earned'] as int,
      overallProgressPercent: map['overall_progress_percent'] as int,
      currentLessonTitle: map['current_lesson_title'] as String,
      currentLessonProgressPercent: map['current_lesson_progress_percent'] as int,
      completedLessonsList: List<String>.from(jsonDecode(map['completed_lessons'] as String)),
      lessonLastTabs: Map<String, int>.from(jsonDecode(map['lesson_last_tabs'] as String)),
      completedLessonTabs: List<String>.from(jsonDecode(map['completed_lesson_tabs'] as String)),
      unlockedAchievements: List<String>.from(jsonDecode(map['unlocked_achievements'] as String)),
      maxConsecutiveCorrectAnswers: map['max_consecutive_correct_answers'] as int,
      currentConsecutiveCorrectAnswers: map['current_consecutive_correct_answers'] as int,
      uniqueToolsSelected: List<String>.from(jsonDecode(map['unique_tools_selected'] as String)),
      correctMetricEnglishConversions: map['correct_metric_english_conversions'] as int,
      correctMeasurementBasics: map['correct_measurement_basics'] as int,
    );
  }

  Map<String, Object?> toMap() => {
    'id': id,
    'name': name,
    'title': title,
    'lessons_completed': lessonsCompleted,
    'quizzes_taken': quizzesTaken,
    'practice_completed': practiceCompleted,
    'xp_earned': xpEarned,
    'overall_progress_percent': overallProgressPercent,
    'current_lesson_title': currentLessonTitle,
    'current_lesson_progress_percent': currentLessonProgressPercent,
    'completed_lessons': jsonEncode(completedLessonsList),
    'lesson_last_tabs': jsonEncode(lessonLastTabs),
    'completed_lesson_tabs': jsonEncode(completedLessonTabs),
    'unlocked_achievements': jsonEncode(unlockedAchievements),
    'max_consecutive_correct_answers': maxConsecutiveCorrectAnswers,
    'current_consecutive_correct_answers': currentConsecutiveCorrectAnswers,
    'unique_tools_selected': jsonEncode(uniqueToolsSelected),
    'correct_metric_english_conversions': correctMetricEnglishConversions,
    'correct_measurement_basics': correctMeasurementBasics,
  };

  AppUser copyWith({
    String? name,
    String? title,
    int? lessonsCompleted,
    int? quizzesTaken,
    int? practiceCompleted,
    int? xpEarned,
    int? overallProgressPercent,
    String? currentLessonTitle,
    int? currentLessonProgressPercent,
    List<String>? completedLessonsList,
    Map<String, int>? lessonLastTabs,
    List<String>? completedLessonTabs,
    List<String>? unlockedAchievements,
    int? maxConsecutiveCorrectAnswers,
    int? currentConsecutiveCorrectAnswers,
    List<String>? uniqueToolsSelected,
    int? correctMetricEnglishConversions,
    int? correctMeasurementBasics,
  }) {
    return AppUser(
      id: id,
      name: name ?? this.name,
      title: title ?? this.title,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      quizzesTaken: quizzesTaken ?? this.quizzesTaken,
      practiceCompleted: practiceCompleted ?? this.practiceCompleted,
      xpEarned: xpEarned ?? this.xpEarned,
      overallProgressPercent: overallProgressPercent ?? this.overallProgressPercent,
      currentLessonTitle: currentLessonTitle ?? this.currentLessonTitle,
      currentLessonProgressPercent:
          currentLessonProgressPercent ?? this.currentLessonProgressPercent,
      completedLessonsList: completedLessonsList ?? this.completedLessonsList,
      lessonLastTabs: lessonLastTabs ?? this.lessonLastTabs,
      completedLessonTabs: completedLessonTabs ?? this.completedLessonTabs,
      unlockedAchievements: unlockedAchievements ?? this.unlockedAchievements,
      maxConsecutiveCorrectAnswers: maxConsecutiveCorrectAnswers ?? this.maxConsecutiveCorrectAnswers,
      currentConsecutiveCorrectAnswers: currentConsecutiveCorrectAnswers ?? this.currentConsecutiveCorrectAnswers,
      uniqueToolsSelected: uniqueToolsSelected ?? this.uniqueToolsSelected,
      correctMetricEnglishConversions: correctMetricEnglishConversions ?? this.correctMetricEnglishConversions,
      correctMeasurementBasics: correctMeasurementBasics ?? this.correctMeasurementBasics,
    );
  }
}
