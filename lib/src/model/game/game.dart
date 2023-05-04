import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:deep_pick/deep_pick.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';

import 'player.dart';

part 'game.freezed.dart';

@freezed
class PlayableGame with _$PlayableGame {
  const PlayableGame._();

  const factory PlayableGame({
    required GameId id,
    required bool rated,
    required Speed speed,
    required String initialFen,
    required Side orientation,
    required Player white,
    required Player black,
    required Variant variant,
  }) = _PlayableGame;

  Player get player => orientation == Side.white ? white : black;
  Player get opponent => orientation == Side.white ? black : white;
}

@freezed
class ArchivedGameData with _$ArchivedGameData {
  const factory ArchivedGameData({
    required GameId id,
    required bool rated,
    required Speed speed,
    required Perf perf,
    required DateTime createdAt,
    required DateTime lastMoveAt,
    required GameStatus status,
    required Player white,
    required Player black,
    required Variant variant,
    String? initialFen,
    String? lastFen,
    Side? winner,
  }) = _ArchivedGameData;
}

@freezed
class ArchivedGame with _$ArchivedGame {
  const ArchivedGame._();

  const factory ArchivedGame({
    required ArchivedGameData data,
    required IList<GameStep> steps,
    // IList<MoveAnalysis>? analysis,
    ClockData? clock,
  }) = _ArchivedGame;

  String? fenAt(int cursor) =>
      steps.isNotEmpty ? steps[cursor].position.fen : null;

  Move? moveAt(int cursor) =>
      steps.isNotEmpty ? Move.fromUci(steps[cursor].uci) : null;

  Position? positionAt(int cursor) =>
      steps.isNotEmpty ? steps[cursor].position : null;

  Duration? whiteClockAt(int cursor) =>
      steps.isNotEmpty ? steps[cursor].whiteClock : null;

  Duration? blackClockAt(int cursor) =>
      steps.isNotEmpty ? steps[cursor].blackClock : null;

  Move? get lastMove => steps.isNotEmpty ? Move.fromUci(steps.last.uci) : null;
  Position? get lastPosition => steps.isNotEmpty ? steps.last.position : null;
}

@freezed
class ClockData with _$ClockData {
  const factory ClockData({
    required Duration initial,
    required Duration increment,
  }) = _ClockData;
}

@freezed
class MaterialDiffSide with _$MaterialDiffSide {
  const factory MaterialDiffSide({
    required Map<Role, int> pieces,
    required int score,
  }) = _MaterialDiffSide;
}

@freezed
class MaterialDiff with _$MaterialDiff {
  const factory MaterialDiff({
    required MaterialDiffSide black,
    required MaterialDiffSide white,
  }) = _MaterialDiff;
}

@freezed
class GameStep with _$GameStep {
  const factory GameStep({
    required int ply,
    required String san,
    required String uci,
    required Position position,
    required MaterialDiff diff,
    Duration? whiteClock,
    Duration? blackClock,
  }) = _GameStep;
}

@freezed
class PlayerAnalysis with _$PlayerAnalysis {
  const factory PlayerAnalysis({
    required int inaccuracy,
    required int mistake,
    required int blunder,
    int? acpl,
  }) = _PlayerAnalysis;
}

@freezed
class MoveAnalysis with _$MoveAnalysis {
  const factory MoveAnalysis({
    int? eval,
    UCIMove? best,
    String? variation,
    AnalysisJudgment? judgment,
  }) = _MoveAnalysis;
}

@freezed
class AnalysisJudgment with _$AnalysisJudgment {
  const factory AnalysisJudgment({
    required String name,
    required String comment,
  }) = _AnalysisJugdment;
}

enum Speed {
  ultraBullet,
  bullet,
  blitz,
  rapid,
  classical,
  correspondence,
  unlimited,
}

enum GameStatus {
  unknown(-1),
  created(10),
  started(20),
  aborted(25),
  mate(30),
  resign(31),
  stalemate(32),
  timeout(33),
  draw(34),
  outoftime(35),
  cheat(36),
  noStart(37),
  unknownFinish(38),
  variantEnd(60);

  const GameStatus(this.value);
  final int value;
}

extension GameExtension on Pick {
  Speed asSpeedOrThrow() {
    final value = this.required().value;
    if (value is Speed) {
      return value;
    }
    if (value is String) {
      return Speed.values
          .firstWhere((v) => v.name == value, orElse: () => Speed.blitz);
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Speed",
    );
  }

  Speed? asSpeedOrNull() {
    if (value == null) return null;
    try {
      return asSpeedOrThrow();
    } catch (_) {
      return null;
    }
  }

  GameStatus asGameStatusOrThrow() {
    final value = this.required().value;
    if (value is GameStatus) {
      return value;
    }
    if (value is String) {
      return GameStatus.values
          .firstWhere((e) => e.name == value, orElse: () => GameStatus.unknown);
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to GameStatus",
    );
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
