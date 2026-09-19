import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import '../assets_manifest.dart';
import '../navigation/fade_route.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final VideoPlayerController _controller;
  bool _navigated = false;
  bool _videoReady = false;
  bool _nextScreenReady = false;
  bool _precacheStarted = false;
  WidgetBuilder? _nextScreenBuilder;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('lib/assets/splash_video/splash.mp4')
          ..initialize().then((_) {
            setState(() {});
            _controller.play();
          })
          ..addListener(_onVideoTick);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Kick off preloading of the next page's assets as soon as we have a
    // BuildContext. The splash won't hand off until this actually finishes,
    // so the load time now reflects real work instead of a fixed timer.
    if (!_precacheStarted) {
      _precacheStarted = true;
      _prepareNextScreen();
    }
  }

  Future<void> _prepareNextScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool(OnboardingScreen.prefsKey) ?? false;

    final assetPaths = onboardingDone
        ? HomeScreen.assetPaths
        : OnboardingScreen.assetPaths;
    _nextScreenBuilder = onboardingDone
        ? (_) => const HomeScreen()
        : (_) => const OnboardingScreen();

    if (!mounted) return;
    await Future.wait([
      for (final path in assetPaths) precacheAppAsset(path, context),
    ]);
    if (!mounted) return;
    _nextScreenReady = true;
    _maybeGoNext();
  }

  void _onVideoTick() {
    final value = _controller.value;
    // Ready a beat before the true end: some platforms drop the last
    // frame to black right as playback completes, which is what caused
    // the flicker on the splash -> home cut.
    if (value.isInitialized &&
        value.duration > Duration.zero &&
        value.position >= value.duration - const Duration(milliseconds: 150)) {
      _videoReady = true;
      _maybeGoNext();
    }
  }

  void _maybeGoNext() {
    if (!mounted || _navigated || !_videoReady || !_nextScreenReady) return;
    _navigated = true;
    Navigator.of(context).pushReplacement(fadeRoute(_nextScreenBuilder!));
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      body: SizedBox.expand(
        child: _controller.value.isInitialized
            ? FittedBox(
                fit: BoxFit.cover,
                clipBehavior: Clip.hardEdge,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
