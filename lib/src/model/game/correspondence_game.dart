import 'dart:convert';

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
part 'correspondence_game.g.dart';

/// An offline correspondence game.
@Freezed(fromJson: true, toJson: true)
class CorrespondenceGame
    with _$CorrespondenceGame, BaseGame, IndexableSteps
    implements BaseGame {
  const CorrespondenceGame._();

  @Assert('steps.isNotEmpty')
  factory CorrespondenceGame({
    required GameId id,
    required DateTime lastModified,
    @JsonKey(fromJson: _stepsFromJson, toJson: _stepsToJson)
    required IList<GameStep> steps,
    String? initialFen,
    required GameStatus status,
    required Variant variant,
    required Speed speed,
    required Perf perf,
    required Player white,
    required Player black,
    required Side youAre,
    required int daysPerTurn,
    Side? winner,
    bool? isThreefoldRepetition,
  }) = _CorrespondenceGame;

  factory CorrespondenceGame.fromJson(Map<String, dynamic> json) =>
      _$CorrespondenceGameFromJson(json);

  Side get orientation => youAre;

  Player get me => youAre == Side.white ? white : black;
  Player get opponent => youAre == Side.white ? black : white;

  Side get sideToMove => lastPosition.turn;

  Duration get estimatedTimeLeft {
    final elapsed = DateTime.now().difference(lastModified);
    final duration = Duration(days: daysPerTurn) - elapsed;
    return duration > Duration.zero ? duration : Duration.zero;
  }

  bool get isPlayerTurn => lastPosition.turn == youAre;
  bool get playing => status.value > GameStatus.started.value;
  bool get finished => status.value >= GameStatus.mate.value;
}

String _stepsToJson(IList<GameStep> steps) {
  final objs = steps
      .map(
        (e) => {
          'fen': e.position.fen,
          'uci': e.sanMove?.move.uci,
          'san': e.sanMove?.san,
        },
      )
      .toList(growable: false);
  return jsonEncode(objs);
}

// TODO support other rules
IList<GameStep> _stepsFromJson(String json) {
  final objs = jsonDecode(json) as List<Map<String, dynamic>>;
  final initialFen = objs.first['fen'] as String?;
  if (initialFen == null) {
    throw const FormatException(
      '[CorrespondenceGame] steps: expected a fen',
    );
  }
  Position position = Chess.fromSetup(Setup.parseFen(initialFen));
  int ply = 0;
  final List<GameStep> steps = [GameStep(position: position, ply: ply)];
  for (final obj in objs.skip(1)) {
    ply++;
    final uci = obj['uci'] as String?;
    final san = obj['san'] as String?;
    if (uci == null || san == null) {
      break;
    }
    final move = Move.fromUci(uci)!;
    position = position.playUnchecked(move);
    steps.add(
      GameStep(position: position, ply: ply, sanMove: SanMove(san, move)),
    );
  }
  return steps.toIList();
}
