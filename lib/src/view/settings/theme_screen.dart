import 'dart:math' as math;
import 'package:chessground/chessground.dart';
import 'package:dartchess/dartchess.dart' as dartchess;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/settings/board_theme_screen.dart';
import 'package:lichess_mobile/src/view/settings/piece_set_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class ThemeScreen extends StatelessWidget {
  const ThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme')),
      body: _Body(),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: _Body(),
    );
  }
}

class _Body extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final boardPrefs = ref.watch(boardPreferencesProvider);

    const horizontalPadding = 52.0;

    return SafeArea(
      child: ListView(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final double boardSize = math.min(
                290,
                constraints.biggest.shortestSide - horizontalPadding * 2,
              );
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: horizontalPadding,
                  vertical: 16,
                ),
                child: Center(
                  child: Board(
                    size: boardSize,
                    data: const BoardData(
                      interactableSide: InteractableSide.none,
                      orientation: Side.white,
                      fen: dartchess.kInitialFEN,
                    ),
                    settings: BoardSettings(
                      enableCoordinates: false,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(4.0)),
                      boxShadow: boardShadows,
                      pieceAssets: boardPrefs.pieceSet.assets,
                      colorScheme: boardPrefs.boardTheme.colors,
                    ),
                  ),
                ),
              );
            },
          ),
          ListSection(
            children: [
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
            ],
          ),
        ],
      ),
    );
  }
}
