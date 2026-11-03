import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/eval.dart';
import 'package:lichess_mobile/src/model/common/uci.dart';
import 'package:lichess_mobile/src/view/analysis/local_game_analysis_session.dart';
import 'package:lichess_mobile/src/view/game/game_result_dialog.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';
import 'package:lichess_mobile/src/widgets/variations_bar.dart';
import 'package:material_ui/material_ui.dart';

class const AnalysisTreeView(final AnalysisOptions options) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);

    final analysisState = ref.watch(ctrlProvider).requireValue;
    final prefs = ref.watch(analysisPreferencesProvider);
    // enable computer analysis takes effect here only if it's a lichess game
    final enableServerAnalysis = !options.isLichessGameAnalysis || prefs.enableServerAnalysis;
    final currentNode =
        analysisState.root.branchesOn(analysisState.currentPath).lastOrNull ?? analysisState.root;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final hasVariations = currentNode.children.length > 1;
    IMap<UciPath, int>? localMoveAnnotations;
    IMap<UciPath, ExternalEval>? localMoveEvaluations;
    if (options case Pgn(isComputerAnalysisAllowed: true)) {
      final evaluations = ref.watch(
        localGameAnalysisSessionProvider(
          localGameAnalysisSessionKey(options.contextId, analysisState.root),
        ),
      );
      if (evaluations != null) {
        final summary = localGameAnalysisSummary(analysisState.root, evaluations);
        localMoveEvaluations = summary.moveEvaluations;
        if (prefs.showLocalMoveVerdicts) {
          localMoveAnnotations = summary.moveAnnotations;
        }
      }
    }

    return Column(
      crossAxisAlignment: .stretch,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: hasVariations ? 0.0 : bottomInset),
            child: Column(
              children: [
                DebouncedPgnTreeView(
                  root: analysisState.root,
                  currentPath: analysisState.currentPath,
                  livePath: analysisState.pathToLiveMove,
                  pgnRootComments: analysisState.pgnRootComments,
                  notifier: ref.read(ctrlProvider.notifier),
                  // Avoid overlap with the divider of the analysis tab bar
                  showTopDivider: false,
                  shouldShowComputerAnalysis: enableServerAnalysis,
                  shouldShowComments: enableServerAnalysis && prefs.showPgnComments,
                  shouldShowAnnotations: enableServerAnalysis && prefs.showAnnotations,
                  localMoveAnnotations: localMoveAnnotations,
                  localMoveEvaluations: localMoveEvaluations,
                  premovePaths: analysisState.forecast?.lines,
                  displayMode: prefs.inlineNotation ? .inlineNotation : .twoColumn,
                ),
                if (analysisState.archivedGame != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GameResult(game: analysisState.archivedGame!),
                  ),
              ],
            ),
          ),
        ),
        if (hasVariations)
          Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: VariationsBar(
              currentNode: currentNode,
              currentPath: analysisState.currentPath,
              showAnnotations: enableServerAnalysis && prefs.showAnnotations,
              onJump: (path) => ref.read(ctrlProvider.notifier).userJump(path),
            ),
          ),
      ],
    );
  }
}
