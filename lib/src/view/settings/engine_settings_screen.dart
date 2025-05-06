import 'dart:io' show File;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:multistockfish/multistockfish.dart';

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
                          t == EvaluationFunctionPref.hce
                              ? 'Stockfish HCE'
                              : 'Stockfish NNUE (79MB)',
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
