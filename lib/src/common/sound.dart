import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soundpool/soundpool.dart';

import 'package:lichess_mobile/src/model/settings/providers.dart';

class SoundService {
  SoundService(this._pool, this.ref);

  final Soundpool _pool;
  final Ref ref;

  int? _moveId;
  int? _captureId;
  int? _dongId;

  Future<void> init() async {
    _moveId = await rootBundle.load('assets/sounds/move.mp3').then((soundData) {
      return _pool.load(soundData);
    });

    _captureId =
        await rootBundle.load('assets/sounds/capture.mp3').then((soundData) {
      return _pool.load(soundData);
    });

    _dongId = await rootBundle.load('assets/sounds/dong.mp3').then((soundData) {
      return _pool.load(soundData);
    });
  }

  void playMove() {
    final isMuted = ref.read(muteSoundPrefProvider);
    if (_moveId != null && !isMuted) _pool.play(_moveId!);
  }

  void playCapture() {
    final isMuted = ref.read(muteSoundPrefProvider);
    if (_captureId != null && !isMuted) {
      _pool.play(_captureId!);
    }
  }

  void playDong() {
    final isMuted = ref.read(muteSoundPrefProvider);
    if (_dongId != null && !isMuted) _pool.play(_dongId!);
  }

  void dispose() {
    _pool.release();
  }
}

final soundServiceProvider = Provider<SoundService>((ref) {
  final pool = Soundpool.fromOptions();
  final soundService = SoundService(pool, ref);
  ref.onDispose(() => soundService.dispose());
  return soundService;
});
