import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_round_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_boards_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_overview_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_players_tab.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_share_menu.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/bottom_bar.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

enum BroadcastRoundTab {
  overview,
  boards,
  players;

  static BroadcastRoundTab? tabOrNullFromString(String tab) {
    return switch (tab) {
      'overview' => BroadcastRoundTab.overview,
      'boards' => BroadcastRoundTab.boards,
      'players' => BroadcastRoundTab.players,
      _ => null,
    };
  }
}

enum _BroadcastGameFilter {
  all,
  ongoing;

  String l10n(AppLocalizations l10n) {
    switch (this) {
      case all:
        return l10n.mobileAllGames;
      case ongoing:
        return l10n.broadcastOngoing;
    }
  }
}

class BroadcastRoundScreenLoading extends ConsumerWidget {
  final BroadcastRoundId roundId;
  final BroadcastRoundTab? initialTab;

  const BroadcastRoundScreenLoading({super.key, required this.roundId, this.initialTab});

  static Route<dynamic> buildRoute(
    BuildContext context,
    BroadcastRoundId roundId, {
    BroadcastRoundTab? initialTab,
  }) {
    return buildScreenRoute(
      context,
      screen: BroadcastRoundScreenLoading(roundId: roundId, initialTab: initialTab),
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
      ),
      AsyncError(:final error) => Scaffold(
        appBar: AppBar(title: const Text('')),
        body: Center(child: Text('Cannot load round data: $error')),
      ),
      _ => Scaffold(
        appBar: AppBar(title: const Text('')),
        body: const Center(child: CircularProgressIndicator.adaptive()),
      ),
    };
  }
}

class BroadcastRoundScreen extends ConsumerStatefulWidget {
  final Broadcast broadcast;
  final BroadcastRoundTab? initialTab;

  const BroadcastRoundScreen({required this.broadcast, this.initialTab});

  static Route<dynamic> buildRoute(
    BuildContext context,
    Broadcast broadcast, {
    BroadcastRoundTab? initialTab,
  }) {
    return buildScreenRoute(
      context,
      screen: BroadcastRoundScreen(broadcast: broadcast, initialTab: initialTab),
    );
  }

  @override
  _BroadcastRoundScreenState createState() => _BroadcastRoundScreenState();
}

