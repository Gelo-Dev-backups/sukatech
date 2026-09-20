import 'package:flutter/material.dart';

import '../widgets/skeleton.dart';

/// Full-screen "About SUKATECH" page. Opened from the Profile settings row.
/// Uses a plain Scaffold (not DesignCanvas) so the content can scroll freely
/// while still matching the app's Montserrat / navy palette exactly.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _navy = Color(0xFF061D3F);
  static const _green = Color(0xFF05831C);
  static const _amber = Color(0xFFF59E0B);
  static const _lightBg = Color(0xFFF4F6FA);

  static const _displayStyle = TextStyle(
    color: Colors.white,
    fontSize: 28,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
    height: 1.15,
  );

  static const _taglineStyle = TextStyle(
    color: Color(0xCCFFFFFF),
    fontSize: 13,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    letterSpacing: 0.8,
    height: 1.4,
  );

  static const _sectionTitle = TextStyle(
    color: _navy,
    fontSize: 16,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    letterSpacing: 0.5,
  );

  static const _bodyStyle = TextStyle(
    color: Color(0xFF374151),
    fontSize: 14,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w500,
    height: 1.6,
    letterSpacing: 0.2,
  );

  static const _metaLabel = TextStyle(
    color: Color(0xFF6B7280),
    fontSize: 12,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static const _metaValue = TextStyle(
    color: _navy,
    fontSize: 13,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w700,
    letterSpacing: 0.3,
  );

  static const _features = [
    (
      icon: Icons.menu_book_rounded,
      color: Color(0xFF061D3F),
      title: '6 Structured Lessons',
      sub: 'From tools to calculations — step by step.',
    ),
    (
      icon: Icons.quiz_rounded,
      color: Color(0xFF7C3AED),
      title: 'Interactive Quizzes',
      sub: 'Test your knowledge after every lesson.',
    ),
    (
      icon: Icons.architecture_rounded,
      color: Color(0xFFD97706),
      title: 'Practice Mode',
      sub: 'Reinforce skills with hands-on exercises.',
    ),
    (
      icon: Icons.sync_alt_rounded,
      color: Color(0xFF0284C7),
      title: 'Unit Converter',
      sub: 'Instant metric / English / lumber conversions.',
    ),
    (
      icon: Icons.emoji_events_rounded,
      color: Color(0xFFF59E0B),
      title: 'Achievements',
      sub: 'Earn badges as you master each topic.',
    ),
    (
      icon: Icons.trending_up_rounded,
      color: Color(0xFF05831C),
      title: 'Progress Tracking',
      sub: 'Your learning journey, saved automatically.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: _navy,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _HeaderBanner(),
            ),
            title: const Text(
              'About SukaTech',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            titleSpacing: 0,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _green.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.lightbulb_rounded,
                                color: _green,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Our Mission', style: _sectionTitle),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'SukaTech is a mobile learning application designed to help '
                          'carpentry students and vocational learners master the fundamentals '
                          'of measurement — from reading a steel rule to calculating board feet.\n\n'
                          'Our goal is to make technical education engaging, accessible, '
                          'and fun through bite-sized lessons, real-world examples, and '
                          'instant feedback.',
                          style: _bodyStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text("What's Inside", style: _sectionTitle),
                  const SizedBox(height: 14),
                  ..._features.map(
                    (f) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _FeatureTile(
                        icon: f.icon,
                        color: f.color,
                        title: f.title,
                        subtitle: f.sub,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    child: Column(
                      children: [
                        _InfoRow(label: 'App Version', value: '1.0.0'),
                        _Divider(),
                        _InfoRow(label: 'Platform', value: 'Android / iOS'),
                        _Divider(),
                        _InfoRow(label: 'Subject Area', value: 'Carpentry TLE'),
                        _Divider(),
                        _InfoRow(label: 'Target Learners', value: 'Grades 7–10'),
                        _Divider(),
                        _InfoRow(label: 'Language', value: 'English / Filipino'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _SectionCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: _amber.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.favorite_rounded,
                                color: _amber,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text('Built With Care', style: _sectionTitle),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'SukaTech was crafted with dedication to empower the next '
                          'generation of Filipino craftspeople. Every lesson, quiz, and '
                          'tool in this app was designed with the learner in mind.\n\n'
                          'Built with Flutter · Powered by SQLite · Made in the Philippines 🇵🇭',
                          style: _bodyStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: const SkeletonImage(
                            'lib/assets/images/MAIN LOGO.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'SukaTech',
                          style: TextStyle(
                            color: _navy,
                            fontSize: 18,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '© ${DateTime.now().year} All rights reserved.',
                          style: _metaLabel,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF061D3F), Color(0xFF0D3270), Color(0xFF061D3F)],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -40,
            top: -30,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          Positioned(
            left: -30,
            bottom: -20,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: const SkeletonImage(
                        'lib/assets/images/MAIN LOGO.png',
                        width: 72,
                        height: 72,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('SUKATECH', style: AboutScreen._displayStyle),
                  const SizedBox(height: 6),
                  const Text(
                    'SUKA SA TEKNIK · LEARN MEASUREMENT LIKE A PRO',
                    style: AboutScreen._taglineStyle,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                      ),
                    ),
                    child: const Text(
                      'Version 1.0.0',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _FeatureTile extends StatelessWidget {
  const _FeatureTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.30),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AboutScreen._navy,
                    fontSize: 14,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AboutScreen._metaLabel),
          Text(value, style: AboutScreen._metaValue),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: const Color(0x18000000));
  }
}
