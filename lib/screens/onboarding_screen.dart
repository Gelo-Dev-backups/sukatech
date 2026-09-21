import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../navigation/fade_route.dart';
import '../widgets/design_canvas.dart';
import 'about_screen.dart';
import 'home_screen.dart';

// First-run intro screen. Shown once; SplashScreen decides whether to route
// here or straight to HomeScreen based on [prefsKey].
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  static const String prefsKey = 'onboarding_complete';

  static const List<String> assetPaths = [
    'lib/assets/images/MAIN LOGO.png',
    'lib/assets/images/l and c.png',
    'lib/assets/images/onboard ruler.png',
    'lib/assets/images/Folding Rule.png',
    'lib/assets/images/no wifi.svg',
  ];

  static const _navy = Color(0xFF0E2551);
  static const _brandTextStyle = TextStyle(
    fontSize: 40,
    fontFamily: 'Montserrat',
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
  );

  static Future<void> _completeOnboarding(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(prefsKey, true);
    if (!context.mounted) return;
    Navigator.of(context).pushReplacement(fadeRoute((_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return DesignCanvas(
      width: 409,
      height: 849,
      backgroundColor: Colors.white,
      children: [
        Positioned(
          left: 57,
          top: 70,
          child: Image.asset(
            'lib/assets/images/MAIN LOGO.png',
            width: 55,
            height: 52,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          left: 85,
          top: 70,
          child: SizedBox(
            width: 297,
            height: 59,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'SUKA',
                    style: _brandTextStyle.copyWith(color: _navy),
                  ),
                  TextSpan(
                    text: 'TECH',
                    style: _brandTextStyle.copyWith(
                      color: const Color(0xFFFFA500),
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 95,
          top: 138,
          child: Text(
            'Learn Carpentry\nMeasurement Skills\nAnywhere, Anytime!',
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
        Positioned(
          left: 100,
          top: 280,
          child: Image.asset(
            'lib/assets/images/onb1.png',
            width: 342,
            height: 186,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          left: 19,
          top: 385,
          child: Image.asset(
            'lib/assets/images/onb2.png',
            width: 342,
            height: 186,
            fit: BoxFit.contain,
          ),
        ),
        Positioned(
          left: 32.25,
          top: 280,
          child: Transform.rotate(
            angle: 0.09,
            child: Image.asset(
              'lib/assets/images/tape.png',
              width: 234.15,
              height: 153.98,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Positioned(
          left: 0,
          top: 721,
          child: Container(
            width: 409,
            height: 160,
            color: const Color(0xFF061D3F),
          ),
        ),
        Positioned(
          left: 35,
          top: 752,
          child: SizedBox(
            width: 60,
            height: 55,
            child: Center(
              child: SvgPicture.asset(
                'lib/assets/images/no wifi.svg',
                width: 40,
                height: 36,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        const Positioned(
          left: 108,
          top: 757,
          child: Text(
            'No Internet Required',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w700,
              letterSpacing: 0.57,
            ),
          ),
        ),
        const Positioned(
          left: 108,
          top: 785,
          child: Text(
            'All content available offline',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w600,
              letterSpacing: 0.54,
            ),
          ),
        ),
        Positioned(
          left: 30,
          top: 570,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _completeOnboarding(context),
            child: Container(
              width: 351,
              decoration: BoxDecoration(
                color: const Color(0xFFFBC235),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  'START LEARNING',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _navy,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.60,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          left: 30,
          top: 645,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).push(
              fadeRoute((_) => const AboutScreen()),
            ),
            child: Container(
              width: 351,
              decoration: BoxDecoration(
                border: Border.all(color: _navy, width: 1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Text(
                  'ABOUT SUKATECH',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: _navy,
                    fontSize: 20,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.60,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
