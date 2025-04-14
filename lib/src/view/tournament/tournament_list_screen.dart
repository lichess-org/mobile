import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';

class TournamentListScreen extends ConsumerStatefulWidget {
  const TournamentListScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(
      context,
      title: context.l10n.tournaments,
      screen: const TournamentListScreen(),
    );
  }

  @override
  ConsumerState<TournamentListScreen> createState() => _TournamentListScreenState();
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

class _TournamentListScreenState extends ConsumerState<TournamentListScreen>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setViewMode(_ViewMode mode) {
    _tabController.animateTo(switch (mode) {
      _ViewMode.completed => 0,
      _ViewMode.ongoing => 1,
      _ViewMode.upcoming => 2,
    });
  }

  @override
  Widget build(BuildContext context) {
    final tournamentAsync = ref.watch(tournamentsProvider);

    return PlatformScaffold(
      appBarTitle: Text(context.l10n.tournaments),
      appBarBottom: TabBar(
        controller: _tabController,
        tabs: <Widget>[
          Tab(text: _ViewMode.completed.l10n(context)),
          Tab(text: _ViewMode.ongoing.l10n(context)),
          Tab(text: _ViewMode.upcoming.l10n(context)),
        ],
      ),
      appBarAutomaticBackgroundVisibility: false,
      body: switch (tournamentAsync) {
        AsyncData(:final value) => TabBarView(
          controller: _tabController,
          children: <Widget>[
            _TournamentListBody(tournaments: value.finished),
            _TournamentListBody(tournaments: value.started),
            _TournamentListBody(tournaments: value.created),
          ],
        ),
        AsyncError(:final error) => Center(child: Text('Could not load tournaments: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _TournamentListBody extends ConsumerStatefulWidget {
  const _TournamentListBody({required this.tournaments});

  final IList<TournamentListItem> tournaments;

  @override
  ConsumerState<_TournamentListBody> createState() => _TournamentListBodyState();
}

class _TournamentListBodyState extends ConsumerState<_TournamentListBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final tournamentListItems =
        widget.tournaments
            .sorted((a, b) {
              final cmp = a.startsAt.compareTo(b.startsAt);
              if (cmp != 0) return cmp;
              return a.position.compareTo(b.position);
            })
            .where((tournament) => playSupportedVariants.contains(tournament.variant))
            .map((tournament) => _TournamentListItem(tournament: tournament))
            .toList();

    return RefreshIndicator.adaptive(
      edgeOffset:
          Theme.of(context).platform == TargetPlatform.iOS
              ? MediaQuery.paddingOf(context).top + 16.0
              : 0,
      key: _refreshIndicatorKey,
      onRefresh: () async => ref.refresh(tournamentsProvider),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: tournamentListItems.length,
        separatorBuilder:
            (context, index) =>
                Theme.of(context).platform == TargetPlatform.iOS
                    ? const PlatformDivider(height: 1, cupertinoHasLeading: true)
                    : const SizedBox.shrink(),
        itemBuilder: (context, index) => tournamentListItems[index],
      ),
    );
  }
}

Color? _iconColor(TournamentListItem tournament) {
  return tournament.maxRating != null
      ? LichessColors.purple
      : switch (tournament.freq) {
        TournamentFreq.hourly => LichessColors.green,
        TournamentFreq.daily => LichessColors.blue,
        TournamentFreq.monthly => LichessColors.red,
        _ => null,
      };
}

class _TournamentListItem extends StatelessWidget {
  const _TournamentListItem({required this.tournament});

  final TournamentListItem tournament;

  static final _hourMinuteFormat = DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
                      '${_hourMinuteFormat.format(tournament.startsAt)} - ${_hourMinuteFormat.format(tournament.finishesAt)}',
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
      onTap:
          () => Navigator.of(
            context,
            rootNavigator: true,
          ).push(TournamentScreen.buildRoute(context, tournament.id)),
    );
  }
}
