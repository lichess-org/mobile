import 'package:flutter/widgets.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/styles/lichess_icons.dart';

enum TvChannel {
  topRated('Top Rated', LichessIcons.crown),
  classical('Classical', LichessIcons.classical),
  bullet('Bullet', LichessIcons.bullet),
  blitz('Blitz', LichessIcons.blitz),
  rapid('Rapid', LichessIcons.rapid),
  chess960('Chess960', LichessIcons.die_six),
  antichess('Antichess', LichessIcons.antichess),
  kingOfTheHill('King Of The Hill', LichessIcons.flag),
  threeCheck('Three-check', LichessIcons.three_check),
  atomic('Atomic', LichessIcons.atom),
  horde('Horde', LichessIcons.horde),
  racingKings('Racing Kings', LichessIcons.racing_kings),
  crazyhouse('Crazyhouse', LichessIcons.h_square),
  bot('Bot', LichessIcons.cogs),
  computer('Computer', LichessIcons.cogs);

  const TvChannel(this.title, this.icon);

  final String title;
  final IconData icon;

  static final IMap<String, TvChannel> titleMap =
      IMap({for (final value in TvChannel.values) value.title: value});
}
