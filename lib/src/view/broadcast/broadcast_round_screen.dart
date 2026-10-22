import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/constants.dart';
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

  /// The outer scroll controller of the [NestedScrollView], scrolled to its end when the tabs are
  /// pinned below the app bar.
  final _scrollController = ScrollController();
  final _tabsPinned = ValueNotifier(false);
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
    _scrollController.addListener(_onScroll);

    _selectedTournamentId = widget.broadcast.tour.id;
    _selectedRoundId = widget.broadcast.roundToLinkId;
    _teamFilter = widget.teamFilter;
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _tabsPinned.dispose();
    super.dispose();
  }

  void _onScroll() {
    final position = _scrollController.position;
    _tabsPinned.value = position.maxScrollExtent > 0 && position.pixels >= position.maxScrollExtent;
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
    ({BroadcastRound round, bool? isSubscribed})? roundState,
  ) {
    return switch (roundState) {
      final roundState? => PlatformScaffold(
        extendBody: Theme.of(context).platform == TargetPlatform.iOS,
        // Tinted like the bottom bar buttons, over the boards.
        appBar: PlatformAppBar(
          tintedGlass: true,
          // Before iOS 26, the pinned tabs paint the bar background ([_RoundHeader]).
          scrolledUnderTint: false,
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
              if (roundState.isSubscribed case final isSubscribed?)
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
                      roundState.round,
                    ),
                  ),
                ],
              ),
            ];
          },
        ),
        // The tabs scroll under the glass bottom bar buttons.
        body: BottomBarScrollEdgeEffect(
          barHeight: kBottomBarHeight + MediaQuery.paddingOf(context).bottom,
          color: Theme.of(context).scaffoldBackgroundColor,
          child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder: (context, _) => [
              SliverOverlapAbsorber(
                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: _RoundHeader(
                  title: Theme.of(context).platform == TargetPlatform.iOS
                      ? asyncTournament.value?.data.name ?? widget.broadcast.title
                      : null,
                  imageUrl: asyncTournament.value?.data.imageUrl ?? widget.broadcast.tour.imageUrl,
                  information: asyncTournament.value?.data.information,
                  onMorePressed: () => showBroadcastOverviewSheet(context, _selectedTournamentId),
                  tabController: _tabController,
                  tabsPinned: _tabsPinned,
                  tabs: [
                    context.l10n.broadcastBoards,
                    context.l10n.players,
                    if (asyncTournament.value?.data.teamTable == true) context.l10n.broadcastTeams,
                  ],
                ),
              ),
            ],
            // The header is above the tabs, which start below it with a SliverOverlapInjector. The
            // padding is the body's, with the bottom bar height, not the screen's.
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
      null => PlatformScaffold(
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
            (state) => switch (state.value) {
              final value? => (round: value.round, isSubscribed: value.isSubscribed),
              null => null,
            },
          ),
        );

        return _buildContent(context, asyncTour, roundState);
      case _:
        return _buildContent(context, asyncTour, null);
    }
  }
}

/// The header of the round screen, above the tabs: the tournament image, title and a line of its
/// information that opens the overview sheet, which scroll away, and the tabs, which stay pinned
/// below the app bar.
class const _RoundHeader({
  /// Null when the title is in the app bar (Android).
  required final String? title,
  required final String? imageUrl,

  /// Null while the tournament is loading.
  required final BroadcastTournamentInformation? information,
  required final VoidCallback onMorePressed,
  required final TabController tabController,

  /// Whether the tabs are pinned below the app bar.
  required final ValueListenable<bool> tabsPinned,
  required final List<String> tabs,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isIOS = Theme.of(context).platform == TargetPlatform.iOS;
    // The height of the app bar on iOS, where the body extends behind it.
    final topPadding = MediaQuery.paddingOf(context).top;

    return _SliverPinnedTabsHeader(
      topInset: topPadding,
      header: Padding(
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
      tabs: ValueListenableBuilder(
        valueListenable: tabsPinned,
        builder: (context, pinned, _) {
          final tabBar = AnimatedContainer(
            duration: kThemeChangeDuration,
            // On iOS the content scrolls under the glass segmented control. On Android, pinned
            // tabs have the color of the scrolled under app bar above them.
            color: isIOS
                ? Colors.transparent
                : pinned
                ? _scrolledUnderAppBarColor(context)
                : Theme.of(context).scaffoldBackgroundColor,
            child: PlatformTabBar(
              tabs: tabs,
              controller: tabController,
              inAppBar: false,
              tintedGlass: true,
              // Flat in the header, glass once pinned under the app bar, over the content.
              glass: pinned,
            ),
          );
          if (!isIOS || useLiquidGlass(context)) return tabBar;
          // Before iOS 26, pinned tabs are the bottom of the app bar: one bar background behind
          // the status bar, the app bar (which has no tint of its own) and the tabs.
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -topPadding,
                left: 0,
                right: 0,
                bottom: 0,
                child: IgnorePointer(
                  child: AnimatedOpacity(
                    opacity: pinned ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 150),
                    child: const BlurredBarBackground(),
                  ),
                ),
              ),
              tabBar,
            ],
          );
        },
      ),
    );
  }
}

/// The color of a Material 3 [AppBar] when content is scrolled under it: its background color with
/// the surface tint of its scrolled under elevation, as its [Material] paints it.
Color _scrolledUnderAppBarColor(BuildContext context) {
  final appBarTheme = AppBarTheme.of(context);
  final colorScheme = ColorScheme.of(context);
  return ElevationOverlay.applySurfaceTint(
    appBarTheme.backgroundColor ?? colorScheme.surfaceContainer,
    appBarTheme.surfaceTintColor ?? colorScheme.surfaceTint,
    // The Material 3 default.
    appBarTheme.scrolledUnderElevation ?? 3.0,
  );
}

