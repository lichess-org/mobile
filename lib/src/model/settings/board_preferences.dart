import 'dart:convert';

import 'package:chessground/chessground.dart' hide BoardTheme;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  Future<void> toggleShowMaterialDifference() {
    return _save(
      state.copyWith(showMaterialDifference: !state.showMaterialDifference),
    );
  }

  Future<void> toggleBlindfoldMode() {
    return _save(state.copyWith(blindfoldMode: !state.blindfoldMode));
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
    required bool showMaterialDifference,
    required bool blindfoldMode,
  }) = _BoardPrefs;

  static BoardColorScheme colorSchemeOf(BuildContext context) {
    return BoardColorScheme(
      darkSquare: Theme.of(context).colorScheme.primary,
      lightSquare: Theme.of(context).colorScheme.onPrimary,
      // TODO add system colors here
      background: SolidColorBackground(
        lightSquare: Color(0xfff0d9b6),
        darkSquare: Color(0xffb58863),
      ),
      whiteCoordBackground: SolidColorBackground(
        lightSquare: Color(0xfff0d9b6),
        darkSquare: Color(0xffb58863),
        coordinates: true,
      ),
      blackCoordBackground: SolidColorBackground(
        lightSquare: Color(0xfff0d9b6),
        darkSquare: Color(0xffb58863),
        coordinates: true,
        orientation: Side.black,
      ),
      lastMove: HighlightDetails(solidColor: Color(0x809cc700)),
      selected: HighlightDetails(solidColor: Color(0x6014551e)),
      validMoves: Color(0x4014551e),
      validPremoves: Color(0x40203085),
    );
  }

  static const defaults = BoardPrefs(
    pieceSet: PieceSet.staunty,
    boardTheme: BoardTheme.system,
    hapticFeedback: true,
    showLegalMoves: true,
    boardHighlights: true,
    coordinates: true,
    pieceAnimation: true,
    showMaterialDifference: true,
    blindfoldMode: false,
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

/// The chessboard theme.
enum BoardTheme {
  system('System', BoardColorScheme.brown),
  blue('Blue', BoardColorScheme.blue),
  blue2('Blue2', BoardColorScheme.blue2),
  blue3('Blue3', BoardColorScheme.blue3),
  blueMarble('Blue Marble', BoardColorScheme.blueMarble),
  canvas('Canvas', BoardColorScheme.canvas),
  wood('Wood', BoardColorScheme.wood),
  wood2('Wood2', BoardColorScheme.wood2),
  wood3('Wood3', BoardColorScheme.wood3),
  wood4('Wood4', BoardColorScheme.wood4),
  maple('Maple', BoardColorScheme.maple),
  maple2('Maple 2', BoardColorScheme.maple2),
  brown('Brown', BoardColorScheme.brown),
  leather('Leather', BoardColorScheme.leather),
  green('Green', BoardColorScheme.green),
  marble('Marble', BoardColorScheme.marble),
  greenPlastic('Green Plastic', BoardColorScheme.greenPlastic),
  grey('Grey', BoardColorScheme.grey),
  metal('Metal', BoardColorScheme.metal),
  olive('Olive', BoardColorScheme.olive),
  newspaper('Newspaper', BoardColorScheme.newspaper),
  purpleDiag('Purple-Diag', BoardColorScheme.purpleDiag),
  pinkPyramid('Pink', BoardColorScheme.pinkPyramid),
  horsey('Horsey', BoardColorScheme.horsey);

  final String label;

  final BoardColorScheme colors;

  const BoardTheme(this.label, this.colors);
}
