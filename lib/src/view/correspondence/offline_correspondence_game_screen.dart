import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/correspondence_clock_widget.dart';
import 'package:lichess_mobile/src/view/game/game_player.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

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
    final (lastModified, game) = currentGame;
    return PlatformScaffold(
      appBar: PlatformAppBar(title: _Title(game)),
      body: _Body(
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
  NormalMove? promotionMove;

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
    final materialDifference = ref.watch(
      boardPreferencesProvider.select(
        (prefs) => prefs.materialDifferenceFormat,
      ),
    );

    final offlineOngoingGames =
        ref.watch(offlineOngoingCorrespondenceGamesProvider);

    final position = game.positionAt(stepCursor);
    final sideToMove = position.turn;
    final youAre = game.youAre;

    final black = GamePlayer(
      player: game.black,
      materialDiff: materialDifference.visible
          ? game.materialDiffAt(stepCursor, Side.black)
          : null,
      materialDifferenceFormat: materialDifference,
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
      materialDiff: materialDifference.visible
          ? game.materialDiffAt(stepCursor, Side.white)
          : null,
      materialDifferenceFormat: materialDifference,
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
              orientation: isBoardTurned ? youAre.opposite : youAre,
              fen: position.fen,
              lastMove: game.moveAt(stepCursor) as NormalMove?,
              gameData: GameData(
                playerSide: game.playable && !isReplaying
                    ? youAre == Side.white
                        ? PlayerSide.white
                        : PlayerSide.black
                    : PlayerSide.none,
                isCheck: position.isCheck,
                sideToMove: sideToMove,
                validMoves: makeLegalMoves(
                  position,
                  isChess960: game.variant == Variant.chess960,
                ),
                promotionMove: promotionMove,
                onMove: (move, {isDrop, captured}) {
                  onUserMove(move);
                },
                onPromotionSelection: onPromotionSelection,
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
        BottomBar(
          children: [
            BottomBarButton(
              label: context.l10n.flipBoard,
              onTap: () {
                setState(() {
                  isBoardTurned = !isBoardTurned;
                });
              },
              icon: CupertinoIcons.arrow_2_squarepath,
            ),
            BottomBarButton(
              label: context.l10n.analysis,
              onTap: () {
                pushPlatformRoute(
                  context,
                  builder: (_) => AnalysisScreen(
                    pgnOrId: game.makePgn(),
                    options: AnalysisOptions(
                      isLocalEvaluationAllowed: false,
                      variant: game.variant,
                      initialMoveCursor: stepCursor,
                      orientation: game.youAre,
                      id: game.id,
                      division: game.meta.division,
                    ),
                  ),
                );
              },
              icon: Icons.biotech,
            ),
            BottomBarButton(
              label: 'Go to the next game',
              icon: Icons.skip_next,
              onTap: offlineOngoingGames.maybeWhen(
                data: (games) {
                  final nextTurn = games
                      .whereNot((g) => g.$2.id == game.id)
                      .firstWhereOrNull((g) => g.$2.isMyTurn);
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
              label: context.l10n.mobileCorrespondenceClearSavedMove,
              onTap: game.registeredMoveAtPgn != null
                  ? () {
                      showConfirmDialog<void>(
                        context,
                        title: Text(
                          context.l10n.mobileCorrespondenceClearSavedMove,
                        ),
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
                icon: CupertinoIcons.chevron_back,
                showTooltip: false,
              ),
            ),
            Expanded(
              child: RepeatButton(
                onLongPress: canGoForward ? () => moveForward() : null,
                child: BottomBarButton(
                  onTap: canGoForward ? () => moveForward() : null,
                  label: context.l10n.next,
                  icon: CupertinoIcons.chevron_forward,
                  showTooltip: false,
                ),
              ),
            ),
          ],
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

  void onUserMove(NormalMove move) {
    if (isPromotionPawnMove(game.lastPosition, move)) {
      setState(() {
        promotionMove = move;
      });
      return;
    }

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
      promotionMove = null;
      stepCursor = stepCursor + 1;
    });

    _moveFeedback(sanMove);
  }

  void onPromotionSelection(Role? role) {
    if (role == null) {
      setState(() {
        promotionMove = null;
      });
      return;
    }
    if (promotionMove != null) {
      final move = promotionMove!.withPromotion(role);
      onUserMove(move);
    }
  }

  Future<void> confirmMove() async {
    setState(() {
      game = game.copyWith(
        registeredMoveAtPgn: (moveToConfirm!.$1, moveToConfirm!.$2),
      );
      moveToConfirm = null;
    });

    final storage = await ref.read(correspondenceGameStorageProvider.future);
    storage.save(game);
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

  Future<void> deleteRegisteredMove() async {
    setState(() {
      stepCursor = stepCursor - 1;
      game = game.copyWith(
        steps: game.steps.removeLast(),
        registeredMoveAtPgn: null,
      );
    });

    final storage = await ref.read(correspondenceGameStorageProvider.future);
    storage.save(game);
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
