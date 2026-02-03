import 'dart:math';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/theme.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform_search_bar.dart';
import 'package:lichess_mobile/src/widgets/progression_widget.dart';

final playersAndTournamentProvider = FutureProvider.autoDispose
    .family<
      (IList<BroadcastPlayerWithOverallResult> players, BroadcastTournament tournament),
      BroadcastTournamentId
    >((ref, tournamentId) async {
      final players = await ref.watch(broadcastPlayersProvider(tournamentId).future);
      final tournament = await ref.watch(broadcastTournamentProvider(tournamentId).future);

      return (players, tournament);
    });

/// A tab that displays the players participating in a broadcast tournament.
class BroadcastPlayersTab extends ConsumerWidget {
  const BroadcastPlayersTab({required this.tournamentId});

  final BroadcastTournamentId tournamentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(playersAndTournamentProvider(tournamentId))) {
      AsyncData(value: final data) => BroadcastPlayersList(data.$1, data.$2),
      AsyncError(:final error) => Center(child: Text('Cannot load players data: $error')),
      _ => const Center(child: CircularProgressIndicator.adaptive()),
    };
  }
}

enum _SortingTypes { elo, score }

typedef _BroadcastPlayerPicker<T> = T? Function(BroadcastPlayerWithOverallResult player);

const _kTableRowVerticalPadding = 12.0;
const _kTableRowHorizontalPadding = 8.0;
const _kTableRowPadding = EdgeInsets.symmetric(
  horizontal: _kTableRowHorizontalPadding,
  vertical: _kTableRowVerticalPadding,
);
const _kHeaderTextStyle = TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis);

class BroadcastPlayersList extends ConsumerStatefulWidget {
  const BroadcastPlayersList(this.players, this.tournament);

  final IList<BroadcastPlayerWithOverallResult> players;
  final BroadcastTournament tournament;

  @override
  ConsumerState<BroadcastPlayersList> createState() => _BroadcastPlayersListState();
}

