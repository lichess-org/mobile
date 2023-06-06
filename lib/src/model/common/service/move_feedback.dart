import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';

part 'move_feedback.g.dart';

@Riverpod(keepAlive: true)
MoveFeedbackService moveFeedbackService(MoveFeedbackServiceRef ref) {
  final soundService = ref.watch(soundServiceProvider);
  return MoveFeedbackService(soundService, ref);
}

class MoveFeedbackService {
  MoveFeedbackService(this._soundService, this._ref);

  final SoundService _soundService;
  final MoveFeedbackServiceRef _ref;

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
