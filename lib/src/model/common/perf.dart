import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/speed.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';

/// Represents a lichess rating perf item
enum Perf {
  ultraBullet('UltraBullet', 'Ultra', LichessIcons.ultrabullet),
  bullet('Bullet', 'Bullet', LichessIcons.bullet),
  blitz('Blitz', 'Blitz', LichessIcons.blitz),
  rapid('Rapid', 'Rapid', LichessIcons.rapid),
  classical('Classical', 'Classical', LichessIcons.classical),
  correspondence('Correspondence', 'Corresp.', LichessIcons.correspondence),
  fromPosition('From Position', 'From Pos.', LichessIcons.feather),
  chess960('Chess960', '960', LichessIcons.die_six),
  antichess('Antichess', 'Antichess', LichessIcons.antichess),
  kingOfTheHill('King of the Hill', 'KotH', LichessIcons.flag),
  threeCheck('Three-check', '3check', LichessIcons.three_check),
  atomic('Atomic', 'Atomic', LichessIcons.atom),
  horde('Horde', 'Horde', LichessIcons.horde),
  racingKings('Racing Kings', 'Racing', LichessIcons.racing_kings),
  crazyhouse('Crazyhouse', 'Crazy', LichessIcons.h_square),
  puzzle('Puzzle', 'Puzzle', LichessIcons.target),
  storm('Storm', 'Storm', LichessIcons.storm),
  streak('Streak', 'Streak', LichessIcons.streak);

  const Perf(this.title, this.shortTitle, this.icon);

  final String title;
  final String shortTitle;
  final IconData icon;

  String label(AppLocalizations l10n) {
    switch (this) {
      case Perf.ultraBullet:
        return l10n.ultraBullet;
      case Perf.bullet:
        return l10n.bullet;
      case Perf.blitz:
        return l10n.blitz;
      case Perf.rapid:
        return l10n.rapid;
      case Perf.classical:
        return l10n.classical;
      case Perf.correspondence:
        return l10n.correspondence;
      case Perf.fromPosition:
        return l10n.variantFromPosition;
      case Perf.chess960:
        return l10n.variantChess960;
      case Perf.antichess:
        return l10n.variantAntichess;
      case Perf.kingOfTheHill:
        return l10n.variantKingOfTheHill;
      case Perf.threeCheck:
        return l10n.variantThreeCheck;
      case Perf.atomic:
        return l10n.variantAtomic;
      case Perf.horde:
        return l10n.variantHorde;
      case Perf.racingKings:
        return l10n.variantRacingKings;
      case Perf.crazyhouse:
        return l10n.variantCrazyhouse;
      case Perf.puzzle:
        return l10n.puzzles;
      case Perf.storm:
      case Perf.streak:
        return title;
    }
  }

  String shortLabel(AppLocalizations l10n) {
    return shortTitle;
  }

  factory Perf.fromVariantAndSpeed(Variant variant, Speed speed) {
    switch (variant) {
      case Variant.standard:
        switch (speed) {
          case Speed.ultraBullet:
            return Perf.ultraBullet;
          case Speed.bullet:
            return Perf.bullet;
          case Speed.blitz:
            return Perf.blitz;
          case Speed.rapid:
            return Perf.rapid;
          case Speed.classical:
            return Perf.classical;
          case Speed.correspondence:
            return Perf.correspondence;
        }
      case Variant.chess960:
        return Perf.chess960;
      case Variant.fromPosition:
        return Perf.fromPosition;
      case Variant.antichess:
        return Perf.antichess;
      case Variant.kingOfTheHill:
        return Perf.kingOfTheHill;
      case Variant.threeCheck:
        return Perf.threeCheck;
      case Variant.atomic:
        return Perf.atomic;
      case Variant.horde:
        return Perf.horde;
      case Variant.racingKings:
        return Perf.racingKings;
      case Variant.crazyhouse:
        return Perf.crazyhouse;
    }
  }

  static final IMap<String, Perf> nameMap = IMap(Perf.values.asNameMap());
}

String _titleKey(String title) => title.toLowerCase().replaceAll(RegExp('[ -_]'), '');

final IMap<String, Perf> _lowerCaseTitleMap = Perf.nameMap.map(
  (key, value) => MapEntry(_titleKey(value.title), value),
);

extension PerfExtension on Pick {
  Perf asPerfOrThrow() {
    final value = this.required().value;
    if (value is Perf) {
      return value;
    }
    if (value is String) {
      if (Perf.nameMap.containsKey(value)) {
        return Perf.nameMap[value]!;
      }
      // handle lichess api inconsistencies
      final valueKey = _titleKey(value);
      if (_lowerCaseTitleMap.containsKey(valueKey)) {
        return _lowerCaseTitleMap[valueKey]!;
      }
      switch (valueKey) {
        case 'puzzles':
          return Perf.puzzle;
      }
    } else if (value is Map<String, dynamic>) {
      final perf = Perf.nameMap[value['key'] as String];
      if (perf != null) {
        return perf;
      }
    }
    throw PickException("value $value at $debugParsingExit can't be casted to Perf");
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
