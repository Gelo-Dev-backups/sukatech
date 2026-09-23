import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../models/tutorial_step.dart';
import '../services/sound_service.dart';

/// Interactive spotlight onboarding overlay that guides new users through
/// key interface elements on a page.
///
/// Designed to sit directly inside a [DesignCanvas] stack (409 x 849) or
/// overlay tree, rendering an animated spotlight cutout, pulsing golden halo,
/// bouncing directional pointer arrow, and a floating instructional card.
class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({
    super.key,
    required this.steps,
    required this.onFinish,
    required this.onSkip,
    this.canvasWidth = 409.0,
    this.canvasHeight = 849.0,
  });

  /// The list of steps to present in sequence.
  final List<TutorialStep> steps;

  /// Invoked when the user completes the final step.
  final VoidCallback onFinish;

  /// Invoked if the user skips the tour.
  final VoidCallback onSkip;

  final double canvasWidth;
  final double canvasHeight;

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with TickerProviderStateMixin {
  int _currentIndex = 0;

  // Breathing pulse animation for the halo around the target.
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // Bouncing bob animation for the directional arrow.
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnimation;

  // Smooth transition between steps.
  late final AnimationController _stepTransitionController;
  late final Animation<double> _stepFadeAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _bounceAnimation = Tween<double>(begin: -4.0, end: 4.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );

    _stepTransitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: 1.0,
    );
    _stepFadeAnimation = CurvedAnimation(
      parent: _stepTransitionController,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _bounceController.dispose();
    _stepTransitionController.dispose();
    super.dispose();
  }

  TutorialStep get _currentStep => widget.steps[_currentIndex];

  void _nextStep() {
    if (_currentIndex < widget.steps.length - 1) {
      _stepTransitionController.reverse().then((_) {
        if (!mounted) return;
        setState(() {
          _currentIndex++;
        });
        _stepTransitionController.forward();
      });
    } else {
      _finish();
    }
  }

  void _previousStep() {
    if (_currentIndex > 0) {
      _stepTransitionController.reverse().then((_) {
        if (!mounted) return;
        setState(() {
          _currentIndex--;
        });
        _stepTransitionController.forward();
      });
    }
  }

  void _finish() {
    SoundService.instance.playGainXp();
    widget.onFinish();
  }

  void _skip() {
    widget.onSkip();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.steps.isEmpty) return const SizedBox.shrink();

    final step = _currentStep;
    final paddedRect = step.paddedRect;

    // Determine card positioning: place above or below the target.
    final bool placeBelow;
    if (step.preferredPosition == TutorialCardPosition.below) {
      placeBelow = true;
    } else if (step.preferredPosition == TutorialCardPosition.above) {
      placeBelow = false;
    } else {
      // Auto: if target center is in the upper half of canvas, place below.
      placeBelow = paddedRect.center.dy < (widget.canvasHeight * 0.52);
    }

    const double cardWidth = 365.0;
    const double cardLeft = 22.0; // (409 - 365) / 2 = 22.0
    const double cardHeight = 205.0;

    final double cardTop;
    final double arrowTop;
    final bool arrowPointsUp;

    if (placeBelow) {
      // Card is below the target; arrow sits at top of card pointing UP to target.
      cardTop = math.min(
        paddedRect.bottom + 22.0,
        widget.canvasHeight - cardHeight - 16.0,
      );
      arrowTop = cardTop - 14.0;
      arrowPointsUp = true;
    } else {
      // Card is above the target; arrow sits at bottom of card pointing DOWN to target.
      cardTop = math.max(16.0, paddedRect.top - cardHeight - 22.0);
      arrowTop = cardTop + cardHeight - 2.0;
      arrowPointsUp = false;
    }

    // Arrow X is centered on target X, clamped to within the card boundaries.
    final double arrowLeft = (paddedRect.center.dx - 14.0).clamp(
      cardLeft + 24.0,
      cardLeft + cardWidth - 52.0,
    );

    return Positioned.fill(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _pulseAnimation,
          _bounceAnimation,
          _stepFadeAnimation,
        ]),
        builder: (context, _) {
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Dark spotlight scrim with punched-out hole for target
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: _nextStep,
                  child: CustomPaint(
                    painter: _SpotlightPainter(
                      step: step,
                      canvasWidth: widget.canvasWidth,
                      canvasHeight: widget.canvasHeight,
                    ),
                  ),
                ),
              ),

              // Animated glowing halo ring around the target
              Positioned.fromRect(
                rect: paddedRect,
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _HaloPainter(
                      shape: step.shape,
                      borderRadius: step.borderRadius,
                      pulse: _pulseAnimation.value,
                    ),
                  ),
                ),
              ),

              // Bouncing directional arrow
              Positioned(
                left: arrowLeft,
                top: arrowTop + (arrowPointsUp ? -_bounceAnimation.value : _bounceAnimation.value),
                child: IgnorePointer(
                  child: CustomPaint(
                    size: const Size(28, 16),
                    painter: _ArrowPainter(
                      pointsUp: arrowPointsUp,
                      color: const Color(0xFFFFA500),
                    ),
                  ),
                ),
              ),

              // Floating instructional tooltip card
              Positioned(
                left: cardLeft,
                top: cardTop,
                width: cardWidth,
                child: FadeTransition(
                  opacity: _stepFadeAnimation,
                  child: _FloatingCard(
                    step: step,
                    currentIndex: _currentIndex,
                    totalSteps: widget.steps.length,
                    onNext: _nextStep,
                    onPrevious: _previousStep,
                    onSkip: _skip,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Paints the semi-transparent navy scrim with a cutout spotlight over the target.
class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({
    required this.step,
    required this.canvasWidth,
    required this.canvasHeight,
  });

  final TutorialStep step;
  final double canvasWidth;
  final double canvasHeight;

  @override
  void paint(Canvas canvas, Size size) {
    final scrimPaint = Paint()
      ..color = const Color(0xE0061D3F) // Deep Sukatech navy with 88% opacity
      ..style = PaintingStyle.fill;

    final canvasRect = Rect.fromLTWH(0, 0, canvasWidth, canvasHeight);
    final canvasPath = Path()..addRect(canvasRect);

    final padded = step.paddedRect;
    final Path cutoutPath = Path();

    switch (step.shape) {
      case TutorialTargetShape.circle:
        cutoutPath.addOval(padded);
        break;
      case TutorialTargetShape.roundedRect:
        cutoutPath.addRRect(
          RRect.fromRectAndRadius(padded, Radius.circular(step.borderRadius)),
        );
        break;
      case TutorialTargetShape.rect:
        cutoutPath.addRect(padded);
        break;
    }

    final combinedPath = Path.combine(
      PathOperation.difference,
      canvasPath,
      cutoutPath,
    );

    canvas.drawPath(combinedPath, scrimPaint);
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) {
    return oldDelegate.step != step;
  }
}

/// Paints an animated breathing halo / glowing border around the cutout.
class _HaloPainter extends CustomPainter {
  _HaloPainter({
    required this.shape,
    required this.borderRadius,
    required this.pulse,
  });

  final TutorialTargetShape shape;
  final double borderRadius;
  final double pulse; // 0.0 -> 1.0

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);

    // Outer glow
    final glowPaint = Paint()
      ..color = Color.lerp(
        const Color(0x60FFA500),
        const Color(0xB0FBC235),
        pulse,
      )!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 + (pulse * 3.5)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4.0 + (pulse * 4.0));

    // Crisp inner border
    final borderPaint = Paint()
      ..color = Color.lerp(
        const Color(0xFFFFA500),
        const Color(0xFFFFCC44),
        pulse,
      )!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    switch (shape) {
      case TutorialTargetShape.circle:
        canvas.drawOval(rect, glowPaint);
        canvas.drawOval(rect, borderPaint);
        break;
      case TutorialTargetShape.roundedRect:
        final rrect = RRect.fromRectAndRadius(rect, Radius.circular(borderRadius));
        canvas.drawRRect(rrect, glowPaint);
        canvas.drawRRect(rrect, borderPaint);
        break;
      case TutorialTargetShape.rect:
        canvas.drawRect(rect, glowPaint);
        canvas.drawRect(rect, borderPaint);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _HaloPainter oldDelegate) {
    return oldDelegate.pulse != pulse ||
        oldDelegate.shape != shape ||
        oldDelegate.borderRadius != borderRadius;
  }
}

