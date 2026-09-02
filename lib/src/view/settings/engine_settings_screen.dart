import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/evaluation_preferences.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/model/engine/weights_service.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/analysis/engine_settings_widget.dart';
import 'package:lichess_mobile/src/widgets/adaptive_choice_picker.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:lichess_mobile/src/widgets/settings.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';
import 'package:material_ui/material_ui.dart';

class EngineSettingsScreen extends ConsumerStatefulWidget {
  const EngineSettingsScreen({super.key});

  static Route<dynamic> buildRoute() {
    return buildScreenRoute(screen: const EngineSettingsScreen());
  }

  @override
  ConsumerState<EngineSettingsScreen> createState() => _EngineSettingsScreenState();
}

class _EngineSettingsScreenState extends ConsumerState<EngineSettingsScreen> {
  /// null = loading, true = has files with checked integrity, false = doesn't have files
  bool? _hasVerifiedNNUEFiles;

  /// Whether there are NNUE files on disk the engine cannot use: the networks of a previous
  /// Stockfish version, or a pair that did not survive its download.
  bool _hasUnusableNNUEFiles = false;

  Future<bool>? _downloadNNUEFilesFuture;

  late final ValueListenable<double> _downloadProgress;

  @override
  void initState() {
    _checkFiles();

    _downloadProgress = ref.read(stockfishNnueServiceProvider).nnueDownloadProgress;

    super.initState();
  }

  Future<void> _checkFiles() async {
    final nnueService = ref.read(stockfishNnueServiceProvider);
    // Deletes the files itself if they are corrupted, so whatever is left over afterwards is
    // either usable or from another Stockfish version.
    final good = await nnueService.checkNNUEFiles();
    final leftOver = !good && await nnueService.hasNNUEFilesOnDisk();
    if (!mounted) return;
    setState(() {
      _hasVerifiedNNUEFiles = good;
      _hasUnusableNNUEFiles = leftOver;
    });
  }

  void _startDownload() {
    final future = ref.read(stockfishNnueServiceProvider).downloadNNUEFiles(inBackground: false);
    future.then((downloaded) {
      if (mounted && downloaded) {
        setState(() {
          _hasVerifiedNNUEFiles = true;
          _hasUnusableNNUEFiles = false;
        });
      }
    });
    setState(() {
      _downloadNNUEFilesFuture = future;
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(engineEvaluationPreferencesProvider);

    return PlatformScaffold(
      appBar: PlatformAppBar(title: const Text('Chess engine')),
      body: ListView(
        children: [
          if (_hasVerifiedNNUEFiles == null)
            Shimmer(
              child: ShimmerLoading(isLoading: true, child: ListSection.loading(itemsNumber: 2)),
            )
          else
            ListSection(
              children: [
                SettingsListTile(
                  settingsLabel: const Text('Engine'),
                  settingsValue: prefs.enginePref.label,
                  onTap: () {
                    showChoicePicker(
                      context,
                      choices: ChessEnginePref.values,
                      selectedItem: prefs.enginePref,
                      labelBuilder: (ChessEnginePref t) => Text(t.label),
                      onSelectedItemChanged: (ChessEnginePref? value) {
                        ref
                            .read(engineEvaluationPreferencesProvider.notifier)
                            .setEvaluationFunction(value ?? ChessEnginePref.sf16);
                        if (value == ChessEnginePref.sfLatest && _hasVerifiedNNUEFiles == false) {
                          _startDownload();
                        }
                      },
                    );
                  },
                ),
                if (prefs.enginePref == ChessEnginePref.sfLatest && _hasVerifiedNNUEFiles == false)
                  LoadingButtonBuilder(
                    initialFuture: _downloadNNUEFilesFuture,
                    fetchData: () => ref
                        .read(stockfishNnueServiceProvider)
                        .downloadNNUEFiles(inBackground: false),
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
                        title: Text(isLoading ? 'Downloading NNUE files' : 'Download NNUE files'),
                        subtitle: const Text(nnueTotalSizeMB),
                        enabled: !isLoading,
                        onTap: () async {
                          final downloaded = await fetchData();
                          if (context.mounted && downloaded) {
                            setState(() {
                              _hasVerifiedNNUEFiles = true;
                              _hasUnusableNNUEFiles = false;
                            });
                          }
                        },
                      );
                    },
                  )
                else if (prefs.enginePref == ChessEnginePref.sfLatest &&
                    _hasVerifiedNNUEFiles == true)
                  ListTile(
                    trailing: const Icon(Icons.check),
                    title: const Text('NNUE files downloaded'),
                    subtitle: const Text('$nnueTotalSizeMB (tap to delete)'),
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
                        await ref.read(stockfishNnueServiceProvider).deleteNNUEFiles();
                        if (!mounted) return;
                        setState(() {
                          _hasVerifiedNNUEFiles = false;
                          _hasUnusableNNUEFiles = false;
                        });
                      }
                    },
                  ),
                if (_hasVerifiedNNUEFiles == false && _hasUnusableNNUEFiles)
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
          const _MaiaNetworksSection(),
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

/// The Maia networks that have been downloaded, and a way to get the space back.
///
/// Nothing is shown until there is something to delete: one network ships with the app, and the
/// rest arrive only if someone chose that rating to play against.
class _MaiaNetworksSection extends ConsumerStatefulWidget {
  const _MaiaNetworksSection();

  @override
  ConsumerState<_MaiaNetworksSection> createState() => _MaiaNetworksSectionState();
}

class _MaiaNetworksSectionState extends ConsumerState<_MaiaNetworksSection> {
  Set<MaiaRating>? _downloaded;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    ref.read(maiaWeightsServiceProvider).availableRatings().then((available) {
      if (mounted) {
        setState(() => _downloaded = available.where((r) => !r.isBundled).toSet());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final downloaded = _downloaded;
    if (downloaded == null || downloaded.isEmpty) return const SizedBox.shrink();

    final totalBytes = downloaded.fold(0, (sum, rating) => sum + rating.expectedSize);
    final ratings = (downloaded.toList()..sort((a, b) => a.rating - b.rating))
        .map((r) => r.rating.toString())
        .join(', ');

    return ListSection(
      header: const Text('Maia networks'),
      children: [
        ListTile(
          trailing: const Icon(Icons.delete_outline),
          title: Text(ratings),
          subtitle: Text('${(totalBytes / (1024 * 1024)).toStringAsFixed(1)} MB (tap to delete)'),
          onTap: () async {
            final isOk = await showAdaptiveDialog<bool>(
              context: context,
              barrierDismissible: true,
              builder: (context) {
                return AlertDialog.adaptive(
                  content: const Text('Do you want to delete the downloaded Maia networks?'),
                  actions: [
                    PlatformDialogAction(
                      child: const Text('OK'),
                      onPressed: () => Navigator.of(context).pop(true),
                    ),
                    PlatformDialogAction(
                      child: Text(context.l10n.cancel),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                );
              },
            );
            if (isOk != true) return;
            await ref.read(maiaWeightsServiceProvider).deleteWeights();
            if (mounted) _refresh();
          },
        ),
      ],
    );
  }
}
