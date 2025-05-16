import 'package:dartchess/dartchess.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';

part 'uci.freezed.dart';
part 'uci.g.dart';

/// UciCharPair from scalachess
@Freezed(fromJson: true, toJson: true, toStringOverride: false)
sealed class UciCharPair with _$UciCharPair {
  const UciCharPair._();

  const factory UciCharPair(String a, String b) = _UciCharPair;

  factory UciCharPair.fromStringId(String id) {
    if (id.length != 2) {
      throw ArgumentError('Invalid id $id');
    }
    return UciCharPair(id[0], id[1]);
  }

  /// Creates a UciCharPair from a UCI move.
  ///
  /// Throws an [ArgumentError] if the move is invalid.
  factory UciCharPair.fromUci(String uci) {
    final move = Move.parse(uci);
    if (move == null) {
      throw ArgumentError('Invalid uci $uci');
    }
    return UciCharPair.fromMove(move);
  }

  factory UciCharPair.fromMove(Move move) => switch (move) {
    NormalMove(from: final f, to: final t, promotion: final p) => UciCharPair(
      String.fromCharCode(35 + f),
      String.fromCharCode(p != null ? 35 + 64 + 8 * _promotionRoles.indexOf(p) + t.file : 35 + t),
    ),
    DropMove(to: final t, role: final r) => UciCharPair(
      String.fromCharCode(35 + t),
      String.fromCharCode(35 + 64 + 8 * 5 + _dropRoles.indexOf(r)),
    ),
  };

  factory UciCharPair.fromJson(Map<String, dynamic> json) => _$UciCharPairFromJson(json);

  @override
  String toString() => '$a$b';
}

const _promotionRoles = [Role.queen, Role.rook, Role.bishop, Role.knight, Role.king];

const _dropRoles = [Role.queen, Role.rook, Role.bishop, Role.knight, Role.pawn];

/// Compact representation of a path to a game node made from concatenated
/// UciCharPair strings.
@Freezed(fromJson: true, toJson: true)
sealed class UciPath with _$UciPath {
  const UciPath._();

  const factory UciPath(String value) = _UciPath;

  factory UciPath.fromId(UciCharPair id) => UciPath(id.toString());
  factory UciPath.fromIds(Iterable<UciCharPair> ids) =>
      UciPath(ids.map((id) => id.toString()).join(''));

  factory UciPath.fromNodeList(Iterable<Branch> nodeList) {
    final path = StringBuffer();
    for (final node in nodeList) {
      path.write(node.id);
    }
    return UciPath(path.toString());
  }

  factory UciPath.join(UciPath a, UciPath b) => UciPath(a.value + b.value);

  /// Creates a UciPath from a list of UCI moves.
  ///
  /// Throws an [ArgumentError] if any of the moves is invalid.
  factory UciPath.fromUciMoves(Iterable<UCIMove> moves) {
    final path = StringBuffer();
    for (final move in moves) {
      path.write(UciCharPair.fromUci(move));
    }
    return UciPath(path.toString());
  }

  static const empty = UciPath('');

  UciPath operator +(UciCharPair id) => UciPath(value + id.toString());

  bool contains(UciPath other) => value.startsWith(other.value);

  int get size => value.length ~/ 2;

  UciCharPair? get head => value.isEmpty ? null : UciCharPair(value[0], value[1]);

  UciCharPair? get last =>
      value.isEmpty ? null : UciCharPair(value[value.length - 2], value[value.length - 1]);

  UciPath get tail => value.isEmpty ? UciPath.empty : UciPath(value.substring(2));

  UciPath get penultimate =>
      value.isEmpty ? UciPath.empty : UciPath(value.substring(0, value.length - 2));

  bool get isEmpty => value.isEmpty;

  factory UciPath.fromJson(Map<String, dynamic> json) => _$UciPathFromJson(json);
}
