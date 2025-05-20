import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/opening_explorer/opening_explorer_preferences.dart';

part 'opening_explorer.freezed.dart';
part 'opening_explorer.g.dart';

enum OpeningDatabase { master, lichess, player }

@Freezed(fromJson: true)
sealed class OpeningExplorerEntry with _$OpeningExplorerEntry {
  const OpeningExplorerEntry._();

  const factory OpeningExplorerEntry({
    required int white,
    required int draws,
    required int black,
    required IList<OpeningMove> moves,
    IList<OpeningExplorerGame>? topGames,
    IList<OpeningExplorerGame>? recentGames,
    LightOpening? opening,
    int? queuePosition,
  }) = _OpeningExplorerEntry;

  factory OpeningExplorerEntry.empty() =>
      const OpeningExplorerEntry(white: 0, draws: 0, black: 0, moves: IList.empty());

  factory OpeningExplorerEntry.fromJson(Map<String, Object?> json) =>
      _$OpeningExplorerEntryFromJson(json);
}

@Freezed(fromJson: true)
sealed class OpeningMove with _$OpeningMove {
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
    OpeningExplorerGame? game,
  }) = _OpeningMove;

  factory OpeningMove.fromJson(Map<String, Object?> json) => _$OpeningMoveFromJson(json);

  int get games {
    return white + draws + black;
  }
}

@Freezed(fromJson: true)
sealed class OpeningExplorerGame with _$OpeningExplorerGame {
  factory OpeningExplorerGame({
    required GameId id,
    required ({String name, int rating}) white,
    required ({String name, int rating}) black,
    String? uci,
    String? winner,
    Perf? speed,
    GameMode? mode,
    int? year,
    String? month,
  }) = _OpeningExplorerGame;

  factory OpeningExplorerGame.fromJson(Map<String, Object?> json) =>
      OpeningExplorerGame.fromPick(pick(json).required());

  factory OpeningExplorerGame.fromPick(RequiredPick pick) {
    return OpeningExplorerGame(
      id: pick('id').asGameIdOrThrow(),
      white: pick('white').letOrThrow(
        (pick) => (name: pick('name').asStringOrThrow(), rating: pick('rating').asIntOrThrow()),
      ),
      black: pick('black').letOrThrow(
        (pick) => (name: pick('name').asStringOrThrow(), rating: pick('rating').asIntOrThrow()),
      ),
      uci: pick('uci').asStringOrNull(),
      winner: pick('winner').asStringOrNull(),
      speed: pick('speed').asPerfOrNull(),
      mode: switch (pick('mode').value) {
        'casual' => GameMode.casual,
        'rated' => GameMode.rated,
        _ => null,
      },
      year: pick('year').asIntOrNull(),
      month: pick('month').asStringOrNull(),
    );
  }
}

enum GameMode { casual, rated }

@freezed
sealed class OpeningExplorerCacheKey with _$OpeningExplorerCacheKey {
  const factory OpeningExplorerCacheKey({
    required String fen,
    required OpeningExplorerPrefs prefs,
  }) = _OpeningExplorerCacheKey;
}
