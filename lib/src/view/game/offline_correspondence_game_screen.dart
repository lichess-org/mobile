import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/game/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/settings/board_preferences.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/correspondence_clock_widget.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class OfflineCorrespondenceGameScreen extends StatelessWidget {
  const OfflineCorrespondenceGameScreen({
    required this.game,
    super.key,
  });

  final OfflineCorrespondenceGame game;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: (context) => _androidBuilder(
        context,
      ),
      iosBuilder: (context) => _iosBuilder(
        context,
      ),
    );
  }

  Widget _androidBuilder(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _Title(game)),
      body: _Body(game: game),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: _Title(game),
      ),
      child: _Body(game: game),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title(this.game);
  final OfflineCorrespondenceGame game;

  @override
  Widget build(BuildContext context) {
    final mode =
        game.rated ? ' • ${context.l10n.rated}' : ' • ${context.l10n.casual}';
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          game.perf.icon,
          color: DefaultTextStyle.of(context).style.color,
        ),
        const SizedBox(width: 4.0),
        if (game.daysPerTurn != null)
          Text(
            '${context.l10n.nbDays(game.daysPerTurn!)}$mode',
          )
        else
          Text('∞$mode'),
      ],
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.game,
  });

  final OfflineCorrespondenceGame game;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  late OfflineCorrespondenceGame game;
  int stepCursor = 0;
  Move? moveToConfirm;
  bool isBoardTurned = false;

  bool get isReplaying => stepCursor < game.steps.length - 1;
  bool get canGoForward => stepCursor < game.steps.length - 1;
  bool get canGoBackward => stepCursor > 0;

  @override
  void initState() {
    game = widget.game;
    stepCursor = widget.game.steps.length - 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowMaterialDiff = ref.watch(
      boardPreferencesProvider.select(
        (prefs) => prefs.showMaterialDifference,
      ),
    );

    final position = game.positionAt(stepCursor);
    final sideToMove = position.turn;
    final youAre = game.youAre;

    final black = GamePlayer(
      player: game.black,
      materialDiff: shouldShowMaterialDiff
          ? game.materialDiffAt(stepCursor, Side.black)
          : null,
      shouldLinkToUserProfile: false,
      mePlaying: youAre == Side.black,
      confirmMoveCallbacks: youAre == Side.black && moveToConfirm != null
          ? (
              confirm: confirmMove,
              cancel: cancelMove,
            )
          : null,
      clock: youAre == Side.black && game.estimatedTimeLeft != null
          ? CorrespondenceClock(
              duration: game.estimatedTimeLeft!,
              active: activeClockSide == Side.black,
            )
          : null,
    );
    final white = GamePlayer(
      player: game.white,
      materialDiff: shouldShowMaterialDiff
          ? game.materialDiffAt(stepCursor, Side.white)
          : null,
      shouldLinkToUserProfile: false,
      mePlaying: youAre == Side.white,
      confirmMoveCallbacks: youAre == Side.white && moveToConfirm != null
          ? (
              confirm: confirmMove,
              cancel: cancelMove,
            )
          : null,
      clock: youAre == Side.white && game.estimatedTimeLeft != null
          ? CorrespondenceClock(
              duration: game.estimatedTimeLeft!,
              active: activeClockSide == Side.white,
            )
          : null,
    );

    final topPlayer = youAre == Side.white ? black : white;
    final bottomPlayer = youAre == Side.white ? white : black;

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              onMove: (move, {isDrop, isPremove}) {
                onUserMove(Move.fromUci(move.uci)!);
              },
              boardData: cg.BoardData(
                interactableSide: game.playable && !isReplaying
                    ? youAre == Side.white
                        ? cg.InteractableSide.white
                        : cg.InteractableSide.black
                    : cg.InteractableSide.none,
                orientation: isBoardTurned ? youAre.opposite.cg : youAre.cg,
                fen: position.fen,
                lastMove: game.moveAt(stepCursor)?.cg,
                isCheck: position.isCheck,
                sideToMove: sideToMove.cg,
                validMoves: algebraicLegalMoves(position),
              ),
              topTable: topPlayer,
              bottomTable: bottomPlayer,
              moves: game.steps
                  .skip(1)
                  .map((e) => e.sanMove!.san)
                  .toList(growable: false),
              currentMoveIndex: stepCursor,
              onSelectMove: (moveIndex) {
                // ref.read(ctrlProvider.notifier).cursorAt(moveIndex);
              },
            ),
          ),
        ),
        Container(
          padding: Styles.horizontalBodyPadding,
          color: defaultTargetPlatform == TargetPlatform.iOS
              ? CupertinoTheme.of(context).barBackgroundColor
              : Theme.of(context).bottomAppBarTheme.color,
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BottomBarButton(
                  label: context.l10n.flipBoard,
                  shortLabel: 'Flip',
                  onTap: () {
                    setState(() {
                      isBoardTurned = !isBoardTurned;
                    });
                  },
                  icon: Icons.swap_vert,
                ),
                BottomBarButton(
                  label: context.l10n.analysis,
                  shortLabel: 'Analysis',
                  onTap: () {
                    pushPlatformRoute(
                      context,
                      builder: (_) => AnalysisScreen(
                        options: AnalysisOptions(
                          isLocalEvaluationAllowed: false,
                          variant: game.variant,
                          pgn: game.pgn,
                          initialMoveCursor: stepCursor,
                          orientation: game.youAre,
                          id: game.id,
                        ),
                        title: context.l10n.analysis,
                      ),
                    );
                  },
                  icon: Icons.biotech,
                ),
                BottomBarButton(
                  label: 'Clear saved move',
                  shortLabel: 'Clear move',
                  onTap: game.registeredMoveAtPly != null
                      ? () {
                          showConfirmDialog<void>(
                            context,
                            title: const Text('Clear saved move'),
                            isDestructiveAction: true,
                            onConfirm: (_) => deleteRegisteredMove(),
                          );
                        }
                      : null,
                  icon: Icons.save,
                ),
                RepeatButton(
                  onLongPress: canGoBackward ? () => moveBackward() : null,
                  child: BottomBarButton(
                    onTap: canGoBackward ? () => moveBackward() : null,
                    label: 'Previous',
                    shortLabel: 'Previous',
                    icon: CupertinoIcons.chevron_back,
                    showAndroidTooltip: false,
                  ),
                ),
                RepeatButton(
                  onLongPress: canGoForward ? () => moveForward() : null,
                  child: BottomBarButton(
                    onTap: canGoForward ? () => moveForward() : null,
                    label: context.l10n.next,
                    shortLabel: context.l10n.next,
                    icon: CupertinoIcons.chevron_forward,
                    showAndroidTooltip: false,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void moveBackward() {
    if (stepCursor > 0) {
      setState(() {
        stepCursor = stepCursor - 1;
      });
      _playReplayMoveSound();
    }
  }

  void moveForward() {
    if (stepCursor < game.steps.length - 1) {
      setState(() {
        stepCursor = stepCursor + 1;
      });
      _playReplayMoveSound();
    }
  }

  void onUserMove(Move move) {
    final (newPos, newSan) = game.lastPosition.makeSan(move);
    final sanMove = SanMove(newSan, move);
    final newStep = GameStep(
      position: newPos,
      sanMove: sanMove,
      diff: MaterialDiff.fromBoard(newPos.board),
    );

    setState(() {
      game = game.copyWith(
        steps: game.steps.add(newStep),
      );
      stepCursor = stepCursor + 1;
      moveToConfirm = move;
    });

    _moveFeedback(sanMove);
  }

  void confirmMove() {
    setState(() {
      game = game.copyWith(
        registeredMoveAtPly: (game.lastPly, moveToConfirm!.uci),
      );
      moveToConfirm = null;
    });

    ref.read(correspondenceGameStorageProvider).save(game);
  }

  void cancelMove() {
    setState(() {
      moveToConfirm = null;
      stepCursor = stepCursor - 1;
      game = game.copyWith(
        steps: game.steps.removeLast(),
      );
    });
  }

  void deleteRegisteredMove() {
    setState(() {
      stepCursor = stepCursor - 1;
      game = game.copyWith(
        steps: game.steps.removeLast(),
        registeredMoveAtPly: null,
      );
    });

    ref.read(correspondenceGameStorageProvider).save(game);
  }

  Side? get activeClockSide {
    if (game.status == GameStatus.started) {
      final pos = game.lastPosition;
      if (pos.fullmoves > 1) {
        return moveToConfirm != null ? pos.turn.opposite : pos.turn;
      }
    }
    return null;
  }

  void _playReplayMoveSound() {
    final san = game.stepAt(stepCursor).sanMove?.san;
    if (san != null) {
      final soundService = ref.read(soundServiceProvider);
      if (san.contains('x')) {
        soundService.play(Sound.capture);
      } else {
        soundService.play(Sound.move);
      }
    }
  }

  void _moveFeedback(SanMove sanMove) {
    final isCheck = sanMove.san.contains('+');
    if (sanMove.san.contains('x')) {
      ref.read(moveFeedbackServiceProvider).captureFeedback(check: isCheck);
    } else {
      ref.read(moveFeedbackServiceProvider).moveFeedback(check: isCheck);
    }
  }
}