/// Directional pointer arrow that points towards the target.
class _ArrowPainter extends CustomPainter {
  _ArrowPainter({required this.pointsUp, required this.color});

  final bool pointsUp;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = color.withValues(alpha: 0.45)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

    final path = Path();
    if (pointsUp) {
      // Tip points UP (toward target above the card)
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
    } else {
      // Tip points DOWN (toward target below the card)
      path.moveTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
      path.close();
    }

    canvas.drawPath(path, shadowPaint);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.pointsUp != pointsUp || oldDelegate.color != color;
  }
}

/// The modern, sleek floating card with step counter, headline, body,
/// step progress dots, Back button, and Next/Finish action.
class _FloatingCard extends StatelessWidget {
  const _FloatingCard({
    required this.step,
    required this.currentIndex,
    required this.totalSteps,
    required this.onNext,
    required this.onPrevious,
    required this.onSkip,
  });

  final TutorialStep step;
  final int currentIndex;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onSkip;

  static const _navy = Color(0xFF061D3F);
  static const _accentGold = Color(0xFFFFA500);

  @override
  Widget build(BuildContext context) {
    final isLast = currentIndex == totalSteps - 1;
    final actionLabel = step.actionText ?? (isLast ? 'Got It! 🎉' : 'Next');

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFFFA500).withValues(alpha: 0.8),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: _accentGold.withValues(alpha: 0.30),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row: Step pill & Skip button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [_navy, Color(0xFF0F326A)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(step.icon, size: 13, color: _accentGold),
                    const SizedBox(width: 5),
                    Text(
                      'STEP ${currentIndex + 1} OF $totalSteps',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onSkip,
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Text(
                    'Skip Tour',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 12,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            step.title,
            style: const TextStyle(
              color: _navy,
              fontSize: 17,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 5),

          // Description
          Text(
            step.description,
            style: const TextStyle(
              color: Color(0xFF334155),
              fontSize: 13,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w500,
              height: 1.35,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 14),

          // Bottom Controls: Progress dots + Navigation buttons
          Row(
            children: [
              // Progress dots
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(totalSteps, (index) {
                  final active = index == currentIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.only(right: 4),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? _accentGold : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              const Spacer(),

              // Back button (if step > 0)
              if (currentIndex > 0) ...[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onPrevious,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: const Color(0xFFCBD5E1)),
                    ),
                    child: const Text(
                      'Back',
                      style: TextStyle(
                        color: _navy,
                        fontSize: 12,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],

              // Next / Got It button
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onNext,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFC837), Color(0xFFFF9900)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9900).withValues(alpha: 0.40),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    actionLabel,
                    style: const TextStyle(
                      color: _navy,
                      fontSize: 13,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
