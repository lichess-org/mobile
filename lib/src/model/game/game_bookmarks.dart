import 'dart:async';

import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_bookmarks.freezed.dart';
part 'game_bookmarks.g.dart';

const _nbPerPage = 20;

/// A provider that paginates the game bookmarks for the current app user.
@riverpod
class GameBookmarksPaginator extends _$GameBookmarksPaginator {
  final _list = <LightExportedGameWithPov>[];

  @override
  Future<GameBookmarksPaginatorState> build() async {
    ref.onDispose(() {
      _list.clear();
    });

    final session = ref.watch(authSessionProvider);

    if (session == null) {
      return GameBookmarksPaginatorState(
        gameList: <LightExportedGameWithPov>[].toIList(),
        isLoading: false,
        hasMore: false,
        hasError: false,
      );
    }

    final games = ref.withClient((client) => GameRepository(client).getBookmarkedGames(session));

    _list.addAll(await games);

    return GameBookmarksPaginatorState(
      gameList: _list.toIList(),
      isLoading: false,
      hasMore: true,
      hasError: false,
    );
  }

  /// Fetches the next page of games.
  Future<void> getNext() async {
    if (!state.hasValue) return;

    final session = ref.read(authSessionProvider);

    if (session == null) return;

    final currentVal = state.requireValue;
    state = AsyncData(currentVal.copyWith(isLoading: true));
    try {
      final value = await ref.withClient(
        (client) => GameRepository(
          client,
        ).getBookmarkedGames(session, max: _nbPerPage, until: _list.last.game.createdAt),
      );
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
    } catch (e) {
      state = AsyncData(currentVal.copyWith(isLoading: false, hasError: true));
    }
  }

  void removeBookmark(GameId id) {
    if (!state.hasValue) return;

    final gameList = state.requireValue.gameList;
    final entry = gameList.firstWhereOrNull((e) => e.game.id == id);
    if (entry == null) return;

    final index = gameList.indexOf(entry);

    state = AsyncData(state.requireValue.copyWith(gameList: gameList.removeAt(index)));
  }
}

@freezed
sealed class GameBookmarksPaginatorState with _$GameBookmarksPaginatorState {
  const factory GameBookmarksPaginatorState({
    required IList<LightExportedGameWithPov> gameList,
    required bool isLoading,
    required bool hasMore,
    required bool hasError,
  }) = _GameBookmarksPaginatorState;
}
