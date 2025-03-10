import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_federation.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_screen_providers.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

class BroadcastPlayerResultsScreenLoading extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastPlayer player;

  const BroadcastPlayerResultsScreenLoading({required this.roundId, required this.player});

  static Route<dynamic> buildRoute(
    BuildContext context,
    BroadcastRoundId roundId,
    BroadcastPlayer player,
  ) {
    return buildScreenRoute(
      context,
      screen: BroadcastPlayerResultsScreenLoading(roundId: roundId, player: player),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentId = ref.watch(broadcastTournamentIdProvider(roundId));

    return switch (tournamentId) {
      AsyncData(value: final tournamentId) => BroadcastPlayerResultsScreen(
        tournamentId: tournamentId,
        player: player,
      ),
      AsyncError(:final error) => PlatformScaffold(
        appBarTitle: const Text(''),
        body: Center(child: Text('Cannot load round data: $error')),
      ),
      _ => const PlatformScaffold(
        appBarTitle: Text(''),
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
    };
  }
}

class BroadcastPlayerResultsScreen extends StatelessWidget {
  final BroadcastTournamentId tournamentId;
  final BroadcastPlayer player;

  const BroadcastPlayerResultsScreen({required this.tournamentId, required this.player});

  static Route<dynamic> buildRoute(
    BuildContext context,
    BroadcastTournamentId tournamentId,
    BroadcastPlayer player,
  ) {
    return buildScreenRoute(
      context,
      screen: BroadcastPlayerResultsScreen(tournamentId: tournamentId, player: player),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBarTitle: BroadcastPlayerWidget(player: player, showFederation: false, showRating: false),
      body: _Body(tournamentId, player.id),
    );
  }
}

const _kTableRowPadding = EdgeInsets.symmetric(vertical: 12.0);

class _Body extends ConsumerWidget {
  final BroadcastTournamentId tournamentId;
  final String playerId;

  const _Body(this.tournamentId, this.playerId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playerWithGameResults = ref.watch(broadcastPlayerProvider(tournamentId, playerId));

    switch (playerWithGameResults) {
      case AsyncData(value: final playerWithGameResults):
        final games = playerWithGameResults.games;
        final player = playerWithGameResults.playerWithOverallResult.player;

        final showRatingDiff = games.any((result) => result.ratingDiff != null);
        final indexWidth = max(8.0 + games.length.toString().length * 10.0, 28.0);

        return ListView.builder(
          itemCount: games.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return _OverallStatPlayer(playerWithGameResults: playerWithGameResults);
            }

            final playerGameResult = playerWithGameResults.games[index - 1];

            return _GameResultRow(
              playerGameResult: playerGameResult,
              player: player,
              tournamentId: tournamentId,
              index: index,
              indexWidth: indexWidth,
              showRatingDiff: showRatingDiff,
            );
          },
        );
      case AsyncError(:final error):
        return Center(child: Text('Cannot load player data: $error'));
      case _:
        return const Center(child: CircularProgressIndicator.adaptive());
    }
  }
}

class _OverallStatPlayer extends StatelessWidget {
  const _OverallStatPlayer({required this.playerWithGameResults});

  final BroadcastPlayerWithGameResults playerWithGameResults;

