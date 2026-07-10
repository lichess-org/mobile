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
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

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

  /// The rematch button action, or null to disable it. A socket offer if the
  /// opponent is online, otherwise a challenge for offline clockless games.
  VoidCallback? _rematchAction(BuildContext context, GameState value) {
    if (!_activateButtons || value.game.opponent?.offeringRematch == true) {
      return null;
    }
    final ctrlProvider = gameControllerProvider(widget.id);
    if (value.game.opponent?.onGame == true) {
      return () {
        ref.read(ctrlProvider.notifier).proposeOrAcceptRematch();
      };
    }
    if (value.game.clock == null &&
        value.game.me?.user != null &&
        value.game.opponent?.user != null) {
      return () async {
        try {
          await ref.read(ctrlProvider.notifier).challengeRematch();
        } catch (_) {
          if (context.mounted) {
            showSnackBar(context, 'Could not send the rematch challenge', type: SnackBarType.error);
          }
        }
      };
    }
    return null;
  }

  /// Navigates back to the tournament this game belongs to.
  ///
  /// If we came from the tournament screen (the usual case: we were on the
  /// tournament, the game was pushed on top and we played it), it is still in
  /// the navigation stack, so we close the dialog and pop back to it. Otherwise
  /// (e.g. the game was opened from the home recent games list) there is no
  /// tournament screen to go back to, so we push a fresh one.
  void _backToTournament(TournamentId tournamentId) {
    final navigator = Navigator.of(context);
    if (rootNavRouteStackObserver.containsRoute(
      TournamentScreen.routeName,
      arguments: tournamentId.value,
    )) {
      navigator.popUntil(
        (route) =>
            route.settings.name == TournamentScreen.routeName &&
            route.settings.arguments == tournamentId.value,
      );
    } else {
      // Close the dialog first, then push the tournament screen.
      navigator.popUntil((route) => route is! PopupRoute);
      navigator.push(TournamentScreen.buildRoute(tournamentId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final ctrlProvider = gameControllerProvider(widget.id);

    return switch (ref.watch(ctrlProvider)) {
      AsyncError() => const Center(child: Text('Could not load game')),
      AsyncData(:final value) => _ResultDialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: GameResult(game: value.game),
            ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 400),
              firstCurve: Curves.easeOutExpo,
              secondCurve: Curves.easeInExpo,
              sizeCurve: Curves.easeInOut,
              firstChild: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (value.game.me?.offeringRematch == true ||
                      value.correspondenceRematchId != null) ...[
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
                      onPressed: () async {
                        if (value.game.me?.offeringRematch == true) {
                          ref.read(ctrlProvider.notifier).declineRematch();
                        } else {
                          try {
                            await ref.read(ctrlProvider.notifier).cancelRematchChallenge();
                          } catch (_) {
                            if (context.mounted) {
                              showSnackBar(
                                context,
                                'Could not cancel the rematch challenge',
                                type: SnackBarType.error,
                              );
                            }
                          }
                        }
                      },
                      tooltip: context.l10n.cancelRematchOffer,
                      icon: const Icon(Icons.cancel),
                    ),
                  ] else if (value.canOfferRematch)
                    Expanded(
                      child: FilledButton(
                        onPressed: _rematchAction(context, value),
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
              crossFadeState: value.game.opponent?.offeringRematch ?? false
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
            ),
            if (value.canGetNewOpponent)
              FilledButton.tonal(
                onPressed: _activateButtons
                    ? () {
                        Navigator.of(context).popUntil((route) => route is! PopupRoute);
                        widget.onNewOpponentCallback(value.game);
                      }
                    : null,
                child: Text(context.l10n.newOpponent, textAlign: TextAlign.center),
              ),
            if (value.tournament?.isOngoing == true) ...[
              FilledButton.icon(
                icon: const Icon(Icons.play_arrow),
                onPressed: () => _backToTournament(value.tournament!.id),
                label: Text(context.l10n.backToTournament, textAlign: TextAlign.center),
              ),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.pause),
                onPressed: () {
                  // Pause the tournament
                  ref
                      .read(tournamentControllerProvider(value.tournament!.id).notifier)
                      .joinOrPause();
                  _backToTournament(value.tournament!.id);
                },
                label: Text(context.l10n.pause, textAlign: TextAlign.center),
              ),
            ],
            if (value.game.userAnalysable)
              FilledButton.tonal(
                onPressed: () {
                  Navigator.of(context).push(AnalysisScreen.buildRoute(value.analysisOptions));
                },
                child: Text(context.l10n.analysis, textAlign: TextAlign.center),
              ),
          ],
        ),
      ),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
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
                AnalysisOptions.pgn(
                  id: const StringId('otb_finished_game_analysis'),
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
    final screenWidth = MediaQuery.widthOf(context);
    final paddedContent = Padding(padding: const EdgeInsets.all(16.0), child: child);
    final sizedContent = SizedBox(
      width: min(screenWidth, kMaterialPopupMenuMaxWidth),
      child: paddedContent,
    );
    return Dialog(child: sizedContent);
  }
}
