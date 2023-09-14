import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

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

// crazyhouse is implemented in dartchess, but not supported by the ui yet
const ISet<Variant> supportedVariants = ISetConst({
  Variant.standard,
  Variant.chess960,
  Variant.fromPosition,
  Variant.antichess,
  Variant.kingOfTheHill,
  Variant.threeCheck,
  Variant.atomic,
  Variant.racingKings,
  Variant.horde,
});

enum Variant {
  standard('Standard'),
  chess960('Chess960'),
  fromPosition('From Position'),
  antichess('Antichess'),
  kingOfTheHill('King of the Hill'),
  threeCheck('Three Check'),
  atomic('Atomic'),
  horde('Horde'),
  racingKings('Racing Kings'),
  crazyhouse('Crazyhouse');

  const Variant(this.label);

  final String label;

  bool get isSupported => supportedVariants.contains(this);

  static final IMap<String, Variant> nameMap = IMap(values.asNameMap());

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

  Rules get rules {
    switch (this) {
      case Variant.standard:
      case Variant.chess960:
      case Variant.fromPosition:
        return Rules.chess;
      case Variant.antichess:
        return Rules.antichess;
      case Variant.kingOfTheHill:
        return Rules.kingofthehill;
      case Variant.threeCheck:
        return Rules.threecheck;
      case Variant.atomic:
        return Rules.atomic;
      case Variant.horde:
        return Rules.horde;
      case Variant.racingKings:
        return Rules.racingKings;
      case Variant.crazyhouse:
        return Rules.crazyhouse;
    }
  }
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
      return value == 'white' ? Side.white : Side.black;
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
