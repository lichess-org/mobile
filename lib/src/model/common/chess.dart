import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartchess/dartchess.dart';
import 'package:deep_pick/deep_pick.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';

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

  static Variant fromRules(Rules rules) {
    switch (rules) {
      case Rules.chess:
        return Variant.standard;
      case Rules.antichess:
        return Variant.antichess;
      case Rules.kingofthehill:
        return Variant.kingOfTheHill;
      case Rules.threecheck:
        return Variant.threeCheck;
      case Rules.atomic:
        return Variant.atomic;
      case Rules.horde:
        return Variant.horde;
      case Rules.racingKings:
        return Variant.racingKings;
      case Rules.crazyhouse:
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
