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

/// Available Stockfish Elo ratings for game creation.
/// Distribution favors lower Elos with more granularity.
const kStockfishEloChoices = [
  1320,
  1450,
  1550,
  1650,
  1750,
  1850,
  1950,
  2100,
  2300,
  2550,
  2850,
  3190,
];

const kStockfishDefaultElo = 1320;

/// An offline game played against the local Stockfish engine.
@Freezed(fromJson: false, toJson: false)
abstract class OfflineComputerGame with _$OfflineComputerGame, BaseGame, IndexableSteps {
  const OfflineComputerGame._();

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
    required IList<GameStep> steps,
    required GameMeta meta,
    required String? initialFen,
    required GameStatus status,

    /// The side the human player is playing as.
    required Side playerSide,

    /// The Elo rating of the Stockfish opponent.
    required int engineElo,

    /// The player's data.
    required Player humanPlayer,

    /// The engine player's data.
    required Player enginePlayer,

    Side? winner,
    bool? isThreefoldRepetition,
  }) = _OfflineComputerGame;

  @override
  Player get white => playerSide == Side.white ? humanPlayer : enginePlayer;

  @override
  Player get black => playerSide == Side.black ? humanPlayer : enginePlayer;
}

/// Returns a Player representing the Stockfish engine at the given Elo.
Player stockfishPlayer(int elo) => Player(
  onGame: true,
  rating: elo,
  user: LightUser(id: const UserId('stockfish'), name: 'Stockfish ($elo)'),
);
