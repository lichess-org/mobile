import 'dart:math' as math;

import 'package:chessground/chessground.dart';
import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lichess_mobile/src/binding.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:logging/logging.dart';

part 'eval.freezed.dart';
part 'eval.g.dart';

final _logger = Logger('Eval');

/// Base class for evals.
sealed class Eval {
  const Eval();

  /// The centipawn score.
  int? get cp;

  /// The mate score.
  int? get mate;

  /// The string to display the eval
  String get evalString => _evalString(cp, mate);

  /// The winning chances for the given [Side].
  ///
  /// 1  = infinitely winning
  /// -1 = infinitely losing
  double winningChances(Side side) => _toPov(side, _toWhiteWinningChances(cp, mate));

  /// The difference, in winning chances, between two [Eval]s.
  ///
  /// 1  = e1 is infinitely better than e2
  /// -1 = e1 is infinitely worse  than e2
  static double winningChancesPovDiff(Side side, Eval e1, Eval e2) =>
      (e1.winningChances(side) - e2.winningChances(side)) / 2;
}

/// The eval from the client side, either from the cloud or the local engine.
sealed class ClientEval extends Eval {
  const ClientEval({
    required this.position,
    required this.depth,
    required this.nodes,
    required this.pvs,
  });

  /// The position for which the eval was computed.
  final Position position;

  /// The depth of the search.
  final int depth;

  /// The number of nodes searched.
  final int nodes;

  /// The principal variations.
  final IList<PvData> pvs;

  /// The best move.
  Move? get bestMove {
    final uci = pvs.firstOrNull?.moves.firstOrNull;
    if (uci == null) return null;
    return Move.parse(uci);
  }

  /// The best moves with their winning chances.
  IList<MoveWithWinningChances> get bestMoves => pvs
      .where((e) => e.moves.isNotEmpty)
      .map((e) => e._firstMoveWithWinningChances(position.turn))
      .nonNulls
      .sorted((a, b) => b.winningChances.compareTo(a.winningChances))
      .toIList();
}

/// The eval coming from other Lichess clients, served from the network.
@freezed
// ignore: freezed_missing_private_empty_constructor
sealed class CloudEval extends ClientEval with _$CloudEval {
  const CloudEval._({
    required super.position,
    required super.depth,
    required super.nodes,
    required super.pvs,
  });

  const factory CloudEval({
    required Position position,
    required int depth,
    required int nodes,
    required IList<PvData> pvs,
  }) = _CloudEval;

  @override
  int? get cp => pvs[0].cp;

  @override
  int? get mate => pvs[0].mate;
}

/// The eval from the local engine.
@freezed
// ignore: freezed_missing_private_empty_constructor
sealed class LocalEval extends ClientEval with _$LocalEval {
  const LocalEval._({
    required super.position,
    required super.depth,
    required super.nodes,
    required super.pvs,
  });

  const factory LocalEval({
    required Position position,
    required int depth,
    required int nodes,
    required IList<PvData> pvs,
    required int millis,
    required Duration searchTime,
    required bool threatMode,
    int? cp,
    int? mate,
  }) = _LocalEval;

  double get knps => nodes / millis;

  bool isBetter(LocalEval other) =>
      depth > other.depth || (depth == other.depth && nodes > other.nodes);
}

/// The eval from an external engine, typically Lichess server side Stockfish.
@Freezed(fromJson: true, toJson: true)
sealed class ExternalEval extends Eval with _$ExternalEval {
  const ExternalEval._();

  const factory ExternalEval({
    required int? cp,
    required int? mate,
    int? depth,
    UCIMove? bestMove,
    String? variation,
    ({String name, String comment})? judgment,
  }) = _ExternalEval;

  /// Whether this eval has a valid cp or mate value.
  ///
  /// While the server analysis is still pending, the eval may be null.
  bool get hasEval => cp != null || mate != null;

  factory ExternalEval.fromPgnEval(PgnEvaluation eval) {
    return ExternalEval(
      cp: eval.pawns != null ? cpFromPawns(eval.pawns!) : null,
      mate: eval.mate,
      depth: eval.depth,
    );
  }

  factory ExternalEval.fromJson(Map<String, dynamic> json) => _$ExternalEvalFromJson(json);
}

