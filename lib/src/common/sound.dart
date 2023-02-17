import 'package:flutter/services.dart' show rootBundle;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:soundpool/soundpool.dart';

import 'package:lichess_mobile/src/model/settings/providers.dart';

part 'sound.g.dart';

@Riverpod(keepAlive: true)
SoundService soundService(SoundServiceRef ref) {
  final pool = Soundpool.fromOptions();
  final soundService = SoundService(pool, ref);
  ref.onDispose(pool.release);
  return soundService;
}

class SoundService {
  SoundService(this._pool, this.ref);

  final Soundpool _pool;
  final SoundServiceRef ref;

  final Map<String, int> _soundMap = {};

  Future<void> playMove() => _play('move');

  Future<void> playCapture() => _play('capture');

  Future<void> playDong() => _play('dong');

  Future<void> _play(String sound) async {
    await _loadOnce(sound);
    final isMuted = ref.read(muteSoundPrefProvider);
    final soundId = _soundMap[sound];
    if (soundId != null && !isMuted) _pool.play(soundId);
  }

  Future<void> _loadOnce(String sound) async {
    if (_soundMap[sound] == null) {
      _soundMap[sound] =
          await rootBundle.load('assets/sounds/$sound.mp3').then((soundData) {
        return _pool.load(soundData);
      });
    }
  }
}
