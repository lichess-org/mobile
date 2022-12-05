import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soundpool/soundpool.dart';

import '../features/settings/data/settings_repository.dart';

class SoundService {
  SoundService(this._pool, this._settings);

  final Soundpool _pool;
  final SettingsRepository _settings;

  late int _moveId;
  late int _captureId;
  late int _dongId;

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
    if (!_settings.isSoundMuted()) _pool.play(_moveId);
  }

  void playCapture() {
    if (!_settings.isSoundMuted()) _pool.play(_captureId);
  }

  void playDong() {
    if (!_settings.isSoundMuted()) _pool.play(_dongId);
  }

  void dispose() {
    _pool.release();
  }
}

final soundServiceProvider = Provider<SoundService>((ref) {
  final pool = Soundpool.fromOptions();
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  final soundService = SoundService(pool, settingsRepository);
  ref.onDispose(() => soundService.dispose());
  return soundService;
});
