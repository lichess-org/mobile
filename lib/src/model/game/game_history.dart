import 'dart:async';

import 'package:async/async.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/utils/connectivity.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_history.freezed.dart';
part 'game_history.g.dart';

const _nbPerPage = 20;

@riverpod
Future<IList<LightArchivedGameWithPov>> myRecentGames(MyRecentGamesRef ref) {
  final connectivity = ref.watch(connectivityProvider);
  final session = ref.watch(authSessionProvider);
  final online = connectivity.valueOrNull?.isOnline ?? false;
  if (session != null && online) {
    return ref.withClientCacheFor(
      (client) => GameRepository(client).getUserGames(session.user.id),
      const Duration(hours: 1),
    );
  } else {
    final storage = ref.watch(gameStorageProvider);
    ref.cacheFor(const Duration(hours: 1));
    return storage.page(userId: session?.user.id).then(
          (value) => value
              // we can assume that `youAre` is not null either for logged
              // in users or for anonymous users
              .map((e) => (game: e.game.data, pov: e.game.youAre ?? Side.white))
              .toIList(),
        );
  }
}

@riverpod
class UserGameHistory extends _$UserGameHistory {
  final _list = <LightArchivedGameWithPov>[];

  @override
  Future<UserGameHistoryState> build(UserId? userId) async {
    ref.cacheFor(const Duration(minutes: 30));
    ref.onDispose(() {
      _list.clear();
    });

    final connectivity = ref.watch(connectivityProvider);
    final online = connectivity.valueOrNull?.isOnline ?? false;
    final session = ref.watch(authSessionProvider);

    final recentGames = userId != null
        ? ref.read(userRecentGamesProvider(userId: userId).future)
        : ref.read(myRecentGamesProvider.future);

    _list.addAll(await recentGames);

    return UserGameHistoryState(
      gameList: _list.toIList(),
      isLoading: false,
      hasMore: true,
      hasError: false,
      online: online,
      session: session,
    );
  }

  void getNext() {
    if (!state.hasValue) return;

    final currentVal = state.requireValue;
    state = AsyncData(currentVal.copyWith(isLoading: true));
    Result.capture(
      userId != null
          ? ref.withClient(
              (client) => GameRepository(client).getUserGames(
                userId!,
                max: _nbPerPage,
                until: _list.last.game.createdAt,
              ),
            )
          : currentVal.online && currentVal.session != null
              ? ref.withClient(
                  (client) => GameRepository(client).getUserGames(
                    currentVal.session!.user.id,
                    max: _nbPerPage,
                    until: _list.last.game.createdAt,
                  ),
                )
              : ref
                  .watch(gameStorageProvider)
                  .page(max: _nbPerPage, until: _list.last.game.createdAt)
                  .then(
                    (value) => value
                        // we can assume that `youAre` is not null either for logged
                        // in users or for anonymous users
                        .map((e) => (
                              game: e.game.data,
                              pov: e.game.youAre ?? Side.white
                            ))
                        .toIList(),
                  ),
    ).fold(
      (value) {
        if (value.isEmpty) {
          state = AsyncData(
            currentVal.copyWith(hasMore: false, isLoading: false),
          );
          return;
        }

        _list.addAll(value);

        state = AsyncData(
          currentVal.copyWith(
            gameList: _list.toIList(),
            isLoading: false,
            hasMore: value.length == _nbPerPage,
          ),
        );
      },
      (error, stackTrace) {
        state =
            AsyncData(currentVal.copyWith(isLoading: false, hasError: true));
      },
    );
  }
}

@freezed
class UserGameHistoryState with _$UserGameHistoryState {
  const factory UserGameHistoryState({
    required IList<LightArchivedGameWithPov> gameList,
    required bool isLoading,
    required bool hasMore,
    required bool hasError,
    required bool online,
    AuthSessionState? session,
  }) = _UserGameHistoryState;
}
