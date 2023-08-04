import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundpool/soundpool.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/app_dependencies.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/settings/sound_theme.dart';

part 'sound_service.g.dart';

// Must match name of files in assets/sounds/standard
enum Sound {
  move,
  capture,
  lowTime,
  dong,
  error,
  confirmation,
  puzzleStormEnd,
}

typedef SoundMap = IMap<Sound, int>;

@Riverpod(keepAlive: true)
SoundService soundService(SoundServiceRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  final deps = ref.read(appDependenciesProvider).requireValue;
  final (pool, sounds) = deps.soundPool;
  return SoundService(pool, sounds, ref);
}

@Riverpod(keepAlive: true)
Future<(Soundpool, SoundMap)> soundPool(
  SoundPoolRef ref,
  SoundTheme theme,
) async {
  final pool = Soundpool.fromOptions(
    options: const SoundpoolOptions(
      iosOptions: SoundpoolOptionsIos(
        enableRate: false,
        audioSessionCategory: AudioSessionCategory.ambient,
        audioSessionMode: AudioSessionMode.normal,
      ),
    ),
  );

  ref.onDispose(pool.release);
  final sounds = await loadSounds(pool, theme);

  return (pool, sounds);
}

final extension = defaultTargetPlatform == TargetPlatform.iOS ? 'aifc' : 'mp3';

Future<SoundMap> loadSounds(Soundpool pool, SoundTheme soundTheme) async {
  await pool.release();
  return IMap({
    for (final sound in Sound.values)
      sound: await rootBundle
          .load('assets/sounds/${soundTheme.name}/${sound.name}.$extension')
          // on iOS if aifc file is not found, load mp3
          .catchError(
            (_) => rootBundle
                .load('assets/sounds/${soundTheme.name}/${sound.name}.mp3'),
          )
          // if not found, load standard theme sound
          .catchError(
            (_) => rootBundle.load('assets/sounds/standard/${sound.name}.mp3'),
          )
          .then((soundData) => pool.load(soundData)),
  });
}

class SoundService {
  SoundService(this._pool, this._sounds, this._ref);

  final Soundpool _pool;
  SoundMap _sounds;
  final SoundServiceRef _ref;

  (int, Sound)? _currentStream;

  Future<int?> play(Sound sound) async {
    final isEnabled = _ref.read(generalPreferencesProvider).isSoundEnabled;
    final soundId = _sounds[sound];
    if (soundId != null && isEnabled) {
      // Stop current sound only if it is a move or capture sound
      if (_currentStream != null &&
          _currentStream!.$1 > 0 &&
          (_currentStream!.$2 == Sound.move ||
              _currentStream!.$2 == Sound.capture)) {
        await _pool.stop(_currentStream!.$1);
      }
      _currentStream = (await _pool.play(soundId), sound);
      return _currentStream!.$1;
    }
    return null;
  }

  Future<void> stopCurrent() async {
    if (_currentStream != null) return _pool.stop(_currentStream!.$1);
  }

  Future<void> changeTheme(SoundTheme theme, {bool playSound = false}) async {
    _sounds = await loadSounds(_pool, theme);
    if (playSound) {
      play(Sound.move);
    }
  }
}
