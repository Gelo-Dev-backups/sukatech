import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle, AssetManifest;

import '../settings/app_settings.dart';

/// Centralized audio service for SUKATECH.
///
/// ## BGM contexts
///   There are two contexts:
///   - "Main" — the looping background track that plays everywhere except quizzes.
///   - "Quiz" — the same BGM pool but started fresh when a quiz is entered.
///
///   Transitioning between them uses a crossfade so there is never an abrupt
///   stop.  Use [enterQuizMusic] / [exitQuizMusic] from quiz screens instead of
///   the raw play/stop calls.
///
/// ## Audio ducking
///   While any SFX is active the BGM fades to 25 % of its normal volume and
///   restores once all active SFX finish.  A _duckCount reference-counter
///   handles overlapping clips correctly.
///
/// ## Volume control
///   AppSettings.musicVolume (0–1) sets the BGM "normal" volume.
///   AppSettings.sfxVolume   (0–1) sets all SFX player volumes.
class SoundService {
  SoundService._() {
    const prefix = 'lib/assets/sound_effects/';
    AudioCache.instance.prefix = prefix;
    _bgmPlayer.audioCache = AudioCache(prefix: prefix);
    for (var p in _sfxPlayers) {
      p.audioCache = AudioCache(prefix: prefix);
    }
    _specialSfxPlayer.audioCache = AudioCache(prefix: prefix);

    AppSettings.musicVolume.addListener(_onMusicVolumeChanged);
    AppSettings.sfxVolume.addListener(_onSfxVolumeChanged);
  }
  static final SoundService instance = SoundService._();

  // ── Players ────────────────────────────────────────────────────────────────

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final List<AudioPlayer> _sfxPlayers = List.generate(4, (_) => AudioPlayer());
  int _currentSfxIndex = 0;
  final AudioPlayer _specialSfxPlayer = AudioPlayer();

  // ── Volume helpers ─────────────────────────────────────────────────────────

  double get _bgmNormalVolume => AppSettings.musicVolume.value;
  double get _bgmDuckedVolume => (_bgmNormalVolume * 0.25).clamp(0.0, 1.0);
  double get _sfxVol          => AppSettings.sfxVolume.value;

  void _onMusicVolumeChanged() {
    if (_duckCount == 0 && _bgmPlayer.state == PlayerState.playing) {
      _bgmCurrentVolume = _bgmNormalVolume;
      _bgmPlayer.setVolume(_bgmNormalVolume);
    }
  }

  void _onSfxVolumeChanged() {
    final v = _sfxVol;
    for (final p in _sfxPlayers) { p.setVolume(v); }
    _specialSfxPlayer.setVolume(v);
  }

