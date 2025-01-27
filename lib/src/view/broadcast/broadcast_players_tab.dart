import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';

/// A tab that displays the players participating in a broadcast tournament.
class BroadcastPlayersTab extends ConsumerWidget {
  const BroadcastPlayersTab({required this.tournamentId});

  final BroadcastTournamentId tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edgeInsets =
        MediaQuery.paddingOf(context) -
        (Theme.of(context).platform == TargetPlatform.iOS
            ? EdgeInsets.only(top: MediaQuery.paddingOf(context).top)
            : EdgeInsets.zero) +
        Styles.bodyPadding;
    final players = ref.watch(broadcastPlayersProvider(tournamentId));

    return switch (players) {
      AsyncData(value: final players) => PlayersList(players, tournamentId),
      AsyncError(:final error) => SliverPadding(
        padding: edgeInsets,
        sliver: SliverFillRemaining(child: Center(child: Text('Cannot load players data: $error'))),
      ),
      _ => const SliverFillRemaining(child: Center(child: CircularProgressIndicator.adaptive())),
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
const _kHeaderTextStyle = TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis);

class PlayersList extends ConsumerStatefulWidget {
  const PlayersList(this.players, this.tournamentId);

  final IList<BroadcastPlayerExtended> players;
  final BroadcastTournamentId tournamentId;

  @override
  ConsumerState<PlayersList> createState() => _PlayersListState();
}

class _PlayersListState extends ConsumerState<PlayersList> {
  late IList<BroadcastPlayerExtended> players;
  late _SortingTypes currentSort;
  bool reverse = false;

  @override
  void initState() {
    super.initState();
    players = widget.players;
    currentSort = players.firstOrNull?.score != null ? _SortingTypes.score : _SortingTypes.elo;
    sort(currentSort);
  }

  @override
  void didUpdateWidget(PlayersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.players != widget.players) {
      players = widget.players;
      currentSort = players.firstOrNull?.score != null ? _SortingTypes.score : _SortingTypes.elo;
      sort(currentSort);
    }
  }

  void sort(_SortingTypes newSort, {bool toggleReverse = false}) {
    final compare = switch (newSort) {
      _SortingTypes.player =>
        (BroadcastPlayerExtended a, BroadcastPlayerExtended b) => a.name.compareTo(b.name),
      _SortingTypes.elo => (BroadcastPlayerExtended a, BroadcastPlayerExtended b) {
        if (a.rating == null) return 1;
        if (b.rating == null) return -1;
        return b.rating!.compareTo(a.rating!);
      },
      _SortingTypes.score => (BroadcastPlayerExtended a, BroadcastPlayerExtended b) {
        if (a.score == null) return 1;
        if (b.score == null) return -1;

        final value = b.score!.compareTo(a.score!);
        if (value == 0) {
          return a.played.compareTo(b.played);
        } else {
          return value;
        }
      },
    };

    setState(() {
      if (currentSort != newSort) {
        reverse = false;
      } else {
        reverse = toggleReverse ? !reverse : reverse;
      }
      currentSort = newSort;
      players = reverse ? players.sortReversed(compare) : players.sort(compare);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double eloWidth = max(MediaQuery.sizeOf(context).width * 0.2, 100);
    final double scoreWidth = max(MediaQuery.sizeOf(context).width * 0.15, 90);

    final firstPlayer = players.firstOrNull;

    return SliverList.builder(
      itemCount: players.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: _TableTitleCell(
                  title: Text(context.l10n.player, style: _kHeaderTextStyle),
                  onTap:
                      () => sort(
                        _SortingTypes.player,
                        toggleReverse: currentSort == _SortingTypes.player,
                      ),
                  sortIcon:
                      (currentSort == _SortingTypes.player)
                          ? (reverse ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                          : null,
                ),
              ),
              SizedBox(
                width: eloWidth,
                child: _TableTitleCell(
                  title: const Text('Elo', style: _kHeaderTextStyle),
                  onTap:
                      () =>
                          sort(_SortingTypes.elo, toggleReverse: currentSort == _SortingTypes.elo),
                  sortIcon:
                      (currentSort == _SortingTypes.elo)
                          ? (reverse ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                          : null,
                ),
              ),
              SizedBox(
                width: scoreWidth,
                child: _TableTitleCell(
                  title: Text(
                    firstPlayer?.score != null ? context.l10n.broadcastScore : context.l10n.games,
                    style: _kHeaderTextStyle,
                  ),
                  onTap:
                      () => sort(
                        _SortingTypes.score,
                        toggleReverse: currentSort == _SortingTypes.score,
                      ),
                  sortIcon:
                      (currentSort == _SortingTypes.score)
                          ? (reverse ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down)
                          : null,
                ),
              ),
            ],
          );
        } else {
          final player = players[index - 1];

          return GestureDetector(
            onTap: () {
              pushPlatformRoute(
                context,
                builder:
                    (context) => BroadcastPlayerResultsScreen(
                      widget.tournamentId,
                      player.fideId != null ? player.fideId.toString() : player.name,
                      player.title,
                      player.name,
                    ),
              );
            },
            child: ColoredBox(
              color:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? index.isEven
                          ? CupertinoColors.secondarySystemBackground.resolveFrom(context)
                          : CupertinoColors.tertiarySystemBackground.resolveFrom(context)
                      : index.isEven
                      ? ColorScheme.of(context).surfaceContainerLow
                      : ColorScheme.of(context).surfaceContainerHigh,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Padding(
                      padding: _kTableRowPadding,
                      child: BroadcastPlayerWidget(
                        federation: player.federation,
                        title: player.title,
                        name: player.name,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: eloWidth,
                    child: Padding(
                      padding: _kTableRowPadding,
                      child: Row(
                        children: [
                          if (player.rating != null) ...[
                            Text(player.rating.toString()),
                            const SizedBox(width: 5),
                            if (player.ratingDiff != null)
                              ProgressionWidget(player.ratingDiff!, fontSize: 14),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    width: scoreWidth,
                    child: Padding(
                      padding: _kTableRowPadding,
                      child:
                          (player.score != null)
                              ? Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${player.score!.toStringAsFixed((player.score! == player.score!.roundToDouble()) ? 0 : 1)} / ${player.played}',
                                ),
                              )
                              : Align(
                                alignment: Alignment.centerRight,
                                child: Text(player.played.toString()),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

class _TableTitleCell extends StatelessWidget {
  const _TableTitleCell({required this.title, required this.onTap, this.sortIcon});

  final Widget title;
  final void Function() onTap;
  final IconData? sortIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: _kTableRowPadding,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: title),
              if (sortIcon != null)
                Text(
                  String.fromCharCode(sortIcon!.codePoint),
                  style: _kHeaderTextStyle.copyWith(fontSize: 16, fontFamily: sortIcon!.fontFamily),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
