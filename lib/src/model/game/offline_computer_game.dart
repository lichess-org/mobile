import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

export 'package:lichess_mobile/src/model/engine/opponent_level.dart';

part 'offline_computer_game.freezed.dart';
part 'offline_computer_game.g.dart';

/// Reads the [OfflineComputerGame.opponentSpec] of a saved game.
///
/// Games saved before there was more than one engine to play carry a `stockfishLevel` instead, so
/// one is turned into the other rather than being lost.
Object? readOpponent(Map<dynamic, dynamic> json, String key) =>
    json[key] ?? {'type': 'stockfish', 'level': json['stockfishLevel']};

/// An offline game played against the local engine.
@Freezed(fromJson: true, toJson: true)
abstract class OfflineComputerGame with BaseGame, _$OfflineComputerGame, LocalGame, IndexableSteps {
  const OfflineComputerGame._();

  @Assert('steps.isNotEmpty')
  factory OfflineComputerGame({
    required StringId id,
    required GameMeta meta,
    required String? initialFen,
    required GameStatus status,
    @JsonKey(fromJson: stepsFromJson, toJson: stepsToJson) required IList<GameStep> steps,

    /// The side the human player is playing as.
    required Side playerSide,

    /// The computer opponent: a Stockfish level, or a Maia rating.
    @JsonKey(readValue: readOpponent) required OpponentSpec opponentSpec,

    /// Whether the game is casual (allows takebacks and hints).
    @Default(true) bool casual,

    /// Whether the game is in practice mode (evaluates player moves and gives feedback).
    @Default(false) bool practiceMode,

    /// The player's data.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(Player(onGame: true))
    Player humanPlayer,

    /// The engine player's data.
    @JsonKey(includeFromJson: false, includeToJson: false)
    @Default(Player(onGame: true))
    Player enginePlayer,

    Side? winner,
    bool? isThreefoldRepetition,
  }) = _OfflineComputerGame;

  factory OfflineComputerGame.fromJson(Map<String, dynamic> json) =>
      _$OfflineComputerGameFromJson(json);

  @override
  Side? get youAre => playerSide;

  @override
  IList<ExternalEval>? get evals => null;
  @override
  IList<Duration>? get clocks => null;

  bool get abortable => playable && lastPosition.fullmoves <= 1;

  bool get resignable => playable && !abortable;

  @override
  Player get white => playerSide == Side.white ? humanPlayer : enginePlayer;

  @override
  Player get black => playerSide == Side.black ? humanPlayer : enginePlayer;
}

/// The [Player] standing for [opponent].
Player enginePlayerFor(OpponentSpec opponent) => Player(
  onGame: true,
  user: switch (opponent) {
    StockfishOpponentSpec() => const LightUser(id: UserId('stockfish'), name: 'Stockfish'),
    MaiaOpponentSpec() => const LightUser(id: UserId('maia'), name: 'Maia'),
  },
);
