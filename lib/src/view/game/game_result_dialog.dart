import 'dart:async';
import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/over_the_board_game.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/status_l10n.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

class GameResultDialog extends ConsumerStatefulWidget {
  const GameResultDialog({required this.id, required this.onNewOpponentCallback, super.key});

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
  final paddedContent = Padding(padding: const EdgeInsets.all(16.0), child: content);
  return Dialog(
    backgroundColor:
        Theme.of(context).platform == TargetPlatform.iOS
            ? CupertinoDynamicColor.resolve(dialogColor, context)
            : null,
    child: SizedBox(
      width: min(screenWidth, kMaterialPopupMenuMaxWidth),
      child:
          Theme.of(context).platform == TargetPlatform.iOS
              ? CupertinoPopupSurface(child: paddedContent)
              : paddedContent,
    ),
  );
}

class _GameEndDialogState extends ConsumerState<GameResultDialog> {
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
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text('Your opponent has offered a rematch', textAlign: TextAlign.center),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
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
            ],
          ),
          crossFadeState:
              gameState.game.opponent?.offeringRematch ?? false
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
        ),
        if (gameState.game.me?.offeringRematch == true)
          SecondaryButton(
            semanticsLabel: context.l10n.cancelRematchOffer,
            onPressed: () {
              ref.read(ctrlProvider.notifier).declineRematch();
            },
            child: Text(context.l10n.cancelRematchOffer, textAlign: TextAlign.center),
          )
        else if (gameState.canOfferRematch)
          SecondaryButton(
            semanticsLabel: context.l10n.rematch,
            onPressed:
                _activateButtons &&
                        gameState.game.opponent?.onGame == true &&
                        gameState.game.opponent?.offeringRematch != true
                    ? () {
                      ref.read(ctrlProvider.notifier).proposeOrAcceptRematch();
                    }
                    : null,
            child: Text(context.l10n.rematch, textAlign: TextAlign.center),
          ),
        if (gameState.canGetNewOpponent)
          SecondaryButton(
            semanticsLabel: context.l10n.newOpponent,
            onPressed:
                _activateButtons
                    ? () {
                      Navigator.of(context).popUntil((route) => route is! PopupRoute);
                      widget.onNewOpponentCallback(gameState.game);
                    }
                    : null,
            child: Text(context.l10n.newOpponent, textAlign: TextAlign.center),
          ),
        if (gameState.game.userAnalysable)
          SecondaryButton(
            semanticsLabel: context.l10n.analysis,
            onPressed: () {
              pushPlatformRoute(
                context,
                builder: (_) => AnalysisScreen(options: gameState.analysisOptions),
              );
            },
            child: Text(context.l10n.analysis, textAlign: TextAlign.center),
          ),
      ],
    );

    return _adaptiveDialog(context, content);
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
      children: [GameResult(game: game), const SizedBox(height: 16.0), PlayerSummary(game: game)],
    );

    return _adaptiveDialog(context, content);
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
        SecondaryButton(
          semanticsLabel: context.l10n.rematch,
          onPressed: onRematch,
          child: Text(context.l10n.rematch, textAlign: TextAlign.center),
        ),
        SecondaryButton(
          semanticsLabel: context.l10n.analysis,
          onPressed: () {
            pushPlatformRoute(
              context,
              builder:
                  (_) => AnalysisScreen(
                    options: AnalysisOptions(
                      orientation: Side.white,
                      standalone: (
                        pgn: game.makePgn(),
                        isComputerAnalysisAllowed: true,
                        variant: game.meta.variant,
                      ),
                    ),
                  ),
            );
          },
          child: Text(context.l10n.analysis, textAlign: TextAlign.center),
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

    Widget makeStatCol(int value, String Function(int count) labelFn, Color? color) {
      return Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              value.toString(),
              style: TextStyle(fontSize: 18.0, color: color, fontWeight: FontWeight.bold),
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
    final showWinner =
        game.winner != null
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
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
