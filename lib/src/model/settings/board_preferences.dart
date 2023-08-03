import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:chessground/chessground.dart';

import 'package:lichess_mobile/src/db/shared_preferences.dart';

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
        : BoardPrefs.defaults;
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

  Future<void> toggleBoardHighlights() {
    return _save(state.copyWith(boardHighlights: !state.boardHighlights));
  }

  Future<void> toggleCoordinates() {
    return _save(state.copyWith(coordinates: !state.coordinates));
  }

  Future<void> togglePieceAnimation() {
    return _save(state.copyWith(pieceAnimation: !state.pieceAnimation));
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
  const BoardPrefs._();

  const factory BoardPrefs({
    required PieceSet pieceSet,
    required BoardTheme boardTheme,
    required bool hapticFeedback,
    required bool showLegalMoves,
    required bool boardHighlights,
    required bool coordinates,
    required bool pieceAnimation,
  }) = _BoardPrefs;

  static const defaults = BoardPrefs(
    pieceSet: PieceSet.staunty,
    boardTheme: BoardTheme.brown,
    hapticFeedback: true,
    showLegalMoves: true,
    boardHighlights: true,
    coordinates: true,
    pieceAnimation: true,
  );

  factory BoardPrefs.fromJson(Map<String, dynamic> json) {
    try {
      return _$BoardPrefsFromJson(json);
    } catch (_) {
      return defaults;
    }
  }

  Duration get pieceAnimationDuration =>
      pieceAnimation ? const Duration(milliseconds: 150) : Duration.zero;
}
