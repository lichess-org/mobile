import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_boards_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_overview_sheet.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_players_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_share_menu.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_teams_tab.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/network_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';
import 'package:lichess_mobile/src/widgets/platform_tab_bar.dart';
import 'package:material_ui/material_ui.dart';

enum BroadcastRoundTab() {
  boards,
  players,
  teams;

  static BroadcastRoundTab? tabOrNullFromString(String tab) {
    return switch (tab) {
      'boards' => BroadcastRoundTab.boards,
      'players' => BroadcastRoundTab.players,
      'teams' => BroadcastRoundTab.teams,
      _ => null,
    };
  }
}

enum _BroadcastGameFilter() {
  all,
  ongoing,
}

class const BroadcastRoundScreenLoading({
  super.key,
  required final BroadcastRoundId roundId,
  final BroadcastRoundTab? initialTab,
  final String? teamFilter,
}) extends ConsumerWidget {
  static Route<dynamic> buildRoute(
    BroadcastRoundId roundId, {
    BroadcastRoundTab? initialTab,
    String? teamFilter,
  }) {
    return buildScreenRoute(
      screen: BroadcastRoundScreenLoading(
        roundId: roundId,
        initialTab: initialTab,
        teamFilter: teamFilter,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final round = ref.watch(broadcastRoundProvider(roundId));

    return switch (round) {
      AsyncData(:final value) => BroadcastRoundScreen(
        broadcast: Broadcast(
          tour: value.tournament,
          round: value.round,
          group: value.groupName,
          roundToLinkId: roundId,
        ),
        initialTab: initialTab,
        teamFilter: teamFilter,
      ),
      AsyncError(:final error) => PlatformScaffold(
        appBar: const PlatformAppBar(title: Text('')),
        body: Center(child: Text('Cannot load round data: $error')),
      ),
      _ => const PlatformScaffold(
        appBar: PlatformAppBar(title: Text('')),
        body: Center(child: CircularProgressIndicator.adaptive()),
      ),
    };
  }
}

class const BroadcastRoundScreen({
  required final Broadcast broadcast,
  final BroadcastRoundTab? initialTab,
  final String? teamFilter,
}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute(Broadcast broadcast, {BroadcastRoundTab? initialTab}) {
    return buildScreenRoute(
      screen: BroadcastRoundScreen(broadcast: broadcast, initialTab: initialTab),
    );
  }

  @override
  _BroadcastRoundScreenState createState() => _BroadcastRoundScreenState();
}

class _BroadcastRoundScreenState()
    extends ConsumerState<BroadcastRoundScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late BroadcastTournamentId _selectedTournamentId;
  BroadcastRoundId? _selectedRoundId;
  String? _teamFilter;

  _BroadcastGameFilter filter = _BroadcastGameFilter.all;

  @override
  void initState() {
    super.initState();
    final hasTeamsTab = widget.broadcast.tour.teamTable == true;
    final tabCount = hasTeamsTab ? 3 : 2;

    _tabController = TabController(
      initialIndex: widget.initialTab?.index ?? 0,
      length: tabCount,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);

    _selectedTournamentId = widget.broadcast.tour.id;
    _selectedRoundId = widget.broadcast.roundToLinkId;
    _teamFilter = widget.teamFilter;
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      final currentRoundId = _selectedRoundId ?? widget.broadcast.roundToLinkId;

      ref.read(observedGamesControllerProvider(currentRoundId).notifier).clear();
    }
  }

  void setTournamentId(BroadcastTournamentId tournamentId) {
    setState(() {
      _selectedTournamentId = tournamentId;
      _selectedRoundId = null;
    });
  }

  void setGameFilter(_BroadcastGameFilter filter, String? team) {
    _tabController.index = BroadcastRoundTab.boards.index;
    setState(() {
      this.filter = filter;
      _teamFilter = team;
    });
  }

  void setRoundId(BroadcastRoundId roundId) {
    setState(() {
      _selectedRoundId = roundId;
    });
  }

  Widget _buildContent(
    BuildContext context,
    AsyncValue<BroadcastTournament> asyncTournament,
    AsyncValue<({BroadcastRound round, bool? isSubscribed})>? roundState,
  ) {
    return switch (roundState) {
      AsyncData(value: (:final round, isSubscribed: final subscription)) => PlatformScaffold(
        extendBody: Theme.of(context).platform == TargetPlatform.iOS,
        appBar: PlatformAppBar(
          // On iOS the title is in the header of the body, below the image, like the Music app.
          title: Theme.of(context).platform == TargetPlatform.iOS
              ? null
              : AppBarTitleText(
                  asyncTournament.value?.data.name ?? widget.broadcast.title,
                  maxLines: 2,
                ),
          // A long title, next to the actions.
          centerTitle: false,
          actionsBuilder: (context, ref) {
            final roundId = _selectedRoundId ?? asyncTournament.value?.defaultRoundId;
            final showEvalBar = ref.watch(
              broadcastPreferencesProvider.select((prefs) => prefs.showRoundEvaluationGauges),
            );
            // Only what the menu shows, so that game updates don't rebuild the app bar. The counts
            // are those of the selected team, whose games the filter choices apply to.
            final games = roundId != null
                ? ref.watch(
                    broadcastRoundControllerProvider(roundId).select((state) {
                      final games = state.value?.games.values ?? const [];
                      final teamGames = _teamFilter == null
                          ? games
                          : games.where(
                              (g) => g.players.values.any((p) => p.player.team == _teamFilter),
                            );
                      return (
                        all: teamGames.length,
                        ongoing: teamGames.where((g) => g.isOngoing).length,
                        teams: games
                            .expand((g) => g.players.values.map((p) => p.player.team))
                            .nonNulls
                            .toIList()
                            .removeDuplicates()
                            .sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase())),
                      );
                    }),
                  )
                : null;
            return [
              if (subscription case final isSubscribed?)
                if (roundId != null)
                  SemanticIconButton(
                    icon: Icon(isSubscribed ? Icons.notifications : Icons.notifications_none),
                    semanticsLabel: isSubscribed
                        ? context.l10n.unsubscribe
                        : context.l10n.subscribe,
                    onPressed: () async {
                      try {
                        await ref
                            .read(broadcastRoundControllerProvider(roundId).notifier)
                            .setSubscribed(_selectedTournamentId, !isSubscribed);
                      } catch (_) {
                        if (context.mounted) {
                          showSnackBar(
                            context,
                            'Could not update the subscription',
                            type: SnackBarType.error,
                          );
                        }
                      }
                    },
                  ),
              ContextMenuIconButton(
                icon: const Icon(Icons.more_horiz),
                semanticsLabel: context.l10n.menu,
                actions: [
                  ContextMenuAction(
                    label: context.l10n.studyShowEvalBar,
                    toggled: showEvalBar,
                    onPressed: () =>
                        ref.read(broadcastPreferencesProvider.notifier).toggleEvaluationBar(),
                  ),
                  ContextMenuSection(
                    title: context.l10n.filterGames,
                    actions: [
                      ContextMenuAction(
                        label: '${context.l10n.mobileAllGames} (${games?.all ?? 0})',
                        selected: filter == .all,
                        onPressed: () => setGameFilter(.all, _teamFilter),
                      ),
                      ContextMenuAction(
                        label: '${context.l10n.broadcastOngoing} (${games?.ongoing ?? 0})',
                        selected: filter == .ongoing,
                        onPressed: () => setGameFilter(.ongoing, _teamFilter),
                      ),
                      if (games != null && games.teams.isNotEmpty)
                        ContextMenuAction(
                          label: context.l10n.teamTeam,
                          subtitle: _teamFilter ?? context.l10n.broadcastAllTeams,
                          onPressed: null,
                          submenu: [
                            for (final team in [null, ...games.teams])
                              ContextMenuAction(
                                label: team ?? context.l10n.broadcastAllTeams,
                                selected: team == _teamFilter,
                                onPressed: () => setGameFilter(filter, team),
                              ),
                          ],
                        ),
                    ],
                  ),
                  ContextMenuAction(
                    icon: Theme.of(context).platform == TargetPlatform.iOS
                        ? Icons.ios_share_outlined
                        : Icons.share_outlined,
                    label: context.l10n.mobileShare,
                    onPressed: null,
                    submenu: makeBroadcastShareMenuActions(
                      context,
                      asyncTournament.value?.data ?? widget.broadcast.tour,
                      round,
                    ),
                  ),
                ],
              ),
            ];
          },
        ),
        // The tabs scroll under the glass bottom bar buttons.
        body: BottomBarScrollEdgeEffect(
          barHeight: BottomBar.heightOf(context),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: NestedScrollView(
            headerSliverBuilder: (context, _) => [
              SliverPadding(
                // The body starts behind the app bar on iOS.
                padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top),
                sliver: SliverToBoxAdapter(
                  child: _RoundHeader(
                    title: Theme.of(context).platform == TargetPlatform.iOS
                        ? asyncTournament.value?.data.name ?? widget.broadcast.title
                        : null,
                    imageUrl:
                        asyncTournament.value?.data.imageUrl ?? widget.broadcast.tour.imageUrl,
                    information: asyncTournament.value?.data.information,
                    onMorePressed: () => showBroadcastOverviewSheet(context, _selectedTournamentId),
                    tabController: _tabController,
                    tabs: [
                      context.l10n.broadcastBoards,
                      context.l10n.players,
                      if (asyncTournament.value?.data.teamTable == true)
                        context.l10n.broadcastTeams,
                    ],
                  ),
                ),
              ),
            ],
            // The tabs are below the header, which has the app bar padding. The padding is the
            // body's, with the bottom bar height, not the screen's.
            body: Builder(
              builder: (context) => MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    switch (asyncTournament) {
                      AsyncData(:final value) => BroadcastBoardsTab(
                        tournamentId: _selectedTournamentId,
                        roundId: _selectedRoundId ?? value.defaultRoundId,
                        tournamentSlug: value.data.slug,
                        showOnlyOngoingGames: filter == _BroadcastGameFilter.ongoing,
                        teamFilter: _teamFilter,
                      ),
                      _ => const SizedBox.shrink(),
                    },
                    BroadcastPlayersTab(tournamentId: _selectedTournamentId),
                    if (asyncTournament.value?.data.teamTable == true) ...[
                      switch (asyncTournament) {
                        AsyncData(:final value) => BroadcastTeamsTab(
                          roundId: _selectedRoundId ?? value.defaultRoundId,
                          tournamentId: _selectedTournamentId,
                          tournamentSlug: value.data.slug,
                          showTeamScores: value.data.showTeamScores == true,
                        ),
                        _ => const SizedBox.shrink(),
                      },
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: switch (asyncTournament) {
          AsyncData(:final value) => _BottomBar(
            tournament: value,
            roundId: _selectedRoundId ?? value.defaultRoundId,
            setTournamentId: setTournamentId,
            setRoundId: setRoundId,
          ),
          _ => const BottomBar.empty(cupertinoGlass: true),
        },
      ),
      AsyncError() => PlatformScaffold(
        extendBody: Theme.of(context).platform == TargetPlatform.iOS,
        appBar: const PlatformAppBar(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Cannot load broadcast round'),
              TextButton(
                onPressed: () {
                  final roundId = _selectedRoundId ?? asyncTournament.value?.defaultRoundId;
                  if (roundId != null) {
                    ref.invalidate(broadcastRoundControllerProvider(roundId));
                  }
                },
                child: Text(context.l10n.retry),
              ),
            ],
          ),
        ),
      ),
      _ => PlatformScaffold(
        extendBody: Theme.of(context).platform == TargetPlatform.iOS,
        appBar: const PlatformAppBar(),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    final asyncTour = ref.watch(broadcastTournamentProvider(_selectedTournamentId));

    switch (asyncTour) {
      case AsyncData(value: final tournament):
        final roundId = _selectedRoundId ?? tournament.defaultRoundId;

        // Only what the scaffold needs, so that game updates don't rebuild the whole screen.
        final roundState = ref.watch(
          broadcastRoundControllerProvider(roundId).select(
            (state) => switch (state) {
              AsyncData(:final value) => AsyncData<({BroadcastRound round, bool? isSubscribed})>((
                round: value.round,
                isSubscribed: value.isSubscribed,
              )),
              AsyncError(:final error, :final stackTrace) =>
                AsyncError<({BroadcastRound round, bool? isSubscribed})>(error, stackTrace),
              AsyncLoading() => const AsyncLoading<({BroadcastRound round, bool? isSubscribed})>(),
            },
          ),
        );

        return _buildContent(context, asyncTour, roundState);
      case _:
        return _buildContent(context, asyncTour, null);
    }
  }
}

/// The header of the round screen, which scrolls away with the tabs below it: the tournament image,
/// title and a line of its information that opens the overview sheet.
class const _RoundHeader({
  /// Null when the title is in the app bar (Android).
  required final String? title,
  required final String? imageUrl,

  /// Null while the tournament is loading.
  required final BroadcastTournamentInformation? information,
  required final VoidCallback onMorePressed,
  required final TabController tabController,
  required final List<String> tabs,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: Styles.horizontalBodyPadding.copyWith(top: 16.0),
          child: Column(
            children: [
              if (imageUrl != null)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    // Broadcast images are cropped to this ratio by the server.
                    child: AspectRatio(
                      aspectRatio: 2.0,
                      child: HttpNetworkImageWidget(
                        imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, _, _) =>
                            ColoredBox(color: ColorScheme.of(context).surfaceContainer),
                      ),
                    ),
                  ),
                ),
              if (title != null) ...[
                const SizedBox(height: 16.0),
                Text(
                  title!,
                  style: TextTheme.of(context).titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ] else
                const SizedBox(height: 8.0),
              if (information case final information?)
                Row(
                  // MORE is at the end of the last line.
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: DefaultTextStyle.merge(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Up to 2 pieces of information per line, on 2 lines.
                            for (final line in broadcastInformationTexts(
                              information,
                            ).take(4).slices(2))
                              Text(line.join(' · ')),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: onMorePressed,
                      child: Text(
                        context.l10n.more.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        PlatformTabBar(tabs: tabs, controller: tabController, inAppBar: false, glass: false),
      ],
    );
  }
}

/// A non-scrolling content for a tab of the round screen, such as a loading indicator or a message,
/// centered in the space below the header.
class const BroadcastRoundTabPlaceholder(final Widget child) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
            child: Center(child: child),
          ),
        ),
      ],
    );
  }
}

