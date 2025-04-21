import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/model/settings/general_preferences.dart';
import 'package:lichess_mobile/src/model/study/study_controller.dart';
import 'package:lichess_mobile/src/model/study/study_preferences.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';
import 'package:lichess_mobile/src/view/opening_explorer/opening_explorer_settings.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class StudySettingsScreen extends ConsumerWidget {
  const StudySettingsScreen(this.id);

  final StudyId id;

  static Route<dynamic> buildRoute(BuildContext context, StudyId id) {
    return buildScreenRoute(context, screen: StudySettingsScreen(id));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final studyController = studyControllerProvider(id);

    final isComputerAnalysisAllowed = ref.watch(
      studyController.select((s) => s.requireValue.isComputerAnalysisAllowed),
    );

    final analysisPrefs = ref.watch(analysisPreferencesProvider);
    final studyPrefs = ref.watch(studyPreferencesProvider);
    final isSoundEnabled = ref.watch(
      generalPreferencesProvider.select((pref) => pref.isSoundEnabled),
    );

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
              SwitchSettingTile(
                title: Text(context.l10n.showVariationArrows),
                value: studyPrefs.showVariationArrows,
                onChanged:
                    (value) =>
                        ref.read(studyPreferencesProvider.notifier).toggleShowVariationArrows(),
              ),
              SwitchSettingTile(
                title: Text(context.l10n.toggleGlyphAnnotations),
                value: analysisPrefs.showAnnotations,
                onChanged:
                    (_) => ref.read(analysisPreferencesProvider.notifier).toggleAnnotations(),
              ),
            ],
          ),
          if (isComputerAnalysisAllowed)
            EngineSettingsWidget(
              onToggleLocalEvaluation: () => ref.read(studyController.notifier).toggleEngine(),
              onSetEngineSearchTime:
                  (value) => ref.read(studyController.notifier).setEngineSearchTime(value),
              onSetNumEvalLines:
                  (value) => ref.read(studyController.notifier).setNumEvalLines(value),
              onSetEngineCores: (value) => ref.read(studyController.notifier).setEngineCores(value),
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
              SwitchSettingTile(
                title: Text(context.l10n.sound),
                value: isSoundEnabled,
                onChanged: (value) {
                  ref.read(generalPreferencesProvider.notifier).toggleSoundEnabled();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
