import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
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
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

final broadcastTournamentIdProvider = FutureProvider.autoDispose
    .family<BroadcastTournamentId, BroadcastRoundId>((Ref ref, BroadcastRoundId roundId) async {
      return (await ref.watch(broadcastRoundProvider(roundId).future)).tournament.id;
    }, name: 'BroadcastTournamentIdProvider');

class BroadcastPlayerResultsScreenLoading extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastPlayer player;
  final String playerId;

  const BroadcastPlayerResultsScreenLoading({
    required this.roundId,
    required this.player,
    required this.playerId,
  });

  static Route<dynamic> buildRoute(
    BuildContext context,
    BroadcastRoundId roundId,
    BroadcastPlayer player,
    String playerId,
  ) {
    return buildScreenRoute(
      context,
      screen: BroadcastPlayerResultsScreenLoading(
        roundId: roundId,
        player: player,
        playerId: playerId,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tournamentId = ref.watch(broadcastTournamentIdProvider(roundId));

    return switch (tournamentId) {
      AsyncData(value: final tournamentId) => BroadcastPlayerResultsScreen(
        tournamentId: tournamentId,
        player: player,
        playerId: playerId,
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(title: const Text('')),
        body: Center(child: Text('Cannot load round data: $error')),
      ),
      _ => Scaffold(
        appBar: AppBar(title: const Text('')),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      ),
    };
  }
}

class BroadcastPlayerResultsScreen extends StatelessWidget {
  final BroadcastTournamentId tournamentId;
  final BroadcastPlayer player;
  final String playerId;

  const BroadcastPlayerResultsScreen({
    required this.tournamentId,
    required this.player,
    required this.playerId,
  });

  static Route<dynamic> buildRoute(
    BuildContext context,
    BroadcastTournamentId tournamentId,
    BroadcastPlayer player,
    String playerId,
  ) {
    return buildScreenRoute(
      context,
      screen: BroadcastPlayerResultsScreen(
        tournamentId: tournamentId,
        player: player,
        playerId: playerId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: BroadcastPlayerWidget(player: player, showFederation: false, showRating: false),
      ),
      body: _Body(tournamentId, playerId),
    );
  }
}

final _playerAndTournamentProvider = FutureProvider.autoDispose
    .family<
      (BroadcastPlayerWithGameResults player, BroadcastTournament tournament),
      (BroadcastTournamentId, String)
    >((ref, args) async {
      final (tournamentId, playerId) = args;
      final player = await ref.watch(broadcastPlayerProvider(args).future);
      final tournament = await ref.watch(broadcastTournamentProvider(tournamentId).future);

      return (player, tournament);
    });

class _Body extends ConsumerWidget {
  final BroadcastTournamentId tournamentId;
  final String playerId;

  const _Body(this.tournamentId, this.playerId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (ref.watch(_playerAndTournamentProvider((tournamentId, playerId)))) {
      case AsyncData(value: final data):
        final (playerWithGameResults, tournament) = data;
        final BroadcastPlayerWithGameResults(:playerWithOverallResult, :games) =
            playerWithGameResults;
        final BroadcastPlayerWithOverallResult(:tieBreaks) = playerWithOverallResult;

        final showRatingDiff = games.any((result) => result.ratingDiff != null);
        final indexWidth = max(8.0 + games.length.toString().length * 10.0, 28.0);

        final gamesSectionHeader = ColoredBox(
          color: ColorScheme.of(context).surfaceDim,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              context.l10n.broadcastGamesThisTournament,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        );

        final itemCount =
            games.length +
            1 + // overall stats
            (tieBreaks != null ? 1 : 0) + // tie-breaks
            1; // games header

        return ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            final gamesStartIndex = itemCount - games.length;

            if (index == 0) {
              return _OverallStatPlayer(
                playerWithGameResults: playerWithGameResults,
                tournament: tournament,
              );
            }
            if (tieBreaks != null) {
              if (index == 1) {
                return _TieBreaksSection(tieBreaks, playerWithOverallResult);
              }
              if (index == 2) {
                return gamesSectionHeader;
              }
            } else {
              if (index == 1) {
                return gamesSectionHeader;
              }
            }

            return _GameResultListTile(
              playerGameResult: games[index - gamesStartIndex],
              tournament: tournament,
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
  const _OverallStatPlayer({required this.playerWithGameResults, required this.tournament});

  final BroadcastPlayerWithGameResults playerWithGameResults;
  final BroadcastTournament tournament;

  @override
  Widget build(BuildContext context) {
    final BroadcastPlayerWithGameResults(:playerWithOverallResult, :fideData, :games) =
        playerWithGameResults;
    final birthYear = fideData.birthYear;
    final (:standard, :rapid, :blitz) = fideData.ratings;
    final BroadcastPlayerWithOverallResult(
      :player,
      :score,
      :played,
      :performance,
      :ratingDiff,
      :team,
    ) = playerWithOverallResult;
    final BroadcastPlayer(:federation, :fideId) = player;

    final pic = player.fideId != null ? tournament.photos?.get(player.fideId!) : null;

    final statWidth =
        (MediaQuery.sizeOf(context).width - Styles.bodyPadding.horizontal - 10 * 2) / 3;
    const cardSpacing = 10.0;

    final picWidth = MediaQuery.sizeOf(context).width / 3;

    return Padding(
      padding: Styles.bodyPadding,
      child: Column(
        spacing: cardSpacing,
        children: [
          Row(
            children: [
              if (pic != null) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: HttpNetworkImageWidget(pic.mediumUrl, width: picWidth),
                ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  mainAxisAlignment: .spaceAround,
                  children: [
                    if (federation != null)
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text(context.l10n.broadcastFederation)),
                          Expanded(
                            child: Row(
                              children: [
                                Image.asset('assets/images/fide-fed/$federation.png', height: 12),
                                const SizedBox(width: 5),
                                Flexible(
                                  child: Text(
                                    federationIdToName[federation]!,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(height: 1.2),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    const SizedBox(height: 16),
                    if (team != null) ...[
                      Row(
                        children: [
                          const SizedBox(width: 100, child: Text('Team')),
                          Expanded(
                            child: Text(team.trim(), style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (birthYear != null)
                      Row(
                        children: [
                          SizedBox(width: 100, child: Text(context.l10n.broadcastAge)),
                          Expanded(
                            child: Text(
                              (DateTime.now().year - birthYear).toString(),
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
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

class _TieBreaksSection extends StatelessWidget {
  const _TieBreaksSection(this.tieBreaks, this.player);

  final BroadcastPlayerWithOverallResult player;
  final IList<BroadcastTieBreakDetail> tieBreaks;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          Container(
            width: double.infinity,
            color: ColorScheme.of(context).surfaceDim,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Tie-breaking', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ),
          ...tieBreaks
              .where((t) => t.extendedCode != 'TPR')
              .map(
                (tieBreak) => ListTile(
                  dense: true,
                  title: Text(tieBreak.description),
                  trailing: Text(
                    tieBreak.points.toStringAsFixed(
                      (tieBreak.points == tieBreak.points.roundToDouble()) ? 0 : 1,
                    ),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _GameResultListTile extends StatelessWidget {
  const _GameResultListTile({
    required this.playerGameResult,
    required this.tournament,
    required this.index,
    required this.indexWidth,
    required this.showRatingDiff,
  });

  final BroadcastPlayerGameResult playerGameResult;
  final BroadcastTournament tournament;
  final int index;
  final double indexWidth;
  final bool showRatingDiff;

  @override
  Widget build(BuildContext context) {
    final BroadcastPlayerGameResult(:roundId, :gameId, :color, :points, :ratingDiff, :opponent) =
        playerGameResult;
    final BroadcastPlayer(:federation, :title, :name, :rating) = opponent;
    final pic = opponent.fideId != null ? tournament.photos?.get(opponent.fideId!) : null;

    return ListTile(
      tileColor: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
      onTap: () {
        Navigator.of(context).push(
          BroadcastGameScreen.buildRoute(
            context,
            tournamentId: tournament.data.id,
            roundId: roundId,
            gameId: gameId,
          ),
        );
      },
      leading: ClipRRect(
        borderRadius: Styles.thumbnailBorderRadius,
        child: pic != null
            ? HttpNetworkImageWidget(pic.smallUrl, width: 40, height: 40)
            : opponent.isBot
            ? Image.asset('assets/images/anon-engine.webp', width: 40, height: 40)
            : Image.asset('assets/images/anon-face.webp', width: 40, height: 40),
      ),
      title: BroadcastPlayerWidget(player: opponent, showFederation: false, showRating: false),
      subtitle: federation != null
          ? Row(
              mainAxisSize: .min,
              children: [
                Image.asset('assets/images/fide-fed/$federation.png', height: 12),
                const SizedBox(width: 5),
                if (opponent.rating != null) Text(opponent.rating.toString()),
              ],
            )
          : null,
      trailing: SizedBox(
        width: 40,
        child: Column(
          mainAxisSize: .min,
          crossAxisAlignment: .end,
          children: [
            Row(
              mainAxisSize: .min,
              children: [
                Text(
                  switch (points) {
                    BroadcastPoints.one => '1',
                    BroadcastPoints.half => '½',
                    BroadcastPoints.zero => '0',
                    _ => '*',
                  },
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (showRatingDiff &&
                playerGameResult.ratingDiff != null &&
                playerGameResult.ratingDiff != 0)
              ProgressionWidget(playerGameResult.ratingDiff!, fontSize: 12),
          ],
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
