import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/widgets/pgn.dart';

const kOpeningHeaderHeight = 32.0;

class AnalysisTreeView extends ConsumerWidget {
  const AnalysisTreeView(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);

    final root = ref.watch(ctrlProvider.select((value) => value.requireValue.root));
    final currentPath = ref.watch(ctrlProvider.select((value) => value.requireValue.currentPath));
    final pgnRootComments = ref.watch(
      ctrlProvider.select((value) => value.requireValue.pgnRootComments),
    );
    final prefs = ref.watch(analysisPreferencesProvider);
    // enable computer analysis takes effect here only if it's a lichess game
    final enableComputerAnalysis = !options.isLichessGameAnalysis || prefs.enableComputerAnalysis;

    return SingleChildScrollView(
      padding: EdgeInsets.zero,
      child: DebouncedPgnTreeView(
        root: root,
        currentPath: currentPath,
        pgnRootComments: pgnRootComments,
        notifier: ref.read(ctrlProvider.notifier),
        shouldShowComputerVariations: enableComputerAnalysis,
        shouldShowComments: enableComputerAnalysis && prefs.showPgnComments,
        shouldShowAnnotations: enableComputerAnalysis && prefs.showAnnotations,
        displayMode:
            prefs.inlineNotation ? PgnTreeDisplayMode.inlineNotation : PgnTreeDisplayMode.twoColumn,
      ),
    );
  }
}
