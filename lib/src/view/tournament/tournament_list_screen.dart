import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_repository.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class TournamentListScreen extends ConsumerWidget {
  const TournamentListScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      title: context.l10n.tournaments,
      screen: const TournamentListScreen(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return const Center(child: Text('Could not load tournaments'));
          } else {
            return PlatformWidget(
              androidBuilder: (_) => _AndroidBody(tournaments: snapshot.requireData),
              iosBuilder: (_) => _CupertinoBody(tournaments: snapshot.requireData),
            );
          }
        }

        return PlatformScaffold(
          appBarTitle: Text(context.l10n.tournaments),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
      future: ref.watch(tournamentRepositoryProvider).getTournaments(),
    );
  }
}

class _AndroidBody extends StatefulWidget {
  const _AndroidBody({required this.tournaments});

  final TournamentLists tournaments;

  @override
  State<_AndroidBody> createState() => _AndroidBodyState();
}

enum _ViewMode {
  completed,
  ongoing,
  upcoming;

  String l10n(BuildContext context) {
    switch (this) {
      case _ViewMode.completed:
        // TODO l10n
        return 'Completed';
      case _ViewMode.ongoing:
        return context.l10n.broadcastOngoing;
      case _ViewMode.upcoming:
        return context.l10n.broadcastUpcoming;
    }
  }
}

class _AndroidBodyState extends State<_AndroidBody> with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 1, length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.tournaments),
        bottom: TabBar(
          controller: _tabController,
          tabs: _ViewMode.values.map((mode) => Tab(text: mode.l10n(context))).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _TournamentListBody(tournaments: widget.tournaments.finished),
          _TournamentListBody(tournaments: widget.tournaments.started),
          _TournamentListBody(tournaments: widget.tournaments.created),
        ],
      ),
    );
  }
}

class _CupertinoBody extends StatefulWidget {
  const _CupertinoBody({required this.tournaments});

  final TournamentLists tournaments;

  @override
  _CupertinoBodyState createState() => _CupertinoBodyState();
}

class _CupertinoBodyState extends State<_CupertinoBody> {
  _ViewMode _selectedSegment = _ViewMode.ongoing;

  void setViewMode(_ViewMode mode) {
    setState(() {
      _selectedSegment = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: Styles.bodyPadding,
              child: CupertinoSlidingSegmentedControl<_ViewMode>(
                groupValue: _selectedSegment,
                children: {
                  _ViewMode.completed: Text(_ViewMode.completed.l10n(context)),
                  _ViewMode.ongoing: Text(_ViewMode.ongoing.l10n(context)),
                  _ViewMode.upcoming: Text(_ViewMode.upcoming.l10n(context)),
                },
                onValueChanged: (_ViewMode? view) {
                  if (view != null) {
                    setState(() {
                      _selectedSegment = view;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: _TournamentListBody(
                tournaments: switch (_selectedSegment) {
                  _ViewMode.completed => widget.tournaments.finished,
                  _ViewMode.ongoing => widget.tournaments.started,
                  _ViewMode.upcoming => widget.tournaments.created,
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TournamentListBody extends StatelessWidget {
  const _TournamentListBody({required this.tournaments});

  final IList<TournamentListItem> tournaments;

  @override
  Widget build(BuildContext context) {
    final tournamentListItems =
        tournaments
            .sorted((a, b) {
              final cmp = a.startsAt.compareTo(b.startsAt);
              if (cmp != 0) return cmp;
              return a.position.compareTo(b.position);
            })
            .map((tournament) => _TournamentListItem(tournament: tournament))
            .toList();

    return ListView.separated(
      shrinkWrap: true,
      itemCount: tournaments.length,
      separatorBuilder:
          (context, index) => const PlatformDivider(height: 1, cupertinoHasLeading: true),
      itemBuilder: (context, index) => tournamentListItems[index],
    );
  }
}

Color? _iconColor(TournamentListItem tournament) {
  return tournament.maxRating != null
      ? LichessColors.purple
      : switch (tournament.schedule.freq) {
        'hourly' => LichessColors.green,
        'daily' => LichessColors.blue,
        'monthly' => LichessColors.red,
        _ => null,
      };
}

class _TournamentListItem extends StatelessWidget {
  const _TournamentListItem({required this.tournament});

  final TournamentListItem tournament;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      padding: Styles.bodyPadding,
      title: Row(
        children: [
          Icon(tournament.perf.icon, size: 30, color: _iconColor(tournament)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        tournament.fullName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      '${DateFormat.Hm().format(tournament.startsAt)} - ${DateFormat.Hm().format(tournament.finishesAt)}',
                    ),
                  ],
                ),
                DefaultTextStyle.merge(
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${tournament.timeIncrement.display} ${tournament.rated ? context.l10n.rated : context.l10n.broadcastUnrated} • ${context.l10n.nbMinutes(tournament.minutes)}',
                      ),
                      Text.rich(
                        TextSpan(
                          style: const TextStyle(color: Colors.grey),
                          children: [
                            const WidgetSpan(
                              alignment: PlaceholderAlignment.middle,
                              child: Icon(Icons.group_outlined, size: 18),
                            ),
                            TextSpan(text: '${tournament.nbPlayers}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {},
    );
  }
}
