import 'package:chessground/chessground.dart' as cg;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';

part 'preferences.freezed.dart';
part 'preferences.g.dart';

/// Interface for serializable preferences.
abstract class SerializablePreferences {
  Map<String, dynamic> toJson();

  static SerializablePreferences fromJson(
    Category key,
    Map<String, dynamic> json,
  ) {
    switch (key) {
      case Category.general:
        return General.fromJson(json);
      case Category.home:
        return Home.fromJson(json);
      case Category.board:
        return Board.fromJson(json);
      case Category.analysis:
        return Analysis.fromJson(json);
      case Category.overTheBoard:
        return OverTheBoard.fromJson(json);
    }
  }
}

/// A preference category with its storage key and default values.
enum Category<T extends SerializablePreferences> {
  general('preferences.general', General.defaults),
  home('preferences.home', Home.defaults),
  board('preferences.board', Board.defaults),
  analysis('preferences.analysis', Analysis.defaults),
  overTheBoard('preferences.overTheBoard', OverTheBoard.defaults);

  const Category(this.storageKey, this.defaults);

  final String storageKey;
  final T defaults;
}

Map<String, dynamic>? _localeToJson(Locale? locale) {
  return locale != null
      ? {
          'languageCode': locale.languageCode,
          'countryCode': locale.countryCode,
          'scriptCode': locale.scriptCode,
        }
      : null;
}

Locale? _localeFromJson(Map<String, dynamic>? json) {
  if (json == null) {
    return null;
  }
  return Locale.fromSubtags(
    languageCode: json['languageCode'] as String,
    countryCode: json['countryCode'] as String?,
    scriptCode: json['scriptCode'] as String?,
  );
}

/// Preferences models
//////////////////////

@Freezed(fromJson: true, toJson: true)
class General with _$General implements SerializablePreferences {
  const factory General({
    @JsonKey(unknownEnumValue: ThemeMode.system, defaultValue: ThemeMode.system)
    required ThemeMode themeMode,
    required bool isSoundEnabled,
    @JsonKey(unknownEnumValue: SoundTheme.standard)
    required SoundTheme soundTheme,
    @JsonKey(defaultValue: 0.8) required double masterVolume,

    /// Should enable system color palette (android 12+ only)
    required bool systemColors,

    /// Locale to use in the app, use system locale if null
    @JsonKey(toJson: _localeToJson, fromJson: _localeFromJson) Locale? locale,
  }) = _General;

  static const defaults = General(
    themeMode: ThemeMode.system,
    isSoundEnabled: true,
    soundTheme: SoundTheme.standard,
    masterVolume: 0.8,
    systemColors: true,
  );

  factory General.fromJson(Map<String, dynamic> json) {
    return _$GeneralFromJson(json);
  }
}

enum SoundTheme {
  standard('Standard'),
  piano('Piano'),
  nes('NES'),
  sfx('SFX'),
  futuristic('Futuristic'),
  lisp('Lisp');

  final String label;

  const SoundTheme(this.label);
}

enum EnabledWidget {
  hello,
  perfCards,
  quickPairing,
}

@Freezed(fromJson: true, toJson: true)
class Home with _$Home implements SerializablePreferences {
  const factory Home({
    required Set<EnabledWidget> enabledWidgets,
  }) = _Home;

  static const defaults = Home(
    enabledWidgets: {
      EnabledWidget.hello,
      EnabledWidget.perfCards,
      EnabledWidget.quickPairing,
    },
  );

