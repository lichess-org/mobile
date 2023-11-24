import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';

import 'player.dart';
import 'game.dart';
import 'game_status.dart';

part 'correspondence_game.freezed.dart';

@Freezed(fromJson: true, toJson: true)
class CorrespondenceGame
    with _$CorrespondenceGame, BaseGame, IndexableSteps
    implements BaseGame {
  const CorrespondenceGame._();

  @Assert('steps.isNotEmpty')
  factory CorrespondenceGame({
    required GameId id,
    required IList<GameStep> steps,
    String? initialFen,
    required GameStatus status,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    required Player white,
    required Player black,
    required Side youAre,
    CorrespondenceClockData? correspondenceClock,
    Side? winner,
    bool? isThreefoldRepetition,
  }) = _CorrespondenceGame;

  factory CorrespondenceGame.fromJson(Map<String, dynamic> json) =>
      _$CorrespondenceGameFromJson(json);

  Player get me => youAre == Side.white ? white : black;
  Player get opponent => youAre == Side.white ? black : white;

  Side get sideToMove => lastPosition.turn;

  bool get isPlayerTurn => lastPosition.turn == youAre;
  bool get playing => status.value > GameStatus.started.value;
  bool get finished => status.value >= GameStatus.mate.value;
}
