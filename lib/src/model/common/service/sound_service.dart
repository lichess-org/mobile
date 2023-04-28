import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:tuple/tuple.dart';
import 'package:soundpool/soundpool.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart'
    hide Tuple2;

import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/app_dependencies.dart';

part 'sound_service.g.dart';

enum Sound { move, capture, dong, error, confirmation }

typedef SoundMap = IMap<Sound, int>;

@Riverpod(keepAlive: true)
SoundService soundService(SoundServiceRef ref) {
  // requireValue is possible because appDependenciesProvider is loaded before
  // anything. See: lib/src/app.dart
  final deps = ref.watch(appDependenciesProvider).requireValue;
  final pool = deps.soundPool;
  return SoundService(pool.item1, pool.item2, ref);
}

@Riverpod(keepAlive: true)
Future<Tuple2<Soundpool, SoundMap>> soundPool(SoundPoolRef ref) async {
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

  final sounds = await loadSounds(pool);

  return Tuple2(pool, sounds);
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

  void playMove() => play(Sound.move);

  void playCapture() => play(Sound.capture);

  void playDong() => play(Sound.dong);

  void play(Sound sound) {
    final isEnabled = _ref.read(generalPreferencesProvider).isSoundEnabled;
    final soundId = _sounds[sound];
    if (soundId != null && isEnabled) _pool.play(soundId);
  }
}
