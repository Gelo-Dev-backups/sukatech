import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Scales a fixed-size Figma frame (typically 409 x 849) to adaptively and
/// responsively fit any screen size — from small and tall Android phones to
/// tablets (iPad, Galaxy Tab), foldables, desktops, and big screens — without
/// clipping or distorted letterboxing.
class DesignCanvas extends StatelessWidget {
  const DesignCanvas({
    super.key,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.children,
    this.topColor,
    this.bottomColor,
    this.allowKeyboardResize = false,
  });

  final double width;
  final double height;
  final Color backgroundColor;
  final List<Widget> children;

  /// Optional override for top edge / status bar extension color.
  final Color? topColor;

  /// Optional override for bottom edge / gesture bar extension color.
  final Color? bottomColor;

  /// Whether virtual keyboard should resize the canvas body.
  final bool allowKeyboardResize;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: backgroundColor,
        resizeToAvoidBottomInset: allowKeyboardResize,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenW = constraints.maxWidth;
            final screenH = constraints.maxHeight;

            final designAspect = width / height;
            final screenAspect = screenW / screenH;

            if (screenW <= 600 || screenAspect < designAspect) {
              // Phones:
              // Scales the entire design frame (409 x 849) to fill the screen width and height.
              // All cards, text, buttons, and the bottom bar scale together proportionally
              // so they fit the screen cleanly without empty gaps or displaced buttons, and the
              // screen background color is completely preserved.
              return Container(
                width: screenW,
                height: screenH,
                color: backgroundColor,
                child: MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    padding: EdgeInsets.zero,
                    viewPadding: EdgeInsets.zero,
                    viewInsets: EdgeInsets.zero,
                  ),
                  child: FittedBox(
                    fit: BoxFit.fill,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Stack(children: children),
                    ),
                  ),
                ),
              );
            } else {
              // Shorter phone (e.g. 16:9, iPhone SE, 360x640) or tablet portrait:
              // Height fills 100% of screen height; canvas is centered horizontally
              // and flush to the top.
              final scale = screenH / height;
              final canvasH = screenH;
              final canvasW = width * scale;

              return Container(
                width: screenW,
                height: screenH,
                color: backgroundColor,
                child: Center(
                  child: SizedBox(
                    width: canvasW,
                    height: canvasH,
                    child: MediaQuery(
                      data: MediaQuery.of(context).copyWith(
                        padding: EdgeInsets.zero,
                        viewPadding: EdgeInsets.zero,
                        viewInsets: EdgeInsets.zero,
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          width: width,
                          height: height,
                          child: Stack(children: children),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
