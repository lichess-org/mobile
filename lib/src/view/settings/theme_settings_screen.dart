import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
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
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class ThemeSettingsScreen extends ConsumerStatefulWidget {
  const ThemeSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      screen: const ThemeSettingsScreen(),
      title: context.l10n.mobileTheme,
    );
  }

  @override
  ConsumerState<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends ConsumerState<ThemeSettingsScreen> {
  late double brightness;
  late double hue;

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
    final boardSize = isTabletOrLarger(context) ? 350.0 : 200.0;

    final bool hasAjustedColors =
        brightness != kBoardDefaultBrightnessFilter || hue != kBoardDefaultHueFilter;

    final body = ListView(
      padding:
          Theme.of(context).platform == TargetPlatform.iOS
              ? (MediaQuery.paddingOf(context) +
                  EdgeInsets.only(top: boardSize + 32.0 + kMinInteractiveDimensionCupertino))
              : null,
      children: [
        ListSection(
          hasLeading: true,
          children: [
            if (getCorePalette() != null)
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
              settingsValue:
                  generalPrefs.backgroundTheme?.label(context.l10n) ??
                  (generalPrefs.backgroundImage != null ? 'Image' : 'Default'),
              onTap: () {
                Navigator.of(context).push(BackgroundChoiceScreen.buildRoute(context));
              },
            ),
            if (generalPrefs.backgroundTheme != null || generalPrefs.backgroundImage != null)
              PlatformListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Reset background'),
                onTap: () {
                  ref
                      .read(generalPreferencesProvider.notifier)
                      .setBackground(backgroundTheme: null, backgroundImage: null);
                },
              ),
            SettingsListTile(
              icon: const Icon(LichessIcons.chess_board),
              settingsLabel: Text(context.l10n.board),
              settingsValue: boardPrefs.boardTheme.label,
              onTap: () {
                Navigator.of(context).push(BoardChoiceScreen.buildRoute(context));
              },
            ),
            SettingsListTile(
              icon: const Icon(LichessIcons.chess_pawn),
              settingsLabel: Text(context.l10n.pieceSet),
              settingsValue: boardPrefs.pieceSet.label,
              onTap: () {
                Navigator.of(context).push(PieceSetScreen.buildRoute(context));
              },
            ),
            SettingsListTile(
              icon: const Icon(LichessIcons.arrow_full_upperright),
              settingsLabel: const Text('Shape color'),
              settingsValue: shapeColorL10n(context, boardPrefs.shapeColor),
              onTap: () {
                showChoicePicker(
                  context,
                  choices: ShapeColor.values,
                  selectedItem: boardPrefs.shapeColor,
                  labelBuilder:
                      (t) => Text.rich(
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
              title: const Text('Show border'),
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
            PlatformListTile(
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
                  ref.read(boardPreferencesProvider.notifier).adjustColors(brightness: brightness);
                },
              ),
            ),
            PlatformListTile(
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
            PlatformListTile(
              leading: Opacity(
                opacity: hasAjustedColors ? 1.0 : 0.5,
                child: const Icon(Icons.cancel),
              ),
              title: Opacity(
                opacity: hasAjustedColors ? 1.0 : 0.5,
                child: Text(context.l10n.boardReset),
              ),
              onTap:
                  hasAjustedColors
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
    );

    final boardPreview = PreferredSize(
      preferredSize: Size.fromHeight(boardSize + 32.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: _BoardPreview(
          size: boardSize,
          boardPrefs: boardPrefs,
          brightness: brightness,
          hue: hue,
        ),
      ),
    );

    return PlatformWidget(
      androidBuilder:
          (context) => Scaffold(
            appBar: AppBar(title: Text(context.l10n.mobileTheme), bottom: boardPreview),
            body: body,
          ),
      iosBuilder:
          (context) => CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(context.l10n.mobileTheme),
              bottom: boardPreview,
            ),
            child: body,
          ),
    );
  }
}

String shapeColorL10n(BuildContext context, ShapeColor shapeColor) =>
// TODO add l10n
switch (shapeColor) {
  ShapeColor.green => 'Green',
  ShapeColor.red => 'Red',
  ShapeColor.blue => 'Blue',
  ShapeColor.yellow => 'Yellow',
};

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
      child: BrightnessHueFilter(
        brightness: brightness,
        hue: hue,
        child: Chessboard.fixed(
          size: size,
          orientation: Side.white,
          lastMove: const NormalMove(from: Square.e2, to: Square.e4),
          fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
          shapes:
              <Shape>{
                Circle(color: boardPrefs.shapeColor.color, orig: Square.fromName('b8')),
                Arrow(
                  color: boardPrefs.shapeColor.color,
                  orig: Square.fromName('b8'),
                  dest: Square.fromName('c6'),
                ),
              }.lock,
          settings: boardPrefs.toBoardSettings().copyWith(
            brightness: kBoardDefaultBrightnessFilter,
            hue: kBoardDefaultHueFilter,
            borderRadius: Styles.boardBorderRadius,
            boxShadow: boardShadows,
          ),
        ),
      ),
    );
  }
}
