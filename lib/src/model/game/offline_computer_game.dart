import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

part 'offline_computer_game.freezed.dart';
part 'offline_computer_game.g.dart';

/// Stockfish strength levels. Level 1 is the easiest, level 12 is the hardest.
enum StockfishLevel {
  level1(1320),
  level2(1450),
  level3(1550),
  level4(1650),
  level5(1750),
  level6(1850),
  level7(1950),
  level8(2100),
  level9(2300),
  level10(2550),
  level11(2850),
  level12(3190);

  const StockfishLevel(this.elo);

  /// The internal Elo rating used to limit Stockfish strength.
  final int elo;

  /// The display level number (1-12).
  int get level => index + 1;

  /// The default level for new games.
  static const defaultLevel = StockfishLevel.level1;
}

/// An offline game played against the local Stockfish engine.
@Freezed(fromJson: true, toJson: true)
abstract class OfflineComputerGame with _$OfflineComputerGame, BaseGame, IndexableSteps {
  const OfflineComputerGame._();

  factory OfflineComputerGame.fromJson(Map<String, dynamic> json) =>
      _$OfflineComputerGameFromJson(json);

  @override
  Side? get youAre => playerSide;

  @override
  IList<ExternalEval>? get evals => null;
  @override
  IList<Duration>? get clocks => null;

  @override
  GameId get id => const GameId('--------');

  bool get abortable => playable && lastPosition.fullmoves <= 1;

  bool get resignable => playable && !abortable;

  @Assert('steps.isNotEmpty')
  factory OfflineComputerGame({
    @JsonKey(fromJson: stepsFromJson, toJson: stepsToJson) required IList<GameStep> steps,
    required GameMeta meta,
    required String? initialFen,
    required GameStatus status,

    /// The side the human player is playing as.
    required Side playerSide,

    /// The Stockfish strength level.
    required StockfishLevel stockfishLevel,

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

  @override
  Player get white => playerSide == Side.white ? humanPlayer : enginePlayer;

  @override
  Player get black => playerSide == Side.black ? humanPlayer : enginePlayer;
}

/// Returns a Player representing the Stockfish engine.
Player stockfishPlayer() => const Player(
  onGame: true,
  user: LightUser(id: UserId('stockfish'), name: 'Stockfish'),
);
