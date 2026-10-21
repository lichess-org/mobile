import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
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
    // The height of a bar floating over the view: the moves scroll under it, unless the variations
    // bar is shown, which is kept above it.
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final hasVariations = currentNode.children.length > 1;

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
