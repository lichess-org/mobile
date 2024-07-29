import 'package:chessground/chessground.dart' as cg;
import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_numbers.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/chessground_compat.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/user_full_name.dart';

class LobbyScreenLoadingContent extends StatelessWidget {
  const LobbyScreenLoadingContent(this.seek, this.cancelGameCreation);

  final GameSeek seek;
  final Future<void> Function() cancelGameCreation;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardState: kEmptyBoardState,
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
                      Text(context.l10n.mobileWaitingForOpponentToJoin),
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
                  ),
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          children: [
            BottomBarButton(
              onTap: () async {
                await cancelGameCreation();
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
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

class ChallengeLoadingContent extends StatelessWidget {
  const ChallengeLoadingContent(this.challenge, this.cancelChallenge);

  final ChallengeRequest challenge;
  final Future<void> Function() cancelChallenge;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardState: kEmptyBoardState,
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
                      Text(context.l10n.waitingForOpponent),
                      const SizedBox(height: 16.0),
                      UserFullNameWidget(
                        user: challenge.destUser,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            challenge.perf.icon,
                            color: DefaultTextStyle.of(context).style.color,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            challenge.timeIncrement?.display ??
                                '${context.l10n.daysPerTurn}: ${challenge.days}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        _BottomBar(
          children: [
            BottomBarButton(
              onTap: () async {
                await cancelChallenge();
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                }
              },
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
    return BoardTable(
      boardState: cg.ChessboardState(
        interactableSide: cg.InteractableSide.none,
        orientation: orientation ?? Side.white,
        fen: fen ?? kEmptyFen,
        lastMove: lastMove?.cg,
      ),
      topTable: const SizedBox.shrink(),
      bottomTable: const SizedBox.shrink(),
      showMoveListPlaceholder: true,
    );
  }
}

class LoadGameError extends StatelessWidget {
  const LoadGameError(this.errorMessage);

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardState: const cg.ChessboardState(
                interactableSide: cg.InteractableSide.none,
                orientation: Side.white,
                fen: kEmptyFen,
              ),
              topTable: const SizedBox.shrink(),
              bottomTable: const SizedBox.shrink(),
              showMoveListPlaceholder: true,
              errorMessage: errorMessage,
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

class ChallengeDeclinedBoard extends StatelessWidget {
  const ChallengeDeclinedBoard({
    required this.declineReason,
    this.destUser,
  });

  final String declineReason;

  final LightUser? destUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              boardState: const cg.ChessboardState(
                interactableSide: cg.InteractableSide.none,
                orientation: Side.white,
                fen: kEmptyFen,
              ),
              topTable: const SizedBox.shrink(),
              bottomTable: const SizedBox.shrink(),
              showMoveListPlaceholder: true,
              boardOverlay: PlatformCard(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.challengeChallengeDeclined,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          declineReason,
                          style: const TextStyle(fontStyle: FontStyle.italic),
                        ),
                        if (destUser != null) ...[
                          const SizedBox(height: 8.0),
                          Align(
                            alignment: Alignment.centerRight,
                            child: UserFullNameWidget(user: destUser),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
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
      color: Theme.of(context).platform == TargetPlatform.iOS
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.l10n.nbPlayers(nbPlayers)),
          const SizedBox(height: 8.0),
          Text(context.l10n.nbGamesInPlay(nbGames)),
        ],
      );
    }
  }
}
