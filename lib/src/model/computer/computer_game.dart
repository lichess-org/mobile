import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/game.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/utils/string.dart';

part 'computer_game.freezed.dart';
part 'computer_game.g.dart';

enum StockfishLevel {
  // Values taken from lichobile https://github.com/lichess-org/lichobile/blob/663e69fab10e4267a9b3369febe85d1363816ba2/src/ui/ai/engine.ts#L71-L108
  one(1350, 5),
  two(1500, 5),
  three(1600, 5),
  four(1700, 5),
  five(2000, 5),
  six(2300, 8),
  seven(2700, 13),
  eight(2850, 22);

  const StockfishLevel(this.elo, this.depth);

  final int elo;
  final int depth;

  static const _maxMoveTime = Duration(milliseconds: 5000);

  int get value => index + 1;

  Duration get moveTime => (_maxMoveTime * value) ~/ 8;

  String label(AppLocalizations l10n) => l10n.aiNameLevelAiLevel('Stockfish', value.toString());
}

/// An offline game played against Sockfish.
@Freezed(fromJson: true, toJson: true)
abstract class ComputerGame with _$ComputerGame, BaseGame, IndexableSteps {
  const ComputerGame._();

  @Assert('steps.isNotEmpty')
  factory ComputerGame({
    @JsonKey(fromJson: stepsFromJson, toJson: stepsToJson) required IList<GameStep> steps,
    required GameMeta meta,
    required String? initialFen,
    required GameStatus status,
    required StockfishLevel level,
    required SideChoice sideChoice,
    // can't be null for a computer game but I don't know how to make the type not nullable
    Side? youAre,
    Side? winner,
    bool? isThreefoldRepetition,
  }) = _ComputerGame;

  @override
  Player get white => _playerFromSide(Side.white);

  @override
  Player get black => _playerFromSide(Side.black);

  Player _playerFromSide(Side side) =>
      (youAre == side) ? Player(name: side.name.capitalize()) : Player(aiLevel: level.value);

  @override
  IList<ExternalEval>? get evals => null;

  @override
  IList<Duration>? get clocks => null;

  @override
  GameId get id => const GameId('--------');

  bool get abortable => playable && lastPosition.fullmoves <= 1;

  bool get resignable => playable && !abortable;
  bool get drawable => playable && lastPosition.fullmoves >= 2;
}
