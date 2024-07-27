import 'package:chessground/chessground.dart';
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
    this.gameFilter = const GameFilterState(),
    super.key,
  });
  final LightUser? user;
  final bool isOnline;
  final GameFilterState gameFilter;

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
            isScrollControlled: true,
            showDragHandle: true,
            builder: (_) => _FilterGames(
              filter: ref.read(gameFilterProvider(filter: gameFilter)),
            ),
          ).then((value) {
            if (value != null) {
              ref
                  .read(gameFilterProvider(filter: gameFilter).notifier)
                  .setFilter(value);
            }
          }),
        ),
      ),
      child: _Body(user: user, isOnline: isOnline, gameFilter: gameFilter),
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
              isScrollControlled: true,
              showDragHandle: true,
              builder: (_) => _FilterGames(
                filter: ref.read(gameFilterProvider(filter: gameFilter)),
              ),
            ).then((value) {
              if (value != null) {
                ref
                    .read(gameFilterProvider(filter: gameFilter).notifier)
                    .setFilter(value);
              }
            }),
          ),
        ],
      ),
      body: _Body(user: user, isOnline: isOnline, gameFilter: gameFilter),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.user,
    required this.isOnline,
    required this.gameFilter,
  });

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
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
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
    final gameFilterState =
        ref.watch(gameFilterProvider(filter: widget.gameFilter));
    final gameListState = ref.watch(
      userGameHistoryProvider(
        widget.user?.id,
        isOnline: widget.isOnline,
        filter: gameFilterState,
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
              : ListView.builder(
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
      child: DraggableScrollableSheet(
        initialChildSize: .7,
        expand: false,
        snap: true,
        snapSizes: const [.7],
        builder: (context, scrollController) => ListView(
          controller: scrollController,
          children: [
            _Filter<Perf>(
              filterName: context.l10n.variant,
              filterType: FilterType.multipleChoice,
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
              choiceSelected: (choice) => filter.perfs.contains(choice),
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
            const Divider(),
            const SizedBox(height: 10.0),
            _Filter<Side>(
              filterName: context.l10n.side,
              filterType: FilterType.singleChoice,
              choices: Side.values,
              choiceSelected: (choice) => filter.side == choice,
              choiceLabel: (t) => switch (t) {
                Side.white => context.l10n.white,
                Side.black => context.l10n.black,
              },
              onSelected: (value, selected) => setState(
                () {
                  filter = filter.copyWith(side: selected ? value : null);
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
      ),
    );
  }
}

enum FilterType {
  singleChoice,
  multipleChoice,
}

class _Filter<T extends Enum> extends StatelessWidget {
  const _Filter({
    required this.filterName,
    required this.filterType,
    required this.choices,
    required this.choiceSelected,
    required this.choiceLabel,
    required this.onSelected,
  });

  final String filterName;
  final FilterType filterType;
  final Iterable<T> choices;
  final bool Function(T choice) choiceSelected;
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
                  (choice) => switch (filterType) {
                    FilterType.singleChoice => ChoiceChip(
                        label: Text(choiceLabel(choice)),
                        selected: choiceSelected(choice),
                        onSelected: (value) => onSelected(choice, value),
                      ),
                    FilterType.multipleChoice => FilterChip(
                        label: Text(choiceLabel(choice)),
                        selected: choiceSelected(choice),
                        onSelected: (value) => onSelected(choice, value),
                      ),
                  },
                )
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}
