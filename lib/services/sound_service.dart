import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle, AssetManifest;

/// A centralized singleton service to handle audio playback for Sukatech quizzes.
/// Uses the audioplayers package to securely load and play MP3s from assets.
class SoundService {
  SoundService._() {
    const prefix = 'lib/assets/sound_effects/';
    AudioCache.instance.prefix = prefix;
    _bgmPlayer.audioCache = AudioCache(prefix: prefix);
    for (var p in _sfxPlayers) {
      p.audioCache = AudioCache(prefix: prefix);
    }
    _specialSfxPlayer.audioCache = AudioCache(prefix: prefix);
  }
  static final SoundService instance = SoundService._();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final List<AudioPlayer> _sfxPlayers = List.generate(4, (_) => AudioPlayer());
  int _currentSfxIndex = 0;
  final AudioPlayer _specialSfxPlayer = AudioPlayer(); // For XP/Achievements so they don't get cut off

  Future<void>? _initFuture;
  Set<String>? _availableAssets;

  Future<void> init() {
    _initFuture ??= _initInternal();
    return _initFuture!;
  }

  Future<void> _initInternal() async {
    try {
      const prefix = 'lib/assets/sound_effects/';
      AudioCache.instance.prefix = prefix;
      _bgmPlayer.audioCache.prefix = prefix;
      for (var p in _sfxPlayers) {
        p.audioCache.prefix = prefix;
      }
      _specialSfxPlayer.audioCache.prefix = prefix;

      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(0.3); // 30% volume for background music
      for (var p in _sfxPlayers) {
        await p.setVolume(1.0);
      }
      await _specialSfxPlayer.setVolume(1.0);

      await _loadAssetManifest();
    } catch (e) {
      debugPrint('Audio initialization failed: $e');
    }
  }

  Future<void> _loadAssetManifest() async {
    if (_availableAssets != null) return;
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _availableAssets = manifest.listAssets().toSet();
    } catch (e) {
      debugPrint('Could not load AssetManifest: $e');
      _availableAssets = {};
    }
  }

  String _resolveFile(List<String> candidates) {
    if (_availableAssets != null && _availableAssets!.isNotEmpty) {
      for (final candidate in candidates) {
        if (_availableAssets!.contains('lib/assets/sound_effects/$candidate')) {
          return candidate;
        }
      }
    }
    // Return first candidate if manifest not loaded yet or no match
    return candidates.first;
  }

  Future<void> _playSfxSafe(List<String> candidates, {bool special = false}) async {
    try {
      await init();
      final fileName = _resolveFile(candidates);
      AudioPlayer player;
      if (special) {
        player = _specialSfxPlayer;
      } else {
        player = _sfxPlayers[_currentSfxIndex];
        _currentSfxIndex = (_currentSfxIndex + 1) % _sfxPlayers.length;
      }
      
      // Stop before playing if it's currently active (especially needed for single special player)
      if (player.state == PlayerState.playing) {
        await player.stop();
      }
      await player.play(AssetSource(fileName));
    } catch (e) {
      debugPrint('Failed to play sound effect ($candidates): $e');
    }
  }

  /// Plays the correct answer sound effect.
  void playCorrect() {
    _playSfxSafe(['correct.mp3']);
  }

  /// Plays the wrong answer sound effect.
  void playWrong() {
    _playSfxSafe(['wrong.mp3']);
  }

  /// Plays the quiz completion sound effect.
  void playQuizComplete() {
    _playSfxSafe(['done-quiz.mp3'], special: true);
  }

  /// Plays the XP gain sound effect.
  /// Dynamically handles existing 'gain-exp.mp3' and alternate 'gain-xp.mp3'.
  void playGainXp() {
    _playSfxSafe(['gain-exp.mp3', 'gain-xp.mp3'], special: true);
  }

  /// Plays the achievement unlocked sound effect.
  /// Dynamically handles existing 'achivement-unlocked.mp3' and alternate 'achievement-unlocked.mp3'.
  void playAchievementUnlocked() {
    _playSfxSafe(['achivement-unlocked.mp3', 'achievement-unlocked.mp3'], special: true);
  }

  /// Starts random background music and loops it continuously.
  Future<void> playBackgroundMusic() async {
    try {
      await init(); // Ensure configured for loop
      final bgmList = ['bg-music1.mp3', 'bg-music2.mp3'];
      final chosen = bgmList[Random().nextInt(bgmList.length)];
      final fileName = _resolveFile([chosen, ...bgmList]);
      
      if (_bgmPlayer.state != PlayerState.playing) {
        await _bgmPlayer.play(AssetSource(fileName));
      }
    } catch (e) {
      debugPrint('Failed to start background music: $e');
    }
  }

  /// Stops background music completely.
  Future<void> stopBackgroundMusic() async {
    try {
      await _bgmPlayer.stop();
    } catch (e) {
      debugPrint('Failed to stop background music: $e');
    }
  }
}
