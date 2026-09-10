import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'screens/dashboard_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/profile_screen.dart';

/// Every image asset the app can show past the splash screen, combined in
/// one place so a loading step can preload the whole app instead of just
/// whatever the very next page happens to need.
const List<String> allAppAssetPaths = [
  ...OnboardingScreen.assetPaths,
  ...DashboardScreen.assetPaths,
  ...ProfileScreen.assetPaths,
];

/// Safely precaches either a raster image (PNG/JPG/WebP) or an SVG vector asset.
Future<void> precacheAppAsset(String path, BuildContext context) {
  if (path.toLowerCase().endsWith('.svg')) {
    return vg.loadPicture(SvgAssetLoader(path), null);
  }
  return precacheImage(AssetImage(path), context);
}

