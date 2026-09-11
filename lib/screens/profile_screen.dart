import 'package:flutter/material.dart';

import '../data/user_store.dart';
import '../models/user.dart';
import '../navigation/fade_route.dart';
import '../settings/app_settings.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/confirmation_modal.dart';
import '../widgets/design_canvas.dart';
import '../widgets/skeleton.dart';

// The learner's profile: stats, avatar and app settings. Dark Mode and
// Sound read/write AppSettings, so they're real, working toggles — they
// just aren't wired to an actual theme/audio system yet. Reset Progress is
// fully functional: it zeroes the on-device user's stats in SQLite behind a
// confirmation dialog. "1.0.0" is the only remaining placeholder.
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
        onTap: () => pushUnderDevelopment(context, title: 'No Edit Profile'),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          shadows: const [
            BoxShadow(color: Color(0x3F000000), blurRadius: 4, offset: Offset(0, 4)),
          ],
        ),
      ),
    ),
    ..._statColumn(
      centerX: 78,
      value: '${user.lessonsCompleted}',
      label: 'Lessons\nCompleted',
    ),
    ..._statColumn(centerX: 205.5, value: '${user.quizzesTaken}', label: 'Quizzes\nTaken'),
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
          child: Text(value, textAlign: TextAlign.center, style: _statValueStyle),
        ),
      ),
      Positioned(
        left: left,
        top: 217,
        child: SizedBox(
          width: boxWidth,
          child: Text(label, textAlign: TextAlign.center, style: _statLabelStyle),
        ),
      ),
    ];
  }

  // --- Settings list -------------------------------------------------

  List<Widget> _settingsList(BuildContext context) => [
    ..._settingsRow(
      top: 357,
      label: 'Dark Mode',
      trailing: ValueListenableBuilder<bool>(
        valueListenable: AppSettings.darkMode,
        builder: (context, value, _) => _ToggleSwitch(value: value),
      ),
      onTap: () => AppSettings.darkMode.value = !AppSettings.darkMode.value,
    ),
    ..._settingsRow(
      top: 404,
      label: 'Sound',
      trailing: ValueListenableBuilder<bool>(
        valueListenable: AppSettings.soundOn,
        builder: (context, value, _) => _ToggleSwitch(value: value),
      ),
      onTap: () => AppSettings.soundOn.value = !AppSettings.soundOn.value,
    ),
    ..._settingsRow(
      top: 452,
      label: 'Reset Progress',
      trailing: const Icon(Icons.restart_alt_rounded, color: _navy, size: 22),
      onTap: () => _confirmResetProgress(context),
    ),
    ..._settingsRow(
      top: 500,
      label: 'About SUKATECH',
      trailing: const Icon(Icons.info_outline_rounded, color: _navy, size: 22),
      onTap: () => pushUnderDevelopment(context, title: 'No About'),
    ),
    ..._settingsRow(
      top: 548,
      label: 'App Version',
      trailing: const Text(
        '1.0.0',
        style: TextStyle(
          color: _navy,
          fontSize: 14,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.42,
        ),
      ),
      showDivider: false,
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
      ),
    );
  }

  /// One label + trailing control, with a hairline divider under it. All
  /// five settings rows share this exact shape, just with different
  /// trailing content (a toggle, an icon, or plain text).
  static List<Widget> _settingsRow({
    required double top,
    required String label,
    required Widget trailing,
    VoidCallback? onTap,
    bool showDivider = true,
  }) => [
    if (onTap != null)
      Positioned(
        left: 27,
        top: top - 15,
        width: 354,
        height: 44,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: onTap),
      ),
    Positioned(
      left: 73,
      top: top,
      child: SizedBox(width: 220, child: Text(label, style: _settingsLabelStyle)),
    ),
    Positioned(left: 310, top: top - 6, child: trailing),
    if (showDivider)
      Positioned(
        left: 27,
        top: top + 29,
        child: Container(width: 354, height: 1, color: _dividerColor),
      ),
  ];
}

/// Purely presentational — the enclosing settings row owns the tap, so
/// there's exactly one place that flips the value instead of two
/// overlapping tap handlers that could both fire off a single tap.
class _ToggleSwitch extends StatelessWidget {
  const _ToggleSwitch({required this.value});

  final bool value;

  static const _trackWidth = 46.0;
  static const _trackHeight = 22.0;
  static const _thumbSize = 18.0;
  static const _onColor = Color(0xFF05831C);
  static const _offColor = Color(0xFFEBE9E9);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: _trackWidth,
        height: _trackHeight,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: value ? _onColor : _offColor,
          borderRadius: BorderRadius.circular(_trackHeight),
          border: Border.all(color: Colors.black.withValues(alpha: 0.12)),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeInOut,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: _thumbSize,
            height: _thumbSize,
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
          ),
        ),
      ),
    );
  }
}
