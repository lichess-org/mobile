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
import 'package:lichess_mobile/src/widgets/feedback.dart';

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
    final gameFilterState =
        ref.watch(gameFilterProvider(perfs: gameFilters.perfs));

    final perfFilter = _MultipleChoiceFilter(
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
              selectedItems: gameFilterState.perfs,
              choiceLabel: (t) => t.title,
              onChanged: (value) => ref
                  .read(
                    gameFilterProvider(
                      perfs: gameFilters.perfs,
                    ).notifier,
                  )
                  .setPerfs(value),
            );

    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return _buildAndroid(context, ref, perfFilter: perfFilter);
      case TargetPlatform.iOS:
        return _buildIos(context, ref, perfFilter: perfFilter);
      default:
        assert(false, 'Unexpected platform ${Theme.of(context).platform}');
        return const SizedBox.shrink();
    }
  }

  Widget _buildIos(BuildContext context, WidgetRef ref, {
    required Widget perfFilter,
  }) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: [
            perfFilter,
          ],
        ),
      ),
      child: _Body(user: user, isOnline: isOnline, gameFilters: gameFilters),
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref, {
    required Widget perfFilter,
  }) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            perfFilter,
          ],
        ),
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

class _MultipleChoiceFilter<T extends Enum> extends StatelessWidget {
  const _MultipleChoiceFilter({
    required this.filterName,
    required this.choices,
    required this.selectedItems,
    required this.choiceLabel,
    required this.onChanged,
  });

  final String filterName;
  final Iterable<T> choices;
  final ISet<T> selectedItems;
  final String Function(T choice) choiceLabel;
  final void Function(ISet<T> value) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showMultipleChoiceFilter(
        context,
        filterName: filterName,
        choices: choices,
        selectedItems: selectedItems,
        choiceLabel: choiceLabel,
      ).then((value) {
        if (value != null) {
          onChanged(value);
        }
      }),
      style: TextButton.styleFrom(
        backgroundColor: selectedItems.isEmpty
            ? Theme.of(context).colorScheme.secondary
            : Theme.of(context).colorScheme.primary,
        foregroundColor: selectedItems.isEmpty
            ? Theme.of(context).colorScheme.onSecondary
            : Theme.of(context).colorScheme.onPrimary,
      ),
      child: Row(
        children: [
          if (selectedItems.length > 1)
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onPrimary,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${selectedItems.length}',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          Text(
            selectedItems.length == 1
                ? choiceLabel(selectedItems.first)
                : filterName,
          ),
        ],
      ),
    );
  }
}

Future<ISet<T>?> showMultipleChoiceFilter<T extends Enum>(
  BuildContext context, {
  required String filterName,
  required Iterable<T> choices,
  required ISet<T> selectedItems,
  required String Function(T choice) choiceLabel,
}) {
  return showAdaptiveDialog<ISet<T>>(
    context: context,
    builder: (context) {
      ISet<T> items = selectedItems;
      return AlertDialog.adaptive(
        contentPadding: const EdgeInsets.all(16.0),
        scrollable: true,
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: choices
                  .map(
                    (choice) => FilterChip(
                      label: Text(choiceLabel(choice)),
                      selected: items.contains(choice),
                      onSelected: (value) {
                        setState(() {
                          items =
                              value ? items.add(choice) : items.remove(choice);
                        });
                      },
                    ),
                  )
                  .toList(growable: false),
            );
          },
        ),
        actions: Theme.of(context).platform == TargetPlatform.iOS
            ? [
                CupertinoDialogAction(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(context.l10n.cancel),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: Text(context.l10n.mobileOkButton),
                  onPressed: () => Navigator.of(context).pop(items),
                ),
              ]
            : [
                TextButton(
                  child: Text(context.l10n.cancel),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                TextButton(
                  child: Text(context.l10n.mobileOkButton),
                  onPressed: () => Navigator.of(context).pop(items),
                ),
              ],
      );
    },
  );
}