class const _BottomBar({
  required final BroadcastTournament tournament,
  required final BroadcastRoundId roundId,
  required final void Function(BroadcastTournamentId) setTournamentId,
  required final void Function(BroadcastRoundId) setRoundId,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomBar(
      cupertinoGlass: true,
      children: [
        if (tournament.group != null)
          BottomBarTextButton(
            onPressed: () => showAdaptiveDraggableBottomSheet<void>(
              context: context,
              constraints: BoxConstraints(maxHeight: MediaQuery.heightOf(context) * 0.9),
              initialChildSize: 0.4,
              snap: true,
              builder: (context, scrollController) {
                return _TournamentSelectorMenu(
                  tournament: tournament,
                  group: tournament.group!,
                  scrollController: scrollController,
                  setTournamentId: setTournamentId,
                );
              },
            ),
            child: Text(
              tournament.group!.firstWhere((g) => g.id == tournament.data.id).name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        BottomBarTextButton(
          onPressed: () => showAdaptiveDraggableBottomSheet<void>(
            context: context,
            constraints: BoxConstraints(maxHeight: MediaQuery.heightOf(context) * 0.9),
            initialChildSize: 0.6,
            snap: true,
            builder: (context, scrollController) {
              return _RoundSelectorMenu(
                selectedRoundId: roundId,
                rounds: tournament.rounds,
                scrollController: scrollController,
                setRoundId: setRoundId,
              );
            },
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  tournament.rounds.firstWhere((round) => round.id == roundId).name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 5.0),
              switch (tournament.rounds.firstWhere((round) => round.id == roundId).status) {
                RoundStatus.finished => Icon(Icons.check, color: context.lichessColors.good),
                RoundStatus.live => Icon(Icons.circle, color: context.lichessColors.error),
                RoundStatus.upcoming => const Icon(Icons.calendar_month, color: Colors.grey),
              },
            ],
          ),
        ),
      ],
    );
  }
}

