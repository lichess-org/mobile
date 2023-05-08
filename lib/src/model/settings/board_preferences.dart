import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/model/settings/sound.dart';

part 'board_preferences.freezed.dart';
part 'board_preferences.g.dart';

const _prefKey = 'preferences.board';

@Riverpod(keepAlive: true)
class BoardPreferences extends _$BoardPreferences {
  @override
  BoardPrefs build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(_prefKey);
    return stored != null
        ? BoardPrefs.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : const BoardPrefs(
            soundSet: SoundSet.normal,
            pieceSet: PieceSet.staunty,
            boardTheme: BoardTheme.brown,
            hapticFeedback: true,
            showLegalMoves: true,
          );
  }

  Future<void> setSoundSet(SoundSet soundSet) {
    return _save(state.copyWith(soundSet: soundSet));
  }

  Future<void> setPieceSet(PieceSet pieceSet) {
    return _save(state.copyWith(pieceSet: pieceSet));
  }

  Future<void> setBoardTheme(BoardTheme boardTheme) {
    return _save(state.copyWith(boardTheme: boardTheme));
  }

  Future<void> toggleHapticFeedback() {
    return _save(state.copyWith(hapticFeedback: !state.hapticFeedback));
  }

  Future<void> toggleShowLegalMoves() {
    return _save(state.copyWith(showLegalMoves: !state.showLegalMoves));
  }

  Future<void> _save(BoardPrefs newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      _prefKey,
      jsonEncode(newState.toJson()),
    );
    state = newState;
  }
}

@Freezed(fromJson: true, toJson: true)
class BoardPrefs with _$BoardPrefs {
  const factory BoardPrefs({
    required SoundSet soundSet,
    required PieceSet pieceSet,
    required BoardTheme boardTheme,
    required bool hapticFeedback,
    required bool showLegalMoves,
  }) = _BoardPrefs;

  factory BoardPrefs.fromJson(Map<String, dynamic> json) =>
      _$BoardPrefsFromJson(json);
}
