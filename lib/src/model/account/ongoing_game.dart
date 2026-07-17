import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'ongoing_game.freezed.dart';

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
