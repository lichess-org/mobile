import 'dart:math' as math;

import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/model/engine/practice_comment.dart';
import 'package:lichess_mobile/src/model/game/player.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_division.dart';

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

int? localMoveVerdictNagFor(MoveVerdict? verdict) => switch (verdict) {
  .inaccuracy => 6,
  .mistake => 2,
  .blunder => 4,
  .goodMove || .notBest || null => null,
};

typedef LocalGameAnalysisSummary = ({
  PlayersAnalysis playersAnalysis,
  int whiteExpectedScore,
  IMap<UciPath, int> moveAnnotations,
});

LocalGameAnalysisSummary localGameAnalysisSummary(ViewNode root, IList<LocalEval> evaluations) {
  final branches = root.mainline.toList(growable: false);
  if (evaluations.length != branches.length + 1) {
    throw ArgumentError.value(evaluations.length, 'evaluations', 'Must include every position.');
  }

  final division = inferLocalGameDivision(root);
  final middlePly = division?.middlegame ?? root.position.ply + 20;
  final whiteStats = _LocalPlayerAnalysisStats();
  final blackStats = _LocalPlayerAnalysisStats();
  final openingStats = (_LocalPlayerAnalysisStats(), _LocalPlayerAnalysisStats());
  final middlegameStats = (_LocalPlayerAnalysisStats(), _LocalPlayerAnalysisStats());
  final endgameStats = (_LocalPlayerAnalysisStats(), _LocalPlayerAnalysisStats());
  final annotations = <UciPath, int>{};
  var path = UciPath.empty;

  for (final (index, branch) in branches.indexed) {
    final before = evaluations[index];
    final after = evaluations[index + 1];
    final side = before.position.turn;
    final verdict = localMoveVerdictFor(before: before, after: after, branch: branch);
    final endgamePly = division?.endgame;
    final phaseStats = endgamePly != null && before.position.ply >= endgamePly
        ? endgameStats
        : before.position.ply >= middlePly
        ? middlegameStats
        : openingStats;

    (side == Side.white ? whiteStats : blackStats).addMove(before, after, side, verdict);
    (side == Side.white ? phaseStats.$1 : phaseStats.$2).addMove(before, after, side, verdict);

    final nag = localMoveVerdictNagFor(verdict);
    path = path + branch.id;
    if (nag != null) annotations[path] = nag;
  }

  final finalEvaluation = evaluations.last;
  final whiteExpectedScore = ((finalEvaluation.winningChances(Side.white) + 1) * 50).round().clamp(
    0,
    100,
  );

  return (
    playersAnalysis: (
      white: whiteStats.toPlayerAnalysis(
        opening: openingStats.$1,
        middlegame: middlegameStats.$1,
        endgame: endgameStats.$1,
      ),
      black: blackStats.toPlayerAnalysis(
        opening: openingStats.$2,
        middlegame: middlegameStats.$2,
        endgame: endgameStats.$2,
      ),
    ),
    whiteExpectedScore: whiteExpectedScore,
    moveAnnotations: IMap(annotations),
  );
}

class _LocalPlayerAnalysisStats() {
  int inaccuracies = 0;
  int mistakes = 0;
  int blunders = 0;
  int moveCount = 0;
  int cpLossCount = 0;
  int totalCpLoss = 0;
  double totalExpectedScoreLoss = 0;

  void addMove(LocalEval before, LocalEval after, Side side, MoveVerdict? verdict) {
    moveCount++;
    final expectedScoreLoss = Eval.winningChancesPovDiff(side, before, after);
    totalExpectedScoreLoss += expectedScoreLoss.clamp(0, 1);

    switch (verdict) {
      case .inaccuracy:
        inaccuracies++;
      case .mistake:
        mistakes++;
      case .blunder:
        blunders++;
      case _:
        break;
    }

    final beforeCp = _cpInPerspective(before, side);
    final afterCp = _cpInPerspective(after, side);
    if (beforeCp != null && afterCp != null) {
      cpLossCount++;
      totalCpLoss += math.max(0, beforeCp - afterCp);
    }
  }

  PlayerAnalysis toPlayerAnalysis({
    required _LocalPlayerAnalysisStats opening,
    required _LocalPlayerAnalysisStats middlegame,
    required _LocalPlayerAnalysisStats endgame,
  }) => PlayerAnalysis(
    inaccuracies: inaccuracies,
    mistakes: mistakes,
    blunders: blunders,
    acpl: cpLossCount > 0 ? (totalCpLoss / cpLossCount).round() : null,
    accuracy: accuracy,
    phases: (opening: opening.accuracy, middlegame: middlegame.accuracy, endgame: endgame.accuracy),
  );

  int? get accuracy =>
      moveCount > 0 ? (100 * (1 - totalExpectedScoreLoss / moveCount)).round().clamp(0, 100) : null;
}

int? _cpInPerspective(LocalEval evaluation, Side side) {
  final cp =
      evaluation.cp ??
      (evaluation.mate == null
          ? null
          : evaluation.mate! > 0
          ? 10000
          : -10000);
  if (cp == null) return null;
  return side == Side.white ? cp : -cp;
}

class LocalGameAnalysisSession(final String sessionKey) extends Notifier<IList<LocalEval>?> {
  @override
  IList<LocalEval>? build() => null;

  IList<LocalEval>? get evaluations => state;

  set evaluations(IList<LocalEval> evaluations) => state = evaluations;
}
