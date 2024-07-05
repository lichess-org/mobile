import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

part 'opening_explorer.freezed.dart';

@freezed
class OpeningExplorer with _$OpeningExplorer {
  const factory OpeningExplorer({
    required LightOpening opening,
    required int white,
    required int draws,
    required int black,
    required IList<OpeningMove> moves,
    required IList<GameWithMove> topGames,
    required IList<GameWithMove> recentGames,
    required IList<HistoryStat> history,
  }) = _OpeningExplorer;
}

@freezed
class OpeningMove with _$OpeningMove {
  const factory OpeningMove({
    required String uci,
    required String san,
    required int averageRating,
    required int white,
    required int draws,
    required int black,
    Game? game,
  }) = _OpeningMove;
}

@freezed
class Game with _$Game {
  const Game._();

  factory Game({
    required String uci,
    required String id,
    required String winner,
    required MasterPlayer white,
    required MasterPlayer black,
    required int year,
    required String month,
  }) = _Game;
}

@freezed
class GameWithMove with _$GameWithMove {
  factory GameWithMove({
    required String uci,
    required Game game,
  }) = _GameWithMove;
}


@freezed
class MasterPlayer with _$MasterPlayer {
  const MasterPlayer._();

  const factory MasterPlayer({
    required String name,
    required int rating,
  }) = _MasterPlayer;
}

@freezed
class HistoryStat with _$HistoryStat {
  const HistoryStat._();

  const factory HistoryStat({
    required String month,
    required int white,
    required int draws,
    required int black,
  }) = _HistoryStat;
}
