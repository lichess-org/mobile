import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_filter.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/model/user/game_history_preferences.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/model/user/user_repository_providers.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_history.freezed.dart';
part 'game_history.g.dart';

const kNumberOfRecentGames = 20;

const _nbPerPage = 20;

/// A provider that fetches the current app user's recent games.
///
/// If the user is logged in, the recent games are fetched from the server.
/// If the user is not logged in, or there is no connectivity, the recent games
/// stored locally are fetched instead.
@riverpod
Future<IList<LightExportedGameWithPov>> myRecentGames(Ref ref) async {
  final online = await ref.watch(connectivityChangesProvider.selectAsync((c) => c.isOnline));
  final session = ref.watch(authSessionProvider);
  if (session != null && online) {
    return ref.withClient(
      (client) => GameRepository(client).getUserGames(session.user.id, max: kNumberOfRecentGames),
    );
  } else {
    final storage = await ref.watch(gameStorageProvider.future);
    return storage
        .page(userId: session?.user.id, max: kNumberOfRecentGames)
        .then(
          (value) =>
              value
                  // we can assume that `youAre` is not null either for logged
                  // in users or for anonymous users
                  .map((e) => (game: e.game.data, pov: e.game.youAre ?? Side.white))
                  .toIList(),
        );
  }
}

/// A provider that fetches the recent games from the server for a given user.
@riverpod
Future<IList<LightExportedGameWithPov>> userRecentGames(Ref ref, {required UserId userId}) {
  return ref.withClient(
    (client) => GameRepository(client).getUserGames(userId, withBookmarked: true),
  );
}

/// A provider that fetches the total number of games played by given user, or the current app user if no user is provided.
///
/// If the user is logged in, the number of games is fetched from the server.
/// If the user is not logged in, or there is no connectivity, the number of games
/// stored locally are fetched instead.
@riverpod
Future<int> userNumberOfGames(Ref ref, LightUser? user) async {
  final session = ref.watch(authSessionProvider);
  final online = await ref.watch(connectivityChangesProvider.selectAsync((c) => c.isOnline));
  return user != null
      ? ref.watch(userProvider(id: user.id).selectAsync((u) => u.count?.all ?? 0))
      : session != null && online
      ? ref.watch(accountProvider.selectAsync((u) => u?.count?.all ?? 0))
      : (await ref.watch(gameStorageProvider.future)).count(userId: user?.id);
}

/// A provider that paginates the game history for a given user, or the current app user if no user is provided.
///
/// The game history is fetched from the server if the user is logged in and app is online.
/// Otherwise, the game history is fetched from the local storage.
@riverpod
class UserGameHistory extends _$UserGameHistory {
  final _list = <LightExportedGameWithPov>[];

  @override
  Future<UserGameHistoryState> build(
    UserId? userId, {

    /// Whether the history is requested in an online context. Applicable only
    /// when [userId] is null.
    ///
    /// If this is true, the provider will attempt to fetch the games from the
    /// server. If this is false, the provider will fetch the games from the
    /// local storage.
    required bool isOnline,
    GameFilterState filter = const GameFilterState(),
  }) async {
    ref.cacheFor(const Duration(minutes: 5));
    ref.onDispose(() {
      _list.clear();
    });

    final session = ref.watch(authSessionProvider);
    final prefs = ref.watch(gameHistoryPreferencesProvider);
    final online = await ref.watch(connectivityChangesProvider.selectAsync((c) => c.isOnline));
    final storage = await ref.watch(gameStorageProvider.future);

    final id = userId ?? session?.user.id;
    final recentGames =
        id != null && online
            ? ref.withClient(
              (client) => GameRepository(client).getUserGames(
                id,
                filter: filter,
                withBookmarked: true,
                withMoves: prefs.displayMode == GameHistoryDisplayMode.detail,
              ),
            )
            : storage
                .page(userId: id, filter: filter)
                .then(
                  (value) =>
                      value
                          // we can assume that `youAre` is not null either for logged
                          // in users or for anonymous users
                          .map((e) => (game: e.game.data, pov: e.game.youAre ?? Side.white))
                          .toIList(),
                );

    _list.addAll(await recentGames);

    return UserGameHistoryState(
      gameList: _list.toIList(),
      isLoading: false,
      hasMore: true,
      hasError: false,
      online: isOnline,
      filter: filter,
      session: session,
    );
  }

  /// Fetches the next page of games.
  Future<void> getNext() async {
    if (!state.hasValue) return;

    final prefs = ref.read(gameHistoryPreferencesProvider);
    final currentVal = state.requireValue;
    state = AsyncData(currentVal.copyWith(isLoading: true));
    try {
      final value =
          await (userId != null
              ? ref.withClient(
                (client) => GameRepository(client).getUserGames(
                  userId!,
                  max: _nbPerPage,
                  until: _list.last.game.createdAt,
                  filter: currentVal.filter,
                  withBookmarked: true,
                  withMoves: prefs.displayMode == GameHistoryDisplayMode.detail,
                ),
              )
              : currentVal.online && currentVal.session != null
              ? ref.withClient(
                (client) => GameRepository(client).getUserGames(
                  currentVal.session!.user.id,
                  max: _nbPerPage,
                  until: _list.last.game.createdAt,
                  filter: currentVal.filter,
                  withBookmarked: true,
                  withMoves: prefs.displayMode == GameHistoryDisplayMode.detail,
                ),
              )
              : (await ref.watch(gameStorageProvider.future))
                  .page(max: _nbPerPage, until: _list.last.game.createdAt)
                  .then(
                    (value) =>
                        value
                            // we can assume that `youAre` is not null either for logged
                            // in users or for anonymous users
                            .map((e) => (game: e.game.data, pov: e.game.youAre ?? Side.white))
                            .toIList(),
                  ));

      if (value.isEmpty) {
        state = AsyncData(currentVal.copyWith(hasMore: false, isLoading: false));
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
    } catch (error, _) {
      state = AsyncData(currentVal.copyWith(isLoading: false, hasError: true));
    }
  }

  void toggleBookmark(GameId id) {
    if (!state.hasValue) return;

    final gameList = state.requireValue.gameList;
    final entry = gameList.firstWhereOrNull((e) => e.game.id == id);
    if (entry == null) return;

    final (game: game, pov: pov) = entry;
    final index = gameList.indexOf(entry);

    state = AsyncData(
      state.requireValue.copyWith(
        gameList: gameList.replace(index, (
          game: game.copyWith(bookmarked: !game.isBookmarked),
          pov: pov,
        )),
      ),
    );
  }
}

@freezed
class UserGameHistoryState with _$UserGameHistoryState {
  const factory UserGameHistoryState({
    required IList<LightExportedGameWithPov> gameList,
    required bool isLoading,
    required GameFilterState filter,
    required bool hasMore,
    required bool hasError,
    required bool online,
    AuthSessionState? session,
  }) = _UserGameHistoryState;
}
