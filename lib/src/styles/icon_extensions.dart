import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/perf.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';

/// Presentation icons for the [Variant] enum, kept out of the model layer.
extension VariantIcon on Variant {
  IconData get icon => switch (this) {
    .standard => LichessIcons.crown,
    .chess960 => LichessIcons.die_six,
    .fromPosition => LichessIcons.feather,
    .antichess => LichessIcons.antichess,
    .kingOfTheHill => LichessIcons.flag,
    .threeCheck => LichessIcons.three_check,
    .atomic => LichessIcons.atom,
    .horde => LichessIcons.horde,
    .racingKings => LichessIcons.racing_kings,
    .crazyhouse => LichessIcons.h_square,
  };
}

/// Presentation icons for the [Perf] enum, kept out of the model layer.
extension PerfIcon on Perf {
  IconData get icon => switch (this) {
    .ultraBullet => LichessIcons.ultrabullet,
    .bullet => LichessIcons.bullet,
    .blitz => LichessIcons.blitz,
    .rapid => LichessIcons.rapid,
    .classical => LichessIcons.classical,
    .correspondence => LichessIcons.correspondence,
    .fromPosition => LichessIcons.feather,
    .chess960 => LichessIcons.die_six,
    .antichess => LichessIcons.antichess,
    .kingOfTheHill => LichessIcons.flag,
    .threeCheck => LichessIcons.three_check,
    .atomic => LichessIcons.atom,
    .horde => LichessIcons.horde,
    .racingKings => LichessIcons.racing_kings,
    .crazyhouse => LichessIcons.h_square,
    .puzzle => LichessIcons.target,
    .storm => LichessIcons.storm,
    .streak => LichessIcons.streak,
  };
}

/// Presentation icons for the [Speed] enum, kept out of the model layer.
extension SpeedIcon on Speed {
  IconData get icon => switch (this) {
    .ultraBullet => LichessIcons.ultrabullet,
    .bullet => LichessIcons.bullet,
    .blitz => LichessIcons.blitz,
    .rapid => LichessIcons.rapid,
    .classical => LichessIcons.classical,
    .correspondence => LichessIcons.correspondence,
  };
}
