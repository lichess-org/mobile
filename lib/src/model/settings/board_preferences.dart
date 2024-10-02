import 'package:chessground/chessground.dart';
import 'package:lichess_mobile/src/model/settings/preferences.dart' as pref;
import 'package:lichess_mobile/src/model/settings/preferences.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_preferences.g.dart';

@riverpod
class BoardPreferences extends _$BoardPreferences
    with PreferencesStorage<pref.Board> {
  // ignore: avoid_public_notifier_properties
  @override
  pref.Category<pref.Board> get prefCategory => pref.Category.board;

  @override
  pref.Board build() {
    return fetch();
  }

  Future<void> setPieceSet(PieceSet pieceSet) {
    return save(state.copyWith(pieceSet: pieceSet));
  }

  Future<void> setBoardTheme(BoardTheme boardTheme) async {
    await save(state.copyWith(boardTheme: boardTheme));
  }

  Future<void> setPieceShiftMethod(PieceShiftMethod pieceShiftMethod) async {
    await save(state.copyWith(pieceShiftMethod: pieceShiftMethod));
  }

  Future<void> toggleHapticFeedback() {
    return save(state.copyWith(hapticFeedback: !state.hapticFeedback));
  }

  Future<void> toggleImmersiveModeWhilePlaying() {
    return save(
      state.copyWith(
        immersiveModeWhilePlaying: !(state.immersiveModeWhilePlaying ?? false),
      ),
    );
  }

  Future<void> toggleShowLegalMoves() {
    return save(state.copyWith(showLegalMoves: !state.showLegalMoves));
  }

  Future<void> toggleBoardHighlights() {
    return save(state.copyWith(boardHighlights: !state.boardHighlights));
  }

  Future<void> toggleCoordinates() {
    return save(state.copyWith(coordinates: !state.coordinates));
  }

  Future<void> togglePieceAnimation() {
    return save(state.copyWith(pieceAnimation: !state.pieceAnimation));
  }

  Future<void> toggleMagnifyDraggedPiece() {
    return save(
      state.copyWith(
        magnifyDraggedPiece: !state.magnifyDraggedPiece,
      ),
    );
  }

  Future<void> toggleShowMaterialDifference() {
    return save(
      state.copyWith(showMaterialDifference: !state.showMaterialDifference),
    );
  }

  Future<void> toggleEnableShapeDrawings() {
    return save(
      state.copyWith(enableShapeDrawings: !state.enableShapeDrawings),
    );
  }

  Future<void> setShapeColor(ShapeColor shapeColor) {
    return save(state.copyWith(shapeColor: shapeColor));
  }
}
