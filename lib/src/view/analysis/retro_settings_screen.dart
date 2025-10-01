import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/analysis/analysis_preferences.dart';
import 'package:lichess_mobile/src/model/analysis/retro_controller.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class RetroSettingsScreen extends ConsumerWidget {
  const RetroSettingsScreen(this.options);

  final RetroOptions options;

  static Route<dynamic> buildRoute(BuildContext context, {required RetroOptions options}) {
    return buildScreenRoute(context, screen: RetroSettingsScreen(options));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrlProvider = retroControllerProvider(options);
    final prefs = ref.watch(analysisPreferencesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsSettings)),
      body: ListView(
        children: [
          ListSection(
            children: [
              SwitchSettingTile(
                // TODO: translate
                title: const Text('Smaller board'),
                value: prefs.smallBoard,
                onChanged: (value) =>
                    ref.read(analysisPreferencesProvider.notifier).toggleSmallBoard(),
              ),
            ],
          ),
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
                onChanged: (value) =>
                    ref.read(analysisPreferencesProvider.notifier).toggleShowEvaluationGauge(),
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
      ),
    );
  }
}
