import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';
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
      AsyncData(value: final players) => BroadcastPlayersList(players, tournamentId),
      AsyncError(:final error) => Center(child: Text('Cannot load players data: $error')),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

enum _SortingTypes { player, elo, score }

typedef _BroadcastPlayerPicker<T> = T? Function(BroadcastPlayerWithOverallResult player);

const _kTableRowVerticalPadding = 12.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);
const _kHeaderTextStyle = TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis);

class BroadcastPlayersList extends ConsumerStatefulWidget {
  const BroadcastPlayersList(this.players, this.tournamentId);

  final IList<BroadcastPlayerWithOverallResult> players;
  final BroadcastTournamentId tournamentId;

  @override
  ConsumerState<BroadcastPlayersList> createState() => _BroadcastPlayersListState();
}

class _BroadcastPlayersListState extends ConsumerState<BroadcastPlayersList> {
  late IList<BroadcastPlayerWithOverallResult> players;
  late bool reverse;
  _SortingTypes? currentSort;
  bool get withRating => players.any((p) => p.player.rating != null);
  bool get withScores => players.any((p) => p.score != null);

  void resetState() {
    players = widget.players;
    reverse = false;
    final newSort = withScores ? _SortingTypes.score : _SortingTypes.elo;
    sort(newSort);
  }

  @override
  void initState() {
    super.initState();
    resetState();
  }

  @override
  void didUpdateWidget(BroadcastPlayersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.players != widget.players) {
      resetState();
    }
  }

  /// Sort items by values from the [picker] in increasing order.
  ///
  /// Null values are smaller than any other value.
  Comparator<BroadcastPlayerWithOverallResult> nullableCompare<T extends Comparable<T>>(
    _BroadcastPlayerPicker<T> picker,
  ) => (p1, p2) {
    final field1 = picker(p1);
    final field2 = picker(p2);
    if (field1 == null) return -1;
    if (field2 == null) return 1;

    return field1.compareTo(field2);
  };

  /// Sort items first by values from the [picker1] and solve ties by values from the [picker2].
  ///
  /// Null values are smaller than any other value.
  Comparator<BroadcastPlayerWithOverallResult> bothCompare<
    T extends Comparable<T>,
    U extends Comparable<U>
  >(_BroadcastPlayerPicker<T> picker1, _BroadcastPlayerPicker<U> picker2) => (p1, p2) {
    final value = nullableCompare(picker1)(p1, p2);

    if (value == 0) {
      return nullableCompare(picker2)(p1, p2);
    } else {
      return value;
    }
  };

  void sort(_SortingTypes newSort) {
    final compare = switch (newSort) {
      _SortingTypes.player => nullableCompare((p) => p.player.name),
      _SortingTypes.elo =>
        (BroadcastPlayerWithOverallResult p1, BroadcastPlayerWithOverallResult p2) =>
            bothCompare((p) => p.player.rating, (p) => p.score)(p2, p1),
      _SortingTypes.score =>
        (BroadcastPlayerWithOverallResult p1, BroadcastPlayerWithOverallResult p2) => bothCompare(
          withScores ? (p) => p.score : (p) => p.played,
          (p) => p.player.rating,
        )(p2, p1),
    };

    setState(() {
      if (currentSort != newSort) {
        reverse = false;
      } else {
        reverse = !reverse;
      }
      currentSort = newSort;
      players = reverse ? players.sortReversed(compare) : players.sort(compare);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double eloWidth = max(MediaQuery.sizeOf(context).width * 0.2, 100);
    final double scoreWidth = max(MediaQuery.sizeOf(context).width * 0.15, 90);
    final sortIcon = (reverse ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down);

    return ListView.builder(
      itemCount: players.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return ColoredBox(
            color: ColorScheme.of(context).surfaceDim,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: _TableTitleCell(
                    title: Text(context.l10n.player, style: _kHeaderTextStyle),
                    onTap: () => sort(_SortingTypes.player),
                    sortIcon: (currentSort == _SortingTypes.player) ? sortIcon : null,
                  ),
                ),
                if (withRating)
                  SizedBox(
                    width: eloWidth,
                    child: _TableTitleCell(
                      title: const Text('Elo', style: _kHeaderTextStyle),
                      onTap: () => sort(_SortingTypes.elo),
                      sortIcon: (currentSort == _SortingTypes.elo) ? sortIcon : null,
                    ),
                  ),
                SizedBox(
                  width: scoreWidth,
                  child: _TableTitleCell(
                    title: Text(
                      withScores ? context.l10n.broadcastScore : context.l10n.games,
                      style: _kHeaderTextStyle,
                    ),
                    onTap: () => sort(_SortingTypes.score),
                    sortIcon: (currentSort == _SortingTypes.score) ? sortIcon : null,
                  ),
                ),
              ],
            ),
          );
        } else {
          return BroadcastPlayerRow(
            playerWithOverallResult: players[index - 1],
            tournamentId: widget.tournamentId,
            index: index,
            eloWidth: eloWidth,
            scoreWidth: scoreWidth,
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

class BroadcastPlayerRow extends StatelessWidget {
  const BroadcastPlayerRow({
    required this.playerWithOverallResult,
    required this.tournamentId,
    required this.index,
    required this.eloWidth,
    required this.scoreWidth,
  });

  final BroadcastPlayerWithOverallResult playerWithOverallResult;
  final BroadcastTournamentId tournamentId;
  final int index;
  final double eloWidth;
  final double scoreWidth;

  @override
  Widget build(BuildContext context) {
    final BroadcastPlayerWithOverallResult(:player, :ratingDiff, :score, :played) =
        playerWithOverallResult;
    final rating = player.rating;

    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
        ).push(BroadcastPlayerResultsScreen.buildRoute(context, tournamentId, player));
      },
      child: ColoredBox(
        color: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: _kTableRowPadding,
                child: BroadcastPlayerWidget(player: player, showRating: false),
              ),
            ),
            SizedBox(
              width: eloWidth,
              child: Padding(
                padding: _kTableRowPadding,
                child: Row(
                  children: [
                    if (rating != null) ...[
                      Text(rating.toString()),
                      const SizedBox(width: 5),
                      if (ratingDiff != null) ProgressionWidget(ratingDiff, fontSize: 14),
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
                    (score != null)
                        ? Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${score.toStringAsFixed((score == score.roundToDouble()) ? 0 : 1)} / $played',
                          ),
                        )
                        : Align(alignment: Alignment.centerRight, child: Text(played.toString())),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
