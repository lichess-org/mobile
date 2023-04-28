import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

part 'chess.freezed.dart';
part 'chess.g.dart';

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
  standard,
  chess960,
  fromPosition,
  antichess,
  kingOfTheHill,
  threeCheck,
  atomic,
  horde,
  racingKings,
  crazyhouse;

  bool get isSupported => supportedVariants.contains(this);

  /// Returns the initial position for this [Variant].
  ///
  /// Will throw an [ArgumentError] if called on [Variant.fromPosition].
  Position get initialPosition {
    switch (this) {
      case Variant.standard:
      case Variant.chess960:
        return Chess.initial;
      case Variant.fromPosition:
        throw ArgumentError('Check the variant is not `fromPosition` before!');
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
