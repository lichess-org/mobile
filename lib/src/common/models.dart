import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'models.freezed.dart';
part 'models.g.dart';

/// Move represented with UCI notation
typedef UCIMove = String;

/// Represents a [Move] with its associated SAN.
@Freezed(fromJson: true, toJson: true)
class SanMove with _$SanMove {
  const factory SanMove(
    String san,
    @JsonKey(fromJson: _moveFromJson, toJson: _moveToJson) Move move,
  ) = _SanMove;

  factory SanMove.fromJson(Map<String, dynamic> json) =>
      _$SanMoveFromJson(json);
}

String _moveToJson(Move move) => move.uci;
// assume we are serializing only valid uci strings
Move _moveFromJson(String uci) => Move.fromUci(uci)!;

/// Represents a lichess rating perf item
enum Perf {
  ultraBullet('UltraBullet', 'Ultra', LichessIcons.ultrabullet),
  bullet('Bullet', 'Bullet', LichessIcons.bullet),
  blitz('Blitz', 'Blitz', LichessIcons.blitz),
  rapid('Rapid', 'Rapid', LichessIcons.rapid),
  classical('Classical', 'Classical', LichessIcons.classical),
  correspondence('Correspondence', 'Corresp.', LichessIcons.correspondence),
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

/// A pair of time and increment used as game clock
@immutable
class TimeIncrement {
  const TimeIncrement(this.time, this.increment);

  /// Clock initial time in minutes
  final int time;

  /// Clock increment in seconds
  final int increment;

  static TimeIncrement? fromString(String str) {
    try {
      final nums = str.split('+').map(int.parse).toList();
      return TimeIncrement(nums.first, nums[1]);
    } catch (_) {
      return null;
    }
  }

  TimeIncrement.fromJson(Map<String, dynamic> json)
      : time = json['time'] as int,
        increment = json['increment'] as int;

  Map<String, dynamic> toJson() => {
        'time': time,
        'increment': increment,
      };

  String get display => '$time + $increment';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeIncrement &&
          runtimeType == other.runtimeType &&
          time == other.time &&
          increment == other.increment;

  @override
  int get hashCode => Object.hash(time, increment);

  @override
  String toString() => '$time+$increment';
}

/// Default game clock choice of lichess
enum DefaultGameClock {
  blitz3_0(TimeIncrement(3, 0), Perf.blitz),
  blitz3_2(TimeIncrement(3, 2), Perf.blitz),
  blitz5_0(TimeIncrement(5, 0), Perf.blitz),
  blitz5_3(TimeIncrement(5, 3), Perf.blitz),
  rapid10_0(TimeIncrement(10, 0), Perf.rapid),
  rapid10_5(TimeIncrement(10, 5), Perf.rapid),
  rapid15_10(TimeIncrement(15, 10), Perf.rapid),
  classical30_0(TimeIncrement(30, 0), Perf.classical),
  classical30_20(TimeIncrement(30, 20), Perf.classical);

  const DefaultGameClock(this.value, this.perf);
  final TimeIncrement value;
  final Perf perf;
}
