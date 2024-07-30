import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';

part 'opening_explorer.freezed.dart';
part 'opening_explorer.g.dart';

@Freezed(fromJson: true)
class MasterOpeningExplorer with _$MasterOpeningExplorer {
  const MasterOpeningExplorer._();

  const factory MasterOpeningExplorer({
    LightOpening? opening,
    required int white,
    required int draws,
    required int black,
    required IList<OpeningMove> moves,
    required IList<TopGame> topGames,
  }) = _MasterOpeningExplorer;

  factory MasterOpeningExplorer.fromJson(Map<String, Object?> json) =>
      _$MasterOpeningExplorerFromJson(json);

  int get games {
    return white + draws + black;
  }
}

@Freezed(fromJson: true)
class LichessOpeningExplorer with _$LichessOpeningExplorer {
  const LichessOpeningExplorer._();

  const factory LichessOpeningExplorer({
    LightOpening? opening,
    required int white,
    required int draws,
    required int black,
    required IList<OpeningMove> moves,
    required IList<RecentGame> recentGames,
  }) = _LichessOpeningExplorer;

  factory LichessOpeningExplorer.fromJson(Map<String, Object?> json) =>
      _$LichessOpeningExplorerFromJson(json);

  int get games {
    return white + draws + black;
  }
}

@Freezed(fromJson: true)
class OpeningMove with _$OpeningMove {
  const OpeningMove._();

  const factory OpeningMove({
    required String uci,
    required String san,
    required int averageRating,
    required int white,
    required int draws,
    required int black,
  }) = _OpeningMove;

  factory OpeningMove.fromJson(Map<String, Object?> json) =>
      _$OpeningMoveFromJson(json);

  int get games {
    return white + draws + black;
  }
}

class Game {
  const Game({
    required this.uci,
    required this.id,
    this.speed,
    this.mode,
    required this.white,
    required this.black,
    this.winner,
    required this.year,
    this.month,
  });

  final String uci;
  final String id;
  final Perf? speed;
  final Mode? mode;
  final Player white;
  final Player black;
  final String? winner;
  final int year;
  final String? month;

  factory Game.fromTopGame(TopGame topGame) => Game(
        uci: topGame.uci,
        id: topGame.id,
        white: topGame.white,
        black: topGame.black,
        winner: topGame.winner,
        year: topGame.year,
        month: topGame.month,
      );

  factory Game.fromRecentGame(RecentGame recentGame) => Game(
        uci: recentGame.uci,
        id: recentGame.id,
        speed: recentGame.speed,
        mode: recentGame.mode,
        white: recentGame.white,
        black: recentGame.black,
        winner: recentGame.winner,
        year: recentGame.year,
        month: recentGame.month,
      );
}

@Freezed(fromJson: true)
class TopGame with _$TopGame {
  factory TopGame({
    required String uci,
    required String id,
    String? winner,
    required Player white,
    required Player black,
    required int year,
    String? month,
  }) = _TopGame;

  factory TopGame.fromJson(Map<String, Object?> json) =>
      _$TopGameFromJson(json);
}

@Freezed(fromJson: true)
class RecentGame with _$RecentGame {
  factory RecentGame({
    required String uci,
    required String id,
    String? winner,
    required Perf speed,
    required Mode mode,
    required Player white,
    required Player black,
    required int year,
    String? month,
  }) = _RecentGame;

  factory RecentGame.fromJson(Map<String, Object?> json) =>
      RecentGame.fromPick(pick(json).required());

  factory RecentGame.fromPick(RequiredPick pick) {
    return RecentGame(
      uci: pick('uci').asStringOrThrow(),
      id: pick('id').asStringOrThrow(),
      winner: pick('winner').asStringOrNull(),
      speed: pick('speed').asPerfOrThrow(),
      mode: pick('mode').asModeOrThrow(),
      white: pick('white').letOrThrow(Player.fromPick),
      black: pick('black').letOrThrow(Player.fromPick),
      year: pick('year').asIntOrThrow(),
      month: pick('month').asStringOrNull(),
    );
  }
}

enum Mode { casual, rated }

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
