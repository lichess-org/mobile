import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/server_analysis_service.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/over_the_board_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

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

Widget _adaptiveDialog(BuildContext context, Widget content) {
  // TODO return CupertinoAlertDialog on iOS when the pixelated text bug is fixed
  const dialogColor = CupertinoDynamicColor.withBrightness(
    color: Color(0xCCF2F2F2),
    darkColor: Color(0xBF1E1E1E),
  );

  final screenWidth = MediaQuery.of(context).size.width;
  final paddedContent = Padding(
    padding: const EdgeInsets.all(16.0),
    child: content,
  );
  return Dialog(
    backgroundColor: Theme.of(context).platform == TargetPlatform.iOS
        ? CupertinoDynamicColor.resolve(dialogColor, context)
        : null,
    child: SizedBox(
      width: min(screenWidth, kMaterialPopupMenuMaxWidth),
      child: Theme.of(context).platform == TargetPlatform.iOS
          ? CupertinoPopupSurface(child: paddedContent)
          : paddedContent,
    ),
  );
}

class _GameEndDialogState extends ConsumerState<GameResultDialog> {
  late Timer _buttonActivationTimer;
  bool _activateButtons = false;
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
    final session = ref.watch(authSessionProvider);
    final currentGameAnalysis = ref.watch(currentAnalysisProvider);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: GameResult(game: gameState.game),
        ),
        if (currentGameAnalysis == gameState.game.id)
          const Padding(
            padding: EdgeInsets.only(bottom: 16.0),
            child: WaitingForServerAnalysis(),
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
          ),
        Visibility(
          maintainState: true,
          visible: gameState.game.opponent?.offeringRematch ?? false,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: gameState.game.opponent?.offeringRematch ?? false ? 1 : 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FatButton(
                  semanticsLabel: context.l10n.rematch,
                  child: const Text('Accept rematch'),
                  onPressed: () {
                    ref.read(ctrlProvider.notifier).proposeOrAcceptRematch();
                  },
                ),
                SecondaryButton(
                  semanticsLabel: context.l10n.rematch,
                  child: const Text('Decline'),
                  onPressed: () {
                    ref.read(ctrlProvider.notifier).declineRematch();
                  },
                ),
              ],
            ),
          ),
        ),
        if (gameState.canOfferRematch &&
            !(gameState.game.opponent?.offeringRematch ?? false))
          SecondaryButton(
            semanticsLabel: context.l10n.rematch,
            onPressed: _activateButtons &&
                    gameState.game.opponent?.onGame == true
                ? () {
                    ref.read(ctrlProvider.notifier).proposeOrAcceptRematch();
                  }
                : null,
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
        if (currentGameAnalysis != gameState.game.id &&
            gameState.game.userAnalysable &&
            gameState.game.evals == null &&
            gameState.game.white.analysis == null)
          FutureBuilder(
            future: _pendingAnalysisRequestFuture,
            builder: (context, snapshot) {
              return SecondaryButton(
                semanticsLabel: context.l10n.requestAComputerAnalysis,
                onPressed: session == null
                    ? () {
                        showPlatformSnackbar(
                          context,
                          context.l10n.youNeedAnAccountToDoThat,
                        );
                      }
                    : _activateButtons
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
        if (gameState.game.userAnalysable)
          SecondaryButton(
            semanticsLabel: context.l10n.analysis,
            onPressed: () {
              pushPlatformRoute(
                context,
                builder: (_) => AnalysisScreen(
                  pgnOrId: gameState.analysisPgn,
                  options: gameState.analysisOptions,
                ),
              );
            },
            child: Text(
              context.l10n.analysis,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );

    return _adaptiveDialog(context, content);
  }
}

class _AcplChart extends StatelessWidget {
  final IList<ExternalEval> evals;

  const _AcplChart({required this.evals});

  @override
  Widget build(BuildContext context) {
    final mainLineColor = Theme.of(context).colorScheme.secondary;
    final brightness = Theme.of(context).brightness;
    final white = Theme.of(context).colorScheme.surfaceContainerHighest;
    final black = Theme.of(context).colorScheme.outline;
    // yes it looks like below/above are inverted in fl_chart
    final belowLineColor = brightness == Brightness.light ? white : black;
    final aboveLineColor = brightness == Brightness.light ? black : white;
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
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                color: mainLineColor.withValues(alpha: 0.3),
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

    return _adaptiveDialog(context, content);
  }
}

class OverTheBoardGameResultDialog extends StatelessWidget {
  const OverTheBoardGameResultDialog({
    super.key,
    required this.game,
    required this.onRematch,
  });

  final OverTheBoardGame game;

  final void Function() onRematch;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GameResult(game: game),
        SecondaryButton(
          semanticsLabel: context.l10n.rematch,
          onPressed: onRematch,
          child: Text(
            context.l10n.rematch,
            textAlign: TextAlign.center,
          ),
        ),
        SecondaryButton(
          semanticsLabel: context.l10n.analysis,
          onPressed: () {
            pushPlatformRoute(
              context,
              builder: (_) => AnalysisScreen(
                pgnOrId: game.makePgn(),
                options: AnalysisOptions(
                  isLocalEvaluationAllowed: true,
                  variant: game.meta.variant,
                  orientation: Side.white,
                  id: standaloneAnalysisId,
                ),
              ),
            );
          },
          child: Text(
            context.l10n.analysis,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );

    return _adaptiveDialog(context, content);
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

    Widget makeStatCol(
      int value,
      String Function(int count) labelFn,
      Color? color,
    ) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value.toString(),
              style: TextStyle(
                fontSize: 18.0,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4.0),
            FittedBox(
              child: Text(
                labelFn(value).replaceAll(RegExp(r'\d+'), '').trim(),
                style: TextStyle(color: color),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        makeStatCol(
          me.analysis!.inaccuracies,
          context.l10n.nbInaccuracies,
          me.analysis!.inaccuracies > 0 ? innacuracyColor : null,
        ),
        makeStatCol(
          me.analysis!.mistakes,
          context.l10n.nbMistakes,
          me.analysis!.mistakes > 0 ? mistakeColor : null,
        ),
        makeStatCol(
          me.analysis!.blunders,
          context.l10n.nbBlunders,
          me.analysis!.blunders > 0 ? blunderColor : null,
        ),
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
            variant: game.meta.variant,
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
