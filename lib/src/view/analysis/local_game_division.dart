import 'package:collection/collection.dart';
import 'package:dartchess/dartchess.dart';
import 'package:lichess_mobile/src/model/common/chess.dart';
import 'package:lichess_mobile/src/model/common/node.dart';

/// Estimates the phase boundaries used by the analysis charts when a game has no server metadata.
///
/// The opening is treated as the first ten moves. The endgame starts once queens are gone and
/// eighteen or fewer points of non-pawn material remain.
Division? inferLocalGameDivision(ViewNode root) {
  final middlePly = root.position.ply + 20;
  final positions = [root.position, ...root.mainline.map((branch) => branch.position)];
  if (!positions.any((position) => position.ply >= middlePly)) return null;

  final endgamePly = positions
      .where((position) => position.ply > middlePly && _isEndgame(position))
      .firstOrNull
      ?.ply;

  return Division(middlegame: middlePly, endgame: endgamePly);
}

bool _isEndgame(Position position) {
  if (position.rule == Rule.crazyhouse || position.rule == Rule.horde) return false;

  final white = position.board.materialCount(Side.white);
  final black = position.board.materialCount(Side.black);
  if ((white[Role.queen] ?? 0) > 0 || (black[Role.queen] ?? 0) > 0) return false;

  int nonPawnMaterial(Map<Role, int> pieces) =>
      (pieces[Role.rook] ?? 0) * 5 + ((pieces[Role.bishop] ?? 0) + (pieces[Role.knight] ?? 0)) * 3;

  return nonPawnMaterial(white) + nonPawnMaterial(black) <= 18;
}
