import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/tournament/tournament.dart';
import 'package:lichess_mobile/src/model/tournament/tournament_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/focus_detector.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/tournament/tournament_screen.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

class TournamentListScreen extends ConsumerStatefulWidget {
  const TournamentListScreen({super.key});

  static Route<void> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const TournamentListScreen());
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

    return FocusDetector(
      onFocusRegained: () {
        ref.invalidate(tournamentsProvider);
      },
      child: PlatformScaffold(
        appBar: PlatformAppBar(
          title: Text(context.l10n.arenaArenaTournaments),
          bottom: TabBar(
            controller: _tabController,
            tabs: <Widget>[
              Tab(text: _ViewMode.completed.l10n(context)),
              Tab(text: _ViewMode.ongoing.l10n(context)),
              Tab(text: _ViewMode.upcoming.l10n(context)),
            ],
          ),
        ),
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
          _ => const Center(child: CircularProgressIndicator.adaptive()),
        },
      ),
    );
  }
}

class FeaturedTournamentsWidget extends ConsumerWidget {
  const FeaturedTournamentsWidget({required this.featured, super.key});

  final AsyncValue<IList<LightTournament>> featured;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    switch (featured) {
      case AsyncData(:final value):
        if (value.where((t) => playSupportedVariants.contains(t.meta.variant)).isEmpty) {
          return const SizedBox.shrink();
        }
        return ListSection(
          header: Text(context.l10n.openTournaments),
          onHeaderTap: () {
            Navigator.of(context).push(TournamentListScreen.buildRoute(context));
          },
          children: [
            for (final tournament in value)
              if (playSupportedVariants.contains(tournament.meta.variant))
                _TournamentListItem(tournament: tournament),
          ],
        );

      case AsyncError(:final error):
        debugPrint('$error');
        return const Padding(
          padding: Styles.bodySectionPadding,
          child: Text('Could not load featured tournaments'),
        );
      case _:
        return Shimmer(
          child: ShimmerLoading(
            isLoading: true,
            child: ListSection.loading(itemsNumber: 5, header: true),
          ),
        );
    }
  }
}

class _TournamentListBody extends ConsumerStatefulWidget {
  const _TournamentListBody({required this.tournaments});

  final IList<LightTournament> tournaments;

  @override
  ConsumerState<_TournamentListBody> createState() => _TournamentListBodyState();
}

class _TournamentListBodyState extends ConsumerState<_TournamentListBody> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    final List<LightTournament> systemTours = [];
    final List<LightTournament> userTours = [];

    widget.tournaments
        .where((tournament) => playSupportedVariants.contains(tournament.meta.variant))
        .forEach((tournament) {
          if (tournament.isSystemTournament) {
            systemTours.add(tournament);
          } else {
            userTours.add(tournament);
          }
        });

    final sortedSystemTours = systemTours
        .sorted((a, b) {
          final aVariant = a.meta.variant;
          final bVariant = b.meta.variant;
          if (aVariant == Variant.standard && bVariant != Variant.standard) {
            return -1;
          } else if (aVariant != Variant.standard && bVariant == Variant.standard) {
            return 1;
          }

          final aMaxRating = a.meta.maxRating;
          final bMaxRating = b.meta.maxRating;
          if (aMaxRating == null && bMaxRating != null) {
            return -1;
          } else if (aMaxRating != null && bMaxRating == null) {
            return 1;
          } else if (aMaxRating != null && bMaxRating != null) {
            return aMaxRating.compareTo(bMaxRating);
          }

          final position = a.position.compareTo(b.position);
          if (position != 0) {
            return position;
          } else {
            return a.startsAt.compareTo(b.startsAt);
          }
        })
        .sortedBy((tournament) => tournament.meta.freq ?? TournamentFreq.hourly);

    final tournamentListItems = [
      ...sortedSystemTours.map((tournament) => _TournamentListItem(tournament: tournament)),
      ...userTours.map((tournament) => _TournamentListItem(tournament: tournament)),
    ];

    return RefreshIndicator.adaptive(
      edgeOffset:
          Theme.of(context).platform == TargetPlatform.iOS
              ? MediaQuery.paddingOf(context).top + kToolbarHeight
              : 0.0,
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

Color? _iconColor(LightTournament tournament) {
  return tournament.meta.maxRating != null
      ? LichessColors.purple
      : switch (tournament.meta.freq) {
        TournamentFreq.hourly => LichessColors.green,
        TournamentFreq.daily => LichessColors.blue,
        TournamentFreq.monthly => LichessColors.red,
        _ => null,
      };
}

class _TournamentListItem extends StatelessWidget {
  const _TournamentListItem({required this.tournament});

  final LightTournament tournament;

  static final _hourMinuteFormat = DateFormat.Hm();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(tournament.meta.perf.icon, color: _iconColor(tournament)),
      title: Text(tournament.meta.fullName, overflow: TextOverflow.ellipsis, maxLines: 2),
      subtitle: Text(
        '${tournament.meta.timeIncrement.display} ${tournament.meta.rated ? context.l10n.rated : context.l10n.broadcastUnrated} • ${context.l10n.nbMinutes(tournament.meta.duration.inMinutes)}',
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${_hourMinuteFormat.format(tournament.startsAt)} - ${_hourMinuteFormat.format(tournament.finishesAt)}',
            style: const TextStyle(fontSize: 14, fontFeatures: [FontFeature.tabularFigures()]),
          ),
          Text.rich(
            TextSpan(
              style: const TextStyle(color: Colors.grey),
              children: [
                const WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Icon(Icons.group_outlined, size: 18),
                ),
                TextSpan(text: '${tournament.nbPlayers}', style: const TextStyle(fontSize: 14)),
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
