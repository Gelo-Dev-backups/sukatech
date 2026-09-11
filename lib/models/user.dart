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
    );
  }
}
