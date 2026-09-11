import 'package:flutter/material.dart';

enum AchievementCategory { learning, practice, progress }
enum AchievementRarity { common, uncommon, rare, epic, legendary }

class Achievement {
  final String id;
  final String title;
  final String description;
  final String? lessonTitle;
  final IconData icon;
  final AchievementCategory category;
  final AchievementRarity rarity;
  final int xpReward;
  final int requirementValue;

  const Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.rarity,
    required this.xpReward,
    this.lessonTitle,
    this.requirementValue = 1,
  });
}
