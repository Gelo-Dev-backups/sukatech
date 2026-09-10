import 'package:flutter/material.dart';

/// Scales a fixed-size Figma frame to fill any device screen, so screens
/// built from a design export don't each repeat the same scaffolding.
class DesignCanvas extends StatelessWidget {
  const DesignCanvas({
    super.key,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.children,
  });

  final double width;
  final double height;
  final Color backgroundColor;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: width,
            height: height,
            child: Stack(children: children),
          ),
        ),
      ),
    );
  }
}
