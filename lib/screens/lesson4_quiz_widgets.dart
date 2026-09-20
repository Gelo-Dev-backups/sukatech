part of 'lesson4_quiz_screen.dart';

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});
  final _QType type;

  @override
  Widget build(BuildContext context) {
    final (label, icon, color) = switch (type) {
      _QType.englishScale => ('English Scale', Icons.straighten_rounded, const Color(0xFF1565C0)),
      _QType.metricScale => ('Metric Scale', Icons.architecture_rounded, const Color(0xFF00695C)),
      _QType.vernierCaliper => ('Vernier Caliper', Icons.search_rounded, const Color(0xFF6A1B9A)),
      _QType.trySquare => ('Try Square', Icons.crop_square_rounded, const Color(0xFFE65100)),
      _QType.generalReading => ('Knowledge Check', Icons.check_circle_outline_rounded, const Color(0xFF2E7D32)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
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
