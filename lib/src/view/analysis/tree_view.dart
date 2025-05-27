import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/view/game/game_result_dialog.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

const kOpeningHeaderHeight = 32.0;

class AnalysisTreeView extends ConsumerWidget {
  const AnalysisTreeView(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);

    final analysisState = ref.watch(ctrlProvider).requireValue;
    final prefs = ref.watch(analysisPreferencesProvider);
    // enable computer analysis takes effect here only if it's a lichess game
    final enableComputerAnalysis = !options.isLichessGameAnalysis || prefs.enableComputerAnalysis;

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          DebouncedPgnTreeView(
            root: analysisState.root,
            currentPath: analysisState.currentPath,
            livePath: analysisState.pathToLiveMove,
            pgnRootComments: analysisState.pgnRootComments,
            notifier: ref.read(ctrlProvider.notifier),
            shouldShowComputerAnalysis: enableComputerAnalysis,
            shouldShowComments: enableComputerAnalysis && prefs.showPgnComments,
            shouldShowAnnotations: enableComputerAnalysis && prefs.showAnnotations,
            displayMode: prefs.inlineNotation
                ? PgnTreeDisplayMode.inlineNotation
                : PgnTreeDisplayMode.twoColumn,
          ),
          if (analysisState.archivedGame != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GameResult(game: analysisState.archivedGame!),
            ),
        ],
      ),
    );
  }
}
