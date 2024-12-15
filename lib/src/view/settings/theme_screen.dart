import 'dart:math' as math;
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/system.dart';
import 'package:lichess_mobile/src/view/settings/board_theme_screen.dart';
import 'package:lichess_mobile/src/view/settings/piece_set_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(appBar: const PlatformAppBar(title: Text('Theme')), body: _Body());
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

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final generalPrefs = ref.watch(generalPreferencesProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final androidVersionAsync = ref.watch(androidVersionProvider);

    const horizontalPadding = 16.0;

    return ListView(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final double boardSize = math.min(
              400,
              constraints.biggest.shortestSide - horizontalPadding * 2,
            );
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
              child: Center(
                child: Chessboard.fixed(
                  size: boardSize,
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
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    boxShadow: boardShadows,
                  ),
                ),
              ),
            );
          },
        ),
        ListSection(
          hasLeading: true,
          children: [
            if (Theme.of(context).platform == TargetPlatform.android)
              androidVersionAsync.maybeWhen(
                data:
                    (version) =>
                        version != null && version.sdkInt >= 31
                            ? SwitchSettingTile(
                              leading: const Icon(Icons.colorize_outlined),
                              title: Text(context.l10n.mobileSystemColors),
                              value: generalPrefs.systemColors,
                              onChanged: (value) {
                                ref.read(generalPreferencesProvider.notifier).toggleSystemColors();
                              },
                            )
                            : const SizedBox.shrink(),
                orElse: () => const SizedBox.shrink(),
              ),
            SettingsListTile(
              icon: const Icon(LichessIcons.chess_board),
              settingsLabel: Text(context.l10n.board),
              settingsValue: boardPrefs.boardTheme.label,
              onTap: () {
                pushPlatformRoute(
                  context,
                  title: context.l10n.board,
                  builder: (context) => const BoardThemeScreen(),
                );
              },
            ),
            SettingsListTile(
              icon: const Icon(LichessIcons.chess_pawn),
              settingsLabel: Text(context.l10n.pieceSet),
              settingsValue: boardPrefs.pieceSet.label,
              onTap: () {
                pushPlatformRoute(
                  context,
                  title: context.l10n.pieceSet,
                  builder: (context) => const PieceSetScreen(),
                );
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
      ],
    );
  }
}
