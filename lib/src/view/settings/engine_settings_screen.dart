import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:material_ui/material_ui.dart';

class const EngineSettingsScreen({super.key}) extends ConsumerStatefulWidget {
  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const EngineSettingsScreen());
  }

  @override
  ConsumerState<EngineSettingsScreen> createState() => _EngineSettingsScreenState();
}

class _EngineSettingsScreenState() extends ConsumerState<EngineSettingsScreen> {
  /// null = loading, true = has the file with checked integrity, false = doesn't have it
  bool? _hasVerifiedNNUEFile;

  /// Whether there are NNUE files on disk the engine cannot use: the network of a previous
  /// Stockfish version, or one that did not survive its download.
  bool _hasUnusableNNUEFiles = false;

  Future<bool>? _downloadNNUEFileFuture;

  late final ValueListenable<double> _downloadProgress;

  @override
  void initState() {
    _checkFiles();

    _downloadProgress = ref.read(stockfishNnueServiceProvider).nnueDownloadProgress;

    super.initState();
  }

  Future<void> _checkFiles() async {
    final nnueService = ref.read(stockfishNnueServiceProvider);
    // Deletes the file itself if it is corrupted, so whatever is left over afterwards is
    // either usable or from another Stockfish version.
    final good = await nnueService.checkNNUEFile();
    final leftOver = !good && await nnueService.hasNNUEFilesOnDisk();
    if (!mounted) return;
    setState(() {
      _hasVerifiedNNUEFile = good;
      _hasUnusableNNUEFiles = leftOver;
    });
  }

  void _startDownload() {
    final future = ref.read(stockfishNnueServiceProvider).downloadNNUEFile(inBackground: false);
    future.then((downloaded) {
      if (mounted && downloaded) {
        setState(() {
          _hasVerifiedNNUEFile = true;
          _hasUnusableNNUEFiles = false;
        });
      }
    });
    setState(() {
      _downloadNNUEFileFuture = future;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(engineEvaluationPreferencesProvider);

    return PlatformScaffold(
      appBar: PlatformAppBar(title: Text(context.l10n.mobileChessEngine)),
      body: ListView(
        children: [
          if (_hasVerifiedNNUEFile == null)
            Shimmer(
              child: ShimmerLoading(isLoading: true, child: ListSection.loading(itemsNumber: 2)),
            )
          else
            ListSection(
              children: [
                SettingsListTile(
                  settingsLabel: Text(context.l10n.mobileChessEngine),
                  // The check tells apart the net that is on disk from the one still to download:
                  // it only means something for the latest engine, the light one ships with the app.
                  settingsValue:
                      prefs.enginePref == ChessEnginePref.sfLatest && _hasVerifiedNNUEFile == true
                      ? '${prefs.enginePref.label} \u2713'
                      : prefs.enginePref.label,
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: ChessEnginePref.values,
                      selectedItem: prefs.enginePref,
                      labelBuilder: (ChessEnginePref t) => Text(t.label),
                      onSelectedItemChanged: (ChessEnginePref? value) {
                        ref
                            .read(engineEvaluationPreferencesProvider.notifier)
                            .setEvaluationFunction(value ?? ChessEnginePref.sfLight);
                        if (value == ChessEnginePref.sfLatest && _hasVerifiedNNUEFile == false) {
                          _startDownload();
                        }
                      },
                    );
                  },
                ),
                if (prefs.enginePref == ChessEnginePref.sfLatest && _hasVerifiedNNUEFile == false)
                  LoadingButtonBuilder(
                    initialFuture: _downloadNNUEFileFuture,
                    fetchData: () => ref
                        .read(stockfishNnueServiceProvider)
                        .downloadNNUEFile(inBackground: false),
                    builder: (context, isLoading, fetchData) {
                      return ListTile(
                        trailing: isLoading
                            ? AnimatedBuilder(
                                animation: _downloadProgress,
                                builder: (_, _) {
                                  final progress = _downloadProgress.value;
                                  return CircularProgressIndicator(
                                    value: progress > 0.0 ? progress : null,
                                  );
                                },
                              )
                            : const Icon(Icons.download),
                        title: Text(
                          isLoading
                              ? context.l10n.mobileDownloadingNnueFile
                              : context.l10n.mobileDownloadNnueFile,
                        ),
                        subtitle: const Text(nnueDownloadSizeMB),
                        enabled: !isLoading,
                        onTap: () async {
                          final downloaded = await fetchData();
                          if (context.mounted && downloaded) {
                            setState(() {
                              _hasVerifiedNNUEFile = true;
                              _hasUnusableNNUEFiles = false;
                            });
                          }
                        },
                      );
                    },
                  ),
                if (_hasVerifiedNNUEFile == false && _hasUnusableNNUEFiles)
                  ListTile(
                    trailing: const Icon(Icons.delete),
                    title: const Text('Delete unusable NNUE files'),
                    subtitle: const Text(
                      'Some NNUE files on this device cannot be used by the engine. Deleting them '
                      'frees up space and lets you download them again.',
                    ),
                    onTap: () async {
                      await ref.read(stockfishNnueServiceProvider).deleteNNUEFiles();
                      if (!mounted) return;
                      setState(() {
                        _hasUnusableNNUEFiles = false;
                      });
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
