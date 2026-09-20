import 'package:flutter/material.dart';

class QuizStyles {
  static const navy = Color(0xFF061D3F);
  static const accent = Color(0xFFFFA500);
  static const green = Color(0xFF05831C);
  static const red = Color(0xFFD32F2F);
  static const montserrat = 'Montserrat';
}

class QuizChoices extends StatelessWidget {
  const QuizChoices({
    super.key,
    required this.choices,
    required this.correctIndex,
    required this.selected,
    required this.onTap,
  });

  final List<String> choices;
  final int correctIndex;
  final int? selected;
  final void Function(int) onTap;

  static const _letters = ['A', 'B', 'C', 'D', 'E', 'F'];

  @override
  Widget build(BuildContext context) {
    final answered = selected != null;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(choices.length, (i) {
        final isCorrect = i == correctIndex;
        final isSelected = selected == i;

        Color bgColor = Colors.white;
        Color borderColor = const Color(0xFFDDE0E8);
        Color textColor = QuizStyles.navy;
        Color letterBg = QuizStyles.navy.withValues(alpha: 0.08);
        Color letterColor = QuizStyles.navy.withValues(alpha: 0.5);
        Widget? trail;

        if (answered) {
          if (isCorrect) {
            bgColor = QuizStyles.green.withValues(alpha: 0.08);
            borderColor = QuizStyles.green;
            textColor = QuizStyles.green;
            letterBg = QuizStyles.green;
            letterColor = Colors.white;
            trail = const Icon(Icons.check_circle_rounded,
                color: QuizStyles.green, size: 20);
          } else if (isSelected) {
            bgColor = QuizStyles.red.withValues(alpha: 0.08);
            borderColor = QuizStyles.red;
            textColor = QuizStyles.red;
            letterBg = QuizStyles.red;
            letterColor = Colors.white;
            trail =
                const Icon(Icons.cancel_rounded, color: QuizStyles.red, size: 20);
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: borderColor,
                width: answered && (isCorrect || isSelected) ? 1.8 : 1.2,
              ),
              boxShadow: !answered
                  ? [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                onTap: answered ? null : () => onTap(i),
                borderRadius: BorderRadius.circular(14),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 13),
                  child: Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: letterBg,
                        ),
                        child: Center(
                          child: Text(
                            _letters[i],
                            style: TextStyle(
                              color: letterColor,
                              fontSize: 13,
                              fontFamily: QuizStyles.montserrat,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          choices[i],
                          style: TextStyle(
                            color: textColor,
                            fontSize: 14,
                            fontFamily: QuizStyles.montserrat,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (trail != null) trail,
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class QuizSubmitBtn extends StatelessWidget {
  const QuizSubmitBtn({super.key, required this.enabled, required this.onTap});
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: enabled ? 1 : 0.4,
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: const Color(0xFF6A1B9A),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            alignment: Alignment.center,
            child: const Text(
              'CHECK MY ANSWERS',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: QuizStyles.montserrat,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class QuizFeedbackPanel extends StatelessWidget {
  const QuizFeedbackPanel({
    super.key,
    required this.isCorrect,
    required this.explanation,
  });
  final bool isCorrect;
  final String explanation;

  @override
  Widget build(BuildContext context) {
    final color = isCorrect ? QuizStyles.green : QuizStyles.red;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.30), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isCorrect ? '✓  Correct!' : '✗  Not quite.',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontFamily: QuizStyles.montserrat,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            explanation,
            style: TextStyle(
              color: QuizStyles.navy.withValues(alpha: 0.75),
              fontSize: 12,
              fontFamily: QuizStyles.montserrat,
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class QuizNextBtn extends StatelessWidget {
  const QuizNextBtn({super.key, required this.isLast, required this.onTap});
  final bool isLast;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: QuizStyles.navy,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isLast ? 'SEE RESULTS' : 'NEXT QUESTION',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: QuizStyles.montserrat,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                isLast
                    ? Icons.emoji_events_rounded
                    : Icons.arrow_forward_rounded,
                color: QuizStyles.accent,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class QuizResultChip extends StatelessWidget {
  const QuizResultChip({
    super.key,
    required this.label,
    required this.value,
    required this.color,
  });
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontFamily: QuizStyles.montserrat,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.65),
              fontSize: 11,
              fontFamily: QuizStyles.montserrat,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class QuizPrimaryBtn extends StatelessWidget {
  const QuizPrimaryBtn({
    super.key,
    required this.label,
    required this.bgColor,
    required this.fgColor,
    required this.onTap,
    this.borderColor,
  });

  final String label;
  final Color bgColor;
  final Color fgColor;
  final VoidCallback onTap;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 50,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: borderColor != null
                ? Border.all(color: borderColor!, width: 1.5)
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: fgColor,
              fontSize: 14,
              fontFamily: QuizStyles.montserrat,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
