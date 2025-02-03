import 'package:chessground/chessground.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart' show CupertinoThemeData;
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/settings/preferences_storage.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'board_preferences.freezed.dart';
part 'board_preferences.g.dart';

const kBoardDefaultBrightnessFilter = 1.0;
const kBoardDefaultHueFilter = 0.0;

@Riverpod(keepAlive: true)
class BoardPreferences extends _$BoardPreferences with PreferencesStorage<BoardPrefs> {
  // ignore: avoid_public_notifier_properties
  @override
  PrefCategory get prefCategory => PrefCategory.board;

  // ignore: avoid_public_notifier_properties
  @override
  BoardPrefs get defaults => BoardPrefs.defaults;

  @override
  BoardPrefs fromJson(Map<String, dynamic> json) => BoardPrefs.fromJson(json);

  @override
  BoardPrefs build() {
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
      state.copyWith(immersiveModeWhilePlaying: !(state.immersiveModeWhilePlaying ?? false)),
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

  Future<void> toggleBorder() {
    return save(state.copyWith(showBorder: !state.showBorder));
  }

  Future<void> togglePieceAnimation() {
    return save(state.copyWith(pieceAnimation: !state.pieceAnimation));
  }

  Future<void> toggleMagnifyDraggedPiece() {
    return save(state.copyWith(magnifyDraggedPiece: !state.magnifyDraggedPiece));
  }

  Future<void> setDragTargetKind(DragTargetKind dragTargetKind) {
    return save(state.copyWith(dragTargetKind: dragTargetKind));
  }

  Future<void> setMaterialDifferenceFormat(MaterialDifferenceFormat materialDifferenceFormat) {
    return save(state.copyWith(materialDifferenceFormat: materialDifferenceFormat));
  }

  Future<void> setClockPosition(ClockPosition clockPosition) {
    return save(state.copyWith(clockPosition: clockPosition));
  }

  Future<void> toggleEnableShapeDrawings() {
    return save(state.copyWith(enableShapeDrawings: !state.enableShapeDrawings));
  }

  Future<void> setShapeColor(ShapeColor shapeColor) {
    return save(state.copyWith(shapeColor: shapeColor));
  }

  Future<void> adjustColors({double? brightness, double? hue}) {
    return save(state.copyWith(brightness: brightness ?? state.brightness, hue: hue ?? state.hue));
  }

  Future<void> setBackground({
    BoardBackgroundTheme? backgroundTheme,
    BoardBackgroundImage? backgroundImage,
  }) {
    assert(
      !(backgroundTheme != null && backgroundImage != null),
      'Only one of backgroundTheme or backgroundImage should be set',
    );
    return save(state.copyWith(backgroundTheme: backgroundTheme, backgroundImage: backgroundImage));
  }
}

@Freezed(fromJson: true, toJson: true)
class BoardPrefs with _$BoardPrefs implements Serializable {
  const BoardPrefs._();

