import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

/// A provider for [MoveFeedbackService].
final moveFeedbackServiceProvider = Provider<MoveFeedbackService>((Ref ref) {
  final soundService = ref.watch(soundServiceProvider);
  return MoveFeedbackService(soundService, ref);
}, name: 'MoveFeedbackServiceProvider');

class MoveFeedbackService {
  MoveFeedbackService(this._soundService, this._ref);

  final SoundService _soundService;
  final Ref _ref;

  void moveFeedback({bool check = false}) {
    _soundService.play(Sound.move);

    if (_ref.read(boardPreferencesProvider).hapticFeedback) {
      if (check) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }

  void captureFeedback({bool check = false}) {
    _soundService.play(Sound.capture);

    if (_ref.read(boardPreferencesProvider).hapticFeedback) {
      if (check) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }
}
