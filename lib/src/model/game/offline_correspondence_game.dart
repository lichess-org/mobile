import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';

import 'player.dart';
import 'game.dart';
import 'game_status.dart';

part 'offline_correspondence_game.freezed.dart';
part 'offline_correspondence_game.g.dart';

/// An offline correspondence game.
@Freezed(fromJson: true, toJson: true)
class OfflineCorrespondenceGame
    with _$OfflineCorrespondenceGame, BaseGame, IndexableSteps
    implements BaseGame {
  const OfflineCorrespondenceGame._();

  @Assert('steps.isNotEmpty')
  factory OfflineCorrespondenceGame({
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

  factory OfflineCorrespondenceGame.fromJson(Map<String, dynamic> json) =>
      _$OfflineCorrespondenceGameFromJson(json);

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
      .mapIndexed(
        (i, e) => {
          if (i == 0) 'fen': e.position.fen,
          if (i == 0) 'rule': e.position.rule.name,
          'uci': e.sanMove?.move.uci,
          'san': e.sanMove?.san,
        },
      )
      .toList(growable: false);
  return jsonEncode(objs);
}

IList<GameStep> _stepsFromJson(String json) {
  final objs = jsonDecode(json) as List<dynamic>;
  final first = objs.first as Map<String, dynamic>;
  final initialFen = first['fen'] as String;
  final rule = Rule.values.byName(first['rule'] as String);
  Position position = Position.setupPosition(rule, Setup.parseFen(initialFen));
  final List<GameStep> steps = [GameStep(position: position)];
  for (final obj in objs.skip(1)) {
    final step = obj as Map<String, dynamic>;
    final uci = step['uci'] as String?;
    final san = step['san'] as String?;
    if (uci == null || san == null) {
      break;
    }
    final move = Move.fromUci(uci)!;
    position = position.playUnchecked(move);
    steps.add(
      GameStep(
        position: position,
        sanMove: SanMove(san, move),
        diff: MaterialDiff.fromBoard(position.board),
      ),
    );
  }
  return steps.toIList();
}