  factory Home.fromJson(Map<String, dynamic> json) {
    try {
      return _$HomeFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
class Board with _$Board implements SerializablePreferences {
  const Board._();

  const factory Board({
    required cg.PieceSet pieceSet,
    required BoardTheme boardTheme,
    bool? immersiveModeWhilePlaying,
    required bool hapticFeedback,
    required bool showLegalMoves,
    required bool boardHighlights,
    required bool coordinates,
    required bool pieceAnimation,
    required bool showMaterialDifference,
    @JsonKey(
      defaultValue: cg.PieceShiftMethod.either,
      unknownEnumValue: cg.PieceShiftMethod.either,
    )
    required cg.PieceShiftMethod pieceShiftMethod,

    /// Whether to enable shape drawings on the board for games and puzzles.
    @JsonKey(defaultValue: true) required bool enableShapeDrawings,
    @JsonKey(defaultValue: true) required bool magnifyDraggedPiece,
    @JsonKey(
      defaultValue: ShapeColor.green,
      unknownEnumValue: ShapeColor.green,
    )
    required ShapeColor shapeColor,
  }) = _Board;

  static const defaults = Board(
    pieceSet: cg.PieceSet.staunty,
    boardTheme: BoardTheme.brown,
    immersiveModeWhilePlaying: false,
    hapticFeedback: true,
    showLegalMoves: true,
    boardHighlights: true,
    coordinates: true,
    pieceAnimation: true,
    showMaterialDifference: true,
    pieceShiftMethod: cg.PieceShiftMethod.either,
    enableShapeDrawings: true,
    magnifyDraggedPiece: true,
    shapeColor: ShapeColor.green,
  );

  cg.ChessboardSettings toBoardSettings() {
    return cg.ChessboardSettings(
      pieceAssets: pieceSet.assets,
      colorScheme: boardTheme.colors,
      showValidMoves: showLegalMoves,
      showLastMove: boardHighlights,
      enableCoordinates: coordinates,
      animationDuration: pieceAnimationDuration,
      dragFeedbackScale: magnifyDraggedPiece ? 2.0 : 1.0,
      dragFeedbackOffset: Offset(0.0, magnifyDraggedPiece ? -1.0 : 0.0),
      pieceShiftMethod: pieceShiftMethod,
      drawShape: cg.DrawShapeOptions(
        enable: enableShapeDrawings,
        newShapeColor: shapeColor.color,
      ),
    );
  }

  factory Board.fromJson(Map<String, dynamic> json) {
    try {
      return _$BoardFromJson(json);
    } catch (_) {
      return defaults;
    }
  }

  Duration get pieceAnimationDuration =>
      pieceAnimation ? const Duration(milliseconds: 150) : Duration.zero;
}

/// Colors taken from lila: https://github.com/lichess-org/chessground/blob/54a7e71bf88701c1109d3b9b8106b464012b94cf/src/state.ts#L178
enum ShapeColor {
  green,
  red,
  blue,
  yellow;

  Color get color => Color(
        switch (this) {
          ShapeColor.green => 0x15781B,
          ShapeColor.red => 0x882020,
          ShapeColor.blue => 0x003088,
          ShapeColor.yellow => 0xe68f00,
        },
      ).withAlpha(0xAA);
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

  cg.ChessboardColorScheme get colors {
    switch (this) {
      case BoardTheme.system:
        return getBoardColorScheme() ?? cg.ChessboardColorScheme.brown;
      case BoardTheme.blue:
        return cg.ChessboardColorScheme.blue;
      case BoardTheme.blue2:
        return cg.ChessboardColorScheme.blue2;
      case BoardTheme.blue3:
        return cg.ChessboardColorScheme.blue3;
      case BoardTheme.blueMarble:
        return cg.ChessboardColorScheme.blueMarble;
      case BoardTheme.canvas:
        return cg.ChessboardColorScheme.canvas;
      case BoardTheme.wood:
        return cg.ChessboardColorScheme.wood;
      case BoardTheme.wood2:
        return cg.ChessboardColorScheme.wood2;
      case BoardTheme.wood3:
        return cg.ChessboardColorScheme.wood3;
      case BoardTheme.wood4:
        return cg.ChessboardColorScheme.wood4;
      case BoardTheme.maple:
        return cg.ChessboardColorScheme.maple;
      case BoardTheme.maple2:
        return cg.ChessboardColorScheme.maple2;
      case BoardTheme.brown:
        return cg.ChessboardColorScheme.brown;
      case BoardTheme.leather:
        return cg.ChessboardColorScheme.leather;
      case BoardTheme.green:
        return cg.ChessboardColorScheme.green;
      case BoardTheme.marble:
        return cg.ChessboardColorScheme.marble;
      case BoardTheme.greenPlastic:
        return cg.ChessboardColorScheme.greenPlastic;
      case BoardTheme.grey:
        return cg.ChessboardColorScheme.grey;
      case BoardTheme.metal:
        return cg.ChessboardColorScheme.metal;
      case BoardTheme.olive:
        return cg.ChessboardColorScheme.olive;
      case BoardTheme.newspaper:
        return cg.ChessboardColorScheme.newspaper;
      case BoardTheme.purpleDiag:
        return cg.ChessboardColorScheme.purpleDiag;
      case BoardTheme.pinkPyramid:
        return cg.ChessboardColorScheme.pinkPyramid;
      case BoardTheme.horsey:
        return cg.ChessboardColorScheme.horsey;
    }
  }

  Widget get thumbnail => this == BoardTheme.system
      ? SizedBox(
          height: 44,
          width: 44 * 6,
          child: Row(
            children: [
              for (final c in const [1, 2, 3, 4, 5, 6])
                Container(
                  width: 44,
                  color: c.isEven
                      ? BoardTheme.system.colors.darkSquare
                      : BoardTheme.system.colors.lightSquare,
                ),
            ],
          ),
        )
      : Image.asset(
          'assets/board-thumbnails/$name.jpg',
          height: 44,
          errorBuilder: (context, o, st) => const SizedBox.shrink(),
        );
}

@Freezed(fromJson: true, toJson: true)
class Analysis with _$Analysis implements SerializablePreferences {
  const Analysis._();

  const factory Analysis({
    required bool enableLocalEvaluation,
    required bool showEvaluationGauge,
    required bool showBestMoveArrow,
    required bool showAnnotations,
    required bool showPgnComments,
    @Assert('numEvalLines >= 1 && numEvalLines <= 3') required int numEvalLines,
    @Assert('numEngineCores >= 1 && numEngineCores <= maxEngineCores')
    required int numEngineCores,
  }) = _Analysis;

  static const defaults = Analysis(
    enableLocalEvaluation: true,
    showEvaluationGauge: true,
    showBestMoveArrow: true,
    showAnnotations: true,
    showPgnComments: true,
    numEvalLines: 2,
    numEngineCores: 1,
  );

  factory Analysis.fromJson(Map<String, dynamic> json) {
    try {
      return _$AnalysisFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
class OverTheBoard with _$OverTheBoard implements SerializablePreferences {
  const OverTheBoard._();

  const factory OverTheBoard({
    required bool flipPiecesAfterMove,
    required bool symmetricPieces,
  }) = _OverTheBoard;

  static const defaults = OverTheBoard(
    flipPiecesAfterMove: false,
    symmetricPieces: false,
  );

  factory OverTheBoard.fromJson(Map<String, dynamic> json) {
    try {
      return _$OverTheBoardFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}
