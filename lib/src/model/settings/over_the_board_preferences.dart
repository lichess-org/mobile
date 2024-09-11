import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'over_the_board_preferences.freezed.dart';
part 'over_the_board_preferences.g.dart';

@Riverpod(keepAlive: true)
class OverTheBoardPreferences extends _$OverTheBoardPreferences {
  static const String prefKey = 'preferences.board';

  @override
  OverTheBoardPrefs build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(prefKey);
    return stored != null
        ? OverTheBoardPrefs.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : OverTheBoardPrefs.defaults;
  }

  Future<void> toggleFlipPiecesAfterMove() {
    return _save(
      state.copyWith(flipPiecesAfterMove: !state.flipPiecesAfterMove),
    );
  }

  Future<void> toggleSymmetricPieces() {
    return _save(
      state.copyWith(symmetricPieces: !state.symmetricPieces),
    );
  }

  Future<void> _save(OverTheBoardPrefs newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class OverTheBoardPrefs with _$OverTheBoardPrefs {
  const OverTheBoardPrefs._();

  const factory OverTheBoardPrefs({
    required bool flipPiecesAfterMove,
    required bool symmetricPieces,
  }) = _OverTheBoardPrefs;

  static const defaults = OverTheBoardPrefs(
    flipPiecesAfterMove: false,
    symmetricPieces: false,
  );

  factory OverTheBoardPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$OverTheBoardPrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
