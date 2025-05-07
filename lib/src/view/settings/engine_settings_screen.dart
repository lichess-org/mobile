import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';

class EngineSettingsScreen extends ConsumerStatefulWidget {
  const EngineSettingsScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const EngineSettingsScreen());
  }

  @override
  ConsumerState<EngineSettingsScreen> createState() => _EngineSettingsScreenState();
}

class _EngineSettingsScreenState extends ConsumerState<EngineSettingsScreen> {
  bool _hasNNUEFiles = false;

  @override
  void initState() {
    setState(() {
      _hasNNUEFiles = ref.read(evaluationServiceProvider).checkNNUEFilesExist();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(engineEvaluationPreferencesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Engine')),
      body: ListView(
        children: [
          ListSection(
            footer: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Text.rich(
                TextSpan(
                  text: 'Stockfish HCE',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: ' is an engine using handcrafted evaluation. ',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: ' Stockfish NNUE',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' is the modern engine using a neural network.',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                    TextSpan(
                      text: 'The NNUE engine is stronger but downloading a 79MB file is required.',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
              ),
            ),
            children: [
              SettingsListTile(
                settingsLabel: const Text('Engine'),
                settingsValue:
                    prefs.evaluationFunction == EvaluationFunctionPref.hce
                        ? 'Stockfish HCE'
                        : 'Stockfish NNUE',
                onTap: () {
                  showChoicePicker(
                    context,
                    choices: EvaluationFunctionPref.values,
                    selectedItem: prefs.evaluationFunction,
                    labelBuilder:
                        (t) => Text(
                          t == EvaluationFunctionPref.hce ? 'Stockfish HCE' : 'Stockfish NNUE',
                        ),
                    onSelectedItemChanged: (EvaluationFunctionPref? value) {
                      ref
                          .read(engineEvaluationPreferencesProvider.notifier)
                          .setEvaluationFunction(value ?? EvaluationFunctionPref.nnue);
                    },
                  );
                },
              ),
              if (prefs.evaluationFunction == EvaluationFunctionPref.nnue && !_hasNNUEFiles)
                LoadingButtonBuilder(
                  fetchData:
                      () => ref
                          .read(evaluationServiceProvider)
                          .downloadNNUEFiles(inBackground: false),
                  builder: (context, isLoading, fetchData) {
                    return ListTile(
                      trailing:
                          isLoading
                              ? AnimatedBuilder(
                                animation: ref.read(evaluationServiceProvider).nnueDownloadProgress,
                                builder: (_, _) {
                                  return CircularProgressIndicator(
                                    value:
                                        ref
                                            .read(evaluationServiceProvider)
                                            .nnueDownloadProgress
                                            .value,
                                  );
                                },
                              )
                              : const Icon(Icons.download),
                      title: const Text('Download NNUE files'),
                      subtitle: const Text('79MB'),
                      enabled: !isLoading,
                      onTap: () async {
                        final downloaded = await fetchData();
                        if (context.mounted && downloaded) {
                          setState(() {
                            _hasNNUEFiles = true;
                          });
                        }
                      },
                    );
                  },
                )
              else if (_hasNNUEFiles)
                ListTile(
                  trailing: const Icon(Icons.check),
                  title: const Text('NNUE files downloaded'),
                  subtitle: const Text('79MB (tap to delete)'),
                  onTap: () async {
                    final isOk = await showAdaptiveDialog<bool>(
                      context: context,
                      barrierDismissible: true,
                      builder: (context) {
                        return AlertDialog.adaptive(
                          content: const Text('Do you want to delete the NNUE files?'),
                          actions: [
                            PlatformDialogAction(
                              child: const Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                            PlatformDialogAction(
                              child: Text(context.l10n.cancel),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                          ],
                        );
                      },
                    );
                    if (isOk == true) {
                      await ref.read(evaluationServiceProvider).deleteNNUEFiles();
                      setState(() {
                        _hasNNUEFiles = false;
                      });
                    }
                  },
                ),
            ],
          ),
          EngineSettingsWidget(
            onSetEngineSearchTime: (value) {
              ref.read(engineEvaluationPreferencesProvider.notifier).setEngineSearchTime(value);
            },
            onSetEngineCores: (value) {
              ref.read(engineEvaluationPreferencesProvider.notifier).setEngineCores(value);
            },
            onSetNumEvalLines: (value) {
              ref.read(engineEvaluationPreferencesProvider.notifier).setNumEvalLines(value);
            },
          ),
        ],
      ),
    );
  }
}
