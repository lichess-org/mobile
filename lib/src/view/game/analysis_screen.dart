import 'package:dartchess/dartchess.dart';
import 'package:chessground/chessground.dart' as cg;
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/game/analysis_ctrl.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/immersive_mode.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/model/game/game.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({
    required this.steps,
    required this.orientation,
  });

  final IList<GameStep> steps;
  final Side orientation;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.gameAnalysis),
      ),
      body: _Body(
        steps: steps,
        orientation: orientation,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.analysis),
      ),
      child: _Body(
        steps: steps,
        orientation: orientation,
      ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.steps,
    required this.orientation,
  });

  final IList<GameStep> steps;
  final Side orientation;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> with AndroidImmersiveMode {
  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisCtrlProvider(widget.steps, widget.orientation);

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _Board(ctrlProvider),
                _InlineTreeView(ctrlProvider),
              ],
            ),
          ),
        ),
        _BottomBar(ctrlProvider: ctrlProvider),
      ],
    );
  }
}

class _Board extends ConsumerWidget {
  const _Board(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final defaultSettings = cg.BoardSettings(
      pieceAssets: boardPrefs.pieceSet.assets,
      colorScheme: boardPrefs.boardTheme.colors,
      showValidMoves: boardPrefs.showLegalMoves,
      showLastMove: boardPrefs.boardHighlights,
      enableCoordinates: boardPrefs.coordinates,
      animationDuration: boardPrefs.pieceAnimationDuration,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final boardSize = constraints.biggest.shortestSide;
        return cg.Board(
          size: boardSize,
          data: cg.BoardData(
            orientation: analysisState.pov.cg,
            interactableSide: analysisState.position.isGameOver
                ? cg.InteractableSide.none
                : analysisState.position.turn == Side.white
                    ? cg.InteractableSide.white
                    : cg.InteractableSide.black,
            fen: analysisState.fen,
            isCheck: analysisState.position.isCheck,
            lastMove: analysisState.lastMove?.cg,
            sideToMove: analysisState.position.turn.cg,
            validMoves: analysisState.validMoves,
          ),
          settings: defaultSettings,
        );
      },
    );
  }
}

class _InlineTreeView extends ConsumerWidget {
  const _InlineTreeView(this.ctrlProvider);

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nodes = ref.watch(ctrlProvider.select((value) => value.root));
    final currentPath =
        ref.watch(ctrlProvider.select((value) => value.currentPath));
    var path = UciPath.empty;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Wrap(
          spacing: 1.0,
          children: nodes.map((move) {
            path = path + move.id;
            return _Move(
              ctrlProvider,
              path: path,
              move: move.sanMove,
              ply: move.ply,
              isCurrentMove: path == currentPath,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _Move extends ConsumerWidget {
  const _Move(
    this.ctrlProvider, {
    required this.path,
    required this.move,
    required this.ply,
    required this.isCurrentMove,
  });

  final AnalysisCtrlProvider ctrlProvider;
  final UciPath path;
  final SanMove move;
  final int ply;
  final bool isCurrentMove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = ply.isOdd ? '${(ply / 2).ceil()}. ${move.san}' : move.san;
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),
      onTap: () => ref.read(ctrlProvider.notifier).userJump(path),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: isCurrentMove
            ? BoxDecoration(
                color: Theme.of(context).focusColor,
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
              )
            : null,
        child: Text(
          text,
          style: const TextStyle(fontFamily: 'ChessFont'),
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.ctrlProvider,
  });

  final AnalysisCtrlProvider ctrlProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analysisState = ref.watch(ctrlProvider);

    return Container(
      padding: Styles.horizontalBodyPadding,
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            RepeatButton(
              onLongPress:
                  analysisState.canGoBack ? () => _moveBackward(ref) : null,
              child: BottomBarButton(
                onTap:
                    analysisState.canGoBack ? () => _moveBackward(ref) : null,
                label: 'Previous',
                shortLabel: 'Previous',
                icon: CupertinoIcons.chevron_back,
                showAndroidTooltip: false,
              ),
            ),
            RepeatButton(
              onLongPress:
                  analysisState.canGoNext ? () => _moveForward(ref) : null,
              child: BottomBarButton(
                icon: CupertinoIcons.chevron_forward,
                label: context.l10n.next,
                shortLabel: context.l10n.next,
                onTap: analysisState.canGoNext ? () => _moveForward(ref) : null,
                showAndroidTooltip: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _moveForward(WidgetRef ref) =>
      ref.read(ctrlProvider.notifier).userNext();
  void _moveBackward(WidgetRef ref) =>
      ref.read(ctrlProvider.notifier).userPrevious();
}


// how to display the ui for the tree.
// First display mainline.
// For the first sideline it should be in a new line.
// Each subsequent sidelines in the sidelines can be inlined
//
// Implementation Maybe?:
// Add nodes to a Wrap Widget.
