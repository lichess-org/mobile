import 'package:flutter/services.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'sound_service.dart';

part 'move_feedback.g.dart';

@Riverpod(keepAlive: true)
MoveFeedbackService moveFeedbackService(MoveFeedbackServiceRef ref) {
  final soundService = ref.watch(soundServiceProvider);
  return MoveFeedbackService(soundService);
}

class MoveFeedbackService {
  MoveFeedbackService(this._soundService);

  final SoundService _soundService;

  void moveFeedback() {
    _soundService.playMove();
    HapticFeedback.lightImpact();
  }

  void captureFeedback() {
    _soundService.playCapture();
    HapticFeedback.mediumImpact();
  }
}
