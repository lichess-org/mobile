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
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_team_screen.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

enum _SortingTypes { elo, score }

typedef _TeamPicker<T> = T? Function(BroadcastTeamStanding team);

const _kTableRowPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0);
const _kHeaderTextStyle = TextStyle(fontWeight: .bold, overflow: .ellipsis);

class BroadcastTeamStandingsScreen extends ConsumerWidget {
  const BroadcastTeamStandingsScreen({super.key, required this.tournamentId});

  final BroadcastTournamentId tournamentId;

  static Route<dynamic> buildRoute(BroadcastTournamentId tournamentId) {
    return buildScreenRoute(screen: BroadcastTeamStandingsScreen(tournamentId: tournamentId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(broadcastTeamStandingsProvider(tournamentId));
    final tournamentAsync = ref.watch(broadcastTournamentProvider(tournamentId));

    return PlatformScaffold(
      appBar: PlatformAppBar(title: AppBarTitleText(context.l10n.broadcastTeamResults)),
      body: switch ((standingsAsync, tournamentAsync)) {
        (AsyncData(value: final teams), AsyncData()) =>
          teams.isNotEmpty
              ? BroadcastTeamStandingsList(teams: teams, tournamentId: tournamentId)
              : Center(child: Text(context.l10n.nothingToSeeHere)),
        (AsyncError(:final error), _) ||
        (_, AsyncError(:final error)) => Center(child: Text('Cannot load data: $error')),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class BroadcastTeamStandingsList extends ConsumerStatefulWidget {
  const BroadcastTeamStandingsList({required this.teams, required this.tournamentId});

  final IList<BroadcastTeamStanding> teams;
  final BroadcastTournamentId tournamentId;

  @override
  ConsumerState<BroadcastTeamStandingsList> createState() => _BroadcastTeamStandingsListState();
}

class _BroadcastTeamStandingsListState extends ConsumerState<BroadcastTeamStandingsList> {
  late IList<BroadcastTeamStanding> teams;
  late _SortingTypes currentSort;
  bool reverse = false;

  bool get withRating => teams.any((team) => team.averageRating != null);

  @override
  void initState() {
    super.initState();
    teams = widget.teams;
    currentSort = .score;
    sort();
  }

  @override
  void didUpdateWidget(BroadcastTeamStandingsList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.teams != widget.teams) {
      teams = widget.teams;
      sort();
    }
  }

  /// Sort items by values from the [picker] in increasing order.
  ///
  /// Null values are smaller than any other value.
  Comparator<BroadcastTeamStanding> nullableCompare<T extends Comparable<T>>(
    _TeamPicker<T> picker,
  ) => (team1, team2) {
    final field1 = picker(team1);
    final field2 = picker(team2);
    if (field1 == null && field2 == null) return 0;
    if (field1 == null) return -1;
    if (field2 == null) return 1;
    return field1.compareTo(field2);
  };

  /// Sort items first by values from the [picker1] and solve ties by values from the [picker2].
  ///
  /// Null values are smaller than any other value.
  Comparator<BroadcastTeamStanding> bothCompare<T extends Comparable<T>, U extends Comparable<U>>(
    _TeamPicker<T> picker1,
    _TeamPicker<U> picker2,
  ) => (team1, team2) {
    final value = nullableCompare(picker1)(team1, team2);
    if (value == 0) {
      return nullableCompare(picker2)(team1, team2);
    }
    return value;
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
      _SortingTypes.elo => (BroadcastTeamStanding t1, BroadcastTeamStanding t2) => bothCompare(
        (t) => t.averageRating,
        (t) => t.mp,
      )(t2, t1),
      _SortingTypes.score => (BroadcastTeamStanding t1, BroadcastTeamStanding t2) => bothCompare(
        (t) => t.mp,
        (t) => t.gp,
      )(t2, t1),
    };

    setState(() {
      teams = reverse ? teams.sortReversed(compare) : teams.sort(compare);
    });
  }

  @override
  Widget build(BuildContext context) {
    final scoreWidth = max(MediaQuery.sizeOf(context).width * 0.15, 90.0);
    final sortIcon = reverse ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down;
    final mediaQueryPadding = MediaQuery.paddingOf(context);
    final scoreFormat = NumberFormat('#.#');

    return CustomScrollView(
      slivers: [
        SliverSafeArea(
          bottom: false,
          sliver: SliverToBoxAdapter(
            child: Column(
              mainAxisSize: .min,
              children: [
                Padding(
                  padding: Styles.bodyPadding.copyWith(top: 8.0, bottom: 0.0),
                  child: Row(
                    children: [
                      const Icon(Icons.info, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          context.l10n.broadcastStandingsDisclaimer,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 13, overflow: .ellipsis),
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
                          title: Text(
                            '${context.l10n.broadcastTeams} (${context.l10n.averageElo})',
                            style: _kHeaderTextStyle,
                            maxLines: 2,
                          ),
                          onTap: () => toggleSort(.elo),
                          sortIcon: currentSort == .elo ? sortIcon : null,
                        ),
                      )
                    else
                      Expanded(
                        child: Padding(
                          padding: _kTableRowPadding,
                          child: Text(context.l10n.broadcastTeams, style: _kHeaderTextStyle),
                        ),
                      ),
                    SizedBox(
                      width: scoreWidth,
                      child: _TableTitleCell(
                        title: Text(
                          context.l10n.broadcastMatchPoints,
                          style: _kHeaderTextStyle,
                          maxLines: 2,
                          textAlign: .right,
                        ),
                        onTap: () => toggleSort(.score),
                        sortIcon: currentSort == .score ? sortIcon : null,
                        mainAxisAlignment: .end,
                      ),
                    ),
                    SizedBox(
                      width: scoreWidth,
                      child: Padding(
                        padding: _kTableRowPadding,
                        child: Text(
                          context.l10n.broadcastGamePoints,
                          textAlign: .right,
                          style: _kHeaderTextStyle,
                          maxLines: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.only(bottom: mediaQueryPadding.bottom),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _BroadcastTeamStandingRow(
                index: index,
                team: teams[index],
                tournamentId: widget.tournamentId,
                scoreWidth: scoreWidth,
                scoreFormat: scoreFormat,
              ),
              childCount: teams.length,
            ),
          ),
        ),
      ],
    );
  }
}

class _TableTitleCell extends StatelessWidget {
  const _TableTitleCell({
    required this.title,
    required this.onTap,
    this.sortIcon,
    this.mainAxisAlignment = .start,
  });

  final Widget title;
  final void Function() onTap;
  final IconData? sortIcon;
  final MainAxisAlignment mainAxisAlignment;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: _kTableRowPadding,
          child: Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: .center,
            children: [
              Flexible(child: title),
              const SizedBox(width: 4),
              SizedBox(
                width: 16,
                child: sortIcon != null
                    ? Text(
                        String.fromCharCode(sortIcon!.codePoint),
                        style: _kHeaderTextStyle.copyWith(
                          fontSize: 16,
                          fontFamily: sortIcon!.fontFamily,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BroadcastTeamStandingRow extends StatelessWidget {
  const _BroadcastTeamStandingRow({
    required this.index,
    required this.team,
    required this.tournamentId,
    required this.scoreWidth,
    required this.scoreFormat,
  });

  final int index;
  final BroadcastTeamStanding team;
  final BroadcastTournamentId tournamentId;
  final double scoreWidth;
  final NumberFormat scoreFormat;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsetsDirectional.only(start: 16.0, end: 8.0),
      visualDensity: .compact,
      tileColor: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
      title: Text(team.name, maxLines: 2, overflow: .ellipsis),
      subtitle: team.averageRating != null
          ? Text(
              '${team.averageRating}',
              style: TextStyle(fontSize: 13, color: textShade(context, Styles.subtitleOpacity)),
            )
          : null,
      trailing: SizedBox(
        width: scoreWidth * 2,
        child: Row(
          children: [
            SizedBox(
              width: scoreWidth,
              child: Align(
                alignment: .centerRight,
                child: Text(
                  scoreFormat.format(team.mp),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: .bold,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
            SizedBox(
              width: scoreWidth,
              child: Align(
                alignment: .centerRight,
                child: Text(
                  scoreFormat.format(team.gp),
                  style: const TextStyle(
                    fontSize: 14,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.of(
          context,
        ).push(BroadcastTeamScreen.buildRoute(context, tournamentId, team.name));
      },
    );
  }
}
