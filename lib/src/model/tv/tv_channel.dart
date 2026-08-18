import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';

enum TvChannel {
  best(LichessIcons.crown),
  bullet(LichessIcons.bullet),
  blitz(LichessIcons.blitz),
  rapid(LichessIcons.rapid),
  classical(LichessIcons.classical),
  chess960(LichessIcons.die_six),
  kingOfTheHill(LichessIcons.flag),
  threeCheck(LichessIcons.three_check),
  antichess(LichessIcons.antichess),
  atomic(LichessIcons.atom),
  horde(LichessIcons.horde),
  racingKings(LichessIcons.racing_kings),
  crazyhouse(LichessIcons.h_square),
  ultraBullet(LichessIcons.ultrabullet),
  bot(LichessIcons.cogs),
  computer(LichessIcons.cogs);

  const TvChannel(this.icon);

  final IconData icon;

  String label(AppLocalizations l10n) {
    switch (this) {
      case TvChannel.best:
        return l10n.topGames;
      case TvChannel.bullet:
        return l10n.bullet;
      case TvChannel.blitz:
        return l10n.blitz;
      case TvChannel.rapid:
        return l10n.rapid;
      case TvChannel.classical:
        return l10n.classical;
      case TvChannel.chess960:
        return l10n.variantChess960;
      case TvChannel.kingOfTheHill:
        return l10n.variantKingOfTheHill;
      case TvChannel.threeCheck:
        return l10n.variantThreeCheck;
      case TvChannel.antichess:
        return l10n.variantAntichess;
      case TvChannel.atomic:
        return l10n.variantAtomic;
      case TvChannel.horde:
        return l10n.variantHorde;
      case TvChannel.racingKings:
        return l10n.variantRacingKings;
      case TvChannel.crazyhouse:
        return l10n.variantCrazyhouse;
      case TvChannel.ultraBullet:
        return l10n.ultraBullet;
      case TvChannel.bot:
        return l10n.onlineBots;
      case TvChannel.computer:
        return l10n.computer;
    }
  }

  static final IMap<String, TvChannel> nameMap = IMap(TvChannel.values.asNameMap());
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
    throw PickException("value $value at $debugParsingExit can't be casted to TvChannel");
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
