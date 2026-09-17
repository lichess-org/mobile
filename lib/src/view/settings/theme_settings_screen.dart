import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/color_palette.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/settings/background_theme_choice_screen.dart';
import 'package:lichess_mobile/src/view/settings/board_choice_screen.dart';
import 'package:lichess_mobile/src/view/settings/piece_set_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_ui/material_ui.dart';

class const ThemeSettingsScreen({super.key}) extends ConsumerWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const ThemeSettingsScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.mobileTheme), animateColor: true),
      body: const _Body(),
    );
  }
}

String shapeColorL10n(ShapeColor shapeColor) => switch (shapeColor) {
  ShapeColor.green => 'Green',
  ShapeColor.red => 'Red',
  ShapeColor.blue => 'Blue',
  ShapeColor.yellow => 'Yellow',
};

class const _Body() extends ConsumerStatefulWidget {
  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState() extends ConsumerState<_Body> {
  late double brightness;
  late double hue;

  bool openAdjustColorSection = false;

  /// Whether the user has selected a custom background, even if none is set yet.
  bool customBackgroundSelected = false;

  @override
  void initState() {
    super.initState();
    final boardPrefs = ref.read(boardPreferencesProvider);
    brightness = boardPrefs.brightness;
    hue = boardPrefs.hue;
  }

  /// Opens the custom background selection screen.
  ///
  /// Only an actual background color or image makes the background custom, so any transient
  /// selection is discarded when the user comes back without having picked one.
  Future<void> pickCustomBackground() async {
    await Navigator.of(context).push(BackgroundChoiceScreen.buildRoute());
    if (mounted) {
      setState(() {
        customBackgroundSelected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final bool isCustomBackground = generalPrefs.isForcedDarkMode || customBackgroundSelected;
    final BackgroundColor? backgroundColor = generalPrefs.backgroundColor?.$1;

    final bool hasAjustedColors =
        brightness != kBoardDefaultBrightnessFilter || hue != kBoardDefaultHueFilter;

    final boardSize = isTabletOrLarger(context) ? 350.0 : 200.0;

    return SafeArea(
      top: false,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: _BoardPreview(
              size: boardSize,
              boardPrefs: boardPrefs,
              brightness: brightness,
              hue: hue,
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListSection(
                  hasLeading: true,
                  children: [
                    if (getSystemCorePalettes() != null)
                      SwitchSettingTile(
                        leading: const Icon(Icons.colorize_outlined),
                        title: Text(context.l10n.mobileSystemColors),
                        value: generalPrefs.systemColors,
                        onChanged: (value) {
                          ref.read(generalPreferencesProvider.notifier).toggleSystemColors();
                        },
                      ),
                    SettingsListTile(
                      icon: const Icon(Icons.brightness_medium_outlined),
                      settingsLabel: Text(context.l10n.background),
                      settingsValue: isCustomBackground
                          ? backgroundColor?.label ??
                                (generalPrefs.backgroundImage != null
                                    ? context.l10n.backgroundImage
                                    : context.l10n.mobileCustomizeButton)
                          : generalPrefs.themeMode.title(context.l10n),
                      trailing: backgroundColor != null
                          ? _ColorCircle(color: backgroundColor.darker)
                          : null,
                      onTap: () async {
                        // The picker outlives this screen when switching away from a custom
                        // background, so the labels must not depend on this context.
                        final l10n = context.l10n;
                        bool newlyCustom = false;
                        await showChoicePicker<BackgroundThemeMode?>(
                          context,
                          // A null choice means a custom background.
                          choices: const [...BackgroundThemeMode.values, null],
                          selectedItem: isCustomBackground ? null : generalPrefs.themeMode,
                          labelBuilder: (t) => Text(t?.title(l10n) ?? l10n.mobileCustomizeButton),
                          onSelectedItemChanged: (BackgroundThemeMode? value) {
                            newlyCustom = value == null && !isCustomBackground;
                            if (mounted) {
                              setState(() {
                                customBackgroundSelected = value == null;
                              });
                            }
                            if (value != null) {
                              final notifier = ref.read(generalPreferencesProvider.notifier);
                              if (generalPrefs.isForcedDarkMode) {
                                // Preferences are only applied to the state once they are
                                // written, so the two updates must be sequenced, or the second
                                // one would overwrite the first with a stale state.
                                notifier
                                    .setBackground(backgroundColor: null, backgroundImage: null)
                                    .then((_) => notifier.setBackgroundThemeMode(value));
                              } else {
                                notifier.setBackgroundThemeMode(value);
                              }
                            }
                          },
                        );
                        // Let the user pick their background right away.
                        if (newlyCustom && context.mounted) {
                          await pickCustomBackground();
                        }
                      },
                    ),
                    if (isCustomBackground)
                      ListTile(
                        leading: const Icon(Icons.wallpaper),
                        // TODO: l10n
                        title: const Text('Choose a custom background'),
                        trailing: Theme.of(context).platform == TargetPlatform.iOS
                            ? const CupertinoListTileChevron()
                            : null,
                        onTap: pickCustomBackground,
                      ),
                    SettingsListTile(
                      icon: const Icon(LichessIcons.chess_board),
                      settingsLabel: Text(context.l10n.board),
                      settingsValue: boardPrefs.boardTheme.label,
                      onTap: () {
                        Navigator.of(context).push(BoardChoiceScreen.buildRoute());
                      },
                    ),
                    SettingsListTile(
                      icon: const Icon(LichessIcons.chess_pawn),
                      settingsLabel: Text(context.l10n.pieceSet),
                      settingsValue: boardPrefs.pieceSet.label,
                      onTap: () {
                        Navigator.of(context).push(PieceSetScreen.buildRoute());
                      },
                    ),
                    SettingsListTile(
                      icon: const Icon(LichessIcons.arrow_full_upperright),
                      settingsLabel: Text(context.l10n.mobileSettingsDrawnShapeColor),
                      explanation: context.l10n.mobileSettingsDrawnShapeColorHelp,
                      settingsValue: shapeColorL10n(boardPrefs.shapeColor),
                      trailing: _ColorCircle(color: boardPrefs.shapeColor.color),
                      onTap: () {
                        showChoicePicker(
                          context,
                          choices: ShapeColor.values,
                          selectedItem: boardPrefs.shapeColor,
                          labelBuilder: (t) => _ColorCircle(color: t.color),
                          onSelectedItemChanged: (ShapeColor? value) {
                            ref
                                .read(boardPreferencesProvider.notifier)
                                .setShapeColor(value ?? ShapeColor.green);
                          },
                        );
                      },
                    ),
                    SwitchSettingTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(context.l10n.preferencesBoardCoordinates),
                      value: boardPrefs.coordinates,
                      onChanged: (value) {
                        ref.read(boardPreferencesProvider.notifier).toggleCoordinates();
                      },
                    ),
                    SwitchSettingTile(
                      leading: const Icon(Icons.border_outer),
                      title: Text(context.l10n.mobileSettingsShowBorder),
                      value: boardPrefs.showBorder,
                      onChanged: (value) {
                        ref.read(boardPreferencesProvider.notifier).toggleBorder();
                      },
                    ),
                  ],
                ),
                ListSection(
                  header: SettingsSectionTitle(context.l10n.advancedSettings),
                  hasLeading: true,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.brightness_6),
                      title: Slider.adaptive(
                        min: 0.2,
                        max: 1.4,
                        value: brightness,
                        onChanged: (value) {
                          setState(() {
                            brightness = value;
                          });
                        },
                        onChangeEnd: (value) {
                          ref
                              .read(boardPreferencesProvider.notifier)
                              .adjustColors(brightness: brightness);
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.invert_colors),
                      title: Slider.adaptive(
                        min: 0.0,
                        max: 360.0,
                        value: hue,
                        onChanged: (value) {
                          setState(() {
                            hue = value;
                          });
                        },
                        onChangeEnd: (value) {
                          ref.read(boardPreferencesProvider.notifier).adjustColors(hue: hue);
                        },
                      ),
                    ),
                    ListTile(
                      enabled: hasAjustedColors,
                      leading: Icon(
                        Icons.clear,
                        color: hasAjustedColors ? lichessCustomColors.error : null,
                      ),
                      title: Text(
                        context.l10n.boardReset,
                        style: TextStyle(
                          color: hasAjustedColors ? lichessCustomColors.error : null,
                        ),
                      ),
                      onTap: hasAjustedColors
                          ? () {
                              setState(() {
                                brightness = kBoardDefaultBrightnessFilter;
                                hue = kBoardDefaultHueFilter;
                              });
                              ref
                                  .read(boardPreferencesProvider.notifier)
                                  .adjustColors(brightness: brightness, hue: hue);
                            }
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A small circle filled with [color], to preview a color setting.
class const _ColorCircle({required final Color color}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: ColorScheme.of(context).outlineVariant),
      ),
    );
  }
}

class const _BoardPreview({
  required final double size,
  required final BoardPrefs boardPrefs,
  required final double brightness,
  required final double hue,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: StaticChessboard(
        size: size,
        orientation: Side.white,
        lastMove: const NormalMove(from: Square.e2, to: Square.e4),
        fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
        shapes: {
          Circle(color: boardPrefs.shapeColor.color, orig: Square.fromName('b8')),
          Arrow(
            color: boardPrefs.shapeColor.color,
            orig: Square.fromName('b8'),
            dest: Square.fromName('c6'),
          ),
        },
        settings: StaticChessboardSettings.fromBoardSettings(
          boardPrefs
              .toBoardSettings(Variant.standard)
              .copyWith(
                brightness: brightness,
                hue: hue,
                borderRadius: Styles.boardBorderRadius,
                boxShadow: boardShadows,
              ),
        ),
      ),
    );
  }
}
