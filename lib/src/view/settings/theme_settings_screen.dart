import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
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

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

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

String shapeColorL10n(BuildContext context, ShapeColor shapeColor) => switch (shapeColor) {
  ShapeColor.green => context.l10n.mobileColorGreen,
  ShapeColor.red => context.l10n.mobileColorRed,
  ShapeColor.blue => context.l10n.mobileColorBlue,
  ShapeColor.yellow => context.l10n.mobileColorYellow,
};

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  late double brightness;
  late double hue;

  bool openAdjustColorSection = false;

  @override
  void initState() {
    super.initState();
    final boardPrefs = ref.read(boardPreferencesProvider);
    brightness = boardPrefs.brightness;
    hue = boardPrefs.hue;
  }

  @override
  Widget build(BuildContext context) {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);

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
                      icon: const Icon(Icons.wallpaper),
                      settingsLabel: Text(context.l10n.background),
                      settingsValue: generalPrefs.backgroundColor != null
                          ? generalPrefs.backgroundColor!.$1.label
                          : (generalPrefs.backgroundImage != null
                                ? context.l10n.mobileImage
                                : context.l10n.mobileDefaultBackground),
                      onTap: () {
                        Navigator.of(context).push(BackgroundChoiceScreen.buildRoute());
                      },
                    ),
                    if (generalPrefs.backgroundColor != null ||
                        generalPrefs.backgroundImage != null)
                      ListTile(
                        leading: const Icon(Icons.cancel),
                        title: Text(context.l10n.mobileResetBackground),
                        onTap: () {
                          ref
                              .read(generalPreferencesProvider.notifier)
                              .setBackground(backgroundColor: null, backgroundImage: null);
                        },
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
                      settingsLabel: Text(context.l10n.mobileDrawnShapeColor),
                      explanation: context.l10n.mobileDrawnShapeColorExplanation,
                      settingsValue: shapeColorL10n(context, boardPrefs.shapeColor),
                      onTap: () {
                        showChoicePicker(
                          context,
                          choices: ShapeColor.values,
                          selectedItem: boardPrefs.shapeColor,
                          labelBuilder: (t) => Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: shapeColorL10n(context, t)),
                                const TextSpan(text: '   '),
                                WidgetSpan(child: Container(width: 15, height: 15, color: t.color)),
                              ],
                            ),
                          ),
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
                      // TODO translate
                      leading: const Icon(Icons.border_outer),
                      title: Text(context.l10n.mobileShowBorder),
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
                      leading: const Icon(Icons.cancel),
                      title: Text(context.l10n.boardReset),
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

class _BoardPreview extends StatelessWidget {
  const _BoardPreview({
    required this.size,
    required this.boardPrefs,
    required this.brightness,
    required this.hue,
  });

  final BoardPrefs boardPrefs;
  final double brightness;
  final double hue;
  final double size;

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