  @override
  Widget build(BuildContext context) {
    final BroadcastPlayerWithGameResults(:playerWithOverallResult, :fideData, :games) =
        playerWithGameResults;
    final birthYear = fideData.birthYear;
    final (:standard, :rapid, :blitz) = fideData.ratings;
    final BroadcastPlayerWithOverallResult(:player, :score, :played, :performance, :ratingDiff) =
        playerWithOverallResult;
    final BroadcastPlayer(:federation, :fideId) = player;

    final statWidth =
        (MediaQuery.sizeOf(context).width - Styles.bodyPadding.horizontal - 10 * 2) / 3;
    const cardSpacing = 10.0;

    return Padding(
      padding: Styles.bodyPadding,
      child: Column(
        spacing: cardSpacing,
        children: [
          if (standard != null || rapid != null || blitz != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: cardSpacing,
              children: [
                if (standard != null)
                  SizedBox(
                    width: statWidth,
                    child: _StatCard(context.l10n.classical, value: standard.toString()),
                  ),
                if (rapid != null)
                  SizedBox(
                    width: statWidth,
                    child: _StatCard(context.l10n.rapid, value: rapid.toString()),
                  ),
                if (blitz != null)
                  SizedBox(
                    width: statWidth,
                    child: _StatCard(context.l10n.blitz, value: blitz.toString()),
                  ),
              ],
            ),
          if (birthYear != null || federation != null || fideId != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: cardSpacing,
              children: [
                if (birthYear != null)
                  SizedBox(
                    width: statWidth,
                    child: _StatCard(
                      context.l10n.broadcastAgeThisYear,
                      value: (DateTime.now().year - birthYear).toString(),
                    ),
                  ),
                if (federation != null)
                  SizedBox(
                    width: statWidth,
                    child: _StatCard(
                      context.l10n.broadcastFederation,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/fide-fed/$federation.png', height: 12),
                          const SizedBox(width: 5),
                          Flexible(
                            child: Text(
                              federationIdToName[federation]!,
                              style: const TextStyle(fontSize: 18.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (fideId != null)
                  SizedBox(width: statWidth, child: _StatCard('FIDE ID', value: fideId.toString())),
              ],
            ),
          if (score != null || performance != null || ratingDiff != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: cardSpacing,
              children: [
                if (score != null)
                  SizedBox(
                    width: statWidth,
                    child: _StatCard(
                      context.l10n.broadcastScore,
                      value:
                          '${score.toStringAsFixed((score == score.roundToDouble()) ? 0 : 1)} / $played',
                    ),
                  ),
                if (performance != null)
                  SizedBox(
                    width: statWidth,
                    child: _StatCard(context.l10n.performance, value: performance.toString()),
                  ),
                if (ratingDiff != null)
                  SizedBox(
                    width: statWidth,
                    child: _StatCard(
                      context.l10n.broadcastRatingDiff,
                      child: ProgressionWidget(ratingDiff, fontSize: 18.0),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

class _GameResultRow extends StatelessWidget {
  const _GameResultRow({
    required this.playerGameResult,
    required this.player,
    required this.tournamentId,
    required this.index,
    required this.indexWidth,
    required this.showRatingDiff,
  });

  final BroadcastPlayerGameResult playerGameResult;
  final BroadcastPlayer player;
  final BroadcastTournamentId tournamentId;
  final int index;
  final double indexWidth;
  final bool showRatingDiff;

  @override
  Widget build(BuildContext context) {
    final BroadcastPlayerGameResult(:roundId, :gameId, :color, :points, :ratingDiff, :opponent) =
        playerGameResult;
    final opponentRating = opponent.rating;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          BroadcastGameScreen.buildRoute(
            context,
            tournamentId: tournamentId,
            roundId: roundId,
            gameId: gameId,
          ),
        );
      },
      child: ColoredBox(
        color: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
        child: Padding(
          padding: _kTableRowPadding,
          child: Row(
            children: [
              SizedBox(
                width: indexWidth,
                child: Center(
                  child: Text(
                    index.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(flex: 5, child: BroadcastPlayerWidget(player: player, showRating: false)),
              Expanded(
                flex: 3,
                child:
                    (opponentRating != null)
                        ? Center(child: Text(opponentRating.toString()))
                        : const SizedBox.shrink(),
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Container(
                    width: 15,
                    height: 15,
                    decoration: BoxDecoration(
                      border:
                          (Theme.of(context).brightness == Brightness.light &&
                                      color == Side.white ||
                                  Theme.of(context).brightness == Brightness.dark &&
                                      color == Side.black)
                              ? Border.all(width: 2.0, color: ColorScheme.of(context).outline)
                              : null,
                      shape: BoxShape.circle,
                      color: switch (color) {
                        Side.white => Colors.white.withValues(alpha: 0.9),
                        Side.black => Colors.black.withValues(alpha: 0.9),
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 30,
                child: Center(
                  child: Text(
                    switch (points) {
                      BroadcastPoints.one => '1',
                      BroadcastPoints.half => '½',
                      BroadcastPoints.zero => '0',
                      _ => '*',
                    },
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: switch (points) {
                        BroadcastPoints.one => context.lichessColors.good,
                        BroadcastPoints.zero => context.lichessColors.error,
                        _ => null,
                      },
                    ),
                  ),
                ),
              ),
              if (showRatingDiff)
                SizedBox(
                  width: 38,
                  child:
                      (playerGameResult.ratingDiff != null)
                          ? ProgressionWidget(playerGameResult.ratingDiff!, fontSize: 14)
                          : null,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.stat, {this.value, this.child});

  final String stat;
  final String? value;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return StatCard(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      stat,
      value: value,
      child: child,
    );
  }
}