  // ── Init ───────────────────────────────────────────────────────────────────

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
      for (var p in _sfxPlayers) { p.audioCache.prefix = prefix; }
      _specialSfxPlayer.audioCache.prefix = prefix;

      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);
      await _bgmPlayer.setVolume(_bgmNormalVolume);
      _bgmCurrentVolume = _bgmNormalVolume;

      final sfx = _sfxVol;
      for (var p in _sfxPlayers) { await p.setVolume(sfx); }
      await _specialSfxPlayer.setVolume(sfx);

      await _loadAssetManifest();
    } catch (e) {
      debugPrint('Audio initialization failed: $e');
    }
  }

  // ── Asset manifest ─────────────────────────────────────────────────────────

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
      for (final c in candidates) {
        if (_availableAssets!.contains('lib/assets/sound_effects/$c')) return c;
      }
    }
    return candidates.first;
  }

  // ── Audio ducking ──────────────────────────────────────────────────────────

  static const Duration _fadeDuration    = Duration(milliseconds: 300);
  static const Duration _crossfadeDur    = Duration(milliseconds: 700);
  static const int      _fadeSteps       = 12;
  static const int      _crossfadeSteps  = 20;

  int    _duckCount         = 0;
  double _bgmCurrentVolume  = 0.5;
  Timer? _unduckTimer;

  Future<void> _duck() async {
    _duckCount++;
    _unduckTimer?.cancel();
    _unduckTimer = null;
    await _fadeBgmVolume(to: _bgmDuckedVolume, steps: _fadeSteps, dur: _fadeDuration);
  }

  Future<void> _unduck() async {
    if (_duckCount > 0) _duckCount--;
    if (_duckCount > 0) return;
    _unduckTimer = Timer(const Duration(milliseconds: 150), () async {
      if (_duckCount == 0) {
        await _fadeBgmVolume(to: _bgmNormalVolume, steps: _fadeSteps, dur: _fadeDuration);
      }
    });
  }

  /// Generic BGM volume fade from the current tracked level to [to].
  Future<void> _fadeBgmVolume({
    required double to,
    required int steps,
    required Duration dur,
  }) async {
    if (_bgmPlayer.state != PlayerState.playing) return;
    try {
      final double from = _bgmCurrentVolume;
      if ((from - to).abs() < 0.005) return;
      final stepDelay = dur ~/ steps;
      final double step = (to - from) / steps;
      for (int i = 1; i <= steps; i++) {
        final double v = (from + step * i).clamp(0.0, 1.0);
        _bgmCurrentVolume = v;
        await _bgmPlayer.setVolume(v);
        await Future.delayed(stepDelay);
      }
      _bgmCurrentVolume = to;
    } catch (_) { /* stopped mid-fade */ }
  }

  // ── SFX playback ───────────────────────────────────────────────────────────

  Future<void> _playSfxSafe(List<String> candidates, {bool special = false}) async {
    if (_sfxVol == 0) return;
    try {
      await init();
      final fileName = _resolveFile(candidates);
      final AudioPlayer player;
      if (special) {
        player = _specialSfxPlayer;
      } else {
        player = _sfxPlayers[_currentSfxIndex];
        _currentSfxIndex = (_currentSfxIndex + 1) % _sfxPlayers.length;
      }
      if (player.state == PlayerState.playing) await player.stop();
      await player.setVolume(_sfxVol);
      await _duck();
      await player.play(AssetSource(fileName));
      player.onPlayerComplete.first
          .then((_) => _unduck())
          .catchError((_) => _unduck());
    } catch (e) {
      debugPrint('Failed to play SFX ($candidates): $e');
      _unduck();
    }
  }

  // ── Public SFX API ─────────────────────────────────────────────────────────

  void playCorrect()             => _playSfxSafe(['correct.mp3']);
  void playWrong()               => _playSfxSafe(['wrong.mp3']);
  void playQuizComplete()        => _playSfxSafe(['done-quiz.mp3'], special: true);
  void playGainXp()              => _playSfxSafe(['gain-exp.mp3', 'gain-xp.mp3'], special: true);
  void playAchievementUnlocked() => _playSfxSafe(
        ['achivement-unlocked.mp3', 'achievement-unlocked.mp3'], special: true);

  // ── BGM — main context ─────────────────────────────────────────────────────

  /// The file name of the currently playing main BGM track, so we can
  /// resume the same track when returning from a quiz.
  String? _currentMainTrack;

  /// Start the main background music (called once from HomeScreen).
  /// No-op if already playing. Respects the music volume setting.
  Future<void> playBackgroundMusic() async {
    if (_bgmNormalVolume == 0) return;
    try {
      await init();
      if (_bgmPlayer.state == PlayerState.playing) return;

      final bgmList = ['bg-music1.mp3', 'bg-music2.mp3'];
      final chosen = bgmList[Random().nextInt(bgmList.length)];
      _currentMainTrack = _resolveFile([chosen, ...bgmList]);

      final startVol = _duckCount > 0 ? _bgmDuckedVolume : _bgmNormalVolume;
      _bgmCurrentVolume = startVol;
      await _bgmPlayer.setVolume(startVol);
      await _bgmPlayer.play(AssetSource(_currentMainTrack!));
    } catch (e) {
      debugPrint('Failed to start BGM: $e');
    }
  }

  /// Stop BGM completely (e.g. music volume slider dragged to 0).
  Future<void> stopBackgroundMusic() async {
    try {
      await _fadeBgmVolume(to: 0, steps: _crossfadeSteps, dur: _crossfadeDur);
      await _bgmPlayer.stop();
      _bgmCurrentVolume = 0;
    } catch (e) {
      debugPrint('Failed to stop BGM: $e');
    }
  }

  // ── BGM — quiz context ─────────────────────────────────────────────────────

  /// Called by a quiz screen in initState / _restart.
  ///
  /// Crossfades the current BGM out, then starts a fresh quiz track
  /// (same pool, but re-randomised so it feels different from the main music).
  Future<void> enterQuizMusic() async {
    if (_bgmNormalVolume == 0) return;
    try {
      await init();
      // Fade current track to silence.
      await _fadeBgmVolume(to: 0, steps: _crossfadeSteps, dur: _crossfadeDur);
      await _bgmPlayer.stop();

      // Pick a quiz track — prefer a different one from the main track.
      final bgmList = ['bg-music1.mp3', 'bg-music2.mp3'];
      final others  = bgmList.where((f) => f != _currentMainTrack).toList();
      final pool    = others.isNotEmpty ? others : bgmList;
      final chosen  = pool[Random().nextInt(pool.length)];
      final fileName = _resolveFile([chosen, ...bgmList]);

      // Fade in the quiz track from silence.
      _bgmCurrentVolume = 0;
      await _bgmPlayer.setVolume(0);
      await _bgmPlayer.play(AssetSource(fileName));
      await _fadeBgmVolume(
          to: _bgmNormalVolume, steps: _crossfadeSteps, dur: _crossfadeDur);
    } catch (e) {
      debugPrint('Failed to enter quiz music: $e');
    }
  }

  /// Called by a quiz screen in dispose.
  ///
  /// Crossfades the quiz track out, then resumes (or restarts) the main BGM.
  Future<void> exitQuizMusic() async {
    try {
      // Fade quiz track to silence.
      await _fadeBgmVolume(to: 0, steps: _crossfadeSteps, dur: _crossfadeDur);
      await _bgmPlayer.stop();
      _bgmCurrentVolume = 0;

      // Resume main BGM if music is not muted.
      if (_bgmNormalVolume == 0) return;
      final bgmList = ['bg-music1.mp3', 'bg-music2.mp3'];
      // Re-use the same main track if we know it, otherwise pick randomly.
      final fileName = _currentMainTrack != null
          ? _resolveFile([_currentMainTrack!, ...bgmList])
          : _resolveFile(bgmList);
      _currentMainTrack ??= fileName;

      // Fade main BGM back in from silence.
      await _bgmPlayer.setVolume(0);
      await _bgmPlayer.play(AssetSource(fileName));
      await _fadeBgmVolume(
          to: _bgmNormalVolume, steps: _crossfadeSteps, dur: _crossfadeDur);
    } catch (e) {
      debugPrint('Failed to exit quiz music: $e');
    }
  }
}
