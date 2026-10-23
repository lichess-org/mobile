import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/engine/practice_comment.dart';

final localGameAnalysisSessionProvider =
    NotifierProvider.family<LocalGameAnalysisSession, IList<LocalEval>?, String>(
      LocalGameAnalysisSession.new,
    );

String localGameAnalysisSessionKey(StringId contextId, ViewNode root) =>
    '${contextId.value}:${root.position.fen}:${root.mainline.map((branch) => branch.id).join()}';

MoveVerdict? localMoveVerdictFor({
  required LocalEval before,
  required LocalEval after,
  required ViewBranch branch,
}) {
  final bestMove = before.bestMove;
  if (bestMove == null) return null;

  final winningChancesBefore = before.winningChances(before.position.turn);
  final winningChancesAfter = after.winningChances(before.position.turn);
  return MoveVerdict.fromShift(
    winningChancesBefore - winningChancesAfter,
    hasBetterMove: bestMove != branch.sanMove.move,
    winningChancesBefore: winningChancesBefore,
    winningChancesAfter: winningChancesAfter,
  );
}

class LocalGameAnalysisSession(final String sessionKey) extends Notifier<IList<LocalEval>?> {
  @override
  IList<LocalEval>? build() => null;

  IList<LocalEval>? get evaluations => state;

  set evaluations(IList<LocalEval> evaluations) => state = evaluations;
}
