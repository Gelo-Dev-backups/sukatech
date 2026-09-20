import 'package:flutter/material.dart';

import '../data/achievement_manager.dart';
import '../data/user_store.dart';
import '../models/achievement.dart';
import '../models/user.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: UserStore.current,
      builder: (context, user, _) {
        if (user == null) return const SizedBox();

        final unlockedIds = user.unlockedAchievements;
        final totalUnlocked = unlockedIds.length;
        final totalAchievements = AchievementManager.allAchievements.length;
        final progressPercent = totalAchievements == 0
            ? 0.0
            : totalUnlocked / totalAchievements;

        return DesignCanvas(
          width: 409,
          height: 849,
          backgroundColor: Colors.white,
          children: [
            // Header Background
            const Positioned(
              left: 0,
              top: 0,
              child: SizedBox(
                width: 409,
                height: 160,
                child: DecoratedBox(decoration: BoxDecoration(color: _navy)),
              ),
            ),

            // Page Title
            const Positioned(
              left: 0,
              right: 0,
              top: 68,
              child: Text(
                '🏆 Achievements',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.60,
                ),
              ),
            ),
            // Header Stats
            Positioned(
              left: 20,
              right: 20,
              top: 108,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${user.xpEarned} XP',
                    style: const TextStyle(
                      color: _accent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '$totalUnlocked / $totalAchievements Unlocked',
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Header Progress Bar
            Positioned(
              left: 20,
              right: 20,
              top: 136,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressPercent,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  color: const Color(0xFF05831C),
                  minHeight: 6,
                ),
              ),
            ),
            // Achievements List
            Positioned.fill(
              top: 170,
              bottom: 84, // Leave space for bottom nav bar
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 20),
                itemCount: AchievementManager.allAchievements.length,
                itemBuilder: (context, index) {
                  final ach = AchievementManager.allAchievements[index];
                  final isUnlocked = unlockedIds.contains(ach.id);
                  return _AchievementCard(
                    achievement: ach,
                    isUnlocked: isUnlocked,
                    user: user,
                  );
                },
              ),
            ),
            
            // Bottom Nav Bar
            const DashboardBottomNavBar(currentTab: DashboardTab.achievements),
          ],
        );
      },
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final AppUser user;

  const _AchievementCard({
    required this.achievement,
    required this.isUnlocked,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isUnlocked ? const Color(0xFFF6F6F6) : Colors.white;
    final borderColor = isUnlocked
        ? Colors.black.withValues(alpha: 0.12)
        : Colors.black.withValues(alpha: 0.05);
    final iconBgColor = isUnlocked
        ? const Color(0xFF0F3260)
        : Colors.grey.shade300;
    final iconColor = isUnlocked
        ? const Color(0xFFFFA500)
        : Colors.grey.shade500;
    final titleColor = isUnlocked
        ? const Color(0xFF061D3F)
        : Colors.grey.shade600;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: isUnlocked
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isUnlocked ? achievement.icon : Icons.lock_rounded,
              color: iconColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        achievement.title,
                        style: TextStyle(
                          color: titleColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '+${achievement.xpReward} XP',
                      style: TextStyle(
                        color: isUnlocked
                            ? const Color(0xFF10B981)
                            : Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  achievement.description,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _Badge(
                      text: achievement.category.name.toUpperCase(),
                      color: _getCategoryColor(achievement.category),
                      isUnlocked: isUnlocked,
                    ),
                    if (!isUnlocked && achievement.requirementValue > 1)
                      Text(
                        '${_getProgress(user, achievement)} / ${achievement.requirementValue}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else if (isUnlocked)
                      const Text(
                        'UNLOCKED',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  int _getProgress(AppUser user, Achievement ach) {
    switch (ach.id) {
      case 'measurement_basics':
        return user.correctMeasurementBasics;
      case 'right_tool_right_job':
        return user.uniqueToolsSelected.length;
      case 'unit_converter':
        return user.correctMetricEnglishConversions;
      case 'sharp_mind':
        return user.maxConsecutiveCorrectAnswers;
      case 'xp_collector':
        return user.xpEarned;
      case 'sukatech_scholar':
        return user.completedLessonsList.length;
      default:
        return 0;
    }
  }

  Color _getCategoryColor(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.learning:
        return const Color(0xFF0284C7);
      case AchievementCategory.practice:
        return const Color(0xFFD97706);
      case AchievementCategory.progress:
        return const Color(0xFF7C3AED);
    }
  }
}

class _Badge extends StatelessWidget {
  final String text;
  final Color color;
  final bool isUnlocked;

  const _Badge({
    required this.text,
    required this.color,
    required this.isUnlocked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isUnlocked ? color.withValues(alpha: 0.1) : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: isUnlocked ? color.withValues(alpha: 0.2) : Colors.transparent,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isUnlocked ? color : Colors.grey.shade500,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
