import 'dart:async';

import 'package:async/async.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/http.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/archived_game.dart';
import 'package:lichess_mobile/src/model/game/game_repository.dart';
import 'package:lichess_mobile/src/model/game/game_repository_providers.dart';
import 'package:lichess_mobile/src/utils/riverpod.dart';
import 'package:result_extensions/result_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'game_history.freezed.dart';
part 'game_history.g.dart';

const _nbPerPage = 20;

@riverpod
class UserGameHistory extends _$UserGameHistory {
  final _list = <LightArchivedGame>[];

  @override
  Future<UserGameHistoryState> build(UserId id) async {
    ref.cacheFor(const Duration(minutes: 30));
    ref.onDispose(() {
      _list.clear();
    });
    final recentGames =
        await ref.watch(userRecentGamesProvider(userId: id).future);
    _list.addAll(recentGames);
    return UserGameHistoryState(
      gameList: _list.toIList(),
      isLoading: false,
      hasMore: true,
      hasError: false,
    );
  }

  void getNext() {
    if (!state.hasValue) return;

    final currentVal = state.requireValue;
    state = AsyncData(currentVal.copyWith(isLoading: true));
    Result.capture(
      ref.withClient(
        (client) => GameRepository(client)
            .getFullGames(id, _nbPerPage, until: _list.last.createdAt),
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
          UserGameHistoryState(
            gameList: _list.toIList(),
            isLoading: false,
            hasMore: true,
            hasError: false,
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
    required IList<LightArchivedGame> gameList,
    required bool isLoading,
    required bool hasMore,
    required bool hasError,
  }) = _UserGameHistoryState;
}
