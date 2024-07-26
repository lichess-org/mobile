import 'dart:convert';

import 'package:chessground/chessground.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/db/shared_preferences.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_preferences.freezed.dart';
part 'board_preferences.g.dart';

@Riverpod(keepAlive: true)
class BoardPreferences extends _$BoardPreferences {
  static const String prefKey = 'preferences.board';

  @override
  BoardPrefs build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final stored = prefs.getString(prefKey);
    return stored != null
        ? BoardPrefs.fromJson(
            jsonDecode(stored) as Map<String, dynamic>,
          )
        : BoardPrefs.defaults;
  }

  Future<void> setPieceSet(PieceSet pieceSet) {
    return _save(state.copyWith(pieceSet: pieceSet));
  }

  Future<void> setBoardTheme(BoardTheme boardTheme) async {
    await _save(state.copyWith(boardTheme: boardTheme));
  }

  Future<void> setPieceShiftMethod(PieceShiftMethod pieceShiftMethod) async {
    await _save(state.copyWith(pieceShiftMethod: pieceShiftMethod));
  }

  Future<void> toggleHapticFeedback() {
    return _save(state.copyWith(hapticFeedback: !state.hapticFeedback));
  }

  Future<void> toggleImmersiveModeWhilePlaying() {
    return _save(
      state.copyWith(
        immersiveModeWhilePlaying: !(state.immersiveModeWhilePlaying ?? false),
      ),
    );
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

  Future<void> toggleEnableShapeDrawings() {
    return _save(
      state.copyWith(enableShapeDrawings: !state.enableShapeDrawings),
    );
  }

  Future<void> _save(BoardPrefs newState) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(
      prefKey,
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
    bool? immersiveModeWhilePlaying,
    required bool hapticFeedback,
    required bool showLegalMoves,
    required bool boardHighlights,
    required bool coordinates,
    required bool pieceAnimation,
    required bool showMaterialDifference,
    @JsonKey(
      defaultValue: PieceShiftMethod.either,
      unknownEnumValue: PieceShiftMethod.either,
    )
    required PieceShiftMethod pieceShiftMethod,

    /// Whether to enable shape drawings on the board for games and puzzles.
    @JsonKey(defaultValue: false) required bool enableShapeDrawings,
  }) = _BoardPrefs;

  static const defaults = BoardPrefs(
    pieceSet: PieceSet.staunty,
    boardTheme: BoardTheme.brown,
    immersiveModeWhilePlaying: false,
    hapticFeedback: true,
    showLegalMoves: true,
    boardHighlights: true,
    coordinates: true,
    pieceAnimation: true,
    showMaterialDifference: true,
    pieceShiftMethod: PieceShiftMethod.either,
    enableShapeDrawings: false,
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
  system('System'),
  blue('Blue'),
  blue2('Blue2'),
  blue3('Blue3'),
  blueMarble('Blue Marble'),
  canvas('Canvas'),
  wood('Wood'),
  wood2('Wood2'),
  wood3('Wood3'),
  wood4('Wood4'),
  maple('Maple'),
  maple2('Maple 2'),
  brown('Brown'),
  leather('Leather'),
  green('Green'),
  marble('Marble'),
  greenPlastic('Green Plastic'),
  grey('Grey'),
  metal('Metal'),
  olive('Olive'),
  newspaper('Newspaper'),
  purpleDiag('Purple-Diag'),
  pinkPyramid('Pink'),
  horsey('Horsey');

  final String label;

  const BoardTheme(this.label);

  ChessboardColorScheme get colors {
    switch (this) {
      case BoardTheme.system:
        return getBoardColorScheme() ?? ChessboardColorScheme.brown;
      case BoardTheme.blue:
        return ChessboardColorScheme.blue;
      case BoardTheme.blue2:
        return ChessboardColorScheme.blue2;
      case BoardTheme.blue3:
        return ChessboardColorScheme.blue3;
      case BoardTheme.blueMarble:
        return ChessboardColorScheme.blueMarble;
      case BoardTheme.canvas:
        return ChessboardColorScheme.canvas;
      case BoardTheme.wood:
        return ChessboardColorScheme.wood;
      case BoardTheme.wood2:
        return ChessboardColorScheme.wood2;
      case BoardTheme.wood3:
        return ChessboardColorScheme.wood3;
      case BoardTheme.wood4:
        return ChessboardColorScheme.wood4;
      case BoardTheme.maple:
        return ChessboardColorScheme.maple;
      case BoardTheme.maple2:
        return ChessboardColorScheme.maple2;
      case BoardTheme.brown:
        return ChessboardColorScheme.brown;
      case BoardTheme.leather:
        return ChessboardColorScheme.leather;
      case BoardTheme.green:
        return ChessboardColorScheme.green;
      case BoardTheme.marble:
        return ChessboardColorScheme.marble;
      case BoardTheme.greenPlastic:
        return ChessboardColorScheme.greenPlastic;
      case BoardTheme.grey:
        return ChessboardColorScheme.grey;
      case BoardTheme.metal:
        return ChessboardColorScheme.metal;
      case BoardTheme.olive:
        return ChessboardColorScheme.olive;
      case BoardTheme.newspaper:
        return ChessboardColorScheme.newspaper;
      case BoardTheme.purpleDiag:
        return ChessboardColorScheme.purpleDiag;
      case BoardTheme.pinkPyramid:
        return ChessboardColorScheme.pinkPyramid;
      case BoardTheme.horsey:
        return ChessboardColorScheme.horsey;
    }
  }

  Widget get thumbnail => this == BoardTheme.system
      ? SizedBox(
          height: 32,
          width: 32 * 6,
          child: Row(
            children: [
              for (final c in const [1, 2, 3, 4, 5, 6])
                Container(
                  width: 32,
                  color: c.isEven
                      ? BoardTheme.system.colors.darkSquare
                      : BoardTheme.system.colors.lightSquare,
                ),
            ],
          ),
        )
      : Image.asset(
          'assets/board-thumbnails/$name.jpg',
          height: 32,
          errorBuilder: (context, o, st) => const SizedBox.shrink(),
        );
}
