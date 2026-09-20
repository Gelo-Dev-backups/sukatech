import 'package:flutter/material.dart';
import '../services/sound_service.dart';

import '../main.dart';
import '../models/achievement.dart';
import '../models/user.dart';
import 'course_data.dart';

class AchievementManager {
  AchievementManager._();
  static final instance = AchievementManager._();

  static const List<Achievement> allAchievements = [
    Achievement(
      id: 'getting_started',
      title: 'Getting Started',
      description: 'Open your first lesson',
      icon: Icons.menu_book_rounded,
      category: AchievementCategory.learning,
      rarity: AchievementRarity.common,
      xpReward: 25,
    ),
    Achievement(
      id: 'first_lesson',
      title: 'First Lesson',
      description: 'Complete your first lesson',
      icon: Icons.star_rounded,
      category: AchievementCategory.learning,
      rarity: AchievementRarity.common,
      xpReward: 50,
    ),
    Achievement(
      id: 'practice_begins',
      title: 'Practice Begins',
      description: 'Complete your first Interactive Practice',
      icon: Icons.build_rounded,
      category: AchievementCategory.practice,
      rarity: AchievementRarity.common,
      xpReward: 25,
    ),
    Achievement(
      id: 'measure_first',
      title: 'Measure First',
      description: 'Complete Lesson 1',
      lessonTitle: 'Lesson 1: Introduction to Measurement',
      icon: Icons.straighten_rounded,
      category: AchievementCategory.learning,
      rarity: AchievementRarity.uncommon,
      xpReward: 75,
    ),
    Achievement(
      id: 'toolbox_beginner',
      title: 'Toolbox Beginner',
      description: 'Complete Lesson 2',
      lessonTitle: 'Lesson 2: Measuring Tools',
      icon: Icons.handyman_rounded,
      category: AchievementCategory.learning,
      rarity: AchievementRarity.uncommon,
      xpReward: 75,
    ),
    Achievement(
      id: 'know_the_parts',
      title: 'Know the Parts',
      description: 'Complete Lesson 3',
      lessonTitle: 'Lesson 3: Parts and Functions',
      icon: Icons.settings_rounded,
      category: AchievementCategory.learning,
      rarity: AchievementRarity.uncommon,
      xpReward: 75,
    ),
    Achievement(
      id: 'read_the_scale',
      title: 'Read the Scale',
      description: 'Complete Lesson 4',
      lessonTitle: 'Lesson 4: Reading Measurements',
      icon: Icons.search_rounded,
      category: AchievementCategory.learning,
      rarity: AchievementRarity.uncommon,
      xpReward: 75,
    ),
    Achievement(
      id: 'measurement_basics',
      title: 'Measurement Basics',
      description:
          'Correctly answer questions covering Length, Width, Height, and Thickness',
      icon: Icons.category_rounded,
      category: AchievementCategory.practice,
      rarity: AchievementRarity.uncommon,
      xpReward: 50,
      requirementValue: 4,
    ),
    Achievement(
      id: 'right_tool_right_job',
      title: 'Right Tool, Right Job',
      description:
          'Correctly choose the appropriate measuring tool for 10 different tasks',
      icon: Icons.construction_rounded,
      category: AchievementCategory.practice,
      rarity: AchievementRarity.rare,
      xpReward: 75,
      requirementValue: 10,
    ),
    Achievement(
      id: 'tool_anatomy',
      title: 'Tool Anatomy',
      description: 'Correctly identify important parts of measuring tools',
      icon: Icons.science_rounded,
      category: AchievementCategory.practice,
      rarity: AchievementRarity.rare,
      xpReward: 75,
    ),
    Achievement(
      id: 'unit_converter',
      title: 'Unit Converter',
      description: 'Correctly solve 10 Metric/English conversions',
      icon: Icons.swap_horiz_rounded,
      category: AchievementCategory.practice,
      rarity: AchievementRarity.rare,
      xpReward: 75,
      requirementValue: 10,
    ),
    Achievement(
      id: 'perfect_measurement',
      title: 'Perfect Measurement',
      description: 'Score 100% on any Interactive Practice',
      icon: Icons.verified_rounded,
      category: AchievementCategory.practice,
      rarity: AchievementRarity.epic,
      xpReward: 100,
    ),
    Achievement(
      id: 'sharp_mind',
      title: 'Sharp Mind',
      description:
          'Get 10 correct answers consecutively in Interactive Practice',
      icon: Icons.psychology_rounded,
      category: AchievementCategory.practice,
      rarity: AchievementRarity.epic,
      xpReward: 100,
      requirementValue: 10,
    ),
    Achievement(
      id: 'xp_collector',
      title: 'XP Collector',
      description: 'Earn 500 total XP',
      icon: Icons.military_tech_rounded,
      category: AchievementCategory.progress,
      rarity: AchievementRarity.epic,
      xpReward: 100,
      requirementValue: 500,
    ),
    Achievement(
      id: 'sukatech_scholar',
      title: 'Sukatech Scholar',
      description: 'Complete all currently available lessons',
      icon: Icons.school_rounded,
      category: AchievementCategory.progress,
      rarity: AchievementRarity.legendary,
      xpReward: 250,
    ),
  ];

