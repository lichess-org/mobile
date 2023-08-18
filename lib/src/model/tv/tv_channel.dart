import 'package:flutter/widgets.dart';

import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

enum TvChannel {
  best('Top Rated', LichessIcons.crown),
  bullet('Bullet', LichessIcons.bullet),
  blitz('Blitz', LichessIcons.blitz),
  rapid('Rapid', LichessIcons.rapid),
  classical('Classical', LichessIcons.classical),
  chess960('Chess960', LichessIcons.die_six),
  kingOfTheHill('King of the Hill', LichessIcons.flag),
  // threeCheck('Three Check', LichessIcons.three_check),
  antichess('Antichess', LichessIcons.antichess),
  // atomic('Atomic', LichessIcons.atom),
  horde('Horde', LichessIcons.horde),
  racingKings('Racing Kings', LichessIcons.racing_kings),
  // crazyhouse('Crazyhouse', LichessIcons.h_square),
  ultraBullet('UltraBullet', LichessIcons.ultrabullet),
  bot('Bot', LichessIcons.cogs),
  computer('Computer', LichessIcons.cogs);

  const TvChannel(this.label, this.icon);

  final String label;
  final IconData icon;

  static final IMap<String, TvChannel> nameMap =
      IMap(TvChannel.values.asNameMap());
}
