import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

/// A tab that displays the players participating in a broadcast tournament.
class BroadcastPlayersTab extends ConsumerWidget {
  const BroadcastPlayersTab({required this.tournamentId});

  final BroadcastTournamentId tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edgeInsets = MediaQuery.paddingOf(context) -
        (Theme.of(context).platform == TargetPlatform.iOS
            ? EdgeInsets.only(top: MediaQuery.paddingOf(context).top)
            : EdgeInsets.zero) +
        Styles.bodyPadding;
    final players = ref.watch(broadcastPlayersProvider(tournamentId));

    return switch (players) {
      AsyncData(value: final players) => SliverList(
          delegate: SliverChildListDelegate.fixed([
            PlayersList(players),
          ]),
        ),
      AsyncError(:final error) => SliverPadding(
          padding: edgeInsets,
          sliver: SliverFillRemaining(
            child: Center(child: Text('Cannot load players data: $error')),
          ),
        ),
      _ => SliverList(
          delegate: SliverChildListDelegate.fixed([
            Shimmer(
              child: ShimmerLoading(
                isLoading: true,
                child: PlayersList.loading(),
              ),
            ),
          ]),
        ),
    };
  }
}

enum _SortingTypes { player, elo, score }

const _kTableRowVerticalPadding = 12.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);
const _kHeaderTextStyle = TextStyle(fontWeight: FontWeight.bold);

class PlayersList extends ConsumerStatefulWidget {
  const PlayersList(this.players);

  PlayersList.loading()
      : players = List.generate(
          10,
          (_) => const BroadcastPlayerExtended(
            name: '',
            title: null,
            rating: null,
            federation: null,
            fideId: null,
            played: 0,
            score: null,
            ratingDiff: null,
          ),
        ).toIList();

  final IList<BroadcastPlayerExtended> players;

  @override
  ConsumerState<PlayersList> createState() => _PlayersListState();
}

class _PlayersListState extends ConsumerState<PlayersList> {
  late IList<BroadcastPlayerExtended> players;
  _SortingTypes? currentSort;
  bool reverse = false;

  void sort(_SortingTypes newSort) {
    final compare = switch (newSort) {
      _SortingTypes.player =>
        (BroadcastPlayerExtended a, BroadcastPlayerExtended b) =>
            a.name.compareTo(b.name),
      _SortingTypes.elo =>
        (BroadcastPlayerExtended a, BroadcastPlayerExtended b) {
          if (a.rating == null) return 1;
          if (b.rating == null) return -1;
          return b.rating!.compareTo(a.rating!);
        },
      _SortingTypes.score =>
        (BroadcastPlayerExtended a, BroadcastPlayerExtended b) {
          if (a.score == null) return 1;
          if (b.score == null) return -1;
          return b.score!.compareTo(a.score!);
        }
    };

    setState(() {
      if (currentSort == newSort) {
        reverse = !reverse;
      } else {
        reverse = false;
        currentSort = newSort;
      }
      players = reverse ? players.sortReversed(compare) : players.sort(compare);
    });
  }

  @override
  void initState() {
    super.initState();
    players = widget.players;
    sort(_SortingTypes.score);
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        1: MaxColumnWidth(FlexColumnWidth(0.2), FixedColumnWidth(100)),
        2: MaxColumnWidth(FlexColumnWidth(0.2), FixedColumnWidth(100)),
      },
      children: [
        TableRow(
          children: [
            _TableTitleCell(
              text: context.l10n.player,
              onTap: () {
                sort(_SortingTypes.player);
              },
              icon: (currentSort == _SortingTypes.player)
                  ? reverse
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down
                  : null,
            ),
            _TableTitleCell(
              text: 'Elo',
              onTap: () {
                sort(_SortingTypes.elo);
              },
              icon: (currentSort == _SortingTypes.elo)
                  ? reverse
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down
                  : null,
            ),
            _TableTitleCell(
              text: context.l10n.broadcastScore,
              onTap: () {
                sort(_SortingTypes.score);
              },
              icon: (currentSort == _SortingTypes.score)
                  ? reverse
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down
                  : null,
            ),
          ],
        ),
        ...players.indexed.map(
          (player) => TableRow(
            decoration: BoxDecoration(
              color: player.$1.isEven
                  ? Theme.of(context).colorScheme.surfaceContainerLow
                  : Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
            children: [
              Padding(
                padding: _kTableRowPadding,
                child: BroadcastPlayerWidget(
                  federation: player.$2.federation,
                  title: player.$2.title,
                  name: player.$2.name,
                ),
              ),
              Padding(
                padding: _kTableRowPadding,
                child: Row(
                  children: [
                    if (player.$2.rating != null) ...[
                      Text(player.$2.rating.toString()),
                      const SizedBox(width: 5),
                      if (player.$2.ratingDiff != null)
                        ProgressionWidget(player.$2.ratingDiff!, fontSize: 14),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: _kTableRowPadding,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: (player.$2.score != null)
                      ? Text(
                          '${player.$2.score!.toStringAsFixed((player.$2.score! == player.$2.score!.roundToDouble()) ? 0 : 1)}/${player.$2.played}',
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TableTitleCell extends StatelessWidget {
  const _TableTitleCell({required this.text, required this.onTap, this.icon});

  final String text;
  final void Function() onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TableCell(
      verticalAlignment:
          (icon == null) ? TableCellVerticalAlignment.fill : null,
      child: GestureDetector(
        onTap: onTap,
        child: ColoredBox(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: Padding(
            padding: _kTableRowPadding,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    text,
                    style: _kHeaderTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (icon != null) Icon(icon),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
