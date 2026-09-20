import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../models/user.dart';
import '../navigation/fade_route.dart';
import '../settings/app_settings.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/confirmation_modal.dart';
import '../widgets/design_canvas.dart';
import '../widgets/skeleton.dart';
import 'about_screen.dart';
import 'edit_profile_screen.dart';

// The learner's profile: stats, avatar, and app settings.
// musicVolume and sfxVolume read/write AppSettings, so the sliders are real
// and persist across restarts. Reset Progress is fully functional: it zeroes
// the on-device user's stats in SQLite behind a confirmation dialog.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const List<String> assetPaths = ['lib/assets/images/prof hereo.png'];

  static const _navy = Color(0xFF061D3F);
  static const _dividerColor = Color(0x3D000000);

  static const _statValueStyle = TextStyle(
    color: _navy,
    fontSize: 32,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    letterSpacing: 0.96,
  );

  static const _statLabelStyle = TextStyle(
    color: _navy,
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    height: 1.07,
    letterSpacing: 0.42,
  );

  static const _settingsLabelStyle = TextStyle(
    color: _navy,
    fontSize: 16,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    letterSpacing: 0.48,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: UserStore.current,
      builder: (context, user, _) {
        // main() awaits UserStore.load() before runApp, so this is always
        // populated by the time any screen builds.
        final currentUser = user!;
        return DesignCanvas(
          width: 409,
          height: 849,
          backgroundColor: Colors.white,
          children: [
            ..._header(context, currentUser),
            ..._statsCard(currentUser),
            ..._settingsList(context),
            const DashboardBottomNavBar(currentTab: DashboardTab.profile),
          ],
        );
      },
    );
  }

  // --- Header: avatar, name, edit button -------------------------------

  List<Widget> _header(BuildContext context, AppUser user) => [
    Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: 409,
        height: 355,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.50, 0.46),
            end: Alignment(0.50, 1.30),
            colors: [_navy, Colors.white, Colors.white],
          ),
        ),
      ),
    ),
    const Positioned(
      left: 33,
      top: 54,
      child: ClipOval(
        child: SkeletonImage(
          'lib/assets/images/prof hereo.png',
          width: 118,
          height: 118,
          fit: BoxFit.cover,
        ),
      ),
    ),
    Positioned(
      left: 173,
      top: 73,
      child: Text(
        user.name,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w700,
          letterSpacing: 0.60,
        ),
      ),
    ),
    Positioned(
      left: 173,
      top: 103,
      child: Text(
        user.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500,
          letterSpacing: 0.48,
        ),
      ),
    ),
    Positioned(
      left: 169,
      top: 133,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => Navigator.of(context).push(
          fadeRoute((_) => const EditProfileScreen()),
        ),
        child: Container(
          width: 133,
          height: 32,
          decoration: ShapeDecoration(
            color: _navy,
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white),
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          child: const Center(
            child: Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
      ),
    ),
  ];

  // --- Stats card --------------------------------------------------------

  List<Widget> _statsCard(AppUser user) => [
    Positioned(
      left: 14,
      top: 189,
      child: Container(
        width: 382,
        height: 123,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x3F000000),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
      ),
    ),
    ..._statColumn(
      centerX: 78,
      value: '${user.lessonsCompleted}',
      label: 'Lessons\nCompleted',
    ),
    ..._statColumn(
      centerX: 205.5,
      value: '${user.quizzesTaken}',
      label: 'Quizzes\nTaken',
    ),
    ..._statColumn(
      centerX: 332.5,
      value: '${user.practiceCompleted}',
      label: 'Practice\nCompleted',
    ),
    Positioned(
      left: 142,
      top: 207,
      child: Container(width: 1, height: 90, color: _dividerColor),
    ),
    Positioned(
      left: 269,
      top: 207,
      child: Container(width: 1, height: 90, color: _dividerColor),
    ),
  ];

  // Value and label share one column center, instead of two independently
  // hand-picked lefts that didn't actually line up.
  static List<Widget> _statColumn({
    required double centerX,
    required String value,
    required String label,
  }) {
    const boxWidth = 97.0;
    final left = centerX - boxWidth / 2;
    return [
      Positioned(
        left: left,
        top: 250,
        child: SizedBox(
          width: boxWidth,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: _statValueStyle,
          ),
        ),
      ),
      Positioned(
        left: left,
        top: 217,
        child: SizedBox(
          width: boxWidth,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: _statLabelStyle,
          ),
        ),
      ),
    ];
  }

  // --- Settings list -------------------------------------------------

  static const _sectionHeaderStyle = TextStyle(
    color: Color(0xFF8A94A6),
    fontSize: 11,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
  );

  List<Widget> _settingsList(BuildContext context) => [
    // All settings rows live in one Positioned Column so they self-size
    // and never overlap regardless of how tall each row ends up being.
    Positioned(
      left: 14,
      top: 328,
      width: 382,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          const Padding(
            padding: EdgeInsets.only(left: 13, bottom: 6),
            child: Text('SETTINGS', style: _sectionHeaderStyle),
          ),
          // Music Volume slider
          _VolumeSliderRow(
            icon: Icons.music_note_rounded,
            label: 'Music Volume',
            notifier: AppSettings.musicVolume,
            showDivider: true,
          ),
          // SFX Volume slider
          _VolumeSliderRow(
            icon: Icons.volume_up_rounded,
            label: 'Sound Effects',
            notifier: AppSettings.sfxVolume,
            showDivider: true,
          ),
          // Reset Progress
          _settingsRow(
            icon: Icons.refresh_rounded,
            label: 'Reset Progress',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF8A94A6),
              size: 22,
            ),
            onTap: () => _confirmResetProgress(context),
          ),
          // About SUKATECH
          _settingsRow(
            icon: Icons.info_outline_rounded,
            label: 'About SUKATECH',
            trailing: const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF8A94A6),
              size: 22,
            ),
            onTap: () => Navigator.of(context).push(
              fadeRoute((_) => const AboutScreen()),
            ),
          ),
          // App Version (read-only, no divider)
          _settingsRow(
            icon: Icons.tag_rounded,
            label: 'App Version',
            trailing: const Text(
              '1.0.0',
              style: TextStyle(
                color: Color(0xFF8A94A6),
                fontSize: 14,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.42,
              ),
            ),
            showDivider: false,
          ),
        ],
      ),
    ),
  ];

  static Future<void> _confirmResetProgress(BuildContext context) async {
    final confirmed = await showConfirmationModal(
      context,
      title: 'Reset Progress?',
      message:
          'This clears lessons completed, quizzes taken, practice completed, '
          'XP and your current lesson progress. This can\'t be undone.',
      confirmLabel: 'Reset',
      isDestructive: true,
    );
    if (!confirmed) return;
    await UserStore.mutate(
      (user) => user.copyWith(
        lessonsCompleted: 0,
        quizzesTaken: 0,
        practiceCompleted: 0,
        xpEarned: 0,
        overallProgressPercent: 0,
        currentLessonProgressPercent: 0,
        completedLessonsList: [],
        lessonLastTabs: {},
        completedLessonTabs: [],
        unlockedAchievements: [],
        maxConsecutiveCorrectAnswers: 0,
        currentConsecutiveCorrectAnswers: 0,
        uniqueToolsSelected: [],
        correctMetricEnglishConversions: 0,
        correctMeasurementBasics: 0,
      ),
    );
  }

  /// A single settings row: icon bubble + label + trailing control.
  /// Returned as a plain Column child — the parent Positioned Column
  /// handles vertical stacking so rows never overlap.
  static Widget _settingsRow({
    required IconData icon,
    required String label,
    required Widget trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 13,
                vertical: 12,
              ),
              child: Row(
                children: [
                  // Leading icon bubble
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F3F8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: _navy, size: 20),
                  ),
                  const SizedBox(width: 14),
                  // Label fills remaining space
                  Expanded(
                    child: Text(label, style: _settingsLabelStyle),
                  ),
                  // Trailing control (toggle / chevron / text)
                  trailing,
                ],
              ),
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Container(height: 1, color: _dividerColor),
          ),
      ],
    );
  }
}

