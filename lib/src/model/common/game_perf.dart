import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';

enum GamePerf {
  ultraBullet,
  bullet,
  blitz,
  rapid,
  classical,
  correspondence,
  chess960,
  crazyhouse,
  antichess,
  atomic,
  horde,
  kingOfTheHill,
  racingKings,
  threeCheck
}

IMap<Perf, GamePerf> gamePerfMap = IMap(const {
  Perf.ultraBullet: GamePerf.ultraBullet,
  Perf.bullet: GamePerf.bullet,
  Perf.blitz: GamePerf.blitz,
  Perf.rapid: GamePerf.rapid,
  Perf.classical: GamePerf.classical,
  Perf.correspondence: GamePerf.correspondence,
  Perf.chess960: GamePerf.chess960,
  Perf.crazyhouse: GamePerf.crazyhouse,
  Perf.antichess: GamePerf.antichess,
  Perf.atomic: GamePerf.atomic,
  Perf.horde: GamePerf.horde,
  Perf.kingOfTheHill: GamePerf.kingOfTheHill,
  Perf.racingKings: GamePerf.racingKings,
  Perf.threeCheck: GamePerf.threeCheck,
});
