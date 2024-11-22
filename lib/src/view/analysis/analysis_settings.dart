import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_controller.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class AnalysisSettings extends ConsumerWidget {
  const AnalysisSettings(this.options);

  final AnalysisOptions options;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = analysisControllerProvider(options);
    final prefs = ref.watch(analysisPreferencesProvider);
    final asyncState = ref.watch(ctrlProvider);

    switch (asyncState) {
      case AsyncData(:final value):
        return BottomSheetScrollableContainer(
          children: [
            PlatformListTile(
              title: Text(context.l10n.openingExplorer),
              onTap: () => showAdaptiveBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                showDragHandle: true,
                isDismissible: true,
                builder: (_) => OpeningExplorerSettings(options),
              ),
              trailing: const Icon(CupertinoIcons.chevron_right),
            ),
            if (value.isComputerAnalysisAllowed)
              SwitchSettingTile(
                title: Text(context.l10n.computerAnalysis),
                value: prefs.enableComputerAnalysis,
                onChanged: (_) {
                  ref.read(ctrlProvider.notifier).toggleComputerAnalysis();
                },
              ),
            AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: value.isComputerAnalysisAllowedAndEnabled
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: const SizedBox.shrink(),
              secondChild: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SwitchSettingTile(
                    title: Text(context.l10n.toggleLocalEvaluation),
                    value: prefs.enableLocalEvaluation,
                    onChanged: (_) {
                      ref.read(ctrlProvider.notifier).toggleLocalEvaluation();
                    },
                  ),
                  PlatformListTile(
                    title: Text.rich(
                      TextSpan(
                        text: '${context.l10n.multipleLines}: ',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                        children: [
                          TextSpan(
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            text: prefs.numEvalLines.toString(),
                          ),
                        ],
                      ),
                    ),
                    subtitle: NonLinearSlider(
                      value: prefs.numEvalLines,
                      values: const [0, 1, 2, 3],
                      onChangeEnd: value.isEngineAvailable
                          ? (value) => ref
                              .read(ctrlProvider.notifier)
                              .setNumEvalLines(value.toInt())
                          : null,
                    ),
                  ),
                  if (maxEngineCores > 1)
                    PlatformListTile(
                      title: Text.rich(
                        TextSpan(
                          text: '${context.l10n.cpus}: ',
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                          children: [
                            TextSpan(
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              text: prefs.numEngineCores.toString(),
                            ),
                          ],
                        ),
                      ),
                      subtitle: NonLinearSlider(
                        value: prefs.numEngineCores,
                        values:
                            List.generate(maxEngineCores, (index) => index + 1),
                        onChangeEnd: value.isEngineAvailable
                            ? (value) => ref
                                .read(ctrlProvider.notifier)
                                .setEngineCores(value.toInt())
                            : null,
                      ),
                    ),
                  SwitchSettingTile(
                    title: Text(context.l10n.bestMoveArrow),
                    value: prefs.showBestMoveArrow,
                    onChanged: value.isEngineAvailable
                        ? (value) => ref
                            .read(analysisPreferencesProvider.notifier)
                            .toggleShowBestMoveArrow()
                        : null,
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
                    onChanged: (_) => ref
                        .read(analysisPreferencesProvider.notifier)
                        .toggleAnnotations(),
                  ),
                  SwitchSettingTile(
                    title: Text(context.l10n.mobileShowComments),
                    value: prefs.showPgnComments,
                    onChanged: (_) => ref
                        .read(analysisPreferencesProvider.notifier)
                        .togglePgnComments(),
                  ),
                ],
              ),
            ),
          ],
        );
      case AsyncError(:final error):
        debugPrint('Error loading analysis: $error');
        return const SizedBox.shrink();
      case _:
        return const CenterLoadingIndicator();
    }
  }
}
