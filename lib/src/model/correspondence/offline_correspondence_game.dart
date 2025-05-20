import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/player.dart';

part 'offline_correspondence_game.freezed.dart';
part 'offline_correspondence_game.g.dart';

/// An offline correspondence game.
///
/// This is always a game of the current user, so [youAre], [me] and [opponent]
/// are always guaranteed to be non-null.
@Freezed(fromJson: true, toJson: true)
sealed class OfflineCorrespondenceGame
    with _$OfflineCorrespondenceGame, BaseGame, IndexableSteps
    implements BaseGame {
  const OfflineCorrespondenceGame._();

  @Assert('steps.isNotEmpty')
  factory OfflineCorrespondenceGame({
    required GameId id,
    required GameFullId fullId,
    required GameMeta meta,
    @JsonKey(fromJson: stepsFromJson, toJson: stepsToJson) required IList<GameStep> steps,
    CorrespondenceClockData? clock,
    String? initialFen,
    required bool rated,
    required GameStatus status,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    required Player white,
    required Player black,
    required Side? youAre,
    int? daysPerTurn,
    Side? winner,
    bool? isThreefoldRepetition,
    @MoveConverter() (String, Move)? registeredMoveAtPgn,
  }) = _CorrespondenceGame;

  factory OfflineCorrespondenceGame.fromJson(Map<String, dynamic> json) =>
      _$OfflineCorrespondenceGameFromJson(json);

  Side get orientation => youAre!;

  @override
  IList<Duration>? get clocks => null;

  @override
  IList<ExternalEval>? get evals => null;

  Side get sideToMove => lastPosition.turn;

  bool get isMyTurn => sideToMove == youAre;

  Duration? myTimeLeft(DateTime lastModifiedTime) => estimatedTimeLeft(youAre!, lastModifiedTime);

  Duration? estimatedTimeLeft(Side side, DateTime lastModifiedTime) {
    final timeLeft = side == Side.white ? clock?.white : clock?.black;
    if (timeLeft != null) {
      return timeLeft - DateTime.now().difference(lastModifiedTime);
    }
    return null;
  }
}
