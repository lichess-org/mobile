import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';

/// A provider for [MoveFeedbackService].
final moveFeedbackServiceProvider = Provider<MoveFeedbackService>((Ref ref) {
  final soundService = ref.watch(soundServiceProvider);
  final hasHapticFeedback = ref.watch(
    boardPreferencesProvider.select((prefs) => prefs.hapticFeedback),
  );
  return MoveFeedbackService(soundService, hasHapticFeedback: hasHapticFeedback);
}, name: 'MoveFeedbackServiceProvider');

class MoveFeedbackService {
  MoveFeedbackService(this._soundService, {required this.hasHapticFeedback});

  final SoundService _soundService;
  final bool hasHapticFeedback;

  void _playHapticFeedback({required bool check}) {
    if (hasHapticFeedback) {
      if (check) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }
  }

  void moveFeedback({bool check = false}) {
    _soundService.play(Sound.move);
    _playHapticFeedback(check: check);
  }

  void captureFeedback(Variant variant, {bool check = false}) {
    _soundService.playCaptureSound(variant);
    _playHapticFeedback(check: check);
  }
}
