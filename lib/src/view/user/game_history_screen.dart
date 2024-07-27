import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class GameHistoryScreen extends ConsumerWidget {
  const GameHistoryScreen({
    required this.user,
    required this.isOnline,
    this.gameFilters = const GameFilterState(),
    super.key,
  });
  final LightUser? user;
  final bool isOnline;
  final GameFilterState gameFilters;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.games),
        trailing: IconButton(
          icon: const Icon(Icons.tune),
          tooltip: context.l10n.filterGames,
          onPressed: () => showAdaptiveBottomSheet<GameFilterState>(
            context: context,
            builder: (_) => _FilterGames(
              filter: ref.read(
                gameFilterProvider(perfs: gameFilters.perfs),
              ),
            ),
          ).then((value) {
            if (value != null) {
              ref
                  .read(
                    gameFilterProvider(perfs: gameFilters.perfs).notifier,
                  )
                  .setFilter(value);
            }
          }),
        ),
      ),
      child: _Body(user: user, isOnline: isOnline, gameFilters: gameFilters),
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.games),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: context.l10n.filterGames,
            onPressed: () => showAdaptiveBottomSheet<GameFilterState>(
              context: context,
              builder: (_) => _FilterGames(
                filter: ref.read(
                  gameFilterProvider(perfs: gameFilters.perfs),
                ),
              ),
            ).then((value) {
              if (value != null) {
                ref
                    .read(
                      gameFilterProvider(perfs: gameFilters.perfs).notifier,
                    )
                    .setFilter(value);
              }
            }),
          ),
        ],
      ),
      body: _Body(user: user, isOnline: isOnline, gameFilters: gameFilters),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.user,
    required this.isOnline,
    required this.gameFilters,
  });

  final LightUser? user;
  final bool isOnline;
  final GameFilterState gameFilters;

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final state = ref.read(
        userGameHistoryProvider(
          widget.user?.id,
          isOnline: widget.isOnline,
          filters:
              ref.read(gameFilterProvider(perfs: widget.gameFilters.perfs)),
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
                filters: ref
                    .read(gameFilterProvider(perfs: widget.gameFilters.perfs)),
              ).notifier,
            )
            .getNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameFilterState =
        ref.watch(gameFilterProvider(perfs: widget.gameFilters.perfs));
    final gameListState = ref.watch(
      userGameHistoryProvider(
        widget.user?.id,
        isOnline: widget.isOnline,
        filters: gameFilterState,
      ),
    );

    return gameListState.when(
      data: (state) {
        final list = state.gameList;

        return SafeArea(
          child: list.isEmpty
              ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32.0),
                  child: Center(
                    child: Text(
                      'No games found',
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: list.length + (state.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (state.isLoading && index == list.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: CenterLoadingIndicator(),
                        );
                      } else if (state.hasError &&
                          state.hasMore &&
                          index == list.length) {
                        // TODO: add a retry button
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(
                            child: Text(
                              'Could not load more games',
                            ),
                          ),
                        );
                      }

                      return ExtendedGameListTile(
                        item: list[index],
                        userId: widget.user?.id,
                      );
                    },
                  ),
                ),
        );
      },
      error: (e, s) {
        debugPrint(
          'SEVERE: [GameHistoryScreen] could not load game list',
        );
        return const Center(child: Text('Could not load Game History'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}

class _FilterGames extends StatefulWidget {
  const _FilterGames({
    required this.filter,
  });

  final GameFilterState filter;

  @override
  State<_FilterGames> createState() => _FilterGamesState();
}

class _FilterGamesState extends State<_FilterGames> {
  late GameFilterState filter;

  @override
  void initState() {
    super.initState();
    filter = widget.filter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _MultipleChoiceFilter<Perf>(
            filterName: context.l10n.variant,
            choices: const [
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
            ],
            selectedItems: filter.perfs,
            choiceLabel: (t) => t.title,
            onSelected: (value, selected) => setState(
              () {
                filter = filter.copyWith(
                  perfs: selected
                      ? filter.perfs.add(value)
                      : filter.perfs.remove(value),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(filter),
                child: const Text('OK'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MultipleChoiceFilter<T extends Enum> extends StatelessWidget {
  const _MultipleChoiceFilter({
    required this.filterName,
    required this.choices,
    required this.selectedItems,
    required this.choiceLabel,
    required this.onSelected,
  });

  final String filterName;
  final Iterable<T> choices;
  final ISet<T> selectedItems;
  final String Function(T choice) choiceLabel;
  final void Function(T value, bool selected) onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(filterName, style: const TextStyle(fontSize: 18)),
        SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: choices
                .map(
                  (choice) => FilterChip(
                    label: Text(choiceLabel(choice)),
                    selected: selectedItems.contains(choice),
                    onSelected: (value) => onSelected(choice, value),
                  ),
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
