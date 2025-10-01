import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/model/correspondence/offline_correspondence_game.dart';
import 'package:lichess_mobile/src/model/game/exported_game.dart';
import 'package:lichess_mobile/src/model/game/game.dart';
import 'package:lichess_mobile/src/model/game/game_status.dart';
import 'package:lichess_mobile/src/model/game/material_diff.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/model/user/user.dart';

List<ExportedGame> generateExportedGames({int count = 100, String? username}) {
  return List.generate(count, (index) {
    final id = GameId('game${index.toString().padLeft(4, '0')}');
    final whitePlayer = Player(
      user: username != null && index.isEven
          ? LightUser(id: UserId.fromUserName(username), name: username)
          : username != null
          ? const LightUser(id: UserId('whiteId'), name: 'White')
          : null,
      rating: username != null ? 1500 : null,
    );
    final blackPlayer = Player(
      user: username != null && index.isOdd
          ? LightUser(id: UserId.fromUserName(username), name: username)
          : username != null
          ? const LightUser(id: UserId('blackId'), name: 'Black')
          : null,
      rating: username != null ? 1500 : null,
    );
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
        white: whitePlayer,
        black: blackPlayer,
        clock: (initial: const Duration(minutes: 2), increment: const Duration(seconds: 3)),
      ),
      steps: makeSteps('e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2'),
      status: GameStatus.started,
      white: whitePlayer,
      black: blackPlayer,
      youAre: username != null
          ? index.isEven
                ? Side.white
                : Side.black
          : null,
    );
  });
}

IList<GameStep> makeSteps(String pgn) {
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

const offlineCorrespondenceGameId = GameId('g2bzFol8');
final offlineCorrespondenceGame = OfflineCorrespondenceGame(
  id: offlineCorrespondenceGameId,
  meta: GameMeta(
    createdAt: DateTime(2021, 1, 1),
    rated: true,
    perf: Perf.correspondence,
    speed: Speed.correspondence,
    variant: Variant.standard,
  ),
  fullId: const GameFullId('g2bzFol8fgty'),
  steps: makeSteps('e4 Nc6 Bc4 e6 a3 g6 Nf3 Bg7 c3 Nge7 d3 O-O Be3 Na5 Ba2 b6 Qd2'),
  clock: const CorrespondenceClockData(
    white: Duration(days: 2, hours: 23, minutes: 59),
    black: Duration(days: 3),
  ),
  rated: true,
  status: GameStatus.started,
  variant: Variant.standard,
  speed: Speed.correspondence,
  perf: Perf.classical,
  white: const Player(
    user: LightUser(id: UserId('whiteId'), name: 'White'),
    rating: 1500,
  ),
  black: const Player(
    user: LightUser(id: UserId('blackId'), name: 'Black'),
    rating: 1500,
  ),
  youAre: Side.white,
  daysPerTurn: 3,
);
