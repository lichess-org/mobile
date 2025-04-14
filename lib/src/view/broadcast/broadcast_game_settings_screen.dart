import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_analysis_controller.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/stockfish_settings.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class BroadcastGameSettingsScreen extends ConsumerWidget {
  const BroadcastGameSettingsScreen(this.roundId, this.gameId);

  final BroadcastRoundId roundId;
  final BroadcastGameId gameId;

  static Route<dynamic> buildRoute(
    BuildContext context, {
    required BroadcastRoundId roundId,
    required BroadcastGameId gameId,
  }) {
    return buildScreenRoute(context, screen: BroadcastGameSettingsScreen(roundId, gameId));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = broadcastAnalysisControllerProvider(roundId, gameId);

    final analysisPrefs = ref.watch(analysisPreferencesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsSettings)),
      body: ListView(
        children: [
          ListSection(
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.inlineNotation),
                value: analysisPrefs.inlineNotation,
                onChanged:
                    (value) =>
                        ref.read(analysisPreferencesProvider.notifier).toggleInlineNotation(),
              ),
              SwitchSettingTile(
                // TODO: translate
                title: const Text('Small board'),
                value: analysisPrefs.smallBoard,
                onChanged:
                    (value) => ref.read(analysisPreferencesProvider.notifier).toggleSmallBoard(),
              ),
            ],
          ),
          ListSection(
            header: SettingsSectionTitle(context.l10n.computerAnalysis),
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.enable),
                value: analysisPrefs.enableComputerAnalysis,
                onChanged: (_) {
                  ref.read(controller.notifier).toggleComputerAnalysis();
                },
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState:
                    analysisPrefs.enableComputerAnalysis
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  children: [
                    SwitchSettingTile(
                      title: Text(context.l10n.evaluationGauge),
                      value: analysisPrefs.showEvaluationGauge,
                      onChanged:
                          (value) =>
                              ref
                                  .read(analysisPreferencesProvider.notifier)
                                  .toggleShowEvaluationGauge(),
                    ),
                    SwitchSettingTile(
                      title: Text(context.l10n.toggleGlyphAnnotations),
                      value: analysisPrefs.showAnnotations,
                      onChanged:
                          (_) => ref.read(analysisPreferencesProvider.notifier).toggleAnnotations(),
                    ),
                    SwitchSettingTile(
                      title: Text(context.l10n.mobileShowComments),
                      value: analysisPrefs.showPgnComments,
                      onChanged:
                          (_) => ref.read(analysisPreferencesProvider.notifier).togglePgnComments(),
                    ),
                    SwitchSettingTile(
                      title: Text(context.l10n.bestMoveArrow),
                      value: analysisPrefs.showBestMoveArrow,
                      onChanged:
                          (value) =>
                              ref
                                  .read(analysisPreferencesProvider.notifier)
                                  .toggleShowBestMoveArrow(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState:
                analysisPrefs.enableComputerAnalysis
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: StockfishSettingsWidget(
              onSetEngineSearchTime:
                  (value) => ref.read(controller.notifier).setEngineSearchTime(value),
              onSetNumEvalLines: (value) => ref.read(controller.notifier).setNumEvalLines(value),
              onSetEngineCores: (value) => ref.read(controller.notifier).setEngineCores(value),
            ),
          ),
          ListSection(
            children: [
              ListTile(
                title: Text(context.l10n.openingExplorer),
                onTap:
                    () => showAdaptiveBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      isDismissible: true,
                      builder: (_) => const OpeningExplorerSettings(),
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
