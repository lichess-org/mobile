import 'dart:math' as math;
import 'dart:ui';

import 'package:chessground/chessground.dart' as cg;
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/model/game/game_share_service.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/analysis/annotations.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

import 'analysis_share_screen.dart';

class AnalysisBoard extends ConsumerStatefulWidget {
  const AnalysisBoard(
    this.pgn,
    this.options,
    this.boardSize, {
    required this.isTablet,
  });

  final String pgn;
  final AnalysisOptions options;
  final double boardSize;
  final bool isTablet;

  @override
  ConsumerState<AnalysisBoard> createState() => AnalysisBoardState();
}

class AnalysisBoardState extends ConsumerState<AnalysisBoard> {
  ISet<cg.Shape> userShapes = ISet();

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = analysisControllerProvider(widget.pgn, widget.options);
    final analysisState = ref.watch(ctrlProvider);
    final boardPrefs = ref.watch(boardPreferencesProvider);
    final showBestMoveArrow = ref.watch(
      analysisPreferencesProvider.select(
        (value) => value.showBestMoveArrow,
      ),
    );
    final showAnnotationsOnBoard = ref.watch(
      analysisPreferencesProvider.select((value) => value.showAnnotations),
    );

    final evalBestMoves = ref.watch(
      engineEvaluationProvider.select((s) => s.eval?.bestMoves),
    );

    final currentNode = analysisState.currentNode;
    final annotation = makeAnnotation(currentNode.nags);

    final bestMoves = evalBestMoves ?? currentNode.eval?.bestMoves;

    final sanMove = currentNode.sanMove;

    final ISet<cg.Shape> bestMoveShapes = showBestMoveArrow &&
            analysisState.isEngineAvailable &&
            bestMoves != null
        ? _computeBestMoveShapes(bestMoves)
        : ISet();

    return cg.Board(
      size: widget.boardSize,
      onMove: (move, {isDrop, isPremove}) =>
          ref.read(ctrlProvider.notifier).onUserMove(Move.fromUci(move.uci)!),
      data: cg.BoardData(
        orientation: analysisState.pov.cg,
        interactableSide: analysisState.position.isGameOver
            ? cg.InteractableSide.none
            : analysisState.position.turn == Side.white
                ? cg.InteractableSide.white
                : cg.InteractableSide.black,
        fen: analysisState.position.fen,
        isCheck: boardPrefs.boardHighlights && analysisState.position.isCheck,
        lastMove: analysisState.lastMove?.cg,
        sideToMove: analysisState.position.turn.cg,
        validMoves: analysisState.validMoves,
        shapes: userShapes.union(bestMoveShapes),
        annotations:
            showAnnotationsOnBoard && sanMove != null && annotation != null
                ? altCastles.containsKey(sanMove.move.uci)
                    ? IMap({
                        Move.fromUci(altCastles[sanMove.move.uci]!)!.cg.to:
                            annotation,
                      })
                    : IMap({sanMove.move.cg.to: annotation})
                : null,
      ),
      settings: cg.BoardSettings(
        pieceAssets: boardPrefs.pieceSet.assets,
        colorScheme: boardPrefs.boardTheme.colors,
        showValidMoves: boardPrefs.showLegalMoves,
        showLastMove: boardPrefs.boardHighlights,
        enableCoordinates: boardPrefs.coordinates,
        animationDuration: boardPrefs.pieceAnimationDuration,
        borderRadius: widget.isTablet
            ? const BorderRadius.all(Radius.circular(4.0))
            : BorderRadius.zero,
        boxShadow: widget.isTablet ? boardShadows : const <BoxShadow>[],
        drawShape: cg.DrawShapeOptions(
          enable: true,
          onCompleteShape: _onCompleteShape,
          onClearShapes: _onClearShapes,
        ),
        pieceShiftMethod: boardPrefs.pieceShiftMethod,
      ),
    );
  }

  ISet<cg.Shape> _computeBestMoveShapes(IList<MoveWithWinningChances> moves) {
    // Scale down all moves with index > 0 based on how much worse their winning chances are compared to the best move
    // (assume moves are ordered by their winning chances, so index==0 is the best move)
    double scaleArrowAgainstBestMove(int index) {
      const minScale = 0.15;
      const maxScale = 1.0;
      const winningDiffScaleFactor = 2.5;

      final bestMove = moves[0];
      final winningDiffComparedToBestMove =
          bestMove.winningChances - moves[index].winningChances;
      // Force minimum scale if the best move is significantly better than this move
      if (winningDiffComparedToBestMove > 0.3) {
        return minScale;
      }
      return clampDouble(
        math.max(
          minScale,
          maxScale - winningDiffScaleFactor * winningDiffComparedToBestMove,
        ),
        0,
        1,
      );
    }

    return ISet(
      moves.mapIndexed(
        (i, m) {
          final move = m.move;
          // Same colors as in the Web UI with a slightly different opacity
          // The best move has a different color than the other moves
          final color = Color((i == 0) ? 0x66003088 : 0x664A4A4A);
          switch (move) {
            case NormalMove(from: _, to: _, promotion: final promRole):
              return [
                cg.Arrow(
                  color: color,
                  orig: move.cg.from,
                  dest: move.cg.to,
                  scale: scaleArrowAgainstBestMove(i),
                ),
                if (promRole != null)
                  cg.PieceShape(
                    color: color,
                    orig: move.cg.to,
                    role: promRole.cg,
                  ),
              ];
            case DropMove(role: final role, to: _):
              return [
                cg.PieceShape(
                  color: color,
                  orig: move.cg.to,
                  role: role.cg,
                ),
              ];
          }
        },
      ).expand((e) => e),
    );
  }

  void _onClearShapes() {
    setState(() {
      userShapes = ISet();
    });
  }

  void _onCompleteShape(cg.Shape shape) {
    if (userShapes.any((element) => element == shape)) {
      setState(() {
        userShapes = userShapes.remove(shape);
      });
      return;
    } else {
      setState(() {
        userShapes = userShapes.add(shape);
      });
    }
  }
}

