import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/explorer/tablebase.dart';

/// Converts a [TablebaseEntry] to a [CloudEval].
///
/// Returns null for non-conclusive entries (unknown, maybeWin, maybeLoss), and wins or losses
/// without a distance to mate, which can happen for 7 piece tablebases.
CloudEval? tablebaseEntryToCloudEval(TablebaseEntry entry, Position position) {
  final turn = position.turn;
  final int? mate;
  final int? cp;

  switch (entry.category) {
    case .win || .syzygyWin:
      final dtm = entry.dtm;
      if (dtm == null) return null;
      final mateN = (dtm.abs() + 1) ~/ 2;
      mate = turn == .white ? mateN : -mateN;
      cp = null;
    case .loss || .syzygyLoss:
      final dtm = entry.dtm;
      if (dtm == null) return null;
      final mateN = (dtm.abs() + 1) ~/ 2;
      mate = turn == .white ? -mateN : mateN;
      cp = null;
    case .draw || .cursedWin || .blessedLoss:
      mate = null;
      cp = 0;
    default:
      return null;
  }

  // Include the best tablebase move as the first PV move if available.
  final bestMoveUci = entry.moves.firstOrNull?.uci;
  final pvMoves = bestMoveUci != null ? [bestMoveUci].lock : IList<UCIMove>();

  return CloudEval(
    position: position,
    depth: 99,
    nodes: 0,
    pvs: [PvData(moves: pvMoves, mate: mate, cp: cp)].lock,
  );
}
