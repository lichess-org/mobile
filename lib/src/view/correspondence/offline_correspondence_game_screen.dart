import 'package:chessground/chessground.dart' as cg;
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/service/move_feedback.dart';
import 'package:lichess_mobile/src/model/common/service/sound_service.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
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

class OfflineCorrespondenceGameScreen extends StatefulWidget {
  const OfflineCorrespondenceGameScreen({
    required this.initialGame,
    super.key,
  });

  final (DateTime, OfflineCorrespondenceGame) initialGame;

  @override
  State<OfflineCorrespondenceGameScreen> createState() =>
      _OfflineCorrespondenceGameScreenState();
}

class _OfflineCorrespondenceGameScreenState
    extends State<OfflineCorrespondenceGameScreen> {
  late (DateTime, OfflineCorrespondenceGame) currentGame;

  @override
  void initState() {
    currentGame = widget.initialGame;
    super.initState();
  }

  void goToNextGame((DateTime, OfflineCorrespondenceGame) nextGame) {
    setState(() {
      currentGame = nextGame;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(BuildContext context) {
    final (lastModified, game) = currentGame;
    return Scaffold(
      appBar: AppBar(title: _Title(game)),
      body: _Body(
        game: game,
        lastModified: lastModified,
        onGameChanged: goToNextGame,
      ),
    );
  }

  Widget _iosBuilder(BuildContext context) {
    final (lastModified, game) = currentGame;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: _Title(game),
      ),
      child: _Body(
        game: game,
        lastModified: lastModified,
        onGameChanged: goToNextGame,
      ),
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
    required this.lastModified,
    required this.onGameChanged,
  });

  final OfflineCorrespondenceGame game;
  final DateTime lastModified;
  final void Function((DateTime, OfflineCorrespondenceGame)) onGameChanged;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  late OfflineCorrespondenceGame game;
  int stepCursor = 0;
  (String, Move)? moveToConfirm;
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
  void didUpdateWidget(covariant _Body oldWidget) {
    if (oldWidget.game.id != widget.game.id) {
      game = widget.game;
      stepCursor = widget.game.steps.length - 1;
      moveToConfirm = null;
      isBoardTurned = false;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final shouldShowMaterialDiff = ref.watch(
      boardPreferencesProvider.select(
        (prefs) => prefs.showMaterialDifference,
      ),
    );

    final offlineOngoingGames =
        ref.watch(offlineOngoingCorrespondenceGamesProvider);

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
      clock: youAre == Side.black &&
              game.estimatedTimeLeft(Side.black, widget.lastModified) != null
          ? CorrespondenceClock(
              duration:
                  game.estimatedTimeLeft(Side.black, widget.lastModified)!,
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
      clock: game.estimatedTimeLeft(Side.white, widget.lastModified) != null
          ? CorrespondenceClock(
              duration:
                  game.estimatedTimeLeft(Side.white, widget.lastModified)!,
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
                  label: 'Go to the next game',
                  shortLabel: 'Next game',
                  icon: Icons.skip_next,
                  onTap: offlineOngoingGames.maybeWhen(
                    data: (games) {
                      final nextTurn = games
                          .whereNot((g) => g.$2.id == game.id)
                          .firstWhereOrNull((g) => g.$2.isPlayerTurn);
                      return nextTurn != null
                          ? () {
                              widget.onGameChanged(nextTurn);
                            }
                          : null;
                    },
                    orElse: () => null,
                  ),
                ),
                BottomBarButton(
                  label: 'Clear saved move',
                  shortLabel: 'Clear move',
                  onTap: game.registeredMoveAtPgn != null
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
      moveToConfirm = (game.sanMoves, move);
      game = game.copyWith(
        steps: game.steps.add(newStep),
      );
      stepCursor = stepCursor + 1;
    });

    _moveFeedback(sanMove);
  }

  void confirmMove() {
    setState(() {
      game = game.copyWith(
        registeredMoveAtPgn: (moveToConfirm!.$1, moveToConfirm!.$2),
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
        registeredMoveAtPgn: null,
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
