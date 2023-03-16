import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'sound_service.dart';

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

  void moveFeedback() {
    _soundService.playMove();

    if (_ref.read(boardPreferencesProvider).hapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void captureFeedback() {
    _soundService.playCapture();

    if (_ref.read(boardPreferencesProvider).hapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }

  void checkFeedback() {
    if (_ref.read(boardPreferencesProvider).hapticFeedback) {
      HapticFeedback.mediumImpact();
    }
  }
}
