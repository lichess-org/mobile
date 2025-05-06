import 'dart:io' show File;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_service.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/non_linear_slider.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:multistockfish/multistockfish.dart';

class EngineSettingsWidget extends ConsumerStatefulWidget {
  const EngineSettingsWidget({
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
  ConsumerState<EngineSettingsWidget> createState() => _EngineSettingsWidgetState();
}

class _EngineSettingsWidgetState extends ConsumerState<EngineSettingsWidget> {
  bool _hasNNUEFiles = false;

  @override
  void initState() {
    checkNNUEFiles()
        .then((value) {
          setState(() {
            _hasNNUEFiles = value;
          });
        })
        .catchError((Object error) {
          debugPrint('Error checking NNUE files: $error');
        });

    super.initState();
  }

  final ValueNotifier<double> _downloadProgress = ValueNotifier(0.0);

  ValueListenable<double> get downloadProgress => _downloadProgress;

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
          footer: const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text.rich(
              textAlign: TextAlign.justify,
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
                        'The NNUE engine is better at evaluating positions but requires to download a 79MB neural network.',
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
            if (prefs.evaluationFunction == EvaluationFunctionPref.nnue && !_hasNNUEFiles)
              LoadingButtonBuilder(
                fetchData: downloadNNUEFiles,
                builder: (context, isLoading, fetchData) {
                  return ListTile(
                    trailing:
                        isLoading
                            ? AnimatedBuilder(
                              animation: _downloadProgress,
                              builder: (_, _) {
                                return CircularProgressIndicator(value: _downloadProgress.value);
                              },
                            )
                            : const Icon(Icons.download),
                    title: const Text('Download NNUE files'),
                    subtitle: const Text('79MB'),
                    enabled: !isLoading,
                    onTap: () async {
                      await fetchData();
                      if (context.mounted) {
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
                subtitle: const Text('Tap to delete'),
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
                            child: const Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (isOk == true) {
                    await deleteNNUEFiles();
                    setState(() {
                      _hasNNUEFiles = false;
                    });
                  }
                },
              ),
          ],
        ),
        ListSection(
          header: const SettingsSectionTitle('Stockfish'),
          children: [
            ListTile(
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
            ListTile(
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
              ListTile(
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

  Future<bool> checkNNUEFiles() async {
    final appSupportDirectory = ref.read(preloadedDataProvider).requireValue.appSupportDirectory;

    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }

    final bigNetFile = File('${appSupportDirectory.path}/${Stockfish.defaultBigNetFile}');
    final smallNetFile = File('${appSupportDirectory.path}/${Stockfish.defaultSmallNetFile}');

    if (await bigNetFile.exists() && await smallNetFile.exists()) {
      return true;
    }

    return false;
  }

  Future<void> downloadNNUEFiles() async {
    final appSupportDirectory = ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }

    final bigNetFile = File('${appSupportDirectory.path}/${Stockfish.defaultBigNetFile}');
    final smallNetFile = File('${appSupportDirectory.path}/${Stockfish.defaultSmallNetFile}');

    // delete any existing nnue files before downloading
    await deleteNNUEFiles();

    Future<void> doDownload() async {
      final client = ref.read(defaultClientProvider);
      await downloadFiles(
        client,
        [StockfishEngine.bigNetUrl, StockfishEngine.smallNetUrl],
        [bigNetFile, smallNetFile],
        onProgress: (received, length) {
          _downloadProgress.value = received / length;
        },
      );
    }

    final connectivityResult = await ref.read(connectivityPluginProvider).checkConnectivity();
    final onWifi = connectivityResult.contains(ConnectivityResult.wifi);
    if (onWifi == false && mounted) {
      final isOk = await showAdaptiveDialog<bool>(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog.adaptive(
            content: const Text('Are you sure you want to download the NNUE files (79MB)?'),
            actions: [
              PlatformDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              PlatformDialogAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
      if (isOk == true) {
        return doDownload();
      } else {
        return Future.value();
      }
    } else if (mounted) {
      return doDownload();
    }
  }

  Future<void> deleteNNUEFiles() async {
    final appSupportDirectory = ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }

    // delete any existing nnue files before downloading
    await for (final entity in appSupportDirectory.list(followLinks: false)) {
      if (entity is File && entity.path.endsWith('.nnue')) {
        debugPrint('Deleting existing nnue ${entity.path}');
        await entity.delete();
      }
    }
  }
}
