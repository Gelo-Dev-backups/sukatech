import 'package:flutter/material.dart';

/// A smooth, cleanly animated progress bar that interpolates
/// its progress value whenever it changes.
class AnimatedProgressBar extends StatelessWidget {
  const AnimatedProgressBar({
    super.key,
    required this.value,
    this.minHeight = 6,
    this.borderRadius = 8,
    this.backgroundColor = Colors.white24,
    this.progressColor = const Color(0xFF05831C),
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
  });

  final double value;
  final double minHeight;
  final double borderRadius;
  final Color backgroundColor;
  final Color progressColor;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final clamped = value.clamp(0.0, 1.0);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: clamped),
        duration: duration,
        curve: curve,
        builder: (context, animatedValue, _) {
          return LinearProgressIndicator(
            value: animatedValue,
            minHeight: minHeight,
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          );
        },
      ),
    );
  }
}

/// An animated progress bar tailored for lesson step navigation.
class AnimatedLessonProgressBar extends StatelessWidget {
  const AnimatedLessonProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.width = 356,
    this.height = 11,
    this.backgroundColor = const Color(0xBAD9D9D9),
    this.progressColor = const Color(0xFF05831C),
    this.duration = const Duration(milliseconds: 350),
    this.curve = Curves.easeOutCubic,
  });

  final int currentStep;
  final int totalSteps;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color progressColor;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final factor = totalSteps > 0
        ? (currentStep / totalSteps).clamp(0.0, 1.0)
        : 0.0;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: AnimatedFractionallySizedBox(
          duration: duration,
          curve: curve,
          alignment: Alignment.centerLeft,
          widthFactor: factor,
          child: Container(
            height: height,
            decoration: BoxDecoration(
              color: progressColor,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ),
    );
  }
}
