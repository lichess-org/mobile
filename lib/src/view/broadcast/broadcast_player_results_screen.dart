import 'dart:math';

import 'package:dartchess/dartchess.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_federation.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/lichess_assets.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

class BroadcastPlayerResultsScreen extends StatelessWidget {
  final BroadcastTournamentId tournamentId;
  final String playerId;
  final String? playerTitle;
  final String playerName;

  const BroadcastPlayerResultsScreen(
    this.tournamentId,
    this.playerId,
    this.playerTitle,
    this.playerName,
  );

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: BroadcastPlayerWidget(title: playerTitle, name: playerName),
      ),
      body: _Body(tournamentId, playerId),
    );
  }
}

const _kTableRowPadding = EdgeInsets.symmetric(
  vertical: 12.0,
);

class _Body extends ConsumerWidget {
  final BroadcastTournamentId tournamentId;
  final String playerId;

  const _Body(this.tournamentId, this.playerId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final playersResults =
        ref.watch(broadcastPlayerResultProvider(tournamentId, playerId));

    switch (playersResults) {
      case AsyncData(value: final playerResults):
        final player = playerResults.player;
        final fideData = playerResults.fideData;
        final showRatingDiff =
            playerResults.games.any((result) => result.ratingDiff != null);
        final statWidth = (MediaQuery.sizeOf(context).width -
                Styles.bodyPadding.horizontal -
                10 * 2) /
            3;
        const cardSpacing = 10.0;
        final indexWidth = max(
          8.0 + playerResults.games.length.toString().length * 10.0,
          28.0,
        );

        return ListView.builder(
          itemCount: playerResults.games.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Padding(
                padding: Styles.bodyPadding,
                child: Column(
                  spacing: cardSpacing,
                  children: [
                    if (fideData.ratings.standard != null &&
                        fideData.ratings.rapid != null &&
                        fideData.ratings.blitz != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: cardSpacing,
                        children: [
                          if (fideData.ratings.standard != null)
                            SizedBox(
                              width: statWidth,
                              child: StatCard(
                                context.l10n.classical,
                                value: fideData.ratings.standard.toString(),
                              ),
                            ),
                          if (fideData.ratings.rapid != null)
                            SizedBox(
                              width: statWidth,
                              child: StatCard(
                                context.l10n.rapid,
                                value: fideData.ratings.rapid.toString(),
                              ),
                            ),
                          if (fideData.ratings.blitz != null)
                            SizedBox(
                              width: statWidth,
                              child: StatCard(
                                context.l10n.blitz,
                                value: fideData.ratings.blitz.toString(),
                              ),
                            ),
                        ],
                      ),
                    if (fideData.birthYear != null &&
                        player.federation != null &&
                        player.fideId != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: cardSpacing,
                        children: [
                          if (fideData.birthYear != null)
                            SizedBox(
                              width: statWidth,
                              child: StatCard(
                                context.l10n.broadcastAgeThisYear,
                                value:
                                    (DateTime.now().year - fideData.birthYear!)
                                        .toString(),
                              ),
                            ),
                          if (player.federation != null)
                            SizedBox(
                              width: statWidth,
                              child: StatCard(
                                context.l10n.broadcastFederation,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.network(
                                      lichessFideFedSrc(
                                        player.federation!,
                                      ),
                                      height: 12,
                                      httpClient:
                                          ref.read(defaultClientProvider),
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        federationIdToName[player.federation!]!,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (player.fideId != null)
                            SizedBox(
                              width: statWidth,
                              child: StatCard(
                                'FIDE ID',
                                value: player.fideId!.toString(),
                              ),
                            ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: cardSpacing,
                      children: [
                        if (player.score != null)
                          SizedBox(
                            width: statWidth,
                            child: StatCard(
                              context.l10n.broadcastScore,
                              value:
                                  '${player.score!.toStringAsFixed((player.score! == player.score!.roundToDouble()) ? 0 : 1)} / ${player.played}',
                            ),
                          ),
                        if (player.performance != null)
                          SizedBox(
                            width: statWidth,
                            child: StatCard(
                              context.l10n.performance,
                              value: player.performance.toString(),
                            ),
                          ),
                        if (player.ratingDiff != null)
                          SizedBox(
                            width: statWidth,
                            child: StatCard(
                              context.l10n.broadcastRatingDiff,
                              child: ProgressionWidget(
                                player.ratingDiff!,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }

            final playerResult = playerResults.games[index - 1];

            return GestureDetector(
              onTap: () {
                pushPlatformRoute(
                  context,
                  builder: (context) => BroadcastGameScreen(
                    tournamentId: tournamentId,
                    roundId: playerResult.roundId,
                    gameId: playerResult.gameId,
                  ),
                );
              },
              child: ColoredBox(
                color: Theme.of(context).platform == TargetPlatform.iOS
                    ? index.isEven
                        ? CupertinoColors.secondarySystemBackground
                            .resolveFrom(context)
                        : CupertinoColors.tertiarySystemBackground
                            .resolveFrom(context)
                    : index.isEven
                        ? Theme.of(context).colorScheme.surfaceContainerLow
                        : Theme.of(context).colorScheme.surfaceContainerHigh,
                child: Padding(
                  padding: _kTableRowPadding,
                  child: Row(
                    children: [
                      SizedBox(
                        width: indexWidth,
                        child: Center(
                          child: Text(
                            index.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: BroadcastPlayerWidget(
                          federation: playerResult.opponent.federation,
                          title: playerResult.opponent.title,
                          name: playerResult.opponent.name,
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: (playerResult.opponent.rating != null)
                            ? Center(
                                child: Text(
                                  playerResult.opponent.rating.toString(),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                      SizedBox(
                        width: 30,
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              border: (Theme.of(context).brightness ==
                                              Brightness.light &&
                                          playerResult.color == Side.white ||
                                      Theme.of(context).brightness ==
                                              Brightness.dark &&
                                          playerResult.color == Side.black)
                                  ? Border.all(
                                      width: 2.0,
                                      color:
                                          Theme.of(context).colorScheme.outline,
                                    )
                                  : null,
                              shape: BoxShape.circle,
                              color: switch (playerResult.color) {
                                Side.white =>
                                  Colors.white.withValues(alpha: 0.9),
                                Side.black =>
                                  Colors.black.withValues(alpha: 0.9),
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 30,
                        child: Center(
                          child: Text(
                            switch (playerResult.points) {
                              BroadcastPoints.one => '1',
                              BroadcastPoints.half => '½',
                              BroadcastPoints.zero => '0',
                              _ => '*'
                            },
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: switch (playerResult.points) {
                                BroadcastPoints.one =>
                                  context.lichessColors.good,
                                BroadcastPoints.zero =>
                                  context.lichessColors.error,
                                _ => null
                              },
                            ),
                          ),
                        ),
                      ),
                      if (showRatingDiff)
                        SizedBox(
                          width: 38,
                          child: (playerResult.ratingDiff != null)
                              ? ProgressionWidget(
                                  playerResult.ratingDiff!,
                                  fontSize: 14,
                                )
                              : null,
                        ),
                    ],
                  ),
                ),
              ),
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
