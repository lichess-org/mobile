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
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_results_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_player_widget.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/stat_card.dart';

class BroadcastTeamScreen extends ConsumerWidget {
  const BroadcastTeamScreen({super.key, required this.tournamentId, required this.teamName});

  final BroadcastTournamentId tournamentId;
  final String teamName;

  static Route<dynamic> buildRoute(
    BuildContext context,
    BroadcastTournamentId tournamentId,
    String teamName,
  ) {
    return buildScreenRoute(
      screen: BroadcastTeamScreen(tournamentId: tournamentId, teamName: teamName),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final standingsAsync = ref.watch(broadcastTeamStandingsProvider(tournamentId));
    final tournamentAsync = ref.watch(broadcastTournamentProvider(tournamentId));

    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Row(
          children: [
            const Icon(Icons.groups_3),
            const SizedBox(width: 8),
            Flexible(child: Text(teamName, overflow: .ellipsis)),
          ],
        ),
      ),
      body: switch ((standingsAsync, tournamentAsync)) {
        (AsyncData(value: final standings), AsyncData(value: final tournament)) => () {
          final team = standings.where((t) => t.name == teamName).firstOrNull;
          if (team == null) {
            return const Center(child: Text('Team not found'));
          }
          return _Body(tournament: tournament, team: team);
        }(),
        (AsyncError(:final error), _) ||
        (_, AsyncError(:final error)) => Center(child: Text('Cannot load data: $error')),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.tournament, required this.team});

  final BroadcastTournament tournament;
  final BroadcastTeamStanding team;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        _OverallTeamStat(team: team),
        if (team.players.isNotEmpty) ...[
          _SectionHeader(title: context.l10n.players),
          ...team.players.asMap().entries.map(
            (entry) => _PlayerListTile(
              tournament: tournament,
              playerResult: entry.value,
              index: entry.key,
            ),
          ),
        ],

        if (team.matches.isNotEmpty) ...[
          _SectionHeader(title: context.l10n.broadcastMatchHistory),
          _MatchHistoryTable(team: team, tournament: tournament),
        ],
        const SizedBox(height: 32.0),
      ],
    );
  }
}

class _OverallTeamStat extends StatelessWidget {
  const _OverallTeamStat({required this.team});

  final BroadcastTeamStanding team;

