import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/achievement_manager.dart';
import '../data/user_store.dart';
import '../models/user.dart';
import '../widgets/skeleton.dart';

/// Maps each achievement ID to the title the learner can equip.
const Map<String, String> _achievementTitles = {
  'getting_started': 'Beginner Learner',
  'first_lesson': 'Lesson Taker',
  'practice_begins': 'Practicer',
  'measure_first': 'Measurement Starter',
  'toolbox_beginner': 'Tool Apprentice',
  'know_the_parts': 'Parts Expert',
  'read_the_scale': 'Scale Reader',
  'measurement_basics': 'Measurement Basics Pro',
  'right_tool_right_job': 'Right Tool Expert',
  'tool_anatomy': 'Tool Anatomy Master',
  'unit_converter': 'Unit Converter',
  'perfect_measurement': 'Perfect Measurer',
  'sharp_mind': 'Sharp Mind',
  'xp_collector': 'XP Collector',
  'sukatech_scholar': 'Sukatech Scholar',
};

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  static const _navy = Color(0xFF061D3F);

  late final TextEditingController _nameCtrl;
  late String _selectedTitle;
  late String _originalName;
  late String _originalTitle;

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = UserStore.current.value!;
    _originalName = user.name;
    _originalTitle = user.title;
    _nameCtrl = TextEditingController(text: user.name);
    _selectedTitle = user.title;
    _nameCtrl.addListener(_onChanged);
  }

  @override
  void dispose() {
    _nameCtrl.removeListener(_onChanged);
    _nameCtrl.dispose();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  bool get _hasChanges {
    final trimmed = _nameCtrl.text.trim();
    return trimmed.isNotEmpty &&
        (trimmed != _originalName || _selectedTitle != _originalTitle);
  }

  Future<void> _save() async {
    if (!_hasChanges || _saving) return;
    setState(() => _saving = true);
    await UserStore.mutate(
      (u) => u.copyWith(
        name: _nameCtrl.text.trim(),
        title: _selectedTitle,
      ),
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppUser?>(
      valueListenable: UserStore.current,
      builder: (context, user, _) {
        if (user == null) return const SizedBox();

        final unlockedIds = user.unlockedAchievements.toSet();
        final availableTitles = AchievementManager.allAchievements
            .where((a) =>
                unlockedIds.contains(a.id) &&
                _achievementTitles.containsKey(a.id))
            .map((a) =>
                (id: a.id, title: _achievementTitles[a.id]!, icon: a.icon))
            .toList();

        return Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            children: [
              // Header
              _Header(onBack: () => Navigator.of(context).pop()),

              // Scrollable body
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),

                      // Avatar (read-only)
                      Center(
                        child: Container(
                          width: 96,
                          height: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _navy, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: _navy.withValues(alpha: 0.18),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const ClipOval(
                            child: SkeletonImage(
                              'lib/assets/images/prof hereo.png',
                              width: 96,
                              height: 96,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Name field
                      const _SectionLabel(label: 'DISPLAY NAME'),
                      const SizedBox(height: 8),
                      _NameField(controller: _nameCtrl),

                      const SizedBox(height: 28),

                      // Title picker
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const _SectionLabel(
                              label: 'MEASUREMENT MASTER TITLE'),
                          const Spacer(),
                          if (availableTitles.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F4EA),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${availableTitles.length} unlocked',
                                style: const TextStyle(
                                  color: Color(0xFF05831C),
                                  fontSize: 10,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      availableTitles.isEmpty
                          ? _LockedTitlesPlaceholder()
                          : _TitleGrid(
                              options: availableTitles,
                              selected: _selectedTitle,
                              onSelect: (t) =>
                                  setState(() => _selectedTitle = t),
                            ),

                      const SizedBox(height: 36),

                      // Save button
                      _SaveButton(
                        enabled: _hasChanges && !_saving,
                        saving: _saving,
                        onTap: _save,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.onBack});
  final VoidCallback onBack;

  static const _navy = Color(0xFF061D3F);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [_navy, Color(0xFF0F3260)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                // Back button
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(40),
                    onTap: onBack,
                    child: const Padding(
                      padding: EdgeInsets.all(14),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  child: Text(
                    'Edit Profile',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                // Balancing spacer
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF8A94A6),
        fontSize: 11,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }
}

// ── Name field ────────────────────────────────────────────────────────────────

class _NameField extends StatelessWidget {
  const _NameField({required this.controller});
  final TextEditingController controller;

  static const _navy = Color(0xFF061D3F);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE1EA)),
      ),
      child: TextField(
        controller: controller,
        maxLength: 30,
        inputFormatters: [
          // Prevent leading whitespace
          FilteringTextInputFormatter.deny(RegExp(r'^\s')),
        ],
        style: const TextStyle(
          color: _navy,
          fontSize: 16,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: 'Enter your name…',
          hintStyle: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 15,
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w500,
          ),
          counterText: '',
          contentPadding: const EdgeInsets.fromLTRB(16, 14, 8, 14),
          border: InputBorder.none,
          suffixIcon: controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.cancel_rounded,
                    color: Color(0xFFB0B7C3),
                    size: 20,
                  ),
                  onPressed: controller.clear,
                )
              : null,
        ),
      ),
    );
  }
}

// ── Title grid ────────────────────────────────────────────────────────────────

typedef _TitleOption = ({String id, String title, IconData icon});

class _TitleGrid extends StatelessWidget {
  const _TitleGrid({
    required this.options,
    required this.selected,
    required this.onSelect,
  });

  final List<_TitleOption> options;
  final String selected;
  final ValueChanged<String> onSelect;

  static const _navy = Color(0xFF061D3F);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((opt) {
        final isSelected = opt.title == selected;
        return GestureDetector(
          onTap: () => onSelect(opt.title),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: isSelected ? _navy : const Color(0xFFF0F3F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? _navy : const Color(0xFFDDE1EA),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: _navy.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  opt.icon,
                  size: 15,
                  color: isSelected
                      ? Colors.white
                      : const Color(0xFF8A94A6),
                ),
                const SizedBox(width: 7),
                Text(
                  opt.title,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : const Color(0xFF061D3F),
                    fontSize: 13,
                    fontFamily: 'Montserrat',
                    fontWeight: isSelected
                        ? FontWeight.w700
                        : FontWeight.w600,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.check_circle_rounded,
                    size: 14,
                    color: Color(0xFF4ADE80),
                  ),
                ],
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Locked placeholder ────────────────────────────────────────────────────────

class _LockedTitlesPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE1EA)),
      ),
      child: Column(
        children: [
          Icon(Icons.lock_rounded, color: Colors.grey.shade400, size: 32),
          const SizedBox(height: 10),
          Text(
            'No titles unlocked yet',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Complete lessons and practices to\nunlock your Measurement Master title.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 12,
              fontFamily: 'Montserrat',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Save button ───────────────────────────────────────────────────────────────

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.enabled,
    required this.saving,
    required this.onTap,
  });

  final bool enabled;
  final bool saving;
  final VoidCallback onTap;

  static const _navy = Color(0xFF061D3F);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: enabled ? 1.0 : 0.45,
      duration: const Duration(milliseconds: 200),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: Material(
          color: _navy,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: enabled ? onTap : null,
            child: Center(
              child: saving
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : const Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
