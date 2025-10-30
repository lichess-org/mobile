import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';

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

  static final IMap<String, TvChannel> nameMap = IMap(
    TvChannel.values.asNameMap(),
  );
}

extension TvChannelExtension on Pick {
  TvChannel asTvChannelOrThrow() {
    final value = this.required().value;
    if (value is TvChannel) {
      return value;
    }
    if (value is String) {
      if (TvChannel.nameMap.containsKey(value)) {
        return TvChannel.nameMap[value]!;
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to TvChannel",
    );
  }

  TvChannel? asTvChannelOrNull() {
    if (value == null) return null;
    try {
      return asTvChannelOrThrow();
    } catch (_) {
      return null;
    }
  }
}
