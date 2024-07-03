import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';

part 'eval.freezed.dart';
part 'eval.g.dart';

sealed class Eval {
  String get evalString;
  double winningChances(Side side);
}

/// The eval from an external engine, typically lichess server side stockfish.
@Freezed(fromJson: true, toJson: true)
class ExternalEval with _$ExternalEval implements Eval {
  const ExternalEval._();

  const factory ExternalEval({
    required int? cp,
    required int? mate,
    int? depth,
    UCIMove? bestMove,
    String? variation,
    ({String name, String comment})? judgment,
  }) = _ExternalEval;

  factory ExternalEval.fromJson(Map<String, dynamic> json) =>
      _$ExternalEvalFromJson(json);

  @override
  String get evalString => _evalString(cp, mate);

  @override
  double winningChances(Side side) => _toPov(side, _whiteWinningChances);

  double get _whiteWinningChances {
    if (mate != null) {
      return mateWinningChances(mate!);
    } else if (cp != null) {
      return cpWinningChances(cp!);
    } else {
      return 0;
    }
  }
}

double _toWhiteWinningChances(int? cp, int? mate) {
  if (mate != null) {
    return mateWinningChances(mate);
  } else if (cp != null) {
    return cpWinningChances(cp);
  } else {
    return 0;
  }
}

/// The eval from the client's own engine, typically stockfish.
@freezed
class ClientEval with _$ClientEval implements Eval {
  const ClientEval._();

  const factory ClientEval({
    required Position position,
    required int depth,
    required int nodes,
    required IList<PvData> pvs,
    required int millis,
    required int maxDepth,
    int? cp,
    int? mate,
  }) = _ClientEval;

  double get knps => nodes / millis;

  Move? get bestMove {
    final uci = pvs.firstOrNull?.moves.firstOrNull;
    if (uci == null) return null;
    return Move.fromUci(uci);
  }

  IList<MoveWithWinningChances> get bestMoves {
    return pvs
        .where((e) => e.moves.isNotEmpty)
        .map((e) => e.firstMoveWithWinningChances(position.turn))
        .whereNotNull()
        .toIList();
  }

  @override
  String get evalString => _evalString(cp, mate);

  /// The winning chances for the given [Side].
  ///
  /// 1  = infinitely winning
  /// -1 = infinitely losing
  @override
  double winningChances(Side side) => _toPov(side, _whiteWinningChances);

  double get _whiteWinningChances {
    return _toWhiteWinningChances(cp, mate);
  }
}

@freezed
class PvData with _$PvData {
  const PvData._();
  const factory PvData({
    required IList<UCIMove> moves,
    int? mate,
    int? cp,
  }) = _PvData;

  String get evalString => _evalString(cp, mate);

  Side? get winningSide {
    if (mate != null) {
      return mate! > 0 ? Side.white : Side.black;
    } else if (cp != null) {
      return cp! > 0 ? Side.white : Side.black;
    } else {
      return null;
    }
  }

  List<String> sanMoves(Position fromPosition) {
    Position pos = fromPosition;
    final List<String> res = [];
    for (final uciMove in moves.sublist(0, math.min(12, moves.length))) {
      // assume uciMove string is valid as it comes from stockfish
      final move = Move.fromUci(uciMove)!;
      if (pos.isLegal(move)) {
        final (newPos, san) = pos.makeSanUnchecked(move);
        res.add(san);
        pos = newPos;
      } else {
        break;
      }
    }
    return res;
  }

  MoveWithWinningChances? firstMoveWithWinningChances(Side sideToMove) {
    final uciMove = (moves.isNotEmpty) ? Move.fromUci(moves.first) : null;
    return (uciMove != null)
        ? (
            move: uciMove,
            winningChances:
                _toPov(sideToMove, _toWhiteWinningChances(cp, mate)),
          )
        : null;
  }
}

typedef MoveWithWinningChances = ({Move move, double winningChances});

double cpToPawns(int cp) => cp / 100;

int cpFromPawns(double pawns) => (pawns * 100).round();

double cpWinningChances(int cp) =>
    _rawWinningChances(math.min(math.max(-1000, cp), 1000));

double mateWinningChances(int mate) {
  final cp = (21 - math.min(10, mate.abs())) * 100;
  final signed = cp * (mate > 0 ? 1 : -1);
  return _rawWinningChances(signed);
}

double _toPov(Side side, double diff) => side == Side.white ? diff : -diff;

// https://github.com/lichess-org/lila/pull/11148
double _rawWinningChances(num cp) {
  // https://github.com/lichess-org/lila/pull/11148
  const multiplier = -0.00368208;
  return 2 / (1 + math.exp(multiplier * cp)) - 1;
}

String _evalString(int? cp, int? mate) {
  if (cp != null) {
    final e = cpToPawns(cp);
    return e > 0 ? '+${e.toStringAsFixed(1)}' : e.toStringAsFixed(1);
  } else if (mate != null) {
    return '#$mate';
  } else {
    return '-';
  }
}
