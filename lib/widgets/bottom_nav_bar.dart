import 'package:flutter/material.dart';

import '../navigation/fade_route.dart';
import '../screens/dashboard_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/practice_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/quiz_screen.dart';

/// The five sections reachable from the main app's bottom bar.
enum DashboardTab { home, lesson, practice, quiz, profile }

class _NavItem {
  const _NavItem(this.tab, this.icon, this.label);
  final DashboardTab tab;
  final IconData icon;
  final String label;
}

const _navItems = [
  _NavItem(DashboardTab.home, Icons.home_rounded, 'Home'),
  _NavItem(DashboardTab.lesson, Icons.auto_stories_rounded, 'Lesson'),
  _NavItem(DashboardTab.practice, Icons.edit_note_rounded, 'Practice'),
  _NavItem(DashboardTab.quiz, Icons.fact_check_rounded, 'Quiz'),
  _NavItem(DashboardTab.profile, Icons.person_rounded, 'Profile'),
];

const _navy = Color(0xFF061D3F);
const _accentYellow = Color(0xFFFBC235);

/// The screen each tab leads to, for the tabs that are actually built.
/// Tabs missing here fall back to [pushUnderDevelopment].
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
  }
}

/// Bottom tab bar shared by every main-app screen. Meant to sit as the last
/// child of a fixed-size [Stack] (see DesignCanvas), pinned to the bottom.
///
/// Tapping the already-active tab is a no-op; unavailable sections open the
/// shared development screen until their screens are implemented.
class DashboardBottomNavBar extends StatelessWidget {
  const DashboardBottomNavBar({super.key, required this.currentTab});

  final DashboardTab currentTab;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 84,
        color: _navy,
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (final item in _navItems)
              _NavButton(
                item: item,
                active: item.tab == currentTab,
                onTap: () {
                  if (item.tab == currentTab) return;
                  final destination = _screenFor(item.tab);
                  if (destination != null) {
                    Navigator.of(
                      context,
                    ).pushReplacement(fadeRoute(destination));
                  } else {
                    pushUnderDevelopment(context, title: 'No ${item.label}');
                  }
                },
              ),
          ],
        ),
      ),
    );
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
        children: [
          Icon(item.icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            item.label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.33,
            ),
          ),
        ],
      ),
    );
  }
}