/// A settings row that shows an icon bubble, a label, and a compact
/// volume slider wired to a [ValueNotifier<double>].
class _VolumeSliderRow extends StatelessWidget {
  const _VolumeSliderRow({
    required this.icon,
    required this.label,
    required this.notifier,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final ValueNotifier<double> notifier;
  final bool showDivider;

  static const _navy = Color(0xFF061D3F);
  static const _dividerColor = Color(0x3D000000);
  static const _activeColor = Color(0xFF061D3F);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: Row(
            children: [
              // Leading icon bubble
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F3F8),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _navy, size: 20),
              ),
              const SizedBox(width: 12),
              // Label + slider stacked vertically
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        color: _navy,
                        fontSize: 14,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ValueListenableBuilder<double>(
                      valueListenable: notifier,
                      builder: (context, value, _) {
                        return SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: _activeColor,
                            inactiveTrackColor: const Color(0xFFDDE1EA),
                            thumbColor: _activeColor,
                            overlayColor: _activeColor.withValues(alpha: 0.12),
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 7,
                            ),
                            overlayShape: const RoundSliderOverlayShape(
                              overlayRadius: 14,
                            ),
                          ),
                          child: SizedBox(
                            height: 28,
                            child: Slider(
                              value: value,
                              min: 0,
                              max: 1,
                              onChanged: (v) => notifier.value = v,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Percentage label
              ValueListenableBuilder<double>(
                valueListenable: notifier,
                builder: (context, value, _) => SizedBox(
                  width: 36,
                  child: Text(
                    '${(value * 100).round()}%',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Color(0xFF8A94A6),
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Container(height: 1, color: _dividerColor),
          ),
      ],
    );
  }
}
