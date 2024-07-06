import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class GameHistoryScreen extends ConsumerWidget {
  const GameHistoryScreen({
    required this.user,
    required this.isOnline,
    this.perf,
    this.games,
    super.key,
  });
  final LightUser? user;
  final bool isOnline;
  final Perf? perf;
  final int? games;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ConsumerPlatformWidget(
      ref: ref,
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }

  Widget _buildIos(BuildContext context, WidgetRef ref) {
    final nbGamesAsync = ref.watch(
      userNumberOfGamesProvider(user, isOnline: isOnline),
    );
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: nbGamesAsync.when(
          data: (nbGames) => Text(context.l10n.nbGames(games ?? nbGames)),
          loading: () => const CupertinoActivityIndicator(),
          error: (e, s) => const Text('All Games'),
        ),
      ),
      child: _Body(user: user, isOnline: isOnline, perf: perf),
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final nbGamesAsync = ref.watch(
      userNumberOfGamesProvider(user, isOnline: isOnline),
    );
    return Scaffold(
      appBar: AppBar(
        title: nbGamesAsync.when(
          data: (nbGames) => Text(context.l10n.nbGames(games ?? nbGames)),
          loading: () => const ButtonLoadingIndicator(),
          error: (e, s) => const Text('All Games'),
        ),
      ),
      body: _Body(user: user, isOnline: isOnline, perf: perf),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({
    required this.user,
    required this.isOnline,
    required this.perf,
  });

  final LightUser? user;
  final bool isOnline;
  final Perf? perf;

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
          perf: widget.perf,
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
                perf: widget.perf,
              ).notifier,
            )
            .getNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameListState = ref.watch(
      userGameHistoryProvider(
        widget.user?.id,
        isOnline: widget.isOnline,
        perf: widget.perf,
      ),
    );

    return gameListState.when(
      data: (state) {
        final list = state.gameList;

        return SafeArea(
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
