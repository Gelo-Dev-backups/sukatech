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
