import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/over_the_board_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/analysis/retro_screen.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';

class GameResultDialog extends ConsumerStatefulWidget {
  const GameResultDialog({required this.id, required this.onNewOpponentCallback, super.key});

  final GameFullId id;

  /// Callback to load a new opponent.
  final void Function(PlayableGame game) onNewOpponentCallback;

  @override
  ConsumerState<GameResultDialog> createState() => _GameResultDialogState();
}

class _GameResultDialogState extends ConsumerState<GameResultDialog> {
  late Timer _buttonActivationTimer;
  bool _activateButtons = false;

  @override
  void initState() {
    _buttonActivationTimer = Timer(const Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _activateButtons = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _buttonActivationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = gameControllerProvider(widget.id);
    final gameState = ref.watch(ctrlProvider).requireValue;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GameResult(game: gameState.game),
        ),
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 400),
          firstCurve: Curves.easeOutExpo,
          secondCurve: Curves.easeInExpo,
          sizeCurve: Curves.easeInOut,
          firstChild: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (gameState.game.me?.offeringRematch == true) ...[
                Flexible(
                  flex: 3,
                  child: Text(
                    maxLines: 2,
                    context.l10n.rematchOfferSent,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Spacer(),
                IconButton.outlined(
                  onPressed: () {
                    ref.read(ctrlProvider.notifier).declineRematch();
                  },
                  tooltip: context.l10n.cancelRematchOffer,
                  icon: const Icon(Icons.cancel),
                ),
              ] else if (gameState.canOfferRematch)
                Expanded(
                  child: FilledButton(
                    onPressed:
                        _activateButtons &&
                            gameState.game.opponent?.onGame == true &&
                            gameState.game.opponent?.offeringRematch != true
                        ? () {
                            ref.read(ctrlProvider.notifier).proposeOrAcceptRematch();
                          }
                        : null,
                    child: Text(context.l10n.rematch),
                  ),
                )
              else
                const SizedBox.shrink(),
            ],
          ),
          secondChild: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Text(
                  context.l10n.yourOpponentWantsToPlayANewGameWithYou,
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton.filled(
                      icon: const Icon(Icons.check),
                      style: FilledButton.styleFrom(
                        foregroundColor: ColorScheme.of(context).onPrimary,
                        backgroundColor: ColorScheme.of(context).primary,
                      ),
                      tooltip: context.l10n.accept,
                      onPressed: () {
                        ref.read(ctrlProvider.notifier).proposeOrAcceptRematch();
                      },
                    ),
                    IconButton.filled(
                      icon: const Icon(Icons.close),
                      style: FilledButton.styleFrom(
                        foregroundColor: ColorScheme.of(context).onError,
                        backgroundColor: ColorScheme.of(context).error,
                      ),
                      tooltip: context.l10n.decline,
                      onPressed: () {
                        ref.read(ctrlProvider.notifier).declineRematch();
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          crossFadeState: gameState.game.opponent?.offeringRematch ?? false
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
        ),
        if (gameState.canGetNewOpponent)
          FilledButton.tonal(
            onPressed: _activateButtons
                ? () {
                    Navigator.of(context).popUntil((route) => route is! PopupRoute);
                    widget.onNewOpponentCallback(gameState.game);
                  }
                : null,
            child: Text(context.l10n.newOpponent, textAlign: TextAlign.center),
          ),
        if (gameState.tournament?.isOngoing == true) ...[
          FilledButton.icon(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              // Close the dialog
              Navigator.of(context).popUntil((route) => route is! PopupRoute);
              // Close the game screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop(); // Pop the screen after frame
              });
            },
            label: Text(context.l10n.backToTournament, textAlign: TextAlign.center),
          ),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.pause),
            onPressed: () {
              // Pause the tournament
              ref
                  .read(tournamentControllerProvider(gameState.tournament!.id).notifier)
                  .joinOrPause();
              // Close the dialog
              Navigator.of(context).popUntil((route) => route is! PopupRoute);
              // Close the game screen
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop(); // Pop the screen after frame
              });
            },
            label: Text(context.l10n.pause, textAlign: TextAlign.center),
          ),
        ],
        if (gameState.game.userAnalysable) ...[
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(
                context,
              ).push(AnalysisScreen.buildRoute(context, gameState.analysisOptions));
            },
            child: Text(context.l10n.analysis, textAlign: TextAlign.center),
          ),
          FilledButton.tonal(
            onPressed: () {
              Navigator.of(context).push(
                RetroScreen.buildRoute(context, (
                  id: gameState.game.id,
                  initialSide: gameState.game.youAre ?? Side.white,
                )),
              );
            },
            child: Text(context.l10n.learnFromYourMistakes, textAlign: TextAlign.center),
          ),
        ],
      ],
    );

    return _ResultDialog(child: content);
  }
}

class ExportedGameResultDialog extends StatelessWidget {
  const ExportedGameResultDialog({required this.game, super.key});

  final BaseGame game;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [GameResult(game: game)],
    );

    return _ResultDialog(child: content);
  }
}

class OverTheBoardGameResultDialog extends StatelessWidget {
  const OverTheBoardGameResultDialog({super.key, required this.game, required this.onRematch});

  final OverTheBoardGame game;

  final void Function() onRematch;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameResult(game: game),
        FilledButton(
          onPressed: onRematch,
          child: Text(context.l10n.rematch, textAlign: TextAlign.center),
        ),
        FilledButton.tonal(
          onPressed: () {
            Navigator.of(context).push(
              AnalysisScreen.buildRoute(
                context,
                AnalysisOptions.standalone(
                  orientation: Side.white,
                  pgn: game.makePgn(),
                  isComputerAnalysisAllowed: true,
                  variant: game.meta.variant,
                ),
              ),
            );
          },
          child: Text(context.l10n.analysis, textAlign: TextAlign.center),
        ),
      ],
    );

    return _ResultDialog(child: content);
  }
}

class GameResult extends StatelessWidget {
  const GameResult({required this.game, super.key});

  final BaseGame game;

  @override
  Widget build(BuildContext context) {
    final showWinner = game.winner != null
        ? ' • ${game.winner == Side.white ? context.l10n.whiteIsVictorious : context.l10n.blackIsVictorious}'
        : '';

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (game.status.value >= GameStatus.mate.value)
          Text(
            game.winner == null
                ? '½-½'
                : game.winner == Side.white
                ? '1-0'
                : '0-1',
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 6.0),
        Text(
          '${gameStatusL10n(context, variant: game.meta.variant, status: game.status, lastPosition: game.lastPosition, winner: game.winner, isThreefoldRepetition: game.isThreefoldRepetition)}$showWinner',
          style: const TextStyle(fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _ResultDialog extends StatelessWidget {
  const _ResultDialog({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final paddedContent = Padding(padding: const EdgeInsets.all(16.0), child: child);
    final sizedContent = SizedBox(
      width: min(screenWidth, kMaterialPopupMenuMaxWidth),
      child: paddedContent,
    );
    return Dialog(child: sizedContent);
  }
}
