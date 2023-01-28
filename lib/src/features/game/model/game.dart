import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';

import 'package:lichess_mobile/src/common/models.dart';
import './game_status.dart';

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
    required List<GameStep> steps,
    // List<MoveAnalysis>? analysis,
    ClockData? clock,
  }) = _ArchivedGame;

  String? fenAt(int cursor) =>
      steps.isNotEmpty ? steps[cursor].position.fen : null;

  Move? moveAt(int cursor) =>
      steps.isNotEmpty ? Move.fromUci(steps[cursor].uci) : null;

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
class GameStep with _$GameStep {
  const factory GameStep({
    required int ply,
    required String san,
    required String uci,
    required Position position,
    Duration? whiteClock,
    Duration? blackClock,
  }) = _GameStep;
}

@freezed
class Player with _$Player {
  const factory Player({
    String? id,
    required String name,
    int? rating,
    int? ratingDiff,
    bool? provisional,
    String? title,
    bool? patron,
    int? aiLevel,
  }) = _Player;
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

enum Variant {
  standard,
  chess960,
  antichess,
  kingOfTheHill,
  threeCheck,
  atomic,
  horde,
  racingKings,
  crazyhouse;

  // TODO implement missing variants
  Position get initialPosition {
    switch (this) {
      case Variant.standard:
      case Variant.chess960:
        return Chess.initial;
      case Variant.antichess:
        return Antichess.initial;
      case Variant.kingOfTheHill:
        return KingOfTheHill.initial;
      case Variant.threeCheck:
        return ThreeCheck.initial;
      case Variant.atomic:
        return Atomic.initial;
      case Variant.crazyhouse:
        return Crazyhouse.initial;
      default:
        throw UnimplementedError();
    }
  }
}
