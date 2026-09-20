import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// A centralized singleton service to handle audio playback for Sukatech quizzes.
/// Uses the audioplayers package to securely load and play MP3s from assets.
class SoundService {
  SoundService._();
  static final SoundService instance = SoundService._();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _specialSfxPlayer = AudioPlayer(); // For XP/Achievements so they don't get cut off

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;
    try {
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(0.3); // 30% volume for background music
      await _sfxPlayer.setVolume(1.0);
      await _specialSfxPlayer.setVolume(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('Audio initialization failed: $e');
    }
  }

  Future<void> _playSfxSafe(String assetPath, {bool special = false}) async {
    try {
      final player = special ? _specialSfxPlayer : _sfxPlayer;
      await player.play(AssetSource(assetPath));
    } catch (e) {
      debugPrint('Failed to play sound effect ($assetPath): $e');
    }
  }

  /// Plays the correct answer sound effect.
  void playCorrect() {
    _playSfxSafe('sound_effects/correct.mp3');
  }

  /// Plays the wrong answer sound effect.
  void playWrong() {
    _playSfxSafe('sound_effects/wrong.mp3');
  }

  /// Plays the quiz completion sound effect.
  void playQuizComplete() {
    _playSfxSafe('sound_effects/done-quiz.mp3', special: true);
  }

  /// Plays the XP gain sound effect.
  void playGainXp() {
    _playSfxSafe('sound_effects/gain-xp.mp3', special: true);
  }

  /// Plays the achievement unlocked sound effect.
  void playAchievementUnlocked() {
    _playSfxSafe('sound_effects/achievement-unlocked.mp3', special: true);
  }

  /// Starts random background music and loops it continuously.
  Future<void> playBackgroundMusic() async {
    try {
      await init(); // Ensure configured for loop
      final bgm = Random().nextBool() ? 'bg-music1.mp3' : 'bg-music2.mp3';
      await _bgmPlayer.play(AssetSource('sound_effects/$bgm'));
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
