import 'package:flutter/material.dart';

import '../assets_manifest.dart';
import '../navigation/fade_route.dart';
import '../widgets/design_canvas.dart';
import 'dashboard_screen.dart';

// Brief branded loading screen shown after onboarding (or directly, on
// repeat launches), before handing off to the real app in DashboardScreen.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Preloaded by SplashScreen before it navigates here, so the page never
  // pops in with missing images.
  static const List<String> assetPaths = [
    'lib/assets/images/logo.png',
    'lib/assets/images/wood.png',
    'lib/assets/images/tape.png',
    'lib/assets/images/ruler.png',
    'lib/assets/images/pencil.png',
    'lib/assets/images/loading-aa.png',
    'lib/assets/images/loading-abb.png',
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _navigated = false;
  bool _animationDone = false;
  bool _appAssetsReady = false;
  bool _precacheStarted = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(_loadingAnimDuration, () {
      _animationDone = true;
      _maybeGoToDashboard();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_precacheStarted) {
      _precacheStarted = true;
      _precacheAllAppAssets();
    }
  }

  // Waits on every image the app can show anywhere, not just the next
  // page's, so this loading step reflects the whole app being ready.
  Future<void> _precacheAllAppAssets() async {
    final paths = {...HomeScreen.assetPaths, ...allAppAssetPaths};
    await Future.wait([
      for (final path in paths) precacheImage(AssetImage(path), context),
    ]);
    if (!mounted) return;
    _appAssetsReady = true;
    _maybeGoToDashboard();
  }

  void _maybeGoToDashboard() {
    if (!mounted || _navigated || !_animationDone || !_appAssetsReady) return;
    _navigated = true;
    Navigator.of(
      context,
    ).pushReplacement(fadeRoute((_) => const DashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return DesignCanvas(
      width: 409,
      height: 849,
      backgroundColor: const Color(0xFF0E2551),
      children: [
        Positioned(
          left: 89,
          top: 65,
          child: Image.asset(
            'lib/assets/images/logo.png',
            width: 232,
            height: 221,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 48,
          top: 286,
          child: SizedBox(
            width: 314,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'SUKA',
                    style: TextStyle(
                      color: const Color(0xFFFFAA02),
                      fontSize: 48,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.44,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          color: const Color(
                            0xFFFFFFFF,
                          ).withValues(alpha: 0.25),
                        ),
                      ],
                    ),
                  ),
                  TextSpan(
                    text: ' TECH',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 48,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.44,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 4),
                          blurRadius: 4,
                          color: const Color(
                            0xFFFFFFFF,
                          ).withValues(alpha: 0.25),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const Positioned(
          left: 79,
          top: 345,
          child: Text(
            'Measure. Learn. Build.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.w400,
              letterSpacing: 0.72,
            ),
          ),
        ),
        Positioned(
          left: -1,
          top: 490,
          child: Image.asset(
            'lib/assets/images/wood.png',
            width: 410,
            height: 452,
            fit: BoxFit.cover,
          ),
        ),
        const Positioned(
          left: 135,
          top: 687,
          child: SizedBox(
            width: 139,
            height: 27,
            child: Text(
              'Loading...',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 19,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                letterSpacing: 0.57,
              ),
            ),
          ),
        ),
        Positioned(
          left: -12,
          top: 446,
          child: Image.asset(
            'lib/assets/images/tape.png',
            width: 258,
            height: 170,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 82,
          top: 408,
          child: Image.asset(
            'lib/assets/images/ruler.png',
            width: 328,
            height: 169,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          left: 220,
          top: 531,
          child: Image.asset(
            'lib/assets/images/pencil.png',
            width: 202,
            height: 115,
            fit: BoxFit.cover,
          ),
        ),
        const _LoadingBarCrop(),
        const _LoadingDot(),
      ],
    );
  }
}

const Duration _loadingAnimDuration = Duration(milliseconds: 1100);
const Curve _loadingAnimCurve = Curves.easeInOut;

// Reveals the loading bar left-to-right, then stops (plays once).
class _LoadingBarCrop extends StatefulWidget {
  const _LoadingBarCrop();

  @override
  State<_LoadingBarCrop> createState() => _LoadingBarCropState();
}

class _LoadingBarCropState extends State<_LoadingBarCrop>
    with SingleTickerProviderStateMixin {
  static const double _left = 48;
  static const double _top = 729;
  static const double _width = 272;
  static const double _height = 20;

  late final AnimationController _controller;
  late final Animation<double> _reveal;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _loadingAnimDuration,
    )..forward();
    _reveal = CurvedAnimation(parent: _controller, curve: _loadingAnimCurve);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _left,
      top: _top,
      width: _width,
      height: _height,
      child: AnimatedBuilder(
        animation: _reveal,
        builder: (context, child) => ClipRect(
          child: Align(
            alignment: Alignment.centerLeft,
            widthFactor: _reveal.value,
            child: child,
          ),
        ),
        child: Image.asset(
          'lib/assets/images/loading-aa.png',
          width: _width,
          height: _height,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// Slides the loading indicator into its original place, then stops (plays once).
class _LoadingDot extends StatefulWidget {
  const _LoadingDot();

  @override
  State<_LoadingDot> createState() => _LoadingDotState();
}

class _LoadingDotState extends State<_LoadingDot>
    with SingleTickerProviderStateMixin {
  static const double _startLeft = 48;
  static const double _originalLeft = 304;
  static const double _top = 720;
  static const double _width = 78;
  static const double _height = 39;

  late final AnimationController _controller;
  late final Animation<double> _left;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _loadingAnimDuration,
    )..forward();
    _left = Tween<double>(
      begin: _startLeft,
      end: _originalLeft,
    ).animate(CurvedAnimation(parent: _controller, curve: _loadingAnimCurve));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _left,
      builder: (context, child) =>
          Positioned(left: _left.value, top: _top, child: child!),
      child: Image.asset(
        'lib/assets/images/loading-abb.png',
        width: _width,
        height: _height,
        fit: BoxFit.cover,
      ),
    );
  }
}
