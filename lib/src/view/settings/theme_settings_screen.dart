import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
import 'package:lichess_mobile/src/widgets/settings.dart';

class ThemeSettingsScreen extends ConsumerWidget {
  const ThemeSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const ThemeSettingsScreen());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Scaffold(body: _Body());
  }
}

String shapeColorL10n(BuildContext context, ShapeColor shapeColor) => switch (shapeColor) {
  ShapeColor.green => 'Green',
  ShapeColor.red => 'Red',
  ShapeColor.blue => 'Blue',
  ShapeColor.yellow => 'Yellow',
};

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  late double brightness;
  late double hue;

  double headerOpacity = 0;

  bool openAdjustColorSection = false;

  @override
  void initState() {
    super.initState();
    final boardPrefs = ref.read(boardPreferencesProvider);
    brightness = boardPrefs.brightness;
    hue = boardPrefs.hue;
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification && notification.depth == 0) {
      final ScrollMetrics metrics = notification.metrics;
      double scrollExtent = 0.0;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          scrollExtent = metrics.extentAfter;
        case AxisDirection.down:
          scrollExtent = metrics.extentBefore;
        case AxisDirection.right:
        case AxisDirection.left:
          break;
      }

      final opacity = scrollExtent > 0.0 ? 1.0 : 0.0;

      if (opacity != headerOpacity) {
        setState(() {
          headerOpacity = opacity;
        });
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);

    final bool hasAjustedColors =
        brightness != kBoardDefaultBrightnessFilter || hue != kBoardDefaultHueFilter;

    final boardSize = isTabletOrLarger(context) ? 350.0 : 200.0;

    return NotificationListener(
      onNotification: handleScrollNotification,
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Theme.of(
              context,
            ).appBarTheme.backgroundColor?.withValues(alpha: headerOpacity),
            pinned: true,
            title: Text(context.l10n.mobileTheme),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(boardSize + 16.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: _BoardPreview(
                  size: boardSize,
                  boardPrefs: boardPrefs,
                  brightness: brightness,
                  hue: hue,
                ),
              ),
            ),
          ),
          SliverList.list(
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
                    settingsValue: generalPrefs.backgroundColor != null
                        ? generalPrefs.backgroundColor!.$1.label
                        : (generalPrefs.backgroundImage != null ? 'Image' : 'Default'),
                    onTap: () {
                      Navigator.of(context).push(BackgroundChoiceScreen.buildRoute(context));
                    },
                  ),
                  if (generalPrefs.backgroundColor != null || generalPrefs.backgroundImage != null)
                    ListTile(
                      leading: const Icon(Icons.cancel),
                      title: const Text('Reset background'),
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
                    settingsLabel: const Text('Drawn shape color'),
                    explanation:
                        'This color is only used for shapes drawn by hand using two fingers.',
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
                    leading: Opacity(
                      opacity: hasAjustedColors ? 1.0 : 0.5,
                      child: const Icon(Icons.cancel),
                    ),
                    title: Opacity(
                      opacity: hasAjustedColors ? 1.0 : 0.5,
                      child: Text(context.l10n.boardReset),
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
          const SliverSafeArea(
            top: false,
            sliver: SliverToBoxAdapter(child: SizedBox(height: 16.0)),
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
      child: Chessboard.fixed(
        size: size,
        orientation: Side.white,
        lastMove: const NormalMove(from: Square.e2, to: Square.e4),
        fen: 'rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq - 0 1',
        shapes: <Shape>{
          Circle(color: boardPrefs.shapeColor.color, orig: Square.fromName('b8')),
          Arrow(
            color: boardPrefs.shapeColor.color,
            orig: Square.fromName('b8'),
            dest: Square.fromName('c6'),
          ),
        }.lock,
        settings: boardPrefs.toBoardSettings().copyWith(
          brightness: brightness,
          hue: hue,
          borderRadius: Styles.boardBorderRadius,
          boxShadow: boardShadows,
        ),
      ),
    );
  }
}