  @override
  Widget build(BuildContext context) {
    final statWidth =
        (MediaQuery.sizeOf(context).width - Styles.bodyPadding.horizontal - 10 * 2) / 3;
    const cardSpacing = 10.0;

    return Padding(
      padding: Styles.bodyPadding.copyWith(top: 16.0, bottom: 16.0),
      child: Column(
        spacing: cardSpacing,
        children: [
          Row(
            mainAxisAlignment: .center,
            spacing: cardSpacing,
            children: [
              SizedBox(
                width: statWidth,
                child: _StatCard(
                  context.l10n.broadcastMatches,
                  value: team.matches.length.toString(),
                ),
              ),
              SizedBox(
                width: statWidth,
                child: _StatCard(
                  context.l10n.broadcastMatchPoints,
                  value: NumberFormat('#.#').format(team.mp),
                ),
              ),
              SizedBox(
                width: statWidth,
                child: _StatCard(
                  context.l10n.broadcastGamePoints,
                  value: NumberFormat('#.#').format(team.gp),
                ),
              ),
            ],
          ),
          if (team.averageRating != null)
            Row(
              mainAxisAlignment: .center,
              spacing: cardSpacing,
              children: [
                SizedBox(
                  width: statWidth,
                  child: _StatCard(context.l10n.averageElo, value: team.averageRating.toString()),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: ColorScheme.of(context).surfaceDim,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(title, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}

class _PlayerListTile extends StatelessWidget {
  const _PlayerListTile({
    required this.tournament,
    required this.playerResult,
    required this.index,
  });

  final BroadcastTournament tournament;
  final BroadcastPlayerWithOverallResult playerResult;
  final int index;

  @override
  Widget build(BuildContext context) {
    final scoreStr = playerResult.score != null
        ? NumberFormat('#.#').format(playerResult.score)
        : '-';

    final pic = playerResult.player.fideId != null
        ? tournament.photos?.get(playerResult.player.fideId!)
        : null;

    return ListTile(
      tileColor: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
      leading: ClipRRect(
        borderRadius: Styles.thumbnailBorderRadius,
        child: pic != null
            ? HttpNetworkImageWidget(pic.smallUrl, width: 40, height: 40)
            : playerResult.player.isBot
            ? Image.asset('assets/images/anon-engine.webp', width: 40, height: 40)
            : Image.asset('assets/images/anon-face.webp', width: 40, height: 40),
      ),
      title: BroadcastPlayerWidget(player: playerResult.player, showRating: false),
      subtitle: playerResult.player.rating != null
          ? Text(playerResult.player.rating.toString())
          : null,
      trailing: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .end,
        mainAxisAlignment: .center,
        children: [
          Text(
            '$scoreStr / ${playerResult.played}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: .bold),
          ),
          Text(
            'Score',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
      onTap: () {
        if (playerResult.player.id == null) return;
        Navigator.of(context).push(
          BroadcastPlayerResultsScreen.buildRoute(
            tournament.data.id,
            playerResult.player,
            playerResult.player.id!,
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.stat, {this.value});

  final String stat;
  final String? value;

  @override
  Widget build(BuildContext context) {
    return StatCard(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      stat,
      value: value,
    );
  }
}

class _MatchHistoryTable extends StatelessWidget {
  const _MatchHistoryTable({required this.team, required this.tournament});

  final BroadcastTeamStanding team;
  final BroadcastTournament tournament;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(100),
        1: FlexColumnWidth(),
        2: FixedColumnWidth(70),
        3: FixedColumnWidth(70),
      },
      defaultVerticalAlignment: .middle,
      children: [
        const TableRow(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text('Round', style: TextStyle(fontWeight: .bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text('Team', style: TextStyle(fontWeight: .bold)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'MP',
                textAlign: .center,
                style: TextStyle(fontWeight: .bold),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Text(
                'GP',
                textAlign: .center,
                style: TextStyle(fontWeight: .bold),
              ),
            ),
          ],
        ),
        ...team.matches.asMap().entries.map((entry) {
          final index = entry.key;
          final match = entry.value;

          Color? pointsColor;
          if (match.points == '1') {
            pointsColor = context.lichessColors.good;
          } else if (match.points == '0') {
            pointsColor = context.lichessColors.error;
          }

          return TableRow(
            decoration: BoxDecoration(
              color: index.isEven ? context.lichessTheme.rowEven : context.lichessTheme.rowOdd,
            ),
            children: [
              _TableTapCell(
                match: match,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: Text((index + 1).toString()),
                ),
              ),
              TableRowInkWell(
                onTap: () {
                  Navigator.of(context).push(
                    BroadcastTeamScreen.buildRoute(context, tournament.data.id, match.opponent),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(match.opponent, maxLines: 2, overflow: .ellipsis),
                ),
              ),
              _TableTapCell(
                match: match,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: match.mp != null
                      ? Text(
                          NumberFormat('#.#').format(match.mp),
                          textAlign: .center,
                          style: TextStyle(fontWeight: .bold, color: pointsColor),
                        )
                      : const Text('*', textAlign: .center),
                ),
              ),
              _TableTapCell(
                match: match,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                  child: match.gp != null
                      ? Text(NumberFormat('#.#').format(match.gp), textAlign: .center)
                      : const Text('*', textAlign: .center),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _TableTapCell extends StatelessWidget {
  const _TableTapCell({required this.match, required this.child});

  final BroadcastTeamStandingMatch match;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TableRowInkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(BroadcastRoundScreenLoading.buildRoute(match.roundId, initialTab: .teams));
      },
      child: child,
    );
  }
}
