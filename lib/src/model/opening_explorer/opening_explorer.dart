import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';

part 'opening_explorer.freezed.dart';
part 'opening_explorer.g.dart';

@Freezed(fromJson: true)
class OpeningExplorer with _$OpeningExplorer {
  const OpeningExplorer._();

  const factory OpeningExplorer({
    required int white,
    required int draws,
    required int black,
    required IList<OpeningMove> moves,
    IList<OpeningGame>? topGames,
    IList<OpeningGame>? recentGames,
    LightOpening? opening,
    int? queuePosition,
  }) = _OpeningExplorer;

  factory OpeningExplorer.fromJson(Map<String, Object?> json) =>
      _$OpeningExplorerFromJson(json);
}

@Freezed(fromJson: true)
class OpeningMove with _$OpeningMove {
  const OpeningMove._();

  const factory OpeningMove({
    required String uci,
    required String san,
    required int white,
    required int draws,
    required int black,
    int? averageRating,
    int? averageOpponentRating,
    int? performance,
    OpeningGame? game,
  }) = _OpeningMove;

  factory OpeningMove.fromJson(Map<String, Object?> json) =>
      _$OpeningMoveFromJson(json);

  int get games {
    return white + draws + black;
  }
}

@Freezed(fromJson: true)
class OpeningGame with _$OpeningGame {
  factory OpeningGame({
    required String id,
    required OpeningPlayer white,
    required OpeningPlayer black,
    String? uci,
    String? winner,
    Perf? speed,
    Mode? mode,
    int? year,
    String? month,
  }) = _OpeningGame;

  factory OpeningGame.fromJson(Map<String, Object?> json) =>
      OpeningGame.fromPick(pick(json).required());

  factory OpeningGame.fromPick(RequiredPick pick) {
    return OpeningGame(
      id: pick('id').asStringOrThrow(),
      white: pick('white').letOrThrow(OpeningPlayer.fromPick),
      black: pick('black').letOrThrow(OpeningPlayer.fromPick),
      uci: pick('uci').asStringOrNull(),
      winner: pick('winner').asStringOrNull(),
      speed: pick('speed').asPerfOrNull(),
      mode: pick('mode').asModeOrNull(),
      year: pick('year').asIntOrNull(),
      month: pick('month').asStringOrNull(),
    );
  }
}

enum Mode {
  casual('Casual'),
  rated('Rated');

  const Mode(this.title);

  final String title;
}

extension ModeExtension on Pick {
  Mode asModeOrThrow() {
    switch (this.required().value) {
      case 'casual':
        return Mode.casual;
      case 'rated':
        return Mode.rated;
      default:
        throw PickException(
          "value $value at $debugParsingExit can't be casted to Mode",
        );
    }
  }

  Mode? asModeOrNull() {
    if (value == null) return null;
    try {
      return asModeOrThrow();
    } catch (_) {
      return null;
    }
  }
}

@Freezed(fromJson: true)
class OpeningPlayer with _$OpeningPlayer {
  const factory OpeningPlayer({
    required String name,
    required int rating,
  }) = _OpeningPlayer;

  factory OpeningPlayer.fromJson(Map<String, Object?> json) =>
      _$OpeningPlayerFromJson(json);

  factory OpeningPlayer.fromPick(RequiredPick pick) {
    return OpeningPlayer(
      name: pick('name').asStringOrThrow(),
      rating: pick('rating').asIntOrThrow(),
    );
  }
}
