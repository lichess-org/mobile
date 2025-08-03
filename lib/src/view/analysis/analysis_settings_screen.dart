import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';
import 'package:lichess_mobile/src/view/explorer/opening_explorer_settings.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class AnalysisSettingsScreen extends ConsumerWidget {
  const AnalysisSettingsScreen(this.options);

  final AnalysisOptions options;

  static Route<dynamic> buildRoute(BuildContext context, {required AnalysisOptions options}) {
    return buildScreenRoute(context, screen: AnalysisSettingsScreen(options));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final prefs = ref.watch(analysisPreferencesProvider);
    final asyncState = ref.watch(ctrlProvider);

    switch (asyncState) {
      case AsyncData(:final value):
        return Scaffold(
          appBar: AppBar(title: Text(context.l10n.settingsSettings)),
          body: ListView(
            children: [
              ListSection(
                children: [
                  SwitchSettingTile(
                    title: Text(context.l10n.inlineNotation),
                    value: prefs.inlineNotation,
                    onChanged: (value) =>
                        ref.read(analysisPreferencesProvider.notifier).toggleInlineNotation(),
                  ),
                  SwitchSettingTile(
                    // TODO: translate
                    title: const Text('Smaller board'),
                    value: prefs.smallBoard,
                    onChanged: (value) =>
                        ref.read(analysisPreferencesProvider.notifier).toggleSmallBoard(),
                  ),
                  ListTile(
                    title: Text(context.l10n.openingExplorer),
                    onTap: () => showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      isDismissible: true,
                      builder: (_) => const OpeningExplorerSettings(),
                    ),
                  ),
                ],
              ),
              if (value.isComputerAnalysisAllowed) ...[
                ListSection(
                  header: SettingsSectionTitle(context.l10n.computerAnalysis),
                  children: [
                    SwitchSettingTile(
                      title: Text(context.l10n.mobileServerAnalysis),
                      value: prefs.enableServerAnalysis,
                      onChanged: (_) {
                        ref.read(analysisPreferencesProvider.notifier).toggleServerAnalysis();
                      },
                    ),
                    SwitchSettingTile(
                      title: Text(context.l10n.evaluationGauge),
                      value: prefs.showEvaluationGauge,
                      onChanged: (value) => ref
                          .read(analysisPreferencesProvider.notifier)
                          .toggleShowEvaluationGauge(),
                    ),
                    SwitchSettingTile(
                      title: Text(context.l10n.toggleGlyphAnnotations),
                      value: prefs.showAnnotations,
                      onChanged: (_) =>
                          ref.read(analysisPreferencesProvider.notifier).toggleAnnotations(),
                    ),
                    SwitchSettingTile(
                      title: Text(context.l10n.mobileShowComments),
                      value: prefs.showPgnComments,
                      onChanged: (_) =>
                          ref.read(analysisPreferencesProvider.notifier).togglePgnComments(),
                    ),
                    SwitchSettingTile(
                      title: Text(context.l10n.bestMoveArrow),
                      value: prefs.showBestMoveArrow,
                      onChanged: (value) =>
                          ref.read(analysisPreferencesProvider.notifier).toggleShowBestMoveArrow(),
                    ),
                  ],
                ),
                EngineSettingsWidget(
                  onSetEngineSearchTime: (value) {
                    ref.read(ctrlProvider.notifier).setEngineSearchTime(value);
                  },
                  onSetEngineCores: (value) {
                    ref.read(ctrlProvider.notifier).setEngineCores(value);
                  },
                  onSetNumEvalLines: (value) {
                    ref.read(ctrlProvider.notifier).setNumEvalLines(value);
                  },
                ),
              ],
            ],
          ),
        );
      case AsyncError(:final error):
        debugPrint('Error loading analysis: $error');
        return const SizedBox.shrink();
      case _:
        return const CenterLoadingIndicator();
    }
  }
}
