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
    );
  }
}
