import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

const Set<Sound> _emtpySet = {};

/// Loads all sounds of the given [SoundTheme].
Future<void> _loadAllSounds(
  SoundTheme soundTheme, {
  Set<Sound> excluded = _emtpySet,
}) async {
  await Future.wait(
    Sound.values
        .where((s) => !excluded.contains(s))
        .map((sound) => _loadSound(soundTheme, sound)),
  );
}

/// Loads a single sound from the given [SoundTheme].
Future<void> _loadSound(SoundTheme theme, Sound sound) async {
  final themePath = 'assets/sounds/${theme.name}';
  const standardPath = 'assets/sounds/standard';
  final soundId = sound.name;
  final file = '$soundId.$_extension';
  String fullPath = '$themePath/$file';
  // If the sound file is not found in the theme, fallback to the standard theme.
  try {
    await rootBundle.load(fullPath);
  } catch (_) {
    fullPath = '$standardPath/$file';
  }
  await _soundEffectPlugin.load(soundId, fullPath);
}

/// Service to play game sounds.
class SoundService {
  SoundService(this._ref);

  final SoundServiceRef _ref;

  /// Initialize the sound service.
  ///
  /// This will load the sounds from assets and make them ready to be played.
  /// This should be called once when the app starts.
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();

    final stored = prefs.getString(kGeneralPreferencesKey);
    final theme = (stored != null
            ? GeneralPrefsState.fromJson(
                jsonDecode(stored) as Map<String, dynamic>,
              )
            : GeneralPrefsState.defaults)
        .soundTheme;
    await _soundEffectPlugin.initialize();
    await _loadAllSounds(theme);
  }

  /// Play the given sound if sound is enabled.
  Future<void> play(Sound sound) async {
    final isEnabled = _ref.read(generalPreferencesProvider).isSoundEnabled;
    final volume = _ref.read(generalPreferencesProvider).masterVolume;
    if (!isEnabled || volume == 0.0) {
      return;
    }
    _soundEffectPlugin.play(sound.name, volume: volume);
  }

  /// Change the sound theme and optionally play a move sound.
  ///
  /// This will release the previous sounds and load the new ones.
  ///
  /// If [playSound] is true, a move sound will be played.
  Future<void> changeTheme(
    SoundTheme theme, {
    bool playSound = false,
  }) async {
    await _soundEffectPlugin.release();
    await _soundEffectPlugin.initialize();
    await _loadSound(theme, Sound.move);
    if (playSound) {
      play(Sound.move);
    }
    await _loadAllSounds(theme, excluded: {Sound.move});
  }

  Future<void> release() async {
    await _soundEffectPlugin.release();
  }
}
