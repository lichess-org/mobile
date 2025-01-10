import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/challenge/challenge.dart';
import 'package:lichess_mobile/src/model/lobby/game_seek.dart';
import 'package:lichess_mobile/src/model/lobby/lobby_numbers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/board_table.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar_button.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
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
              orientation: Side.white,
              fen: kEmptyFen,
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
                          Icon(seek.perf.icon, color: DefaultTextStyle.of(context).style.color),
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
        BottomBar(
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
              orientation: Side.white,
              fen: kEmptyFen,
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
        BottomBar(
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
  const StandaloneGameLoadingBoard({this.fen, this.lastMove, this.orientation, super.key});

  final String? fen;
  final Side? orientation;
  final Move? lastMove;

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: BoardTable(
        orientation: orientation ?? Side.white,
        fen: fen ?? kEmptyFen,
        lastMove: lastMove as NormalMove?,
        topTable: _LoadingPlayer(),
        bottomTable: _LoadingPlayer(),
        showMoveListPlaceholder: true,
      ),
    );
  }
}

class _LoadingPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const ShimmerLoading(
      isLoading: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 6,
            child: SizedBox(
              height: 24.0,
              width: double.infinity,
              child: ColoredBox(color: Colors.black),
            ),
          ),
          Spacer(),
          Flexible(
            flex: 2,
            child: SizedBox(
              height: 38.0,
              width: double.infinity,
              child: ColoredBox(color: Colors.black),
            ),
          ),
        ],
      ),
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
              orientation: Side.white,
              fen: kEmptyFen,
              topTable: const SizedBox.shrink(),
              bottomTable: const SizedBox.shrink(),
              showMoveListPlaceholder: true,
              errorMessage: errorMessage,
            ),
          ),
        ),
        BottomBar(
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

/// A board that shows a message that a challenge has been declined.
class ChallengeDeclinedBoard extends StatelessWidget {
  const ChallengeDeclinedBoard({required this.declineReason, required this.challenge});

  final String declineReason;
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final textColor = DefaultTextStyle.of(context).style.color;

    return Column(
      children: [
        Expanded(
          child: SafeArea(
            bottom: false,
            child: BoardTable(
              orientation: Side.white,
              fen: kEmptyFen,
              topTable: const SizedBox.shrink(),
              bottomTable: const SizedBox.shrink(),
              showMoveListPlaceholder: true,
              boardOverlay: PlatformCard(
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          context.l10n.challengeChallengeDeclined,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8.0),
                        Divider(height: 26.0, thickness: 0.0, color: textColor),
                        Text(declineReason, style: const TextStyle(fontStyle: FontStyle.italic)),
                        Divider(height: 26.0, thickness: 0.0, color: textColor),
                        if (challenge.destUser != null)
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(' — '),
                                UserFullNameWidget(user: challenge.destUser?.user),
                                if (challenge.destUser?.lagRating != null) ...[
                                  const SizedBox(width: 6.0),
                                  LagIndicator(
                                    lagRating: challenge.destUser!.lagRating!,
                                    size: 13.0,
                                    showLoadingIndicator: false,
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        BottomBar(
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

class _LobbyNumbers extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lobbyNumbers = ref.watch(lobbyNumbersProvider);

    if (lobbyNumbers == null) {
      return Column(
        children: [
          Text(context.l10n.nbPlayers(0).replaceAll('0', '...')),
          const SizedBox(height: 8.0),
          Text(context.l10n.nbGamesInPlay(0).replaceAll('0', '...')),
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
