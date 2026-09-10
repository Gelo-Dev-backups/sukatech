import 'package:flutter/foundation.dart';

import '../data/settings_repository.dart';

/// App-wide toggle state, held outside any screen's State so it survives
/// screens being torn down and rebuilt (the bottom nav bar uses
/// `pushReplacement` between tabs), and persisted to SQLite so it survives
/// an app restart too.
///
/// [load] is awaited in `main()` before `runApp`, so both notifiers already
/// hold the saved value by the time any screen builds.
class AppSettings {
  AppSettings._();

  static const _darkModeKey = 'dark_mode';
  static const _soundOnKey = 'sound_on';

  static final ValueNotifier<bool> darkMode = ValueNotifier(false);
  static final ValueNotifier<bool> soundOn = ValueNotifier(true);

  static Future<void> load() async {
    darkMode.value = await SettingsRepository.instance.getBool(
      _darkModeKey,
      fallback: false,
    );
    soundOn.value = await SettingsRepository.instance.getBool(_soundOnKey, fallback: true);

    darkMode.addListener(() {
      SettingsRepository.instance.setBool(_darkModeKey, darkMode.value);
    });
    soundOn.addListener(() {
      SettingsRepository.instance.setBool(_soundOnKey, soundOn.value);
    });
  }
}
