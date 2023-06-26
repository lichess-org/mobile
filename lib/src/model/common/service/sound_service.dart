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
  final deps = ref.watch(appDependenciesProvider).requireValue;
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

Future<SoundMap> loadSounds(Soundpool pool, SoundTheme soundTheme) async {
  return IMap({
    for (final sound in Sound.values)
      sound: await rootBundle
          .load('assets/sounds/${soundTheme.name}/${sound.name}.mp3')
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

  int? _currentStreamId;

  Future<int?> play(Sound sound) async {
    final isEnabled = _ref.read(generalPreferencesProvider).isSoundEnabled;
    final soundId = _sounds[sound];
    if (soundId != null && isEnabled) {
      return _currentStreamId = await _pool.play(soundId);
    }
    return null;
  }

  Future<void> stopCurrent() async {
    if (_currentStreamId != null) return _pool.stop(_currentStreamId!);
  }

  Future<void> changeTheme(SoundTheme theme, {bool playSound = false}) async {
    _sounds = await loadSounds(_pool, theme);
    if (playSound) {
      play(Sound.move);
    }
  }
}