@freezed
sealed class PvData with _$PvData {
  const PvData._();
  const factory PvData({required IList<UCIMove> moves, int? mate, int? cp}) = _PvData;

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
      final move = Move.parse(uciMove);
      if (move == null) {
        LichessBinding.instance.firebaseCrashlytics.recordError(
          'Invalid UCI move: "$uciMove" in PV: $moves for position: ${pos.fen}',
          StackTrace.current,
          reason: 'Failed to parse UCI move from PV',
        );
        _logger.warning('Invalid UCI move: "$uciMove" in PV: $moves for position: ${pos.fen}');
        break;
      }
      if (!pos.isLegal(move)) {
        LichessBinding.instance.firebaseCrashlytics.recordError(
          'Illegal move: $uciMove in PV: $moves for position: ${pos.fen}',
          StackTrace.current,
          reason: 'Move from PV is not legal in the given position',
        );
        _logger.warning('Illegal move: $uciMove in PV: $moves for position: ${pos.fen}');
        break;
      }
      final (newPos, san) = pos.makeSanUnchecked(move);
      res.add(san);
      pos = newPos;
    }
    return res;
  }

  MoveWithWinningChances? _firstMoveWithWinningChances(Side sideToMove) {
    final uciMove = (moves.isNotEmpty) ? Move.parse(moves.first) : null;
    return (uciMove != null)
        ? (move: uciMove, winningChances: _toPov(sideToMove, _toWhiteWinningChances(cp, mate)))
        : null;
  }
}

typedef MoveWithWinningChances = ({Move move, double winningChances});

ISet<Shape> moveShapes({
  required Move move,
  required Color color,
  required Side sideToMove,
  required PieceAssets pieceAssets,
  double scale = 1.0,
}) => switch (move) {
  NormalMove(from: _, to: _, promotion: final promRole) => {
    Arrow(color: color, orig: move.from, dest: move.to, scale: scale),
    if (promRole != null)
      PieceShape(
        color: color,
        orig: move.to,
        pieceAssets: pieceAssets,
        piece: Piece(color: sideToMove, role: promRole),
      ),
  }.toISet(),
  DropMove(role: final role, to: _) => {
    PieceShape(
      color: color,
      orig: move.to,
      pieceAssets: pieceAssets,
      opacity: 0.5,
      piece: Piece(color: sideToMove, role: role),
    ),
  }.toISet(),
};

ISet<Shape> computeBestMoveShapes(
  IList<MoveWithWinningChances> moves,
  Side sideToMove,
  PieceAssets pieceAssets, {

  /// Color for the best move arrow (index 0)
  required Color bestMoveColor,

  /// Color for the next best moves arrows (when Stockfish MultiPv > 1)
  required Color nextBestMovesColor,
}) {
  // Scale down all moves with index > 0 based on how much worse their winning chances are compared to the best move
  // (assume moves are ordered by their winning chances, so index==0 is the best move)
  double scaleArrowAgainstBestMove(int index) {
    const minScale = 0.15;
    const maxScale = 1.0;
    const winningDiffScaleFactor = 2.5;

    final bestMove = moves[0];
    final winningDiffComparedToBestMove = bestMove.winningChances - moves[index].winningChances;
    // Force minimum scale if the best move is significantly better than this move
    if (winningDiffComparedToBestMove > 0.3) {
      return minScale;
    }
    return clampDouble(
      math.max(minScale, maxScale - winningDiffScaleFactor * winningDiffComparedToBestMove),
      0,
      1,
    );
  }

  return ISet(
    moves
        .mapIndexed((i, m) {
          final move = m.move;
          // Same colors as in the Web UI with a slightly different opacity
          // The best move has a different color than the other moves
          final color = (i == 0) ? bestMoveColor : nextBestMovesColor;

          return moveShapes(
            move: move,
            color: color,
            scale: scaleArrowAgainstBestMove(i),
            sideToMove: sideToMove,
            pieceAssets: pieceAssets,
          );
        })
        .expand((e) => e),
  );
}

double cpToPawns(int cp) => cp / 100;

int cpFromPawns(double pawns) => (pawns * 100).round();

double _cpWinningChances(int cp) => _rawWinningChances(math.min(math.max(-1000, cp), 1000));

double _mateWinningChances(int mate) {
  final cp = (21 - math.min(10, mate.abs())) * 100;
  final signed = cp * (mate > 0 ? 1 : -1);
  return _rawWinningChances(signed);
}

double _toPov(Side side, double diff) => side == Side.white ? diff : -diff;

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

double _toWhiteWinningChances(int? cp, int? mate) {
  if (mate != null) {
    return _mateWinningChances(mate);
  } else if (cp != null) {
    return _cpWinningChances(cp);
  } else {
    return 0;
  }
}
