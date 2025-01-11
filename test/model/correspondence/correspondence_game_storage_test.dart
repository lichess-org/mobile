import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/correspondence/correspondence_game_storage.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

import '../../test_container.dart';

void main() {
  group('CorrespondenceGameStorage', () {
    test('save and fetch data', () async {
      final container = await makeContainer();

      final storage = await container.read(correspondenceGameStorageProvider.future);

      await storage.save(corresGame);
      expect(storage.fetch(gameId: gameId), completion(equals(corresGame)));
    });
  });
}

IList<GameStep> _makeSteps(String pgn) {
  Position position = Chess.initial;
  final steps = <GameStep>[GameStep(position: position)];
  for (final san in pgn.split(' ')) {
    final move = position.parseSan(san)!;
    position = position.play(move);
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

const gameId = GameId('g2bzFol8');
final corresGame = OfflineCorrespondenceGame(
  id: gameId,
  meta: GameMeta(
    createdAt: DateTime(2021, 1, 1),
    rated: true,
    perf: Perf.correspondence,
    speed: Speed.correspondence,
    variant: Variant.standard,
  ),
  fullId: const GameFullId('g2bzFol8fgty'),
  steps: _makeSteps('e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2'),
  clock: const CorrespondenceClockData(
    white: Duration(days: 2, hours: 23, minutes: 59),
    black: Duration(days: 3),
  ),
  rated: true,
  status: GameStatus.started,
  variant: Variant.standard,
  speed: Speed.correspondence,
  perf: Perf.classical,
  white: const Player(user: LightUser(id: UserId('whiteId'), name: 'White'), rating: 1500),
  black: const Player(user: LightUser(id: UserId('blackId'), name: 'Black'), rating: 1500),
  youAre: Side.white,
  daysPerTurn: 3,
);