  @Assert('brightness >= 0.2 && brightness <= 1.4, hue >= 0.0 && hue <= 360.0')
  const factory BoardPrefs({
    required PieceSet pieceSet,
    required BoardTheme boardTheme,
    bool? immersiveModeWhilePlaying,
    required bool hapticFeedback,
    required bool showLegalMoves,
    required bool boardHighlights,
    required bool coordinates,
    required bool pieceAnimation,
    @JsonKey(
      defaultValue: MaterialDifferenceFormat.materialDifference,
      unknownEnumValue: MaterialDifferenceFormat.materialDifference,
    )
    required MaterialDifferenceFormat materialDifferenceFormat,
    @JsonKey(defaultValue: ClockPosition.right, unknownEnumValue: ClockPosition.right)
    required ClockPosition clockPosition,
    @JsonKey(defaultValue: PieceShiftMethod.either, unknownEnumValue: PieceShiftMethod.either)
    required PieceShiftMethod pieceShiftMethod,

    /// Whether to enable shape drawings on the board for games and puzzles.
    @JsonKey(defaultValue: true) required bool enableShapeDrawings,
    @JsonKey(defaultValue: true) required bool magnifyDraggedPiece,
    @JsonKey(defaultValue: DragTargetKind.circle, unknownEnumValue: DragTargetKind.circle)
    required DragTargetKind dragTargetKind,
    @JsonKey(defaultValue: ShapeColor.green, unknownEnumValue: ShapeColor.green)
    required ShapeColor shapeColor,
    @JsonKey(defaultValue: false) required bool showBorder,
    @JsonKey(defaultValue: kBoardDefaultBrightnessFilter) required double brightness,
    @JsonKey(defaultValue: kBoardDefaultHueFilter) required double hue,
    BoardBackgroundTheme? backgroundTheme,
    @BoardBackgroundImageConverter() BoardBackgroundImage? backgroundImage,
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
    materialDifferenceFormat: MaterialDifferenceFormat.materialDifference,
    clockPosition: ClockPosition.right,
    pieceShiftMethod: PieceShiftMethod.either,
    enableShapeDrawings: true,
    magnifyDraggedPiece: true,
    dragTargetKind: DragTargetKind.circle,
    shapeColor: ShapeColor.green,
    showBorder: false,
    brightness: kBoardDefaultBrightnessFilter,
    hue: kBoardDefaultHueFilter,
  );

  bool get hasColorAdjustments =>
      brightness != kBoardDefaultBrightnessFilter || hue != kBoardDefaultHueFilter;

  ChessboardSettings toBoardSettings() {
    return ChessboardSettings(
      pieceAssets: pieceSet.assets,
      colorScheme: boardTheme.colors,
      brightness: brightness,
      hue: hue,
      border:
          showBorder
              ? BoardBorder(color: darken(boardTheme.colors.darkSquare, 0.2), width: 16.0)
              : null,
      showValidMoves: showLegalMoves,
      showLastMove: boardHighlights,
      enableCoordinates: coordinates,
      animationDuration: pieceAnimationDuration,
      dragFeedbackScale: magnifyDraggedPiece ? 2.0 : 1.0,
      dragFeedbackOffset: Offset(0.0, magnifyDraggedPiece ? -1.0 : 0.0),
      dragTargetKind: dragTargetKind,
      pieceShiftMethod: pieceShiftMethod,
      drawShape: DrawShapeOptions(enable: enableShapeDrawings, newShapeColor: shapeColor.color),
    );
  }

  factory BoardPrefs.fromJson(Map<String, dynamic> json) {
    return _$BoardPrefsFromJson(json);
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

  Color get color => Color(switch (this) {
    ShapeColor.green => 0x15781B,
    ShapeColor.red => 0x882020,
    ShapeColor.blue => 0x003088,
    ShapeColor.yellow => 0xe68f00,
  }).withAlpha(0xAA);
}

/// The chessboard theme.
enum BoardTheme {
  system('System', 'system'),
  blue('Blue', 'blue'),
  blue2('Blue 2', 'blue2'),
  blue3('Blue 3', 'blue3'),
  blueMarble('Blue Marble', 'blue-marble'),
  canvas('Canvas', 'canvas'),
  wood('Wood', 'wood'),
  wood2('Wood 2', 'wood2'),
  wood3('Wood 3', 'wood3'),
  wood4('Wood 4', 'wood4'),
  maple('Maple', 'maple'),
  maple2('Maple 2', 'maple2'),
  brown('Brown', 'brown'),
  leather('Leather', 'leather'),
  green('Green', 'green'),
  marble('Marble', 'marble'),
  greenPlastic('Green Plastic', 'green-plastic'),
  grey('Grey', 'grey'),
  metal('Metal', 'metal'),
  olive('Olive', 'olive'),
  newspaper('Newspaper', 'newspaper'),
  purpleDiag('Purple-Diag', 'purple-diag'),
  pinkPyramid('Pink', 'pink'),
  horsey('Horsey', 'horsey');

  final String label;
  final String gifApiName;

  const BoardTheme(this.label, this.gifApiName);

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

  FlexSchemeData get flexScheme {
    final lightScheme = SeedColorScheme.fromSeeds(
      primaryKey: colors.darkSquare,
      secondaryKey: colors.lightSquare,
      brightness: Brightness.light,
    );
    final darkScheme = SeedColorScheme.fromSeeds(
      primaryKey: colors.darkSquare,
      secondaryKey: colors.lightSquare,
      brightness: Brightness.dark,
    );
    return FlexSchemeData(
      name: 'Chessboard',
      description: 'Chessboard based theme: $label',
      light: FlexSchemeColor(
        primary: lightScheme.primary,
        primaryContainer: lightScheme.primaryContainer,
        secondary: lightScheme.secondary,
        secondaryContainer: lightScheme.secondaryContainer,
        tertiary: lightScheme.tertiary,
        tertiaryContainer: lightScheme.tertiaryContainer,
        error: lightScheme.error,
        errorContainer: lightScheme.errorContainer,
      ),
      dark: FlexSchemeColor(
        primary: darkScheme.primary,
        primaryContainer: darkScheme.primaryContainer,
        primaryLightRef: lightScheme.primary,
        secondary: darkScheme.secondary,
        secondaryContainer: darkScheme.secondaryContainer,
        secondaryLightRef: lightScheme.secondary,
        tertiary: darkScheme.tertiary,
        tertiaryContainer: darkScheme.tertiaryContainer,
        tertiaryLightRef: lightScheme.tertiary,
        error: darkScheme.error,
        errorContainer: darkScheme.errorContainer,
      ),
    );
  }

  Widget get thumbnail =>
      this == BoardTheme.system
          ? SizedBox(
            height: 44,
            width: 44 * 6,
            child: Row(
              children: [
                for (final c in const [1, 2, 3, 4, 5, 6])
                  Container(
                    width: 44,
                    color:
                        c.isEven
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

enum MaterialDifferenceFormat {
  materialDifference(label: 'Material difference'),
  capturedPieces(label: 'Captured pieces'),
  hidden(label: 'Hidden');

  const MaterialDifferenceFormat({required this.label});

  final String label;

  bool get visible => this != MaterialDifferenceFormat.hidden;

  String l10n(AppLocalizations l10n) => switch (this) {
    //TODO: Add l10n
    MaterialDifferenceFormat.materialDifference => materialDifference.label,
    MaterialDifferenceFormat.capturedPieces => capturedPieces.label,
    MaterialDifferenceFormat.hidden => hidden.label,
  };
}

enum ClockPosition {
  left,
  right;

  // TODO: l10n
  String get label => switch (this) {
    ClockPosition.left => 'Left',
    ClockPosition.right => 'Right',
  };
}

String dragTargetKindLabel(DragTargetKind kind) => switch (kind) {
  DragTargetKind.circle => 'Circle',
  DragTargetKind.square => 'Square',
  DragTargetKind.none => 'None',
};

enum BoardBackgroundTheme {
  /// The background theme is based on the chess board
  board(20, 30),
  blue(30, 34, FlexScheme.blue, 'Blue'),
  indigo(30, 34, FlexScheme.indigo, 'indigo'),
  green(30, 34, FlexScheme.jungle, 'Green'),
  brown(30, 34, FlexScheme.purpleBrown, 'Brown'),
  gold(30, 34, FlexScheme.gold, 'Gold'),
  red(34, 34, FlexScheme.redWine, 'Red'),
  purple(30, 34, FlexScheme.purpleM3, 'Purple'),
  sepia(28, 34, FlexScheme.sepia, 'Sepia'),

  dimRed(16, 20, FlexScheme.redWine, 'Dim Red'),
  dimPurple(16, 20, FlexScheme.purpleM3, 'Dim Purple'),
  dimIndigo(16, 20, FlexScheme.indigo, 'Dim indigo'),
  dimGold(16, 20, FlexScheme.gold, 'Dim Gold'),
  dimBlue(16, 20, FlexScheme.blue, 'Dim Blue'),
  dimGreen(16, 20, FlexScheme.greenM3, 'Dim Green');

  final int lightBlend;
  final int darkBlend;
  final FlexScheme? scheme;
  final String? _label;

  const BoardBackgroundTheme(this.lightBlend, this.darkBlend, [this.scheme, this._label]);

  String label(AppLocalizations l10n) => this == BoardBackgroundTheme.board ? l10n.board : _label!;

  FlexSchemeData getFlexScheme(BoardTheme boardTheme) =>
      this == BoardBackgroundTheme.board ? boardTheme.flexScheme : scheme!.data;
}

@freezed
class BoardBackgroundImage with _$BoardBackgroundImage {
  const BoardBackgroundImage._();

  const factory BoardBackgroundImage({
    /// The path to the image asset relative to the document directory returned by [getApplicationDocumentsDirectory]
    required String path,
    required Matrix4 transform,
    required bool isBlurred,
    required ColorScheme darkColors,
    required double meanLuminance,
    required double width,
    required double height,
    required double viewportWidth,
    required double viewportHeight,
  }) = _BoardBackgroundImage;

  static Color getFilterColor(ColorScheme scheme, double meanLuminance) =>
      scheme.surface.withValues(
        alpha: switch (meanLuminance) {
          < 0.2 => 0,
          < 0.4 => 0.25,
          < 0.6 => 0.5,
          _ => 0.8,
        },
      );

  static ThemeData getTheme(ColorScheme scheme) => FlexThemeData.dark(
    colors: FlexSchemeColor(
      primary: scheme.primary,
      primaryContainer: scheme.primaryContainer,
      secondary: scheme.secondary,
      secondaryContainer: scheme.secondaryContainer,
      tertiary: scheme.tertiary,
      tertiaryContainer: scheme.tertiaryContainer,
      error: scheme.error,
      errorContainer: scheme.errorContainer,
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
    appBarOpacity: 0.5,
  );

  ThemeData get theme => getTheme(darkColors);

  Color get filterColor => getFilterColor(darkColors, meanLuminance);
}

class BoardBackgroundImageConverter
    implements JsonConverter<BoardBackgroundImage?, Map<String, dynamic>?> {
  const BoardBackgroundImageConverter();

  @override
  BoardBackgroundImage? fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return null;
    }

    final darkColors = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(json['darkPrimary'] as int),
      onPrimary: Color(json['darkOnPrimary'] as int),
      primaryContainer: Color(json['darkPrimaryContainer'] as int),
      secondary: Color(json['darkSecondary'] as int),
      onSecondary: Color(json['darkOnSecondary'] as int),
      secondaryContainer: Color(json['darkSecondaryContainer'] as int),
      tertiary: Color(json['darkTertiary'] as int),
      tertiaryContainer: Color(json['darkTertiaryContainer'] as int),
      error: Color(json['darkError'] as int),
      onError: Color(json['darkOnError'] as int),
      errorContainer: Color(json['darkErrorContainer'] as int),
      surface: Color(json['darkSurface'] as int),
      onSurface: Color(json['darkOnSurface'] as int),
    );

    final transform = json['transform'] as List<dynamic>;

    return BoardBackgroundImage(
      path: json['path'] as String,
      transform: Matrix4.fromList(transform.map((e) => (e as num).toDouble()).toList()),
      isBlurred: json['isBlurred'] as bool,
      darkColors: darkColors,
      meanLuminance: json['meanLuminance'] as double,
      width: json['width'] as double,
      height: json['height'] as double,
      viewportWidth: json['viewportWidth'] as double,
      viewportHeight: json['viewportHeight'] as double,
    );
  }

  @override
  Map<String, dynamic>? toJson(BoardBackgroundImage? object) {
    if (object == null) {
      return null;
    }

    final Map<String, int> darkColors = {
      'darkPrimary': object.darkColors.primary.toARGB32(),
      'darkOnPrimary': object.darkColors.onPrimary.toARGB32(),
      'darkPrimaryContainer': object.darkColors.primaryContainer.toARGB32(),
      'darkSecondary': object.darkColors.secondary.toARGB32(),
      'darkOnSecondary': object.darkColors.onSecondary.toARGB32(),
      'darkSecondaryContainer': object.darkColors.secondaryContainer.toARGB32(),
      'darkTertiary': object.darkColors.tertiary.toARGB32(),
      'darkTertiaryContainer': object.darkColors.tertiaryContainer.toARGB32(),
      'darkError': object.darkColors.error.toARGB32(),
      'darkOnError': object.darkColors.onError.toARGB32(),
      'darkErrorContainer': object.darkColors.errorContainer.toARGB32(),
      'darkSurface': object.darkColors.surface.toARGB32(),
      'darkOnSurface': object.darkColors.onSurface.toARGB32(),
    };

    return {
      'path': object.path,
      'transform': object.transform.storage,
      'isBlurred': object.isBlurred,
      ...darkColors,
      'meanLuminance': object.meanLuminance,
      'width': object.width,
      'height': object.height,
      'viewportWidth': object.viewportWidth,
      'viewportHeight': object.viewportHeight,
    };
  }
}