enum _HeaderSlot() {
  header,
  tabs,
}

/// The header of a [NestedScrollView], in a [SliverOverlapAbsorber]: a [header] that scrolls away,
/// followed by [tabs] that stay pinned [topInset] below the top of the scroll view.
///
/// The scroll view starts at the top of the screen, behind the app bar, and [topInset] is the
/// height of the app bar: the content starts below it, and scrolls under it. The [header] fades out
/// as it goes under the app bar, since its bottom stays there when the [tabs] are pinned.
///
/// Unlike a [SliverMainAxisGroup] with pinned slivers, the pinned extent is reported in
/// [SliverGeometry.maxScrollObstructionExtent], which the [SliverOverlapAbsorber] needs to keep the
/// [tabs] on screen.
class const _SliverPinnedTabsHeader({
  required final Widget header,
  required final Widget tabs,
  required final double topInset,
}) extends SlottedMultiChildRenderObjectWidget<_HeaderSlot, RenderBox> {
  @override
  Iterable<_HeaderSlot> get slots => _HeaderSlot.values;

  @override
  Widget childForSlot(_HeaderSlot slot) => switch (slot) {
    .header => header,
    .tabs => tabs,
  };

  @override
  _RenderSliverPinnedTabsHeader createRenderObject(BuildContext context) =>
      _RenderSliverPinnedTabsHeader(topInset);

  @override
  void updateRenderObject(BuildContext context, _RenderSliverPinnedTabsHeader renderObject) {
    renderObject.topInset = topInset;
  }
}

class _RenderSliverPinnedTabsHeader(var double _topInset)
    extends RenderSliver
    with SlottedContainerRenderObjectMixin<_HeaderSlot, RenderBox>, RenderSliverHelpers {
  double get topInset => _topInset;
  set topInset(double value) {
    if (_topInset == value) return;
    _topInset = value;
    markNeedsLayout();
  }

  RenderBox get _header => childForSlot(_HeaderSlot.header)!;
  RenderBox get _tabs => childForSlot(_HeaderSlot.tabs)!;

  // Main axis positions of the children, and opacity of the header, set during layout.
  double _headerPosition = 0.0;
  double _tabsPosition = 0.0;
  double _headerOpacity = 1.0;

  final _headerOpacityLayer = LayerHandle<OpacityLayer>();

  @override
  void performLayout() {
    assert(constraints.axisDirection == AxisDirection.down);
    final boxConstraints = constraints.asBoxConstraints();
    _header.layout(boxConstraints, parentUsesSize: true);
    _tabs.layout(boxConstraints, parentUsesSize: true);
    final headerExtent = _header.size.height;
    final tabsExtent = _tabs.size.height;
    final scrollExtent = _topInset + headerExtent + tabsExtent;
    final pinnedExtent = _topInset + tabsExtent;
    final scrollOffset = constraints.scrollOffset;

    _headerPosition = _topInset - scrollOffset;
    _tabsPosition = math.max(_topInset + headerExtent - scrollOffset, _topInset);
    // Fades out while the bottom of the header goes from twice the inset to the inset.
    _headerOpacity = _topInset == 0.0
        ? 1.0
        : clampDouble((headerExtent - scrollOffset) / _topInset, 0.0, 1.0);

    final paintExtent = math.min(
      math.max(scrollExtent - scrollOffset, pinnedExtent),
      constraints.remainingPaintExtent,
    );
    geometry = SliverGeometry(
      scrollExtent: scrollExtent,
      paintExtent: paintExtent,
      layoutExtent: clampDouble(scrollExtent - scrollOffset, 0.0, paintExtent),
      maxPaintExtent: scrollExtent,
      maxScrollObstructionExtent: pinnedExtent,
      cacheExtent: calculateCacheOffset(constraints, from: 0.0, to: scrollExtent),
      hasVisualOverflow: true,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!geometry!.visible) return;
    if (_headerOpacity == 0.0) {
      _headerOpacityLayer.layer = null;
    } else if (_headerOpacity == 1.0) {
      _headerOpacityLayer.layer = null;
      context.paintChild(_header, offset + Offset(0.0, _headerPosition));
    } else {
      _headerOpacityLayer.layer = context.pushOpacity(
        offset + Offset(0.0, _headerPosition),
        (_headerOpacity * 255).round(),
        (context, offset) => context.paintChild(_header, offset),
        oldLayer: _headerOpacityLayer.layer,
      );
    }
    context.paintChild(_tabs, offset + Offset(0.0, _tabsPosition));
  }

  @override
  bool hitTestChildren(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    final boxResult = BoxHitTestResult.wrap(result);
    return hitTestBoxChild(
          boxResult,
          _tabs,
          mainAxisPosition: mainAxisPosition,
          crossAxisPosition: crossAxisPosition,
        ) ||
        (_headerOpacity > 0.0 &&
            hitTestBoxChild(
              boxResult,
              _header,
              mainAxisPosition: mainAxisPosition,
              crossAxisPosition: crossAxisPosition,
            ));
  }

  @override
  double childMainAxisPosition(RenderBox child) => child == _tabs ? _tabsPosition : _headerPosition;

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    applyPaintTransformForBoxChild(child, transform);
  }

  @override
  void dispose() {
    _headerOpacityLayer.layer = null;
    super.dispose();
  }
}

/// A non-scrolling content for a tab of the round screen, such as a loading indicator or a message,
/// centered in the space below the header.
class const BroadcastRoundTabPlaceholder(final Widget child) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
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