class BottomBar extends ConsumerWidget {
  const BottomBar({
    required this.pgn,
    required this.options,
  });

  final String pgn;
  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(pgn, options);
    final canGoBack =
        ref.watch(ctrlProvider.select((value) => value.canGoBack));
    final canGoNext =
        ref.watch(ctrlProvider.select((value) => value.canGoNext));
    final displayMode =
        ref.watch(ctrlProvider.select((value) => value.displayMode));
    final canShowGameSummary =
        ref.watch(ctrlProvider.select((value) => value.canShowGameSummary));

    return Container(
      color: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: BottomBarButton(
                  label: context.l10n.menu,
                  onTap: () {
                    _showAnalysisMenu(context, ref);
                  },
                  icon: Icons.menu,
                ),
              ),
              if (canShowGameSummary)
                Expanded(
                  child: BottomBarButton(
                    label: displayMode == DisplayMode.summary
                        ? 'Moves'
                        : 'Summary',
                    onTap: () {
                      ref.read(ctrlProvider.notifier).toggleDisplayMode();
                    },
                    icon: displayMode == DisplayMode.summary
                        ? LichessIcons.flow_cascade
                        : Icons.area_chart,
                  ),
                ),
              Expanded(
                child: RepeatButton(
                  onLongPress: canGoBack ? () => _moveBackward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-previous'),
                    onTap: canGoBack ? () => _moveBackward(ref) : null,
                    label: 'Previous',
                    icon: CupertinoIcons.chevron_back,
                    showTooltip: false,
                  ),
                ),
              ),
              Expanded(
                child: RepeatButton(
                  onLongPress: canGoNext ? () => _moveForward(ref) : null,
                  child: BottomBarButton(
                    key: const ValueKey('goto-next'),
                    icon: CupertinoIcons.chevron_forward,
                    label: context.l10n.next,
                    onTap: canGoNext ? () => _moveForward(ref) : null,
                    showTooltip: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _moveBackward(WidgetRef ref) => ref
      .read(analysisControllerProvider(pgn, options).notifier)
      .userPrevious();
  void _moveForward(WidgetRef ref) =>
      ref.read(analysisControllerProvider(pgn, options).notifier).userNext();

  Future<void> _showAnalysisMenu(BuildContext context, WidgetRef ref) {
    return showAdaptiveActionSheet(
      context: context,
      actions: [
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.flipBoard),
          onPressed: (context) {
            ref
                .read(analysisControllerProvider(pgn, options).notifier)
                .toggleBoard();
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileShareGamePGN),
          onPressed: (_) {
            pushPlatformRoute(
              context,
              title: context.l10n.studyShareAndExport,
              builder: (_) => AnalysisShareScreen(pgn: pgn, options: options),
            );
          },
        ),
        BottomSheetAction(
          makeLabel: (context) => Text(context.l10n.mobileSharePositionAsFEN),
          onPressed: (_) {
            launchShareDialog(
              context,
              text: ref
                  .read(analysisControllerProvider(pgn, options))
                  .position
                  .fen,
            );
          },
        ),
        if (options.gameAnyId != null)
          BottomSheetAction(
            makeLabel: (context) =>
                Text(context.l10n.screenshotCurrentPosition),
            onPressed: (_) async {
              final gameId = options.gameAnyId!.gameId;
              final state = ref.read(analysisControllerProvider(pgn, options));
              try {
                final image =
                    await ref.read(gameShareServiceProvider).screenshotPosition(
                          gameId,
                          options.orientation,
                          state.position.fen,
                          state.lastMove,
                        );
                if (context.mounted) {
                  launchShareDialog(
                    context,
                    files: [image],
                    subject: context.l10n.puzzleFromGameLink(
                      lichessUri('/$gameId').toString(),
                    ),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  showPlatformSnackbar(
                    context,
                    'Failed to get GIF',
                    type: SnackBarType.error,
                  );
                }
              }
            },
          ),
      ],
    );
  }
}
