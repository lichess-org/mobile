import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/account/account_repository.dart';
import 'package:lichess_mobile/src/model/auth/auth_session.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/playable_game.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/network/http.dart';

part 'ongoing_game.freezed.dart';

class OngoingGamesNotifier extends AsyncNotifier<IList<OngoingGame>> {
  @override
  Future<IList<OngoingGame>> build() {
    final session = ref.watch(authSessionProvider);
    if (session == null) return Future.value(IList());

    return ref.withAggregatorCacheFor(
      (client, aggregator) =>
          AccountRepository(client, aggregator).getOngoingGames(nb: 50),
      // cache is useful to reduce the number of requests to the server because this is used by
      // both the correspondence service to sync games and the home screen to display ongoing games
      const Duration(minutes: 1),
    );
  }

  /// Update the game with the given `id` with the new `game` data.
  ///
  /// If the game is not playable anymore, it will be removed from the list.
  void updateGame(GameFullId id, PlayableGame game) {
    if (!state.hasValue) return;
    final index = state.requireValue.indexWhere((e) => e.fullId == id);
    if (index == -1) return;
    if (!game.playable) {
      state = AsyncData(state.requireValue.removeAt(index));
      return;
    }

    final me = game.youAre ?? Side.white;
    final newGame = OngoingGame(
      id: game.id,
      fullId: id,
      orientation: me,
      fen: game.lastPosition.fen,
      perf: game.meta.perf,
      speed: game.meta.speed,
      variant: game.meta.variant,
      opponent: game.opponent?.user,
      isMyTurn: game.isMyTurn,
      opponentRating: game.opponent?.rating,
      opponentAiLevel: game.opponent?.aiLevel,
      lastMove: game.lastMove,
      secondsLeft:
          game.clock?.forSide(me).inSeconds ??
          game.correspondenceClock?.forSide(me).inSeconds,
    );
    state = AsyncData(
      state.requireValue.replace(index, newGame).sort((a, b) {
        if (a.isMyTurn && !b.isMyTurn) return -1;
        if (!a.isMyTurn && b.isMyTurn) return 1;
        return a.secondsLeft?.compareTo(b.secondsLeft ?? 0) ?? 0;
      }),
    );
  }
}

/// A provider that fetches the current user's ongoing games.
final ongoingGamesProvider =
    AsyncNotifierProvider<OngoingGamesNotifier, IList<OngoingGame>>(
      OngoingGamesNotifier.new,
      name: 'OngoingGamesProvider',
    );

@freezed
sealed class OngoingGame with _$OngoingGame {
  const OngoingGame._();

  factory OngoingGame({
    required GameId id,
    required GameFullId fullId,
    required Side orientation,
    required String fen,
    required Perf perf,
    required Speed speed,
    required Variant variant,
    LightUser? opponent,
    required bool isMyTurn,
    int? opponentRating,
    int? opponentAiLevel,
    Move? lastMove,
    int? secondsLeft,
  }) = _OngoingGame;

  bool get isRealTime => speed != Speed.correspondence;

  factory OngoingGame.fromServerJson(Map<String, dynamic> json) {
    return _ongoingGameFromPick(pick(json).required());
  }
}

IList<OngoingGame> ongoingGamesFromServerJson(Map<String, dynamic> json) {
  final list = json['nowPlaying'];
  if (list is! List<dynamic>) {
    throw Exception('Could not read json object as {nowPlaying: []}');
  }
  return list
      .map((e) => OngoingGame.fromServerJson(e as Map<String, dynamic>))
      .where((e) => e.variant.isPlaySupported)
      .toIList();
}

OngoingGame _ongoingGameFromPick(RequiredPick pick) {
  return OngoingGame(
    id: GameId(pick('gameId').asStringOrThrow()),
    fullId: GameFullId(pick('fullId').asStringOrThrow()),
    orientation: pick('color').asSideOrThrow(),
    fen: pick('fen').asStringOrThrow(),
    lastMove: pick('lastMove').asUciMoveOrNull(),
    perf: pick('perf').asPerfOrThrow(),
    speed: pick('speed').asSpeedOrThrow(),
    variant: pick('variant').asVariantOrThrow(),
    opponent: pick('opponent').asLightUserOrNull(),
    opponentRating: pick('opponent', 'rating').asIntOrNull(),
    opponentAiLevel: pick('opponent', 'aiLevel').asIntOrNull(),
    secondsLeft: pick('secondsLeft').asIntOrNull(),
    isMyTurn: pick('isMyTurn').asBoolOrThrow(),
  );
}
