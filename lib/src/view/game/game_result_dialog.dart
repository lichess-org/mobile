import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';

import 'status_l10n.dart';

class GameResultDialog extends ConsumerStatefulWidget {
  const GameResultDialog({
    required this.id,
    required this.onNewOpponentCallback,
    super.key,
  });

  final GameFullId id;

  /// Callback to load a new opponent.
  final void Function(PlayableGame game) onNewOpponentCallback;

  @override
  ConsumerState<GameResultDialog> createState() => _GameEndDialogState();
}

class _GameEndDialogState extends ConsumerState<GameResultDialog> {
  late Timer _buttonActivationTimer;
  bool _activateButtons = false;
  Future<void>? _pendingPgnFuture;
  Future<void>? _pendingAnalysisRequestFuture;

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
        if (gameState.game.evals != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: _AcplChart(evals: gameState.game.evals!),
          ),
        if (gameState.game.white.analysis != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: PlayerSummary(game: gameState.game),
          ),
        if (gameState.game.me?.offeringRematch == true)
          SecondaryButton(
            semanticsLabel: context.l10n.cancelRematchOffer,
            onPressed: () {
              ref.read(ctrlProvider.notifier).declineRematch();
            },
            child: Text(
              context.l10n.cancelRematchOffer,
              textAlign: TextAlign.center,
            ),
          )
        else if (gameState.canOfferRematch)
          SecondaryButton(
            semanticsLabel: context.l10n.rematch,
            onPressed: _activateButtons &&
                    gameState.game.opponent?.onGame == true
                ? () {
                    ref.read(ctrlProvider.notifier).proposeOrAcceptRematch();
                  }
                : null,
            glowing: gameState.game.opponent?.offeringRematch == true,
            child: Text(
              context.l10n.rematch,
              textAlign: TextAlign.center,
            ),
          ),
        if (gameState.canGetNewOpponent)
          SecondaryButton(
            semanticsLabel: context.l10n.newOpponent,
            onPressed: _activateButtons
                ? () {
                    Navigator.of(context)
                        .popUntil((route) => route is! PopupRoute);
                    widget.onNewOpponentCallback(gameState.game);
                  }
                : null,
            child: Text(
              context.l10n.newOpponent,
              textAlign: TextAlign.center,
            ),
          ),
        if (gameState.game.analysable &&
            gameState.game.evals == null &&
            gameState.game.white.analysis == null)
          FutureBuilder(
            future: _pendingAnalysisRequestFuture,
            builder: (context, snapshot) {
              return SecondaryButton(
                semanticsLabel: context.l10n.requestAComputerAnalysis,
                onPressed: _activateButtons
                    ? snapshot.connectionState == ConnectionState.waiting
                        ? null
                        : () {
                            setState(() {
                              _pendingAnalysisRequestFuture = ref
                                  .read(ctrlProvider.notifier)
                                  .requestServerAnalysis()
                                  .catchError((Object e) {
                                if (context.mounted) {
                                  showPlatformSnackbar(
                                    context,
                                    e.toString(),
                                    type: SnackBarType.error,
                                  );
                                }
                              });
                            });
                          }
                    : null,
                child: Text(
                  context.l10n.requestAComputerAnalysis,
                  textAlign: TextAlign.center,
                ),
              );
            },
          ),
        FutureBuilder(
          future: _pendingPgnFuture,
          builder: (context, snapshot) {
            return SecondaryButton(
              semanticsLabel: context.l10n.analysis,
              onPressed: snapshot.connectionState == ConnectionState.waiting
                  ? null
                  : () async {
                      final future = ref.read(
                        gameAnalysisPgnProvider(
                          id: gameState.game.id,
                        ).future,
                      );
                      setState(() {
                        _pendingPgnFuture = future;
                      });
                      final pgn = await future;
                      if (context.mounted) {
                        pushPlatformRoute(
                          context,
                          builder: (_) => AnalysisScreen(
                            options: gameState.analysisOptions.copyWith(
                              pgn: pgn,
                            ),
                            title: context.l10n.gameAnalysis,
                          ),
                        );
                      }
                    },
              child: Text(
                context.l10n.analysis,
                textAlign: TextAlign.center,
              ),
            );
          },
        ),
      ],
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        content: content,
      );
    } else {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      );
    }
  }
}

class _AcplChart extends StatelessWidget {
  final IList<ExternalEval> evals;

  const _AcplChart({required this.evals});

  @override
  Widget build(BuildContext context) {
    // yes it looks like below/above are inverted in fl_chart
    final belowLineColor = Colors.white.withOpacity(0.4);
    final aboveLineColor = Colors.grey.shade800.withOpacity(0.6);
    final spots = evals
        .mapIndexed(
          (i, e) => FlSpot(i.toDouble(), e.winningChances(Side.white)),
        )
        .toList(growable: false);
    return AspectRatio(
      aspectRatio: 2.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0),
        child: LineChart(
          LineChartData(
            minY: -1.0,
            maxY: 1.0,
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: Colors.transparent,
                barWidth: 1,
                aboveBarData: BarAreaData(
                  show: true,
                  color: aboveLineColor,
                  applyCutOffY: true,
                ),
                belowBarData: BarAreaData(
                  show: true,
                  color: belowLineColor,
                  applyCutOffY: true,
                ),
                dotData: const FlDotData(
                  show: false,
                ),
              ),
            ],
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: const FlTitlesData(show: false),
          ),
        ),
      ),
    );
  }
}

class ArchivedGameResultDialog extends StatelessWidget {
  const ArchivedGameResultDialog({required this.game, super.key});

  final BaseGame game;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameResult(game: game),
        const SizedBox(height: 16.0),
        PlayerSummary(game: game),
      ],
    );

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return CupertinoAlertDialog(
        content: content,
      );
    } else {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: content,
        ),
      );
    }
  }
}

class PlayerSummary extends ConsumerWidget {
  const PlayerSummary({required this.game, super.key});

  final BaseGame game;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final youAre = session != null ? game.playerSideOf(session.user.id) : null;
    final me = youAre == null ? null : game.playerOf(youAre);

    if (me == null || me.analysis == null) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(context.l10n.nbInaccuracies(me.analysis!.inaccuracies)),
        Text(context.l10n.nbMistakes(me.analysis!.mistakes)),
        Text(context.l10n.nbBlunders(me.analysis!.blunders)),
        if (me.analysis!.acpl != null)
          Text('${me.analysis!.acpl} ${context.l10n.averageCentipawnLoss}'),
        if (me.analysis!.accuracy != null)
          Text('${me.analysis!.accuracy}% ${context.l10n.accuracy}'),
      ],
    );
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
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 6.0),
        Text(
          '${gameStatusL10n(
            context,
            variant: game.variant,
            status: game.status,
            lastPosition: game.lastPosition,
            winner: game.winner,
            isThreefoldRepetition: game.isThreefoldRepetition,
          )}$showWinner',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