class _BroadcastRoundScreenState extends ConsumerState<BroadcastRoundScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late BroadcastTournamentId _selectedTournamentId;
  BroadcastRoundId? _selectedRoundId;

  bool roundLoaded = false;

  _BroadcastGameFilter filter = _BroadcastGameFilter.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      initialIndex: widget.initialTab?.index ?? 0,
      length: 3,
      vsync: this,
    );
    _selectedTournamentId = widget.broadcast.tour.id;
    _selectedRoundId = widget.broadcast.roundToLinkId;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void setTournamentId(BroadcastTournamentId tournamentId) {
    setState(() {
      _selectedTournamentId = tournamentId;
      _selectedRoundId = null;
    });
  }

  void setGameFilter(_BroadcastGameFilter filter) {
    _tabController.index = 1;
    setState(() {
      this.filter = filter;
    });
  }

  void setRoundId(BroadcastRoundId roundId) {
    setState(() {
      roundLoaded = false;
      _selectedRoundId = roundId;
    });
  }

  Widget _buildContent(
    BuildContext context,
    AsyncValue<BroadcastTournament> asyncTournament,
    AsyncValue<BroadcastRoundState> asyncRound,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          widget.broadcast.title,
          minFontSize: 14.0,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: context.l10n.broadcastOverview),
            Tab(text: context.l10n.broadcastBoards),
            Tab(text: context.l10n.players),
          ],
        ),
        actions: [
          SemanticIconButton(
            icon: const Icon(Icons.settings),
            onPressed:
                () => showAdaptiveBottomSheet<void>(
                  context: context,
                  isDismissible: true,
                  isScrollControlled: true,
                  showDragHandle: true,
                  builder:
                      (_) =>
                          _BroadcastSettingsBottomSheet(filter, onGameFilterChange: setGameFilter),
                ),
            semanticsLabel: context.l10n.settingsSettings,
          ),
          SemanticIconButton(
            icon: const PlatformShareIcon(),
            semanticsLabel: context.l10n.studyShareAndExport,
            onPressed: () => showBroadcastShareMenu(context, widget.broadcast),
          ),
        ],
      ),
      body: switch (asyncRound) {
        AsyncData(value: final _) => TabBarView(
          controller: _tabController,
          children: <Widget>[
            BroadcastOverviewTab(broadcast: widget.broadcast, tournamentId: _selectedTournamentId),
            switch (asyncTournament) {
              AsyncData(:final value) => BroadcastBoardsTab(
                tournamentId: _selectedTournamentId,
                roundId: _selectedRoundId ?? value.defaultRoundId,
                tournamentSlug: widget.broadcast.tour.slug,
                showOnlyOngoingGames: filter == _BroadcastGameFilter.ongoing,
              ),
              _ => const SizedBox.shrink(),
            },
            BroadcastPlayersTab(tournamentId: _selectedTournamentId),
          ],
        ),
        _ => const Center(child: CircularProgressIndicator.adaptive()),
      },
      bottomNavigationBar: switch (asyncTournament) {
        AsyncData(:final value) => _BottomBar(
          tournament: value,
          roundId: _selectedRoundId ?? value.defaultRoundId,
          setTournamentId: setTournamentId,
          setRoundId: setRoundId,
        ),
        _ => const BottomBar.empty(transparentBackground: false),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final asyncTour = ref.watch(broadcastTournamentProvider(_selectedTournamentId));

    const loadingRound = AsyncValue<BroadcastRoundState>.loading();

    switch (asyncTour) {
      case AsyncData(value: final tournament):
        // Eagerly initalize the round controller so it stays alive when switching tabs
        // and to know if the round has games to show
        final roundState = ref.watch(
          broadcastRoundControllerProvider(_selectedRoundId ?? tournament.defaultRoundId),
        );

        ref.listen(
          broadcastRoundControllerProvider(_selectedRoundId ?? tournament.defaultRoundId),
          (_, round) {
            if (widget.initialTab == null && round.hasValue && !roundLoaded) {
              roundLoaded = true;
              if (round.value!.games.isNotEmpty) {
                _tabController.index = 1;
              }
            }
          },
        );

        return _buildContent(context, asyncTour, roundState);
      case _:
        return _buildContent(context, asyncTour, loadingRound);
    }
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.tournament,
    required this.roundId,
    required this.setTournamentId,
    required this.setRoundId,
  });

  final BroadcastTournament tournament;
  final BroadcastRoundId roundId;
  final void Function(BroadcastTournamentId) setTournamentId;
  final void Function(BroadcastRoundId) setRoundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomBar(
      transparentBackground: false,
      children: [
        if (tournament.group != null)
          TextButton(
            onPressed:
                () => showAdaptiveBottomSheet<void>(
                  context: context,
                  showDragHandle: true,
                  isScrollControlled: true,
                  isDismissible: true,
                  builder:
                      (_) => DraggableScrollableSheet(
                        initialChildSize: 0.4,
                        maxChildSize: 0.4,
                        minChildSize: 0.1,
                        snap: true,
                        expand: false,
                        builder: (context, scrollController) {
                          return _TournamentSelectorMenu(
                            tournament: tournament,
                            group: tournament.group!,
                            scrollController: scrollController,
                            setTournamentId: setTournamentId,
                          );
                        },
                      ),
                ),
            child: Text(
              tournament.group!.firstWhere((g) => g.id == tournament.data.id).name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        TextButton(
          onPressed:
              () => showAdaptiveBottomSheet<void>(
                context: context,
                showDragHandle: true,
                isScrollControlled: true,
                isDismissible: true,
                builder:
                    (_) => DraggableScrollableSheet(
                      initialChildSize: 0.6,
                      maxChildSize: 0.6,
                      snap: true,
                      expand: false,
                      builder: (context, scrollController) {
                        return _RoundSelectorMenu(
                          selectedRoundId: roundId,
                          rounds: tournament.rounds,
                          scrollController: scrollController,
                          setRoundId: setRoundId,
                        );
                      },
                    ),
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

class _RoundSelectorMenu extends ConsumerStatefulWidget {
  const _RoundSelectorMenu({
    required this.selectedRoundId,
    required this.rounds,
    required this.scrollController,
    required this.setRoundId,
  });

  final BroadcastRoundId selectedRoundId;
  final IList<BroadcastRound> rounds;
  final ScrollController scrollController;
  final void Function(BroadcastRoundId) setRoundId;

  @override
  ConsumerState<_RoundSelectorMenu> createState() => _RoundSelectorState();
}

final _dateFormatMonth = DateFormat.MMMd().add_jm();
final _dateFormatYearMonth = DateFormat.yMMMd().add_jm();

class _RoundSelectorState extends ConsumerState<_RoundSelectorMenu> {
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
            subtitle:
                (round.startsAt != null || round.startsAfterPrevious)
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

class _TournamentSelectorMenu extends ConsumerStatefulWidget {
  const _TournamentSelectorMenu({
    required this.tournament,
    required this.group,
    required this.scrollController,
    required this.setTournamentId,
  });

  final BroadcastTournament tournament;
  final IList<BroadcastTournamentGroup> group;
  final ScrollController scrollController;
  final void Function(BroadcastTournamentId) setTournamentId;

  @override
  ConsumerState<_TournamentSelectorMenu> createState() => _TournamentSelectorState();
}

class _TournamentSelectorState extends ConsumerState<_TournamentSelectorMenu> {
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
            onTap: () {
              widget.setTournamentId(tournament.id);
              Navigator.of(context).pop();
            },
          ),
      ],
    );
  }
}

class _BroadcastSettingsBottomSheet extends ConsumerStatefulWidget {
  const _BroadcastSettingsBottomSheet(this.selectedFilter, {required this.onGameFilterChange});

  final _BroadcastGameFilter selectedFilter;
  final void Function(_BroadcastGameFilter filter) onGameFilterChange;

  @override
  ConsumerState<_BroadcastSettingsBottomSheet> createState() =>
      _BroadcastSettingsBottomSheetState();
}

class _BroadcastSettingsBottomSheetState extends ConsumerState<_BroadcastSettingsBottomSheet> {
  late _BroadcastGameFilter filter;

  @override
  void initState() {
    super.initState();
    filter = widget.selectedFilter;
  }

  @override
  void didUpdateWidget(covariant _BroadcastSettingsBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    filter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    final broadcastPreferences = ref.watch(broadcastPreferencesProvider);

    return DraggableScrollableSheet(
      initialChildSize: .6,
      expand: false,
      builder:
          (context, scrollController) => ListView(
            controller: scrollController,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SettingsSectionTitle(context.l10n.filterGames),
                    const SizedBox(height: 6),
                    Filter<_BroadcastGameFilter>(
                      filterType: FilterType.singleChoice,
                      choices: _BroadcastGameFilter.values,
                      choiceSelected: (choice) => filter == choice,
                      choiceLabel: (category) => Text(category.l10n(context.l10n)),
                      onSelected: (value, selected) {
                        setState(() => filter = value);
                        widget.onGameFilterChange.call(value);
                      },
                    ),
                  ],
                ),
              ),
              ListSection(
                header: SettingsSectionTitle(context.l10n.preferencesDisplay),
                materialFilledCard: true,
                children: [
                  SwitchSettingTile(
                    title: Text(context.l10n.evaluationGauge),
                    value: broadcastPreferences.showEvaluationBar,
                    onChanged: (value) {
                      ref.read(broadcastPreferencesProvider.notifier).toggleEvaluationBar();
                    },
                  ),
                ],
              ),
            ],
          ),
    );
  }
}
