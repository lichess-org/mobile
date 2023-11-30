import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';

part 'chess.freezed.dart';
part 'chess.g.dart';

/// Move represented with UCI notation
typedef UCIMove = String;

/// Represents a [Move] with its associated SAN.
@Freezed(fromJson: true, toJson: true)
class SanMove with _$SanMove {
  const SanMove._();
  const factory SanMove(
    String san,
    @JsonKey(fromJson: _moveFromJson, toJson: _moveToJson) Move move,
  ) = _SanMove;

  factory SanMove.fromJson(Map<String, dynamic> json) =>
      _$SanMoveFromJson(json);

  bool get isCheck => san.contains('+');
  bool get isCapture => san.contains('x');
}

String _moveToJson(Move move) => move.uci;
// assume we are serializing only valid uci strings
Move _moveFromJson(String uci) => Move.fromUci(uci)!;

/// Alternative castling uci notations.
const altCastles = {
  'e1a1': 'e1c1',
  'e1h1': 'e1g1',
  'e8a8': 'e8c8',
  'e8h8': 'e8g8',
};

const ISet<Variant> supportedVariants = ISetConst({
  Variant.standard,
  Variant.chess960,
  Variant.fromPosition,
  Variant.antichess,
  Variant.kingOfTheHill,
  Variant.threeCheck,
  Variant.racingKings,
  Variant.horde,
});

enum Variant {
  standard('Standard', LichessIcons.crown),
  chess960('Chess960', LichessIcons.die_six),
  fromPosition('From Position', LichessIcons.feather),
  antichess('Antichess', LichessIcons.antichess),
  kingOfTheHill('King of the Hill', LichessIcons.flag),
  threeCheck('Three Check', LichessIcons.three_check),
  atomic('Atomic', LichessIcons.atom),
  horde('Horde', LichessIcons.horde),
  racingKings('Racing Kings', LichessIcons.racing_kings),
  crazyhouse('Crazyhouse', LichessIcons.h_square);

  const Variant(this.label, this.icon);

  final String label;
  final IconData icon;

  bool get isSupported => supportedVariants.contains(this);

  static final IMap<String, Variant> nameMap = IMap(values.asNameMap());

  static Variant fromRule(Rule rule) {
    switch (rule) {
      case Rule.chess:
        return Variant.standard;
      case Rule.antichess:
        return Variant.antichess;
      case Rule.kingofthehill:
        return Variant.kingOfTheHill;
      case Rule.threecheck:
        return Variant.threeCheck;
      case Rule.atomic:
        return Variant.atomic;
      case Rule.horde:
        return Variant.horde;
      case Rule.racingKings:
        return Variant.racingKings;
      case Rule.crazyhouse:
        return Variant.crazyhouse;
    }
  }

  /// Returns the initial position for this [Variant].
  ///
  /// Will throw an [ArgumentError] if called on [Variant.chess960] or [Variant.fromPosition].
  Position get initialPosition {
    switch (this) {
      case Variant.standard:
        return Chess.initial;
      case Variant.chess960:
      case Variant.fromPosition:
        throw ArgumentError('This variant has no defined initial position!');
      case Variant.antichess:
        return Antichess.initial;
      case Variant.kingOfTheHill:
        return KingOfTheHill.initial;
      case Variant.threeCheck:
        return ThreeCheck.initial;
      case Variant.atomic:
        return Atomic.initial;
      case Variant.crazyhouse:
        return Crazyhouse.initial;
      case Variant.horde:
        return Horde.initial;
      case Variant.racingKings:
        return RacingKings.initial;
    }
  }

  Rule get rule {
    switch (this) {
      case Variant.standard:
      case Variant.chess960:
      case Variant.fromPosition:
        return Rule.chess;
      case Variant.antichess:
        return Rule.antichess;
      case Variant.kingOfTheHill:
        return Rule.kingofthehill;
      case Variant.threeCheck:
        return Rule.threecheck;
      case Variant.atomic:
        return Rule.atomic;
      case Variant.horde:
        return Rule.horde;
      case Variant.racingKings:
        return Rule.racingKings;
      case Variant.crazyhouse:
        return Rule.crazyhouse;
    }
  }
}

/// Represents a chess opening.
sealed class Opening {
  String get eco;
  String get name;
}

@freezed
class LightOpening with _$LightOpening implements Opening {
  const LightOpening._();
  const factory LightOpening({
    required String eco,
    required String name,
  }) = _LightOpening;
}

@freezed
class FullOpening with _$FullOpening implements Opening {
  const FullOpening._();
  const factory FullOpening({
    required String eco,
    required String name,
    required String fen,
    required String pgnMoves,
    required String uciMoves,
  }) = _FullOpening;
}

extension ChessExtension on Pick {
  Move asUciMoveOrThrow() {
    final value = this.required().value;
    if (value is Move) {
      return value;
    }
    if (value is String) {
      final move = Move.fromUci(value);
      if (move != null) {
        return move;
      } else {
        throw PickException(
          "value $value at $debugParsingExit can't be casted to Move: invalid UCI string.",
        );
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Move",
    );
  }

  Move? asUciMoveOrNull() {
    if (value == null) return null;
    try {
      return asUciMoveOrThrow();
    } catch (_) {
      return null;
    }
  }

  Side asSideOrThrow() {
    final value = this.required().value;
    if (value is Side) {
      return value;
    }
    if (value is String) {
      return value == 'white'
          ? Side.white
          : value == 'black'
              ? Side.black
              : throw PickException(
                  "value $value at $debugParsingExit can't be casted to Side: invalid string.",
                );
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Side",
    );
  }

  Side? asSideOrNull() {
    if (value == null) return null;
    try {
      return asSideOrThrow();
    } catch (_) {
      return null;
    }
  }

  Variant asVariantOrThrow() {
    final value = this.required().value;
    if (value is Variant) {
      return value;
    }
    if (value is String) {
      final variant = Variant.nameMap[value];
      if (variant != null) {
        return variant;
      }
    } else if (value is Map<String, dynamic>) {
      final variant = Variant.nameMap[value['key'] as String];
      if (variant != null) {
        return variant;
      }
    }
    throw PickException(
      "value $value at $debugParsingExit can't be casted to Variant",
    );
  }

  Variant? asVariantOrNull() {
    if (value == null) return null;
    try {
      return asVariantOrNull();
    } catch (_) {
      return null;
    }
  }
}
