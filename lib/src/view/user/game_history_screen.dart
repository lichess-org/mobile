import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/game/game_history.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/game/game_list_tile.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_history_screen.g.dart';

@riverpod
Future<int> _userNumberOfGames(
  _UserNumberOfGamesRef ref,
  LightUser? user, {
  required bool isOnline,
}) async {
  final session = ref.watch(authSessionProvider);
  return user != null
      ? ref.watch(userProvider(id: user.id).selectAsync((u) => u.totalGames))
      : session != null && isOnline
          ? ref.watch(accountProvider.selectAsync((u) => u?.totalGames ?? 0))
          : ref.watch(gameStorageProvider).count(userId: user?.id);
}

class GameHistoryScreen extends ConsumerWidget {
  const GameHistoryScreen({
    required this.user,
    required this.isOnline,
    super.key,
  });
  final LightUser? user;
  final bool isOnline;

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
      _userNumberOfGamesProvider(user, isOnline: isOnline),
    );
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: nbGamesAsync.when(
          data: (nbGames) => Text(context.l10n.nbGames(nbGames)),
          loading: () => const CupertinoActivityIndicator(),
          error: (e, s) => const Text('All Games'),
        ),
      ),
      child: _Body(user: user, isOnline: isOnline),
    );
  }

  Widget _buildAndroid(BuildContext context, WidgetRef ref) {
    final nbGamesAsync = ref.watch(
      _userNumberOfGamesProvider(user, isOnline: isOnline),
    );
    return Scaffold(
      appBar: AppBar(
        title: nbGamesAsync.when(
          data: (nbGames) => Text(context.l10n.nbGames(nbGames)),
          loading: () => const ButtonLoadingIndicator(),
          error: (e, s) => const Text('All Games'),
        ),
      ),
      body: _Body(user: user, isOnline: isOnline),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body({required this.user, required this.isOnline});

  final LightUser? user;
  final bool isOnline;

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
              ).notifier,
            )
            .getNext();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final gameListState = ref.watch(
      userGameHistoryProvider(widget.user?.id, isOnline: widget.isOnline),
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
          'SEVERE: [FullGameHistoryScreen] could not load game list',
        );
        return const Center(child: Text('Could not load Game History'));
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
