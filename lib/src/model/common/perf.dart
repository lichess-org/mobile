import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:deep_pick/deep_pick.dart';

/// Represents a lichess rating perf item
enum Perf {
  ultraBullet('UltraBullet', 'Ultra', LichessIcons.ultrabullet),
  bullet('Bullet', 'Bullet', LichessIcons.bullet),
  blitz('Blitz', 'Blitz', LichessIcons.blitz),
  rapid('Rapid', 'Rapid', LichessIcons.rapid),
  classical('Classical', 'Classical', LichessIcons.classical),
  correspondence('Correspondence', 'Corresp.', LichessIcons.correspondence),
  fromPosition('From Position', 'From Pos.', LichessIcons.feather),
  chess960('Chess 960', '960', LichessIcons.die_six),
  antichess('Antichess', 'Antichess', LichessIcons.antichess),
  kingOfTheHill('King Of The Hill', 'KotH', LichessIcons.flag),
  threeCheck('Three-check', '3check', LichessIcons.three_check),
  atomic('Atomic', 'Atomic', LichessIcons.atom),
  horde('Horde', 'Horde', LichessIcons.horde),
  racingKings('Racing Kings', 'Racing', LichessIcons.racing_kings),
  crazyhouse('Crazyhouse', 'Crazy', LichessIcons.h_square),
  puzzle('Puzzle', 'Puzzle', LichessIcons.target),
  storm('Storm', 'Storm', LichessIcons.storm);

  const Perf(this.title, this.shortTitle, this.icon);

  final String title;
  final String shortTitle;
  final IconData icon;
}

final IMap<String, Perf> perfNameMap = IMap(Perf.values.asNameMap());

extension PerfExtension on Pick {
  Perf asPerfOrThrow() {
    final value = this.required().value;
    if (value is Perf) {
      return value;
    }
    if (value is String) {
      if (perfNameMap.containsKey(value)) {
        return perfNameMap[value]!;
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Perf",
    );
  }

  Perf? asPerfOrNull() {
    if (value == null) return null;
    try {
      return asPerfOrThrow();
    } catch (_) {
      return null;
    }
  }
}
