import 'dart:async';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle, AssetManifest;

import '../settings/app_settings.dart';

/// Centralized audio service for SUKATECH.
///
/// ## BGM contexts
///   - "Main" — looping background track that plays everywhere except quizzes.
///   - "Quiz" — same BGM pool but started fresh when a quiz is entered.
///
///   Use [enterQuizMusic] / [exitQuizMusic] from quiz screens.
///
/// ## Audio ducking
///   While any SFX is active the BGM fades to 25 % of its normal volume and
///   restores once all active SFX finish.
///
///   ROOT CAUSE FIX: SFX players are configured with AndroidAudioFocus.none so
///   Android's audio session manager never steals focus from the BGM player.
///   Without this, every SFX play() call on Android triggered an OS-level focus
///   grab that paused/silenced the BGM entirely, bypassing all our Dart logic.
///   Additionally, a generation counter prevents concurrent Dart-level fades
///   from racing and driving the volume to 0.
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
      _startFade(to: _bgmNormalVolume);
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

      // BGM player: request persistent music focus so Android keeps it alive.
      await _bgmPlayer.setAudioContext(AudioContext(
        android: AudioContextAndroid(
          audioFocus: AndroidAudioFocus.gain,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          stayAwake: false,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      ));

      // SFX players: request NO audio focus — the OS must not interfere with BGM.
      // We handle volume ducking ourselves in Dart.
      final sfxContext = AudioContext(
        android: AudioContextAndroid(
          audioFocus: AndroidAudioFocus.none,
          contentType: AndroidContentType.sonification,
          usageType: AndroidUsageType.game,
          stayAwake: false,
        ),
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.playback,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
      );
      for (var p in _sfxPlayers) { await p.setAudioContext(sfxContext); }
      await _specialSfxPlayer.setAudioContext(sfxContext);

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

  // ── Fade engine (generation-based cancellation) ────────────────────────────

  static const Duration _fadeDuration   = Duration(milliseconds: 250);
  static const Duration _crossfadeDur   = Duration(milliseconds: 700);
  static const int      _fadeSteps      = 10;
  static const int      _crossfadeSteps = 20;

  /// Incremented every time a new fade is requested.
  /// Any in-progress fade that sees a mismatched generation aborts instantly.
  int    _fadeGen           = 0;
  double _bgmCurrentVolume  = 0.5;

  /// Request a BGM volume fade. Cancels any previously running fade.
  Future<void> _startFade({
    required double to,
    int? steps,
    Duration? dur,
  }) {
    _fadeGen++;
    final myGen = _fadeGen;
    return _runFade(
      to: to,
      steps: steps ?? _fadeSteps,
      dur: dur ?? _fadeDuration,
      gen: myGen,
    );
  }

  Future<void> _runFade({
    required double to,
    required int steps,
    required Duration dur,
    required int gen,
  }) async {
    if (_bgmPlayer.state != PlayerState.playing) {
      // Not playing — just remember the target volume for when it restarts.
      _bgmCurrentVolume = to;
      return;
    }
    try {
      final double from = _bgmCurrentVolume;
      if ((from - to).abs() < 0.005) {
        _bgmCurrentVolume = to;
        return;
      }
      final stepDelay = dur ~/ steps;
      final double step = (to - from) / steps;
      for (int i = 1; i <= steps; i++) {
        if (_fadeGen != gen) return; // superseded — abort without changing vol
        final double v = (from + step * i).clamp(0.0, 1.0);
        _bgmCurrentVolume = v;
        await _bgmPlayer.setVolume(v);
        await Future.delayed(stepDelay);
      }
      if (_fadeGen == gen) {
        _bgmCurrentVolume = to;
        await _bgmPlayer.setVolume(to);
      }
    } catch (_) { /* player stopped mid-fade — that's fine */ }
  }

  // ── Audio ducking ──────────────────────────────────────────────────────────

  int    _duckCount  = 0;
  Timer? _unduckTimer;

  void _duck() {
    _duckCount++;
    _unduckTimer?.cancel();
    _unduckTimer = null;
    _startFade(to: _bgmDuckedVolume); // fire-and-forget; generation ensures no conflict
  }

  void _unduck() {
    if (_duckCount > 0) _duckCount--;
    if (_duckCount > 0) return; // other SFX still active

    // Small delay so rapid successive SFX don't cause audible volume pumping.
    _unduckTimer?.cancel();
    _unduckTimer = Timer(const Duration(milliseconds: 200), () {
      if (_duckCount == 0) {
        _startFade(to: _bgmNormalVolume);
      }
    });
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
      // If this slot was already playing, stop it and balance the duck counter.
      if (player.state == PlayerState.playing) {
        await player.stop();
        _unduck(); // the interrupted SFX won't fire onPlayerComplete
      }
      await player.setVolume(_sfxVol);
      _duck();
      await player.play(AssetSource(fileName));
      player.onPlayerComplete.first
          .then((_) => _unduck())
          .catchError((_) { _unduck(); return null; });
    } catch (e) {
      debugPrint('Failed to play SFX ($candidates): $e');
      _unduck(); // keep duck count balanced even on error
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

  String? _currentMainTrack;

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

  Future<void> stopBackgroundMusic() async {
    try {
      await _startFade(to: 0, steps: _crossfadeSteps, dur: _crossfadeDur);
      await _bgmPlayer.stop();
      _bgmCurrentVolume = 0;
    } catch (e) {
      debugPrint('Failed to stop BGM: $e');
    }
  }

  // ── BGM — quiz context ─────────────────────────────────────────────────────

  Future<void> enterQuizMusic() async {
    if (_bgmNormalVolume == 0) return;
    try {
      await init();
      // Clear duck state — quiz manages its own BGM lifecycle.
      _duckCount = 0;
      _unduckTimer?.cancel();
      _unduckTimer = null;

      await _startFade(to: 0, steps: _crossfadeSteps, dur: _crossfadeDur);
      await _bgmPlayer.stop();

      final bgmList = ['bg-music1.mp3', 'bg-music2.mp3'];
      final others  = bgmList.where((f) => f != _currentMainTrack).toList();
      final pool    = others.isNotEmpty ? others : bgmList;
      final chosen  = pool[Random().nextInt(pool.length)];
      final fileName = _resolveFile([chosen, ...bgmList]);

      _bgmCurrentVolume = 0;
      await _bgmPlayer.setVolume(0);
      await _bgmPlayer.play(AssetSource(fileName));
      await _startFade(to: _bgmNormalVolume, steps: _crossfadeSteps, dur: _crossfadeDur);
    } catch (e) {
      debugPrint('Failed to enter quiz music: $e');
    }
  }

  Future<void> exitQuizMusic() async {
    try {
      // Clear duck state before transitioning back.
      _duckCount = 0;
      _unduckTimer?.cancel();
      _unduckTimer = null;

      await _startFade(to: 0, steps: _crossfadeSteps, dur: _crossfadeDur);
      await _bgmPlayer.stop();
      _bgmCurrentVolume = 0;

      if (_bgmNormalVolume == 0) return;
      final bgmList = ['bg-music1.mp3', 'bg-music2.mp3'];
      final fileName = _currentMainTrack != null
          ? _resolveFile([_currentMainTrack!, ...bgmList])
          : _resolveFile(bgmList);
      _currentMainTrack ??= fileName;

      await _bgmPlayer.setVolume(0);
      await _bgmPlayer.play(AssetSource(fileName));
      await _startFade(to: _bgmNormalVolume, steps: _crossfadeSteps, dur: _crossfadeDur);
    } catch (e) {
      debugPrint('Failed to exit quiz music: $e');
    }
  }
}
