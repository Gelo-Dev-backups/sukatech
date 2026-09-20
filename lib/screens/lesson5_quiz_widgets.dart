part of 'lesson5_quiz_screen.dart';

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final _QType type;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (type) {
      _QType.concept => ('Concepts', Icons.lightbulb_outline_rounded, const Color(0xFF1565C0)),
      _QType.englishToEnglish => ('English Conversion', Icons.straighten_rounded, const Color(0xFF00695C)),
      _QType.metricToMetric => ('Metric Conversion', Icons.architecture_rounded, const Color(0xFF6A1B9A)),
      _QType.englishToMetric => ('System Conversion', Icons.sync_alt_rounded, const Color(0xFFE65100)),
      _QType.application => ('Application', Icons.build_rounded, const Color(0xFF2E7D32)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
