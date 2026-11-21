import 'package:dartchess/dartchess.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/node.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_analysis_session.dart';

void main() {
  test('uses the game outcome for the final checkmate chart point', () {
    final game = Root.fromPgnMoves('e4 e5 Bc4 Nc6 Qh5 Nf6 Qxf7#');
    final branches = game.view.mainline.toList(growable: false);
    final evaluations = IList([
      for (final position in [game.position, ...branches.map((branch) => branch.position)])
        _eval(position, cp: -1000),
    ]);

    final chartData = localGameAnalysisChartData(game.view, evaluations);

    expect(branches.last.position.outcome?.winner, Side.white);
    expect(chartData.last.mate, 1);
    expect(chartData.last.winningChances(Side.white), greaterThan(0));
  });

  test('summarizes local move accuracy, centipawn loss, verdicts, and final expected score', () {
    final game = Root.fromPgnMoves('e4 e5');
    final branches = game.view.mainline.toList(growable: false);
    final evaluations = IList([
      _eval(game.position, cp: 300, bestMove: 'd2d4'),
      _eval(branches.first.position, cp: -300, bestMove: 'e7e5'),
      _eval(branches.last.position, cp: -300),
    ]);

    final summary = localGameAnalysisSummary(game.view, evaluations);
    final whiteAnalysis = summary.playersAnalysis.white;

    expect(whiteAnalysis.blunders, 1);
    expect(whiteAnalysis.acpl, 600);
    expect(whiteAnalysis.accuracy, lessThan(100));
    expect(whiteAnalysis.phases?.opening, whiteAnalysis.accuracy);
    expect(summary.moveAnnotations[UciPath.fromIds([branches.first.id])], 4);
    expect(summary.moveEvaluations[UciPath.fromIds([branches.first.id])]?.evalString, '-3.0');
    expect(
      summary.moveEvaluations[UciPath.fromIds([branches.first.id, branches.last.id])]?.evalString,
      '-3.0',
    );
    expect(
      summary.whiteExpectedScore,
      ((evaluations.last.winningChances(Side.white) + 1) * 50).round(),
    );
  });
}

LocalEval _eval(Position position, {required int cp, String? bestMove}) => LocalEval(
  position: position,
  depth: 12,
  nodes: 1000,
  pvs: bestMove == null
      ? const IListConst<PvData>([])
      : IList([
          PvData(moves: IList([bestMove]), cp: cp),
        ]),
  millis: 100,
  searchTime: const Duration(milliseconds: 100),
  threatMode: false,
  cp: cp,
);
