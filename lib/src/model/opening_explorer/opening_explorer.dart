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
    IList<Game>? topGames,
    IList<Game>? recentGames,
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
    Game? game,
  }) = _OpeningMove;

  factory OpeningMove.fromJson(Map<String, Object?> json) =>
      _$OpeningMoveFromJson(json);

  int get games {
    return white + draws + black;
  }
}

@Freezed(fromJson: true)
class Game with _$Game {
  factory Game({
    required String uci,
    required String id,
    String? winner,
    Perf? speed,
    Mode? mode,
    required Player white,
    required Player black,
    required int year,
    String? month,
  }) = _Game;

  factory Game.fromJson(Map<String, Object?> json) =>
      Game.fromPick(pick(json).required());

  factory Game.fromPick(RequiredPick pick) {
    return Game(
      uci: pick('uci').asStringOrThrow(),
      id: pick('id').asStringOrThrow(),
      winner: pick('winner').asStringOrNull(),
      speed: pick('speed').asPerfOrNull(),
      mode: pick('mode').asModeOrNull(),
      white: pick('white').letOrThrow(Player.fromPick),
      black: pick('black').letOrThrow(Player.fromPick),
      year: pick('year').asIntOrThrow(),
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
class Player with _$Player {
  const factory Player({
    required String name,
    required int rating,
  }) = _Player;

  factory Player.fromJson(Map<String, Object?> json) => _$PlayerFromJson(json);

  factory Player.fromPick(RequiredPick pick) {
    return Player(
      name: pick('name').asStringOrThrow(),
      rating: pick('rating').asIntOrThrow(),
    );
  }
}
