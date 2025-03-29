import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class StockfishSettingsWidget extends ConsumerStatefulWidget {
  const StockfishSettingsWidget({
    this.onToggleLocalEvaluation,
    required this.onSetEngineSearchTime,
    required this.onSetNumEvalLines,
    required this.onSetEngineCores,
    super.key,
  });

  final VoidCallback? onToggleLocalEvaluation;
  final void Function(Duration) onSetEngineSearchTime;
  final void Function(int) onSetNumEvalLines;
  final void Function(int) onSetEngineCores;

  @override
  ConsumerState<StockfishSettingsWidget> createState() => _StockfishSettingsWidgetState();
}

class _StockfishSettingsWidgetState extends ConsumerState<StockfishSettingsWidget> {
  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(engineEvaluationPreferencesProvider);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.onToggleLocalEvaluation != null)
          ListSection(
            children: [
              SwitchSettingTile(
                title: Text(context.l10n.toggleLocalEvaluation),
                value: prefs.isEnabled,
                onChanged: (_) {
                  widget.onToggleLocalEvaluation!.call();
                },
              ),
            ],
          ),
        ListSection(
          footer: const Text.rich(
            TextSpan(
              text: 'Stockfish NNUE',
              style: TextStyle(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: ' is the modern Stockfish engine using neural network evaluation.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(text: ' Stockfish HCE', style: TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(
                  text: ' is the traditional Stockfish engine using handcrafted evaluation. ',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
                TextSpan(
                  text:
                      '\nThe NNUE engine is better at evaluating positions but requires to download a 79MB neural network.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
          ),
          children: [
            SettingsListTile(
              settingsLabel: const Text('Engine'),
              settingsValue:
                  prefs.evaluationFunction == EvaluationFunctionPref.hce
                      ? 'Stockfish HCE'
                      : 'Stockfish NNUE (79MB)',
              onTap: () {
                showChoicePicker(
                  context,
                  choices: EvaluationFunctionPref.values,
                  selectedItem: prefs.evaluationFunction,
                  labelBuilder:
                      (t) => Text(
                        t == EvaluationFunctionPref.hce ? 'Stockfish HCE' : 'Stockfish NNUE (79MB)',
                      ),
                  onSelectedItemChanged: (EvaluationFunctionPref? value) {
                    ref
                        .read(engineEvaluationPreferencesProvider.notifier)
                        .setEvaluationFunction(value ?? EvaluationFunctionPref.nnue);
                  },
                );
              },
            ),
          ],
        ),
        ListSection(
          header: const SettingsSectionTitle('Stockfish'),
          children: [
            PlatformListTile(
              title: Text.rich(
                TextSpan(
                  text: 'Search time: ',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      text:
                          prefs.engineSearchTime.inSeconds == 3600
                              ? '∞'
                              : '${prefs.engineSearchTime.inSeconds}s',
                    ),
                  ],
                ),
              ),
              subtitle: NonLinearSlider(
                labelBuilder: (value) => value == 3600 ? '∞' : '${value}s',
                value: prefs.engineSearchTime.inSeconds,
                values: kAvailableEngineSearchTimes.map((e) => e.inSeconds).toList(),
                onChangeEnd:
                    (value) => widget.onSetEngineSearchTime(Duration(seconds: value.toInt())),
              ),
            ),
            PlatformListTile(
              title: Text.rich(
                TextSpan(
                  text: '${context.l10n.multipleLines}: ',
                  style: const TextStyle(fontWeight: FontWeight.normal),
                  children: [
                    TextSpan(
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      text: prefs.numEvalLines.toString(),
                    ),
                  ],
                ),
              ),
              subtitle: NonLinearSlider(
                value: prefs.numEvalLines,
                values: const [0, 1, 2, 3],
                onChangeEnd: (value) => widget.onSetNumEvalLines(value.toInt()),
              ),
            ),
            if (maxEngineCores > 1)
              PlatformListTile(
                title: Text.rich(
                  TextSpan(
                    text: '${context.l10n.cpus}: ',
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    children: [
                      TextSpan(
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        text: prefs.numEngineCores.toString(),
                      ),
                    ],
                  ),
                ),
                subtitle: NonLinearSlider(
                  value: prefs.numEngineCores,
                  values: List.generate(maxEngineCores, (index) => index + 1),
                  onChangeEnd: (value) => widget.onSetEngineCores(value.toInt()),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
