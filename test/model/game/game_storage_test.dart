import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/game_storage.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

import '../../test_container.dart';

void main() {
  group('GameStorage', () {
    test('save and fetch data', () async {
      final container = await makeContainer();

      final storage = await container.read(gameStorageProvider.future);

      await storage.save(game);
      expect(storage.fetch(gameId: gameId), completion(equals(game)));
    });

    test('paginate games', () async {
      final container = await makeContainer();

      final storage = await container.read(gameStorageProvider.future);

      for (final game in games) {
        await storage.save(game);
        await Future<void>.delayed(const Duration(milliseconds: 1));
      }

      const userId = UserId('whiteId');
      final page1 = await storage.page(userId: userId, max: 10);
      expect(page1.length, 10);
      expect(page1.last.game.id, const GameId('game0090'));

      final page2 = await storage.page(userId: userId, max: 10, until: page1.last.lastModified);
      expect(page2.length, 10);
      expect(page2.last.game.id, const GameId('game0080'));
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
        diff: MaterialDiff.fromPosition(position),
      ),
    );
  }
  return steps.toIList();
}

const gameId = GameId('g2bzFol8');
final game = ExportedGame(
  id: gameId,
  meta: GameMeta(
    createdAt: DateTime(2021, 1, 1),
    rated: true,
    perf: Perf.correspondence,
    speed: Speed.correspondence,
    variant: Variant.standard,
  ),
  source: GameSource.lobby,
  data: LightExportedGame(
    id: gameId,
    variant: Variant.standard,
    lastMoveAt: DateTime(2021, 1, 1),
    createdAt: DateTime(2021, 1, 1),
    perf: Perf.blitz,
    speed: Speed.blitz,
    rated: true,
    status: GameStatus.started,
    white: const Player(
      user: LightUser(id: UserId('whiteId'), name: 'White'),
      rating: 1500,
    ),
    black: const Player(
      user: LightUser(id: UserId('blackId'), name: 'Black'),
      rating: 1500,
    ),
    clock: (initial: const Duration(minutes: 2), increment: const Duration(seconds: 3)),
  ),
  steps: _makeSteps('e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2'),
  status: GameStatus.started,
  white: const Player(
    user: LightUser(id: UserId('whiteId'), name: 'White'),
    rating: 1500,
  ),
  black: const Player(
    user: LightUser(id: UserId('blackId'), name: 'Black'),
    rating: 1500,
  ),
  youAre: Side.white,
);

final games = List.generate(100, (index) {
  final id = GameId('game${index.toString().padLeft(4, '0')}');
  return ExportedGame(
    id: id,
    meta: GameMeta(
      createdAt: DateTime(2021, 1, 1),
      rated: true,
      perf: Perf.correspondence,
      speed: Speed.correspondence,
      variant: Variant.standard,
    ),
    source: GameSource.lobby,
    data: LightExportedGame(
      id: id,
      variant: Variant.standard,
      lastMoveAt: DateTime(2021, 1, 1),
      createdAt: DateTime(2021, 1, 1),
      perf: Perf.blitz,
      speed: Speed.blitz,
      rated: true,
      status: GameStatus.started,
      white: const Player(
        user: LightUser(id: UserId('whiteId'), name: 'White'),
        rating: 1500,
      ),
      black: const Player(
        user: LightUser(id: UserId('blackId'), name: 'Black'),
        rating: 1500,
      ),
      clock: (initial: const Duration(minutes: 2), increment: const Duration(seconds: 3)),
    ),
    steps: _makeSteps('e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2'),
    status: GameStatus.started,
    white: const Player(
      user: LightUser(id: UserId('whiteId'), name: 'White'),
      rating: 1500,
    ),
    black: const Player(
      user: LightUser(id: UserId('blackId'), name: 'Black'),
      rating: 1500,
    ),
    youAre: Side.white,
  );
});
