import 'package:flutter/foundation.dart';

import '../data/settings_repository.dart';

/// App-wide audio volume settings, persisted to SQLite so they survive restarts.
///
/// [load] is awaited in main() before runApp, so all notifiers already hold
/// their saved value by the time any screen builds.
///
/// - [musicVolume]: BGM volume, 0.0 (muted) – 1.0 (full). Default 0.5.
/// - [sfxVolume]:   SFX volume, 0.0 (muted) – 1.0 (full). Default 1.0.
class AppSettings {
  AppSettings._();

  static const _darkModeKey    = 'dark_mode';
  static const _musicVolumeKey = 'music_volume';
  static const _sfxVolumeKey   = 'sfx_volume';

  // Dark mode kept around so existing DB rows are not orphaned.
  static final ValueNotifier<bool>   darkMode    = ValueNotifier(false);
  static final ValueNotifier<double> musicVolume = ValueNotifier(0.5);
  static final ValueNotifier<double> sfxVolume   = ValueNotifier(1.0);

  static Future<void> load() async {
    darkMode.value = await SettingsRepository.instance.getBool(
      _darkModeKey,
      fallback: false,
    );
    musicVolume.value = await SettingsRepository.instance.getDouble(
      _musicVolumeKey,
      fallback: 0.5,
    );
    sfxVolume.value = await SettingsRepository.instance.getDouble(
      _sfxVolumeKey,
      fallback: 1.0,
    );

    darkMode.addListener(() {
      SettingsRepository.instance.setBool(_darkModeKey, darkMode.value);
    });
    musicVolume.addListener(() {
      SettingsRepository.instance.setDouble(_musicVolumeKey, musicVolume.value);
    });
    sfxVolume.addListener(() {
      SettingsRepository.instance.setDouble(_sfxVolumeKey, sfxVolume.value);
    });
  }
}
