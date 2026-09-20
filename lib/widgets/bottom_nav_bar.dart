import 'package:flutter/material.dart';

import '../navigation/fade_route.dart';
import '../screens/achievements_screen.dart';
import '../screens/dashboard_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/practice_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/quiz_screen.dart';
import '../screens/unit_converter_screen.dart';

/// The sections reachable from the main app's bottom bar.
enum DashboardTab {
  home,
  lesson,
  achievements,
  converter,
  practice,
  quiz,
  profile,
}

class _NavItem {
  const _NavItem(this.tab, this.icon, this.label);
  final DashboardTab tab;
  final IconData icon;
  final String label;
}

const _leftItems = [
  _NavItem(DashboardTab.home, Icons.home_rounded, 'Home'),
  _NavItem(DashboardTab.lesson, Icons.auto_stories_rounded, 'Lesson'),
  _NavItem(DashboardTab.achievements, Icons.emoji_events_rounded, 'Awards'),
];

const _rightItems = [
  _NavItem(DashboardTab.practice, Icons.edit_note_rounded, 'Practice'),
  _NavItem(DashboardTab.quiz, Icons.fact_check_rounded, 'Quiz'),
  _NavItem(DashboardTab.profile, Icons.person_rounded, 'Profile'),
];

const _navy = Color(0xFF061D3F);
const _accentYellow = Color(0xFFFBC235);

/// The screen each tab leads to.
WidgetBuilder? _screenFor(DashboardTab tab) {
  switch (tab) {
    case DashboardTab.home:
      return (_) => const DashboardScreen();
    case DashboardTab.profile:
      return (_) => const ProfileScreen();
    case DashboardTab.lesson:
      return (_) => const LessonsScreen();
    case DashboardTab.practice:
      return (_) => const PracticeScreen();
    case DashboardTab.quiz:
      return (_) => const QuizScreen();
    case DashboardTab.achievements:
      return (_) => const AchievementsScreen();
    case DashboardTab.converter:
      return (_) => const UnitConverterScreen();
  }
}

/// Bottom tab bar with a raised centre Unit Converter button.
class DashboardBottomNavBar extends StatelessWidget {
  const DashboardBottomNavBar({super.key, required this.currentTab});

  final DashboardTab currentTab;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: SizedBox(
        height: 84,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Bar background
            Positioned.fill(
              child: Container(
                color: _navy,
                padding: const EdgeInsets.only(bottom: 14, top: 10),
                child: Row(
                  children: [
                    // Left side items
                    for (final item in _leftItems)
                      Expanded(
                        child: _NavButton(
                          item: item,
                          active: item.tab == currentTab,
                          onTap: () => _navigate(context, item.tab),
                        ),
                      ),
                    // Centre placeholder (space for the FAB)
                    const Expanded(child: SizedBox()),
                    // Right side items
                    for (final item in _rightItems)
                      Expanded(
                        child: _NavButton(
                          item: item,
                          active: item.tab == currentTab,
                          onTap: () => _navigate(context, item.tab),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Raised centre Unit Converter FAB
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => _navigate(context, DashboardTab.converter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFFCC44), Color(0xFFFFA500)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: currentTab == DashboardTab.converter
                            ? Colors.white
                            : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFFFFA500,
                          ).withValues(alpha: 0.55),
                          blurRadius: 18,
                          offset: const Offset(0, -4),
                        ),
                        BoxShadow(
                          color: const Color(
                            0xFFFFA500,
                          ).withValues(alpha: 0.25),
                          blurRadius: 30,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.calculate_rounded,
                      color: Color(0xFF061D3F),
                      size: 30,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, DashboardTab tab) {
    if (tab == currentTab) return;
    final destination = _screenFor(tab);
    if (destination != null) {
      Navigator.of(context).pushReplacement(fadeRoute(destination));
    } else {
      pushUnderDevelopment(context, title: tab.name);
    }
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.active,
    required this.onTap,
  });

  final _NavItem item;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = active ? _accentYellow : Colors.white;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(item.icon, color: color, size: 22),
          const SizedBox(height: 3),
          Text(
            item.label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.30,
            ),
          ),
        ],
      ),
    );
  }
}