  AppUser evaluate(AppUser updated) {
    AppUser temp = updated;
    List<Achievement> newlyUnlocked = [];
    final unlocked = List<String>.from(temp.unlockedAchievements);

    // Evaluate logic for each achievement.
    bool changed = true;
    while (changed) {
      changed = false;
      for (final ach in allAchievements) {
        if (!unlocked.contains(ach.id)) {
          if (_checkRequirement(temp, ach)) {
            unlocked.add(ach.id);
            newlyUnlocked.add(ach);
            temp = temp.copyWith(
              unlockedAchievements: unlocked,
              xpEarned: temp.xpEarned + ach.xpReward,
            );
            changed = true;
          }
        }
      }
    }

    if (newlyUnlocked.isNotEmpty) {
      // Schedule notification to display after current frame
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showNotifications(newlyUnlocked);
      });
    }

    return temp;
  }

  bool _checkRequirement(AppUser user, Achievement ach) {
    switch (ach.id) {
      case 'getting_started':
        return user.currentLessonTitle.isNotEmpty ||
            user.completedLessonsList.isNotEmpty;
      case 'first_lesson':
        return user.completedLessonsList.isNotEmpty;
      case 'practice_begins':
        return user.practiceCompleted >= 1;
      case 'measure_first':
      case 'toolbox_beginner':
      case 'know_the_parts':
      case 'read_the_scale':
        return user.completedLessonsList.contains(ach.lessonTitle);
      case 'measurement_basics':
        return user.correctMeasurementBasics >= ach.requirementValue;
      case 'right_tool_right_job':
        return user.uniqueToolsSelected.length >= ach.requirementValue;
      case 'tool_anatomy':
        // Need specific logic later, but for now we'll assume there is a property or it's manual
        // Actually, we don't have a counter for this yet. We'll leave it returning false until implemented.
        return false;
      case 'unit_converter':
        return user.correctMetricEnglishConversions >= ach.requirementValue;
      case 'perfect_measurement':
        return user.completedLessonTabs.contains(
          'lesson_01_practice_intro_measurement_perfect',
        );
      case 'sharp_mind':
        return user.maxConsecutiveCorrectAnswers >= ach.requirementValue;
      case 'xp_collector':
        return user.xpEarned >= ach.requirementValue;
      case 'sukatech_scholar':
        return user.completedLessonsList.length >= CourseData.totalLessons;
      default:
        return false;
    }
  }

  void _showNotifications(List<Achievement> unlocked) {
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger == null) return;
    
    // Play achievement unlocked sound exactly once per batch
    if (unlocked.isNotEmpty) {
      SoundService.instance.playAchievementUnlocked();
    }

    for (final ach in unlocked) {
      messenger.showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF59E0B),
                  shape: BoxShape.circle,
                ),
                child: Icon(ach.icon, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🏆 Achievement Unlocked!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF59E0B),
                      ),
                    ),
                    Text(
                      ach.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(ach.description, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Text(
                '+${ach.xpReward} XP',
                style: const TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }
}