class _BroadcastPlayersListState extends ConsumerState<BroadcastPlayersList> {
  late IList<BroadcastPlayerWithOverallResult> players;
  late _SortingTypes currentSort;
  bool reverse = false;
  bool get withRating => players.any((p) => p.player.rating != null);
  bool get withScores => players.any((p) => p.score != null);
  String _searchQuery = '';
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    players = widget.players;
    currentSort = withScores ? _SortingTypes.score : _SortingTypes.elo;
    sort();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BroadcastPlayersList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.players != widget.players) {
      players = widget.players;
      sort();
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

  void toggleSort(_SortingTypes newSort) {
    if (currentSort != newSort) {
      currentSort = newSort;
      reverse = false;
    } else {
      reverse = !reverse;
    }

    sort();
  }

  void sort() {
    final compare = switch (currentSort) {
      _SortingTypes.elo =>
        (BroadcastPlayerWithOverallResult p1, BroadcastPlayerWithOverallResult p2) =>
            bothCompare((p) => p.player.rating, (p) => p.score)(p2, p1),
      _SortingTypes.score =>
        (BroadcastPlayerWithOverallResult p1, BroadcastPlayerWithOverallResult p2) =>
            p1.rank != null && p2.rank != null
            ? p1.rank!.compareTo(p2.rank!)
            : bothCompare(withScores ? (p) => p.score : (p) => p.played, (p) => p.player.rating)(
                p2,
                p1,
              ),
    };

    setState(() {
      players = reverse ? players.sortReversed(compare) : players.sort(compare);
    });
  }

  @override
  Widget build(BuildContext context) {
    final double scoreWidth = max(MediaQuery.sizeOf(context).width * 0.15, 90);
    final sortIcon = (reverse ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down);
    final withRank = players.any((p) => p.rank != null);
    final showSearchBar = players.length >= 15;
    final filteredPlayers = _searchQuery.isEmpty
        ? players
        : players
              .where(
                (p) => p.player.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false,
              )
              .toIList();

    final mediaQueryPadding = MediaQuery.paddingOf(context);

    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          bottom: false,
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisSize: .min,
              children: [
                if (showSearchBar)
                  Padding(
                    padding: Styles.bodyPadding.copyWith(bottom: 0.0),
                    child: PlatformSearchBar(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      onClear: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    ),
                  ),
                if (withRank)
                  Padding(
                    padding: Styles.bodyPadding.copyWith(top: 8.0, bottom: 0.0),
                    child: const Row(
                      children: [
                        Icon(Icons.info, size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Standings are calculated using broadcasted games and may differ from official results.',
                            maxLines: 2,
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  crossAxisAlignment: .center,
                  children: [
                    if (withRating)
                      Expanded(
                        child: _TableTitleCell(
                          title: Text('${context.l10n.player} (Elo)', style: _kHeaderTextStyle),
                          onTap: () => toggleSort(_SortingTypes.elo),
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
                        onTap: () => toggleSort(_SortingTypes.score),
                        sortIcon: (currentSort == _SortingTypes.score) ? sortIcon : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsetsGeometry.only(
            // top media query padding is already included in the SliverSafeArea above
            top: 0.0,
            bottom: mediaQueryPadding.bottom,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return BroadcastPlayerRow(
                playerWithOverallResult: filteredPlayers[index],
                tournament: widget.tournament,
                index: index + 1,
              );
            }, childCount: filteredPlayers.length),
          ),
        ),
      ],
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
      child: InkWell(
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
    required this.tournament,
    required this.index,
  });

  final BroadcastPlayerWithOverallResult playerWithOverallResult;
  final BroadcastTournament tournament;
  final int index;
  void _showTieBreaksBottomSheet(BuildContext context) {
    final tieBreaks = playerWithOverallResult.tieBreaks;
    if (tieBreaks == null || tieBreaks.isEmpty) return;

    final BroadcastPlayerWithOverallResult(:player, :score, :played) = playerWithOverallResult;

    showModalBottomSheet<void>(
      context: context,
      isDismissible: true,
      isScrollControlled: true,
      builder: (context) {
        return BottomSheetScrollableContainer(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  Expanded(
                    child: BroadcastPlayerWidget(
                      player: player,
                      textStyle: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    score != null
                        ? '${NumberFormat('0.#').format(score)} / $played'
                        : '$played ${context.l10n.games.toLowerCase()}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Tie-breaking', style: Theme.of(context).textTheme.titleSmall),
            ),
            ...tieBreaks.map(
              (tieBreak) => ListTile(
                title: Text(tieBreak.description),
                trailing: Text(NumberFormat('0.##').format(tieBreak.points)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final BroadcastPlayerWithOverallResult(
      :player,
      :ratingDiff,
      :score,
      :played,
      :rank,
      :tieBreaks,
    ) = playerWithOverallResult;
    final BroadcastPlayer(:federation, :rating) = player;
    final pic = player.fideId != null ? tournament.photos?.get(player.fideId!) : null;
    final hasTieBreaks = tieBreaks != null && tieBreaks.isNotEmpty;

    return ListTile(
      tileColor: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
      onTap: () {
        if (player.id != null) {
          Navigator.of(context).push(
            BroadcastPlayerResultsScreen.buildRoute(
              context,
              tournament.data.id,
              player,
              player.id!,
            ),
          );
        }
      },
      onLongPress: hasTieBreaks ? () => _showTieBreaksBottomSheet(context) : null,
      leading: ClipRRect(
        borderRadius: Styles.thumbnailBorderRadius,
        child: pic != null
            ? HttpNetworkImageWidget(pic.smallUrl, width: 40, height: 40)
            : player.isBot
            ? Image.asset('assets/images/anon-engine.webp', width: 40, height: 40)
            : Image.asset('assets/images/anon-face.webp', width: 40, height: 40),
      ),
      title: Row(
        mainAxisSize: .min,
        children: [
          if (rank != null) ...[
            Text(
              rank.toString(),
              style: TextStyle(
                color: textShade(context, Styles.subtitleOpacity),
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
            const SizedBox(width: 5),
          ],
          Expanded(
            child: BroadcastPlayerWidget(player: player, showRating: false, showFederation: false),
          ),
        ],
      ),
      subtitle: federation != null
          ? Row(
              mainAxisSize: .min,
              children: [
                Image.asset('assets/images/fide-fed/$federation.png', height: 12),
                const SizedBox(width: 5),
                if (rating != null)
                  Text(
                    rating.toString(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                const SizedBox(width: 4),
                if (ratingDiff != null) ProgressionWidget(ratingDiff, fontSize: 13),
              ],
            )
          : null,
      trailing: rating != null || score != null
          ? SizedBox(
              width: 35,
              child: Align(
                alignment: Alignment.centerRight,
                child: score != null
                    ? Text(
                        score.toStringAsFixed((score == score.roundToDouble()) ? 0 : 1),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      )
                    : Text(
                        played.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFeatures: [FontFeature.tabularFigures()],
                        ),
                      ),
              ),
            )
          : null,
    );
  }
}
