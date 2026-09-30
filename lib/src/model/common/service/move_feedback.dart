import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

/// A provider for [MoveFeedbackService].
final moveFeedbackServiceProvider = Provider<MoveFeedbackService>((Ref ref) {
  final soundService = ref.watch(soundServiceProvider);
  return MoveFeedbackService(soundService, ref);
}, name: 'MoveFeedbackServiceProvider');

class MoveFeedbackService(final SoundService _soundService, final Ref _ref) {
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

  /// The feedback for a standard chess move written as [san]: a capture or a move, with or without
  /// a check.
  void playedMove(String san) {
    final check = san.contains('+') || san.contains('#');
    if (san.contains('x')) {
      captureFeedback(Variant.standard, check: check);
    } else {
      moveFeedback(check: check);
    }
  }

  void captureFeedback(Variant variant, {bool check = false}) {
    _soundService.playCaptureSound(variant);

    if (_ref.read(boardPreferencesProvider).hapticFeedback) {
      if (check) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }
}
