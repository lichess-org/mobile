import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';

/// A tab that displays the players participating in a broadcast tournament.
class BroadcastPlayersTab extends ConsumerWidget {
  const BroadcastPlayersTab({required this.tournamentId});

  final BroadcastTournamentId tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(broadcastPlayersProvider(tournamentId));

    return switch (players) {
      AsyncData(value: final players) => PlayersList(players),
      AsyncError(:final error) => SliverToBoxAdapter(
          child: Center(child: Text('Cannot load players data: $error')),
        ),
      _ => const SliverToBoxAdapter(
          child: Placeholder(),
        ),
    };
  }
}

class PlayersList extends StatelessWidget {
  const PlayersList(this.players);

  final IList<BroadcastPlayerExtended> players;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate.fixed(
        players
            .map(
              (player) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: BroadcastPlayerWidget(player)),
                  Row(
                    children: [
                      Text(player.rating.toString()),
                      ProgressionWidget(player.ratingDiff),
                    ],
                  ),
                  const SizedBox(width: 50),
                  Text('${player.score}/${player.played}'),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
