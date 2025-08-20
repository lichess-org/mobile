import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

enum GameStatus {
  /// Unknown game status (not handled by the app).
  unknown(-1),

  /// The game is created but not started yet.
  created(10),
  started(20),

  /// From here on, the game is finished.
  aborted(25),
  mate(30),
  resign(31),
  stalemate(32),

  /// When a player leaves the game.
  timeout(33),
  draw(34),

  /// When a player runs out of time (clock flags).
  outoftime(35),
  cheat(36),

  /// The player did not make the first move in time.
  noStart(37),

  /// We don't know why the game ended.
  unknownFinish(38),

  /// If a player offers a draw and their opponent has insufficient material to win, the game is called a draw.
  insufficientMaterialClaim(39),

  /// Chess variant special endings.
  variantEnd(60);

  static final nameMap = IMap(GameStatus.values.asNameMap());

  const GameStatus(this.value);
  final int value;
}

extension GameExtension on Pick {
  GameStatus asGameStatusOrThrow() {
    final value = required().value;
    if (value is GameStatus) {
      return value;
    }
    if (value is String) {
      final gameStatus = GameStatus.nameMap[value];
      if (gameStatus != null) {
        return gameStatus;
      }
    } else if (value is Map<String, dynamic>) {
      final gameStatus = GameStatus.nameMap[value['name'] as String];
      if (gameStatus != null) {
        return gameStatus;
      }
    } else if (value is int) {
      return GameStatus.values.firstWhere(
        (status) => status.value == value,
        orElse: () => GameStatus.unknown,
      );
    }
    throw PickException("value $value at $debugParsingExit can't be casted to GameStatus");
  }

  GameStatus? asGameStatusOrNull() {
    if (value == null) return null;
    try {
      return asGameStatusOrThrow();
    } catch (_) {
      return null;
    }
  }
}
