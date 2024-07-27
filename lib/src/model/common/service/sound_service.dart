import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sound_effect/sound_effect.dart';

part 'sound_service.g.dart';

final _soundEffectPlugin = SoundEffect();

// Must match name of files in assets/sounds/standard
enum Sound {
  move,
  capture,
  lowTime,
  dong,
  error,
  confirmation,
  puzzleStormEnd,
  clock,
}

@Riverpod(keepAlive: true)
SoundService soundService(SoundServiceRef ref) {
  final service = SoundService(ref);
  ref.onDispose(() => service.release());
  return service;
}

final _extension = defaultTargetPlatform == TargetPlatform.iOS ? 'aifc' : 'mp3';

/// Load sounds from assets. Make them ready to be played.
Future<void> _loadSounds(SoundTheme soundTheme) async {
  final themePath = 'assets/sounds/${soundTheme.name}';
  const standardPath = 'assets/sounds/standard';

  for (final sound in Sound.values) {
    final soundId = sound.name;
    final file = '$soundId.$_extension';
    String fullPath = '$themePath/$file';
    try {
      await rootBundle.load(fullPath);
    } catch (_) {
      fullPath = '$standardPath/$file';
    }
    _soundEffectPlugin.load(soundId, fullPath);
  }
}

/// Service to play game sounds.
class SoundService {
  SoundService(this._ref);

  final SoundServiceRef _ref;

  /// Play the given sound if sound is enabled.
  Future<void> play(Sound sound) async {
    final isEnabled = _ref.read(generalPreferencesProvider).isSoundEnabled;
    if (!isEnabled) {
      return;
    }
    final volume = _ref.read(generalPreferencesProvider).masterVolume;
    _soundEffectPlugin.play(sound.name, volume: volume);
  }

  /// Initialize the sound service with the given sound theme.
  ///
  /// This will load the sounds from assets and make them ready to be played.
  Future<void> initialize(SoundTheme theme) async {
    await _soundEffectPlugin.initialize();
    await _loadSounds(theme);
  }

  /// Change the sound theme and optionally play a move sound.
  ///
  /// This will release the previous sounds and load the new ones.
  Future<void> changeTheme(
    SoundTheme theme, {
    bool playSound = false,
  }) async {
    await _soundEffectPlugin.release();
    await _soundEffectPlugin.initialize();
    await _loadSounds(theme);
    if (playSound) {
      play(Sound.move);
    }
  }

  Future<void> release() async {
    await _soundEffectPlugin.release();
  }
}
