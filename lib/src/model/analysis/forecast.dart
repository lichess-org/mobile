import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';

part 'forecast.freezed.dart';
part 'forecast.g.dart';

const kMaxForecastPlies = 30;

/// Contains the current set of conditional premoves ("forecast") in a correspondence game.
///
/// Most logic is based on ForecastCtrl from lichobile
@Freezed(fromJson: true, toJson: true)
sealed class Forecast with _$Forecast {
  const Forecast._();

  const factory Forecast({required bool onMyTurn, required IList<UciPath> lines}) = _Forecast;

  /// Two forecasts are considered to collide if the current player cannot theoretically play both of them.
  /// For example, for black, 1. e4 e5 and 1. e4 c5 are colliding forecasts, as black cannot play both e5 and c5
  /// in response to e4. However, for white, 1. e4 e5 and 1. e4 c5 are not colliding forecasts.
  ///
  /// If it is the current player's turn, divergences on the first forecasted move are not considered to collide.
  /// For example, 2. e4 and 2. d4 are not collisions on white's turn.
  bool _collides(UciPath lhs, UciPath rhs) {
    for (var i = 0; i < min(lhs.size, rhs.size); i++) {
      if (lhs[i] != rhs[i]) {
        if (onMyTurn) {
          return i != 0 && i.isEven;
        }
        return i.isOdd;
      }
    }

    // If the two forecast lines are the same up to the size of the smaller one, they are not considered
    // to be contradictory, but the smaller is considered a prefix of the larger
    return false;
  }

  bool _isLongEnough(UciPath path) {
    return path.size >= (onMyTurn ? 1 : 2);
  }

  /// Returns the given line forecast steps, truncated to a reasonable length and ending with the viewing player's move.
  UciPath _truncate(UciPath path) {
    final requiredPlyMod = onMyTurn ? 1 : 0;

    // must end with player move
    return (path.size % 2 != requiredPlyMod ? path.penultimate : path).truncate(kMaxForecastPlies);
  }

  /// Returns whether the given path is part of a new candidate premove line that is not a prefix of the other saved conditional premove lines.
  bool isCandidate(UciPath path) {
    final forecastCandidate = _truncate(path);
    if (!_isLongEnough(forecastCandidate)) {
      return false;
    }

    return lines.none((line) => line.contains(forecastCandidate));
  }

  @useResult
  Forecast add(UciPath newLine) {
    final candidate = _truncate(newLine);
    if (!isCandidate(candidate)) {
      return this;
    }
    return copyWith(
      lines: lines
          .removeWhere((line) => candidate.contains(line) || _collides(line, candidate))
          .insert(0, candidate),
    );
  }

  @useResult
  Forecast remove(UciPath line) {
    return copyWith(lines: lines.remove(line));
  }

  IList<UciPath> linesStartingWith(Move move) =>
      lines.where((line) => line.head == UciCharPair.fromMove(move)).toIList();

  @useResult
  Forecast playMove(Move move) {
    return copyWith(
      lines: linesStartingWith(
        move,
      ).map((line) => line.tail).whereNot((line) => line.isEmpty).toIList(),
      onMyTurn: !onMyTurn,
    );
  }

  String toApiForecast(ViewNode currentNode) => jsonEncode(
    lines
        .map(
          (line) => currentNode
              .branchesOn(line)
              .map(
                (branch) => {
                  'ply': branch.position.ply,
                  'uci': branch.sanMove.move.uci,
                  'san': branch.sanMove.san,
                  'fen': branch.position.fen,
                },
              )
              .toList(growable: false),
        )
        .toList(growable: false),
  );
}