class const _RoundSelectorMenu({
  required final BroadcastRoundId selectedRoundId,
  required final IList<BroadcastRound> rounds,
  required final ScrollController scrollController,
  required final void Function(BroadcastRoundId) setRoundId,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<_RoundSelectorMenu> createState() => _RoundSelectorState();
}

DateFormat get _dateFormatMonth => DateFormat.MMMd().add_jm();
DateFormat get _dateFormatYearMonth => DateFormat.yMMMd().add_jm();

class _RoundSelectorState() extends ConsumerState<_RoundSelectorMenu> {
  final currentRoundKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Scroll to the current round
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentRoundKey.currentContext != null) {
        Scrollable.ensureVisible(currentRoundKey.currentContext!, alignment: 0.5);
      }
    });

    return BottomSheetScrollableContainer(
      scrollController: widget.scrollController,
      children: [
        for (final (index, round) in widget.rounds.indexed)
          ListTile(
            key: round.id == widget.selectedRoundId ? currentRoundKey : null,
            selected: round.id == widget.selectedRoundId,
            title: Text(round.name, overflow: TextOverflow.ellipsis, maxLines: 2),
            subtitle: (round.startsAt != null || round.startsAfterPrevious)
                ? Text(
                    round.startsAt != null
                        ? round.startsAt!.difference(DateTime.now()).inDays.abs() < 30
                              ? _dateFormatMonth.format(round.startsAt!)
                              : _dateFormatYearMonth.format(round.startsAt!)
                        : context.l10n.broadcastStartsAfter(widget.rounds[index - 1].name),
                    overflow: TextOverflow.ellipsis,
                  )
                : null,
            trailing: switch (round.status) {
              RoundStatus.finished => Icon(Icons.check, color: context.lichessColors.good),
              RoundStatus.live => Icon(Icons.circle, color: context.lichessColors.error),
              RoundStatus.upcoming => const Icon(Icons.calendar_month, color: Colors.grey),
            },
            onTap: () {
              widget.setRoundId(round.id);
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}

class const _TournamentSelectorMenu({
  required final BroadcastTournament tournament,
  required final IList<BroadcastTournamentGroup> group,
  required final ScrollController scrollController,
  required final void Function(BroadcastTournamentId) setTournamentId,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<_TournamentSelectorMenu> createState() => _TournamentSelectorState();
}

class _TournamentSelectorState() extends ConsumerState<_TournamentSelectorMenu> {
  final currentTournamentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // Scroll to the current tournament
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (currentTournamentKey.currentContext != null) {
        Scrollable.ensureVisible(currentTournamentKey.currentContext!, alignment: 0.5);
      }
    });

    return BottomSheetScrollableContainer(
      scrollController: widget.scrollController,
      children: [
        for (final tournament in widget.group)
          ListTile(
            key: tournament.id == widget.tournament.data.id ? currentTournamentKey : null,
            selected: tournament.id == widget.tournament.data.id,
            title: Text(tournament.name),
            trailing: !tournament.active
                ? Icon(Icons.check, color: context.lichessColors.good)
                : tournament.live
                ? Icon(Icons.circle, color: context.lichessColors.error)
                : null,
            onTap: () {
              widget.setTournamentId(tournament.id);
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}
