import 'package:flutter/material.dart';

import '../widgets/design_canvas.dart';
import '../widgets/skeleton.dart';

/// Shown in place of any screen that hasn't been built yet. Has no bottom
/// nav on purpose — the only way out is back to whatever screen sent you
/// here.
class UnderDevelopmentScreen extends StatelessWidget {
  const UnderDevelopmentScreen({super.key, this.title = 'No page'});

  final String title;

  static const _navy = Color(0xFF061D3F);

  @override
  Widget build(BuildContext context) {
    return DesignCanvas(
      width: 409,
      height: 849,
      backgroundColor: Colors.white,
      children: [
        Positioned(
          left: 0,
          top: 0,
          child: Container(width: 409, height: 122, color: _navy),
        ),
        Positioned(
          left: 16,
          top: 60,
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 70,
          child: SizedBox(
            width: 409,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.66,
              ),
            ),
          ),
        ),
        const Positioned(
          left: 123,
          top: 275,
          child: SkeletonImage(
            'lib/assets/images/settings.png',
            width: 165,
            height: 170,
          ),
        ),
        const Positioned(
          left: 69,
          top: 460,
          child: SizedBox(
            width: 272,
            child: Text(
              'The page is not developed yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _navy,
                fontSize: 24,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w700,
                letterSpacing: 0.72,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
