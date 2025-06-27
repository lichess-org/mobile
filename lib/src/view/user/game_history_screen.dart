import 'package:dartchess/dartchess.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lichess_mobile/src/model/account/account_service.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/user/game_history_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/analysis_screen.dart';
import 'package:lichess_mobile/src/view/game/game_list_detail_tile.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_context_menu_button.dart';

// TODO l10n
String displayModeL10n(BuildContext context, GameHistoryDisplayMode mode) {
  switch (mode) {
    case GameHistoryDisplayMode.compact:
      return 'Compact';
    case GameHistoryDisplayMode.detail:
      return 'Detailed';
  }
}

class GameHistoryScreen extends ConsumerWidget {
  const GameHistoryScreen({
    required this.user,
    required this.isOnline,
    this.gameFilter = const GameFilterState(),
    super.key,
  });
  final LightUser? user;
  final bool isOnline;
  final GameFilterState gameFilter;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    LightUser? user,
    bool isOnline = false,
    GameFilterState gameFilter = const GameFilterState(),
  }) {
    return buildScreenRoute(
      context,
      screen: GameHistoryScreen(user: user, isOnline: isOnline, gameFilter: gameFilter),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filtersInUse = ref.watch(gameFilterProvider(filter: gameFilter));
    final nbGamesAsync = ref.watch(userNumberOfGamesProvider(user));
    final title = filtersInUse.count == 0
        ? nbGamesAsync.when(
            data: (nbGames) => Text(context.l10n.nbGames(nbGames)),
            loading: () => const ButtonLoadingIndicator(),
            error: (e, s) => Text(context.l10n.mobileAllGames),
          )
        : Text(filtersInUse.selectionLabel(context.l10n));
    final filterBtn = SemanticIconButton(
      icon: Badge.count(
        backgroundColor: ColorScheme.of(context).secondary,
        textStyle: TextStyle(
          color: ColorScheme.of(context).onSecondary,
          fontWeight: FontWeight.bold,
        ),
        count: filtersInUse.count,
        isLabelVisible: filtersInUse.count > 0,
        child: const Icon(Icons.filter_list),
      ),
      semanticsLabel: context.l10n.filterGames,
      onPressed: () =>
          showModalBottomSheet<GameFilterState>(
            context: context,
            useRootNavigator: true,
            isScrollControlled: true,
            builder: (_) => _FilterGames(
              filter: ref.read(gameFilterProvider(filter: gameFilter)),
              user: user,
            ),
          ).then((value) {
            if (value != null) {
              ref.read(gameFilterProvider(filter: gameFilter).notifier).setFilter(value);
            }
          }),
    );

    final displayModeButton = ContextMenuIconButton(
      consumeOutsideTap: true,
      icon: const Icon(Icons.more_horiz),
      semanticsLabel: context.l10n.menu,
      actions: [
        ContextMenuAction(
          icon: Icons.ballot_outlined,
          label: 'Detailed view',
          onPressed: () {
            ref
                .read(gameHistoryPreferencesProvider.notifier)
                .setDisplayMode(GameHistoryDisplayMode.detail);
          },
        ),
        ContextMenuAction(
          icon: Icons.list_outlined,
          label: 'Compact view',
          onPressed: () {
            ref
                .read(gameHistoryPreferencesProvider.notifier)
                .setDisplayMode(GameHistoryDisplayMode.compact);
          },
        ),
      ],
    );

    return PlatformScaffold(
      appBar: PlatformAppBar(title: title, actions: [filterBtn, displayModeButton]),
      body: _Body(user: user, isOnline: isOnline, gameFilter: gameFilter),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.user, required this.isOnline, required this.gameFilter});

  final LightUser? user;
  final bool isOnline;
  final GameFilterState gameFilter;

  @override
  ConsumerState<_Body> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final state = ref.read(
        userGameHistoryProvider(
          widget.user?.id,
          isOnline: widget.isOnline,
          filter: ref.read(gameFilterProvider(filter: widget.gameFilter)),
        ),
      );

      if (!state.hasValue) {
        return;
      }

      final hasMore = state.requireValue.hasMore;
      final isLoading = state.requireValue.isLoading;

      if (hasMore && !isLoading) {
        ref
            .read(
              userGameHistoryProvider(
                widget.user?.id,
                isOnline: widget.isOnline,
                filter: ref.read(gameFilterProvider(filter: widget.gameFilter)),
              ).notifier,
            )
            .getNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameFilterState = ref.watch(gameFilterProvider(filter: widget.gameFilter));
    final gameListProvider = userGameHistoryProvider(
      widget.user?.id,
      isOnline: widget.isOnline,
      filter: gameFilterState,
    );
    final gameListState = ref.watch(gameListProvider);
    final isLoggedIn = ref.watch(isLoggedInProvider);

    return gameListState.when(
      data: (state) {
        final list = state.gameList;

        final displayMode = ref.watch(
          gameHistoryPreferencesProvider.select((value) => value.displayMode),
        );

        return list.isEmpty
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Center(child: Text('No games found')),
              )
            : ListView.separated(
                controller: _scrollController,
                separatorBuilder: (context, index) =>
                    Theme.of(context).platform == TargetPlatform.iOS
                    ? PlatformDivider(
                        height: 1,
                        cupertinoHasLeading: true,
                        indent: displayMode == GameHistoryDisplayMode.detail ? 0 : null,
                      )
                    : const SizedBox.shrink(),
                itemCount: list.length + (state.isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (state.isLoading && index == list.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: CenterLoadingIndicator(),
                    );
                  } else if (state.hasError && state.hasMore && index == list.length) {
                    // TODO: add a retry button
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32.0),
                      child: Center(child: Text('Could not load more games')),
                    );
                  }

                  final game = list[index].game;
                  final pov = list[index].pov;

                  Future<void> onPressedBookmark(BuildContext context) async {
                    try {
                      await ref
                          .read(accountServiceProvider)
                          .setGameBookmark(game.id, bookmark: !game.bookmarked!);
                    } on Exception catch (_) {
                      if (context.mounted) {
                        showSnackBar(context, 'Bookmark action failed', type: SnackBarType.error);
                      }
                    }
                  }

                  final item = list[index];
                  final gameTile = switch (displayMode) {
                    GameHistoryDisplayMode.compact => GameListTile(
                      item: item,
                      onPressedBookmark: onPressedBookmark,
                    ),
                    GameHistoryDisplayMode.detail => GameListDetailTile(
                      item: item,
                      onPressedBookmark: onPressedBookmark,
                    ),
                  };

                  return Slidable(
                    startActionPane: ActionPane(
                      motion: const StretchMotion(),
                      children: [
                        SlidableAction(
                          backgroundColor: ColorScheme.of(context).tertiaryContainer,
                          foregroundColor: ColorScheme.of(context).onTertiaryContainer,
                          onPressed: game.variant.isReadSupported
                              ? (_) {
                                  Navigator.of(context, rootNavigator: true).push(
                                    AnalysisScreen.buildRoute(
                                      context,
                                      AnalysisOptions.archivedGame(
                                        orientation: pov,
                                        gameId: game.id,
                                      ),
                                    ),
                                  );
                                }
                              : (_) {
                                  showSnackBar(
                                    context,
                                    'This variant is not supported yet.',
                                    type: SnackBarType.info,
                                  );
                                },
                          icon: Icons.biotech,
                          label: context.l10n.analysis,
                        ),
                      ],
                    ),
                    endActionPane: isLoggedIn
                        ? ActionPane(
                            motion: const StretchMotion(),
                            children: [
                              SlidableAction(
                                backgroundColor: context.lichessColors.brag,
                                onPressed: onPressedBookmark,
                                icon: game.isBookmarked
                                    ? Icons.bookmark_remove_outlined
                                    : Icons.bookmark_add_outlined,
                                // TODO l10n
                                label: game.isBookmarked
                                    ? context.l10n.mobileRemoveBookmark
                                    : context.l10n.bookmarkThisGame,
                              ),
                            ],
                          )
                        : null,
                    child: gameTile,
                  );
                },
              );
      },
      error: (e, s) {
        debugPrint('SEVERE: [GameHistoryScreen] could not load game list');
        return const Center(child: Text('Could not load Game History'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}

class _FilterGames extends ConsumerStatefulWidget {
  const _FilterGames({required this.filter, required this.user});

  final GameFilterState filter;
  final LightUser? user;

  @override
  ConsumerState<_FilterGames> createState() => _FilterGamesState();
}

class _FilterGamesState extends ConsumerState<_FilterGames> {
  late GameFilterState filter;

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
  }

  static const gamePerfs = [
    Perf.ultraBullet,
    Perf.bullet,
    Perf.blitz,
    Perf.rapid,
    Perf.classical,
    Perf.correspondence,
    Perf.chess960,
    Perf.antichess,
    Perf.kingOfTheHill,
    Perf.threeCheck,
    Perf.atomic,
    Perf.horde,
    Perf.racingKings,
    Perf.crazyhouse,
  ];
  static const filterGroupSpace = SizedBox(height: 10.0);

  @override
  Widget build(BuildContext context) {
    final session = ref.read(authSessionProvider);
    final userId = widget.user?.id ?? session?.user.id;

    final Widget filters = userId != null
        ? ref
              .watch(userProvider(id: userId))
              .when(
                data: (user) => perfFilter(availablePerfs(user)),
                loading: () => const Center(child: CircularProgressIndicator.adaptive()),
                error: (_, _) => perfFilter(gamePerfs),
              )
        : perfFilter(gamePerfs);

    return BottomSheetScrollableContainer(
      padding: const EdgeInsets.all(16.0),
      children: [
        filters,
        const SizedBox(height: 12.0),
        const PlatformDivider(thickness: 1, indent: 0),
        filterGroupSpace,
        Filter<Side>(
          filterName: context.l10n.side,
          filterType: FilterType.singleChoice,
          choices: Side.values,
          choiceSelected: (choice) => filter.side == choice,
          choiceLabel: (t) => switch (t) {
            Side.white => Text(context.l10n.white),
            Side.black => Text(context.l10n.black),
          },
          onSelected: (value, selected) => setState(() {
            filter = filter.copyWith(side: selected ? value : null);
          }),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => setState(() => filter = const GameFilterState()),
              child: Text(context.l10n.reset),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(filter),
              child: Text(context.l10n.apply),
            ),
          ],
        ),
      ],
    );
  }

  List<Perf> availablePerfs(User user) {
    final perfs = gamePerfs
        .where((perf) {
          final p = user.perfs[perf];
          return p != null && p.numberOfGamesOrRuns > 0;
        })
        .toList(growable: false);
    perfs.sort(
      (p1, p2) =>
          user.perfs[p2]!.numberOfGamesOrRuns.compareTo(user.perfs[p1]!.numberOfGamesOrRuns),
    );
    return perfs;
  }

  Widget perfFilter(List<Perf> choices) => Filter<Perf>(
    filterName: context.l10n.variant,
    filterType: FilterType.multipleChoice,
    choices: choices,
    choiceSelected: (choice) => filter.perfs.contains(choice),
    choiceLabel: (t) => Text(t.shortTitle),
    onSelected: (value, selected) => setState(() {
      filter = filter.copyWith(
        perfs: selected ? filter.perfs.add(value) : filter.perfs.remove(value),
      );
    }),
  );
}
