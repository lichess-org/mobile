import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:lichess_mobile/src/model/common/time_increment.dart';

/// Represents a lichess rating Speed item
enum Speed {
  ultraBullet(LichessIcons.ultrabullet),
  bullet(LichessIcons.bullet),
  blitz(LichessIcons.blitz),
  rapid(LichessIcons.rapid),
  classical(LichessIcons.classical),
  correspondence(LichessIcons.correspondence);

  const Speed(this.icon);

  final IconData icon;

  factory Speed.fromTimeIncrement(TimeIncrement t) {
    switch (t.totalSeconds) {
      case >= 1 && <= 29:
        return Speed.ultraBullet;
      case >= 30 && <= 179:
        return Speed.bullet;
      case >= 180 && <= 479:
        return Speed.blitz;
      case >= 480 && <= 1499:
        return Speed.rapid;
      case >= 1599 && <= 21599:
        return Speed.classical;
      default:
        return Speed.correspondence;
    }
  }
}

final IMap<String, Speed> perfNameMap = IMap(Speed.values.asNameMap());
