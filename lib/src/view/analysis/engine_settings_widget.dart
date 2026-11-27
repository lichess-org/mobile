import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/external_engine.dart';
import 'package:lichess_mobile/src/model/engine/external_engine_repository.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:material_ui/material_ui.dart';

class const EngineSettingsWidget({
  final VoidCallback? onToggleLocalEvaluation,
  required final void Function(Duration) onSetEngineSearchTime,
  final void Function(int)? onSetNumEvalLines,
  required final void Function(int) onSetEngineCores,
  super.key,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prefs = ref.watch(engineEvaluationPreferencesProvider);

    final engines =
        ref.watch(externalEnginesProvider).value ?? const IListConst<ExternalEngine>([]);
    final chosen = engines.firstWhereOrNull((engine) => engine.id == prefs.externalEngineId);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onToggleLocalEvaluation != null)
          ListSection(
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.toggleLocalEvaluation),
                value: prefs.isEnabled,
                onChanged: (_) {
                  onToggleLocalEvaluation!.call();
                },
              ),
            ],
          ),
        ListSection(
          header: SettingsSectionTitle(context.l10n.engineSettings),
          children: [
            SliderSettingsTile(
              title: Text(context.l10n.searchTime),
              explanation: context.l10n.searchTimeDescription,
              value: prefs.engineSearchTime.inSeconds.toDouble(),
              values: kAvailableEngineSearchTimes.map((e) => e.inSeconds.toDouble()).toList(),
              labelBuilder: (value) =>
                  value == kMaxEngineSearchTime.inSeconds.toDouble() ? '∞' : '${value.toInt()}s',
              onChangeEnd: (value) {
                onSetEngineSearchTime(Duration(seconds: value.toInt()));
              },
            ),
            if (onSetNumEvalLines != null)
              SliderSettingsTile(
                title: Text(context.l10n.multipleLines),
                value: prefs.numEvalLines.toDouble(),
                values: const [0, 1, 2, 3],
                labelBuilder: (value) => value.toInt().toString(),
                onChangeEnd: (value) => onSetNumEvalLines!.call(value.toInt()),
              ),
            // an external engine always gets the threads it was registered with
            if (chosen == null && maxEngineCores > 1)
              SliderSettingsTile(
                title: Text(context.l10n.threads),
                explanation: context.l10n.threadsDescriptionMobile,
                value: prefs.numEngineCores.toDouble(),
                values: List.generate(
                  maxEngineCores,
                  (index) => index + 1,
                ).map((e) => e.toDouble()).toList(),
                labelBuilder: (value) => value.toInt().toString(),
                onChangeEnd: (value) => onSetEngineCores(value.toInt()),
              ),
          ],
        ),
      ],
    );
  }
}
