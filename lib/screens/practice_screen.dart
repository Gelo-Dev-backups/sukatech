import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../navigation/fade_route.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/design_canvas.dart';

class PracticeScreen extends StatelessWidget {
  const PracticeScreen({super.key});

  static const _navy = Color(0xFF061D3F);
  static const _accent = Color(0xFFFFA500);

  static const _practices = [
    (title: 'Introduction to\nMeasurement', icon: Icons.menu_book_rounded),
    (title: 'Measuring Tools', icon: Icons.square_foot_rounded),
    (title: 'Parts and\nFunctions', icon: Icons.widgets_rounded),
    (title: 'Reading\nMeasurements', icon: Icons.straighten_rounded),
    (title: 'Unit\nConversion', icon: Icons.sync_alt_rounded),
    (title: 'Measurement\nCalculations', icon: Icons.functions_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return DesignCanvas(
      width: 409,
      height: 849,
      backgroundColor: Colors.white,
      children: [
        const Positioned(
          left: 0,
          top: 0,
          child: SizedBox(
            width: 409,
            height: 122,
            child: DecoratedBox(decoration: BoxDecoration(color: _navy)),
          ),
        ),
        Positioned(
          left: 18,
          top: 56,
          child: Navigator.of(context).canPop()
              ? IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.edit_note_rounded,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
        ),
        const Positioned(
          left: 0,
          right: 0,
          top: 68,
          child: Text(
            'Practice',
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
        const Positioned(
          right: 28,
          top: 62,
          child: Icon(Icons.edit_note_rounded, color: Colors.white, size: 32),
        ),
        for (var index = 0; index < _practices.length; index++)
          _practiceCard(context, index, _practices[index]),
        const DashboardBottomNavBar(currentTab: DashboardTab.practice),
      ],
    );
  }

  Widget _practiceCard(
    BuildContext context,
    int index,
    ({String title, IconData icon}) practice,
  ) {
    final top = 142.0 + (index * 102.0);

    return Positioned(
      left: 16,
      top: top,
      child: Semantics(
        button: true,
        label: 'Open ${practice.title.replaceAll('\n', ' ')} Practice',
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            final flatTitle = practice.title.replaceAll('\n', ' ');
            UserStore.mutate(
              (user) => user.copyWith(currentLessonTitle: flatTitle),
            );

            // TODO: Route to specific practice screens once implemented
            pushUnderDevelopment(context, title: "$flatTitle Practice");
          },
          child: Container(
            width: 377,
            height: 93,
            padding: const EdgeInsets.only(left: 12, right: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F6F6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
            ),
            child: Row(
              children: [
                Container(
                  width: 96,
                  height: 68,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF0F3260), Color(0xFF061D3F)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _accent.withValues(alpha: 0.28),
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: _navy.withValues(alpha: 0.18),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.08),
                        border: Border.all(
                          color: _accent.withValues(alpha: 0.40),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(practice.icon, color: _accent, size: 26),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        practice.title,
                        style: const TextStyle(
                          color: _navy,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.w700,
                          height: 1.12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: _navy,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
