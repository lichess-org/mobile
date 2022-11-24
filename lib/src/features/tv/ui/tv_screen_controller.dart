import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../settings/data/settings_repository.dart';

class TvScreenController extends StateNotifier<bool> {
  TvScreenController(this.settings, bool initialValue) : super(initialValue);

  final SettingsRepository settings;

  void toggleSound() async {
    final ok = await settings.toggleSound();
    if (ok) {
      state = settings.isSoundMuted();
    }
  }
}

final tvScreenControllerProvier =
    StateNotifierProvider.autoDispose<TvScreenController, bool>((ref) {
  final settingsRepository = ref.watch(settingsRepositoryProvider);
  return TvScreenController(
      settingsRepository, settingsRepository.isSoundMuted());
});
