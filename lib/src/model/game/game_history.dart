import 'dart:async';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/account/account_service.dart';
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
import 'package:lichess_mobile/src/utils/riverpod.dart';

part 'game_history.freezed.dart';

const kNumberOfRecentGames = 10;

const _nbPerPage = 20;

/// A provider that fetches the current app user's recent games.
///
/// If the user is logged in, the recent games are fetched from the server.
/// If the user is not logged in, or there is no connectivity, the recent games
/// stored locally are fetched instead.
final myRecentGamesProvider = FutureProvider.autoDispose<IList<LightExportedGameWithPov>>((
  Ref ref,
) async {
  final online = (await ref.watch(connectivityChangesProvider.future)).isOnline;
  final session = ref.watch(authSessionProvider);
  if (session != null && online) {
    return ref
        .read(gameRepositoryProvider)
        .getUserGames(session.user.id, max: kNumberOfRecentGames);
  } else {
    final storage = await ref.watch(gameStorageProvider.future);
    return storage
        .page(userId: session?.user.id, max: kNumberOfRecentGames)
        .then(
          (value) => value
              // we can assume that `youAre` is not null either for logged
              // in users or for anonymous users
              .map((e) => (game: e.game.data, pov: e.game.youAre ?? Side.white))
              .toIList(),
        );
  }
}, name: 'MyRecentGamesProvider');

/// A provider that fetches the recent games from the server for a given user.
final userRecentGamesProvider = FutureProvider.autoDispose
    .family<IList<LightExportedGameWithPov>, UserId>((Ref ref, UserId userId) {
      return ref
          .read(gameRepositoryProvider)
          .getUserGames(userId, withBookmarked: true, max: kNumberOfRecentGames);
    }, name: 'UserRecentGamesProvider');

/// A provider that fetches the total number of games played by given user, or the current app user if no user is provided.
///
/// If the user is logged in, the number of games is fetched from the server.
/// If the user is not logged in, or there is no connectivity, the number of games
/// stored locally are fetched instead.
final userNumberOfGamesProvider = FutureProvider.autoDispose.family<int, LightUser?>((
  Ref ref,
  LightUser? user,
) async {
  final session = ref.watch(authSessionProvider);
  final online = (await ref.watch(connectivityChangesProvider.future)).isOnline;
  return user != null
      ? (await ref.watch(userProvider(id: user.id).future)).count?.all ?? 0
      : session != null && online
      ? (await ref.watch(accountProvider.future))?.count?.all ?? 0
      : (await ref.watch(gameStorageProvider.future)).count(userId: user?.id);
}, name: 'UserNumberOfGamesProvider');

typedef UserGameHistoryNotifierParams = ({UserId? userId, GameFilterState filter});

/// A provider that paginates the game history for a given user, or the current app user if no user is provided.
///
/// The game history is fetched from the server if the user is logged in and app is online.
/// Otherwise, the game history is fetched from the local storage.
final userGameHistoryProvider = AsyncNotifierProvider.autoDispose
    .family<UserGameHistoryNotifier, UserGameHistoryState, UserGameHistoryNotifierParams>(
      UserGameHistoryNotifier.new,
      name: 'UserGameHistoryProvider',
    );

class UserGameHistoryNotifier extends AsyncNotifier<UserGameHistoryState> {
  UserGameHistoryNotifier(this.params);

  final UserGameHistoryNotifierParams params;

  final _list = <LightExportedGameWithPov>[];

  StreamSubscription<(GameId, bool)>? _bookmarkChangesSubscription;

  GameRepository get _gameRepository => ref.read(gameRepositoryProvider);

  @override
  Future<UserGameHistoryState> build() async {
    _bookmarkChangesSubscription?.cancel();
    _bookmarkChangesSubscription = ref.read(accountServiceProvider).bookmarkChanges.listen((data) {
      final (id, bookmarked) = data;
      if (state.hasValue) {
        setBookmark(id, bookmarked: bookmarked);
      }
    });

    ref.cacheFor(const Duration(minutes: 5));
    ref.onDispose(() {
      _bookmarkChangesSubscription?.cancel();
      _list.clear();
    });

    final session = ref.watch(authSessionProvider);
    final prefs = ref.watch(gameHistoryPreferencesProvider);
    final online = (await ref.watch(connectivityChangesProvider.future)).isOnline;
    final storage = await ref.watch(gameStorageProvider.future);

    final id = params.userId ?? session?.user.id;
    final recentGames = id != null && online
        ? _gameRepository.getUserGames(
            id,
            filter: params.filter,
            withBookmarked: true,
            withMoves: prefs.displayMode == GameHistoryDisplayMode.detail,
          )
        : storage
              .page(userId: id, filter: params.filter)
              .then(
                (value) => value
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
      online: online,
      filter: params.filter,
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
      final value = await (params.userId != null
          ? _gameRepository.getUserGames(
              params.userId!,
              max: _nbPerPage,
              until: _list.last.game.createdAt,
              filter: currentVal.filter,
              withBookmarked: true,
              withMoves: prefs.displayMode == GameHistoryDisplayMode.detail,
            )
          : currentVal.online && currentVal.session != null
          ? _gameRepository.getUserGames(
              currentVal.session!.user.id,
              max: _nbPerPage,
              until: _list.last.game.createdAt,
              filter: currentVal.filter,
              withBookmarked: true,
              withMoves: prefs.displayMode == GameHistoryDisplayMode.detail,
            )
          : (await ref.watch(gameStorageProvider.future))
                .page(max: _nbPerPage, until: _list.last.game.createdAt)
                .then(
                  (value) => value
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

  void setBookmark(GameId id, {required bool bookmarked}) {
    if (!state.hasValue) return;

    final gameList = state.requireValue.gameList;
    final entry = gameList.firstWhereOrNull((e) => e.game.id == id);
    if (entry == null) return;

    final (game: game, pov: pov) = entry;
    final index = gameList.indexOf(entry);

    state = AsyncData(
      state.requireValue.copyWith(
        gameList: gameList.replace(index, (game: game.copyWith(bookmarked: bookmarked), pov: pov)),
      ),
    );
  }
}

@freezed
sealed class UserGameHistoryState with _$UserGameHistoryState {
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
