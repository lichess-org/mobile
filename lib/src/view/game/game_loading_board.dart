import 'dart:ui';

import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_providers.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class LobbyGameLoadingBoard extends StatelessWidget {
  const LobbyGameLoadingBoard(this.seek, {this.isRematch = false});

  final GameSeek seek;
  final bool isRematch;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardData: const cg.BoardData(
                interactableSide: cg.InteractableSide.none,
                orientation: cg.Side.white,
                fen: kEmptyFen,
              ),
              topTable: const SizedBox.shrink(),
              bottomTable: const SizedBox.shrink(),
              showMoveListPlaceholder: true,
              boardOverlay: PlatformCard(
                elevation: 2.0,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${context.l10n.waitingForOpponent}...'),
                      if (isRematch == false) ...[
                        const SizedBox(height: 26.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              seek.perf.icon,
                              color: DefaultTextStyle.of(context).style.color,
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              seek.timeIncrement?.display ??
                                  '${context.l10n.daysPerTurn}: ${seek.days}',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                        if (seek.ratingRange != null) ...[
                          const SizedBox(height: 8.0),
                          Text(
                            '${seek.ratingRange!.$1}-${seek.ratingRange!.$2}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                        const SizedBox(height: 16.0),
                        _LobbyNumbers(),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          children: [
            if (isRematch == false)
              BottomBarButton(
                onTap: () => Navigator.of(context).pop(),
                label: context.l10n.cancel,
                showLabel: true,
                icon: CupertinoIcons.xmark,
              ),
          ],
        ),
      ],
    );
  }
}

class StandaloneGameLoadingBoard extends StatelessWidget {
  const StandaloneGameLoadingBoard({
    this.fen,
    this.lastMove,
    this.orientation,
    super.key,
  });

  final String? fen;
  final Side? orientation;
  final Move? lastMove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardData: cg.BoardData(
                interactableSide: cg.InteractableSide.none,
                orientation: orientation?.cg ?? cg.Side.white,
                fen: fen ?? kEmptyFen,
                lastMove: lastMove?.cg,
              ),
              topTable: const SizedBox.shrink(),
              bottomTable: const SizedBox.shrink(),
              showMoveListPlaceholder: true,
            ),
          ),
        ),
        const _BottomBar(
          children: [],
        ),
      ],
    );
  }
}

class LoadGameError extends StatelessWidget {
  const LoadGameError();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardData: cg.BoardData(
                interactableSide: cg.InteractableSide.none,
                orientation: cg.Side.white,
                fen: kEmptyFen,
              ),
              topTable: SizedBox.shrink(),
              bottomTable: SizedBox.shrink(),
              showMoveListPlaceholder: true,
              errorMessage:
                  'Sorry, we could not load the game. Please try again later.',
            ),
          ),
        ),
        _BottomBar(
          children: [
            BottomBarButton(
              onTap: () => Navigator.of(context).pop(),
              label: context.l10n.cancel,
              icon: CupertinoIcons.xmark,
              showLabel: true,
            ),
          ],
        ),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: defaultTargetPlatform == TargetPlatform.iOS
          ? CupertinoTheme.of(context).barBackgroundColor
          : Theme.of(context).bottomAppBarTheme.color,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: kBottomBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children,
          ),
        ),
      ),
    );
  }
}

class _LobbyNumbers extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbyNumbers = ref.watch(lobbyNumbersProvider);

    if (lobbyNumbers == null) {
      return Column(
        children: [
          Text(
            context.l10n.nbPlayers(0).replaceAll('0', '...'),
          ),
          const SizedBox(height: 8.0),
          Text(
            context.l10n.nbGamesInPlay(0).replaceAll('0', '...'),
          ),
        ],
      );
    } else {
      final (:nbPlayers, :nbGames) = lobbyNumbers;
      return Column(
        children: [
          _AnimatedLobbyNumber(
            labelBuilder: (nb) => context.l10n.nbPlayers(nb),
            value: nbPlayers,
          ),
          const SizedBox(height: 8.0),
          _AnimatedLobbyNumber(
            labelBuilder: (nb) => context.l10n.nbGamesInPlay(nb),
            value: nbGames,
          ),
        ],
      );
    }
  }
}

const _lobbyNumbersStyle = TextStyle(
  fontFeatures: [
    FontFeature.tabularFigures(),
  ],
);

class _AnimatedLobbyNumber extends StatefulWidget {
  const _AnimatedLobbyNumber({
    required this.labelBuilder,
    required this.value,
  });

  final String Function(int) labelBuilder;
  final int value;

  @override
  State<_AnimatedLobbyNumber> createState() => _AnimatedLobbyNumberState();
}

class _AnimatedLobbyNumberState extends State<_AnimatedLobbyNumber> {
  int previousValue = 0;
  int value = 0;

  @override
  void initState() {
    super.initState();
    previousValue = widget.value;
    value = widget.value;
  }

  @override
  void didUpdateWidget(covariant _AnimatedLobbyNumber oldWidget) {
    previousValue = oldWidget.value;
    value = widget.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(
        begin: previousValue,
        end: value,
      ),
      curve: Curves.linear,
      duration: const Duration(seconds: 3),
      builder: (context, int value, _) {
        return Text(widget.labelBuilder(value), style: _lobbyNumbersStyle);
      },
    );
  }
}
