import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A shimmering placeholder box shown wherever real content isn't ready
/// yet. Use directly for arbitrary content, or via [SkeletonImage] /
/// [SkeletonSvg] to wrap an asset.
class SkeletonBox extends StatefulWidget {
  const SkeletonBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<SkeletonBox> createState() => _SkeletonBoxState();
}

class _SkeletonBoxState extends State<SkeletonBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final sweep = _controller.value;
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment(-1 + 2 * sweep, 0),
              end: Alignment(1 + 2 * sweep, 0),
              colors: const [Color(0xFFE4E4E4), Color(0xFFF4F4F4), Color(0xFFE4E4E4)],
              stops: const [0.25, 0.5, 0.75],
            ),
          ),
        );
      },
    );
  }
}

/// [Image.asset] with a [SkeletonBox] shown until the first frame has
/// actually decoded, instead of leaving blank space.
class SkeletonImage extends StatelessWidget {
  const SkeletonImage(
    this.assetPath, {
    super.key,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
    this.borderRadius = 8,
  });

  final String assetPath;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) return child;
        return SkeletonBox(width: width, height: height, borderRadius: borderRadius);
      },
    );
  }
}

/// [SvgPicture.asset] with a [SkeletonBox] shown until the vector has
/// finished parsing, instead of leaving blank space.
class SkeletonSvg extends StatelessWidget {
  const SkeletonSvg(
    this.assetPath, {
    super.key,
    required this.width,
    required this.height,
    this.fit = BoxFit.contain,
    this.borderRadius = 8,
  });

  final String assetPath;
  final double width;
  final double height;
  final BoxFit fit;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      placeholderBuilder: (context) =>
          SkeletonBox(width: width, height: height, borderRadius: borderRadius),
    );
  }
}
