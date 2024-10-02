import 'dart:math' as math;
import 'package:chessground/chessground.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/common/time_increment.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';
import 'package:lichess_mobile/src/model/puzzle/puzzle_difficulty.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';

part 'preferences.freezed.dart';
part 'preferences.g.dart';

/// A preference category with its storage key and default values.
enum Category<T extends SerializablePreferences> {
  general('preferences.general', General.defaults),
  home('preferences.home', Home.defaults),
  board('preferences.board', Board.defaults),
  analysis('preferences.analysis', Analysis.defaults),
  overTheBoard('preferences.overTheBoard', OverTheBoard.defaults),
  challenge('preferences.challenge', Challenge.defaults),
  gameSetup('preferences.gameSetup', GameSetup.defaults),
  game('preferences.game', Game.defaults),
  coordinateTraining(
    'preferences.coordinateTraining',
    CoordinateTraining.defaults,
  ),
  openingExplorer(
    'preferences.opening_explorer',
    null as OpeningExplorerPrefs?,
  ),
  puzzle('preferences.puzzle', null as PuzzlePrefs?);

  const Category(this.storageKey, this._defaults);

  final String storageKey;
  final T? _defaults;

  T defaults({LightUser? user}) => switch (this) {
        Category.general => _defaults!,
        Category.home => _defaults!,
        Category.board => _defaults!,
        Category.analysis => _defaults!,
        Category.overTheBoard => _defaults!,
        Category.challenge => _defaults!,
        Category.gameSetup => _defaults!,
        Category.game => _defaults!,
        Category.coordinateTraining => _defaults!,
        Category.openingExplorer =>
          OpeningExplorerPrefs.defaults(user: user) as T,
        Category.puzzle => PuzzlePrefs.defaults(id: user?.id) as T,
      };
}

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
      case Category.challenge:
        return Challenge.fromJson(json);
      case Category.gameSetup:
        return GameSetup.fromJson(json);
      case Category.game:
        return Game.fromJson(json);
      case Category.coordinateTraining:
        return CoordinateTraining.fromJson(json);
      case Category.openingExplorer:
        return OpeningExplorerPrefs.fromJson(json);
      case Category.puzzle:
        return PuzzlePrefs.fromJson(json);
    }
  }
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
    @JsonKey(defaultValue: true) required bool enableShapeDrawings,
    @JsonKey(defaultValue: true) required bool magnifyDraggedPiece,
    @JsonKey(
      defaultValue: ShapeColor.green,
      unknownEnumValue: ShapeColor.green,
    )
    required ShapeColor shapeColor,
  }) = _Board;

  static const defaults = Board(
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
    enableShapeDrawings: true,
    magnifyDraggedPiece: true,
    shapeColor: ShapeColor.green,
  );

  ChessboardSettings toBoardSettings() {
    return ChessboardSettings(
      pieceAssets: pieceSet.assets,
      colorScheme: boardTheme.colors,
      showValidMoves: showLegalMoves,
      showLastMove: boardHighlights,
      enableCoordinates: coordinates,
      animationDuration: pieceAnimationDuration,
      dragFeedbackScale: magnifyDraggedPiece ? 2.0 : 1.0,
      dragFeedbackOffset: Offset(0.0, magnifyDraggedPiece ? -1.0 : 0.0),
      pieceShiftMethod: pieceShiftMethod,
      drawShape: DrawShapeOptions(
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

@Freezed(fromJson: true, toJson: true)
class Challenge with _$Challenge implements SerializablePreferences {
  const Challenge._();

  const factory Challenge({
    required Variant variant,
    required ChallengeTimeControlType timeControl,
    required ({Duration time, Duration increment}) clock,
    required int days,
    required bool rated,
    required SideChoice sideChoice,
  }) = _Challenge;

  static const defaults = Challenge(
    variant: Variant.standard,
    timeControl: ChallengeTimeControlType.clock,
    clock: (time: Duration(minutes: 10), increment: Duration.zero),
    days: 3,
    rated: false,
    sideChoice: SideChoice.random,
  );

  Speed get speed => timeControl == ChallengeTimeControlType.clock
      ? Speed.fromTimeIncrement(
          TimeIncrement(
            clock.time.inSeconds,
            clock.increment.inSeconds,
          ),
        )
      : Speed.correspondence;

  ChallengeRequest makeRequest(LightUser destUser, [String? initialFen]) {
    return ChallengeRequest(
      destUser: destUser,
      variant: variant,
      timeControl: timeControl,
      clock: clock,
      days: days,
      rated: rated,
      sideChoice: sideChoice,
      initialFen: initialFen,
    );
  }

  factory Challenge.fromJson(Map<String, dynamic> json) {
    try {
      return _$ChallengeFromJson(json);
    } catch (_) {
      return Challenge.defaults;
    }
  }
}

enum TimeControl { realTime, correspondence }

@Freezed(fromJson: true, toJson: true)
class GameSetup with _$GameSetup implements SerializablePreferences {
  const GameSetup._();

  const factory GameSetup({
    required TimeIncrement quickPairingTimeIncrement,
    required TimeControl customTimeControl,
    required int customTimeSeconds,
    required int customIncrementSeconds,
    required int customDaysPerTurn,
    required Variant customVariant,
    required bool customRated,
    required SideChoice customSide,
    required (int, int) customRatingDelta,
  }) = _GameSetup;

  static const defaults = GameSetup(
    quickPairingTimeIncrement: TimeIncrement(600, 0),
    customTimeControl: TimeControl.realTime,
    customTimeSeconds: 180,
    customIncrementSeconds: 0,
    customVariant: Variant.standard,
    customRated: false,
    customSide: SideChoice.random,
    customRatingDelta: (-500, 500),
    customDaysPerTurn: 3,
  );

  Speed get speedFromCustom => Speed.fromTimeIncrement(
        TimeIncrement(
          customTimeSeconds,
          customIncrementSeconds,
        ),
      );

  Perf get perfFromCustom => Perf.fromVariantAndSpeed(
        customVariant,
        speedFromCustom,
      );

  /// Returns the rating range for the custom setup, or null if the user
  /// doesn't have a rating for the custom setup perf.
  (int, int)? ratingRangeFromCustom(User user) {
    final perf = user.perfs[perfFromCustom];
    if (perf == null) return null;
    if (perf.provisional == true) return null;
    final min = math.max(0, perf.rating + customRatingDelta.$1);
    final max = perf.rating + customRatingDelta.$2;
    return (min, max);
  }

  factory GameSetup.fromJson(Map<String, dynamic> json) {
    try {
      return _$GameSetupFromJson(json);
    } catch (_) {
      return defaults;
    }
  }
}

@Freezed(fromJson: true, toJson: true)
class Game with _$Game implements SerializablePreferences {
  const factory Game({
    bool? enableChat,
    bool? blindfoldMode,
  }) = _Game;

  static const defaults = Game(
    enableChat: true,
  );

  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);
}

enum TimeChoice {
  thirtySeconds(Duration(seconds: 30)),
  unlimited(null);

  const TimeChoice(this.duration);

  final Duration? duration;

  // TODO l10n
  Widget label(AppLocalizations l10n) {
    switch (this) {
      case TimeChoice.thirtySeconds:
        return const Text('30s');
      case TimeChoice.unlimited:
        return const Icon(Icons.all_inclusive);
    }
  }
}

enum TrainingMode {
  findSquare,
  nameSquare;

  // TODO l10n
  String label(AppLocalizations l10n) {
    switch (this) {
      case TrainingMode.findSquare:
        return 'Find Square';
      case TrainingMode.nameSquare:
        return 'Name Square';
    }
  }
}

@Freezed(fromJson: true, toJson: true)
class CoordinateTraining
    with _$CoordinateTraining
    implements SerializablePreferences {
  const CoordinateTraining._();

  const factory CoordinateTraining({
    required bool showCoordinates,
    required bool showPieces,
    required TrainingMode mode,
    required TimeChoice timeChoice,
    required SideChoice sideChoice,
  }) = _CoordinateTraining;

  static const defaults = CoordinateTraining(
    showCoordinates: false,
    showPieces: true,
    mode: TrainingMode.findSquare,
    timeChoice: TimeChoice.thirtySeconds,
    sideChoice: SideChoice.random,
  );

  factory CoordinateTraining.fromJson(Map<String, dynamic> json) {
    return _$CoordinateTrainingFromJson(json);
  }
}

@Freezed(fromJson: true, toJson: true)
class PuzzlePrefs with _$PuzzlePrefs implements SerializablePreferences {
  const factory PuzzlePrefs({
    required UserId? id,
    required PuzzleDifficulty difficulty,

    /// If `true`, will show next puzzle after successful completion. This has
    /// no effect on puzzle streaks, which always show next puzzle. Defaults to
    /// `false`.
    @Default(false) bool autoNext,
  }) = _PuzzlePrefs;

  factory PuzzlePrefs.defaults({UserId? id}) => PuzzlePrefs(
        id: id,
        difficulty: PuzzleDifficulty.normal,
        autoNext: false,
      );

  factory PuzzlePrefs.fromJson(Map<String, dynamic> json) =>
      _$PuzzlePrefsFromJson(json);
}
