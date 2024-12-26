import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/user/user.dart';
import 'package:lichess_mobile/src/utils/string.dart';

import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';

part 'over_the_board_game.freezed.dart';
part 'over_the_board_game.g.dart';

/// An offline game played in real life by two human players on the same device.
///
/// See [PlayableGame] for a game that is played online.
@Freezed(fromJson: true, toJson: true)
abstract class OverTheBoardGame with _$OverTheBoardGame, BaseGame, IndexableSteps {
  const OverTheBoardGame._();

  @override
  Player get white => Player(
    onGame: true,
    user: LightUser(id: UserId(Side.white.name), name: Side.white.name.capitalize()),
  );

  @override
  Player get black => Player(
    onGame: true,
    user: LightUser(id: UserId(Side.black.name), name: Side.black.name.capitalize()),
  );

  @override
  Side? get youAre => null;

  @override
  IList<ExternalEval>? get evals => null;
  @override
  IList<Duration>? get clocks => null;

  @override
  GameId get id => const GameId('--------');

  @Assert('steps.isNotEmpty')
  factory OverTheBoardGame({
    @JsonKey(fromJson: stepsFromJson, toJson: stepsToJson) required IList<GameStep> steps,
    required GameMeta meta,
    required String? initialFen,
    required GameStatus status,
    Side? winner,
    bool? isThreefoldRepetition,
  }) = _OverTheBoardGame;
}
