import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundpool/soundpool.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';

part 'sound_service.g.dart';

enum Sound { move, capture, dong }

typedef SoundMap = IMap<Sound, int>;

@Riverpod(keepAlive: true)
SoundService soundService(SoundServiceRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  final deps = ref.watch(appDependenciesProvider).requireValue;
  return SoundService(deps.soundPool, deps.sounds, ref);
}

Future<SoundMap> loadSounds(Soundpool pool) async {
  return IMap({
    for (final sound in Sound.values)
      sound: await rootBundle
          .load('assets/sounds/${sound.name}.mp3')
          .then((soundData) => pool.load(soundData)),
  });
}

class SoundService {
  SoundService(this._pool, this._sounds, this._ref);

  final Soundpool _pool;
  final SoundMap _sounds;
  final SoundServiceRef _ref;

  void playMove() => _play(Sound.move);

  void playCapture() => _play(Sound.capture);

  void playDong() => _play(Sound.dong);

  void _play(Sound sound) {
    final isEnabled = _ref.read(generalPreferencesProvider).isSoundEnabled;
    final soundId = _sounds[sound];
    if (soundId != null && isEnabled) _pool.play(soundId);
  }
}
