import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sukatech/services/sound_service.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers.global'),
      (MethodCall methodCall) async => 1,
    );
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('xyz.luan/audioplayers'),
      (MethodCall methodCall) async => 1,
    );
  });

  group('SoundService', () {
    test('initializes and configures AudioCache prefix properly', () async {
      final service = SoundService.instance;
      expect(service, isNotNull);

      // Verify prefix is configured
      expect(AudioCache.instance.prefix, 'lib/assets/sound_effects/');

      await service.init();
      expect(AudioCache.instance.prefix, 'lib/assets/sound_effects/');
    });

    test('sound methods trigger safely without exceptions', () {
      final service = SoundService.instance;
      // Ensure calling playback methods does not throw uncaught exceptions
      expect(() => service.playCorrect(), returnsNormally);
      expect(() => service.playWrong(), returnsNormally);
      expect(() => service.playQuizComplete(), returnsNormally);
      expect(() => service.playGainXp(), returnsNormally);
      expect(() => service.playAchievementUnlocked(), returnsNormally);
    });
  });
}
