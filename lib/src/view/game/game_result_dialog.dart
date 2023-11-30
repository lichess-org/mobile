import 'dart:async';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_controller.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

import 'status_l10n.dart';

class GameResultDialog extends ConsumerStatefulWidget {
  const GameResultDialog({required this.id, this.seek});

  final GameFullId id;
  final GameSeek? seek;

  @override
  ConsumerState<GameResultDialog> createState() => _GameEndDialogState();
}

class _GameEndDialogState extends ConsumerState<GameResultDialog> {
  late Timer _buttonActivationTimer;
  bool _activateButtons = false;
  Future<void>? _pendingPgnFuture;

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
        if (gameState.game.me?.offeringRematch == true)
          SecondaryButton(
            semanticsLabel: context.l10n.cancelRematchOffer,
            onPressed: () {
              ref.read(ctrlProvider.notifier).declineRematch();
            },
            child: Text(context.l10n.cancelRematchOffer),
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
            child: Text(context.l10n.rematch),
          ),
        if (gameState.canGetNewOpponent && widget.seek != null)
          SecondaryButton(
            semanticsLabel: context.l10n.newOpponent,
            onPressed: _activateButtons
                ? () {
                    ref
                        .read(lobbyGameProvider(widget.seek!).notifier)
                        .newOpponent();
                    // Other alert dialogs may be shown before this one, so be sure to pop them all
                    Navigator.of(context)
                        .popUntil((route) => route is! RawDialogRoute);
                  }
                : null,
            child: Text(context.l10n.newOpponent),
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
              child: Text(context.l10n.analysis),
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
          '${gameStatusL10n(context, game)}$showWinner',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
