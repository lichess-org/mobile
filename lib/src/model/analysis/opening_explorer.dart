import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

part 'opening_explorer.freezed.dart';
part 'opening_explorer.g.dart';

@Freezed(fromJson: true)
class OpeningExplorer with _$OpeningExplorer {
  const OpeningExplorer._();

  const factory OpeningExplorer({
    LightOpening? opening,
    required int white,
    required int draws,
    required int black,
    IList<OpeningMove>? moves,
    IList<GameWithMove>? topGames,
    IList<GameWithMove>? recentGames,
    IList<HistoryStat>? history,
  }) = _OpeningExplorer;

  factory OpeningExplorer.fromJson(Map<String, Object?> json) =>
      _$OpeningExplorerFromJson(json);

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
    required String id,
    String? winner,
    required MasterPlayer white,
    required MasterPlayer black,
    required int year,
    required String month,
  }) = _Game;

  factory Game.fromJson(Map<String, Object?> json) =>
      _$GameFromJson(json);
}

@Freezed(fromJson: true)
class GameWithMove with _$GameWithMove {
  factory GameWithMove({
    required String uci,
    required String id,
    String? winner,
    required MasterPlayer white,
    required MasterPlayer black,
    required int year,
    required String month,
  }) = _GameWithMove;

  factory GameWithMove.fromJson(Map<String, Object?> json) =>
      _$GameWithMoveFromJson(json);
}


@Freezed(fromJson: true)
class MasterPlayer with _$MasterPlayer {
  const factory MasterPlayer({
    required String name,
    required int rating,
  }) = _MasterPlayer;

  factory MasterPlayer.fromJson(Map<String, Object?> json) =>
      _$MasterPlayerFromJson(json);
}

@Freezed(fromJson: true)
class HistoryStat with _$HistoryStat {
  const factory HistoryStat({
    required String month,
    required int white,
    required int draws,
    required int black,
  }) = _HistoryStat;

  factory HistoryStat.fromJson(Map<String, Object?> json) =>
      _$HistoryStatFromJson(json);
}
