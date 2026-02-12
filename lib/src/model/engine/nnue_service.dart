import 'dart:io';
import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show AlertDialog, Navigator, Text, showAdaptiveDialog;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:logging/logging.dart';
import 'package:multistockfish/multistockfish.dart';

final _logger = Logger('NnueService');

typedef NNUEFiles = ({File bigNet, File smallNet});

/// A provider for [NnueService].
final nnueServiceProvider = Provider<NnueService>((Ref ref) {
  return NnueService(ref);
}, name: 'NnueServiceProvider');

/// A service to manage NNUE files for the Stockfish engine.
///
/// This service handles downloading, checking, and deleting NNUE files.
/// It can be overridden in tests to avoid file system access.
class NnueService {
  NnueService(this._ref);

  final Ref _ref;

  final ValueNotifier<double> _nnueDownloadProgress = ValueNotifier(0.0);
  bool _nnueOperationInProgress = false;

  /// Cache the result of the NNUE checksum verification.
  bool? _nnueSumCheckResult;

  ValueListenable<double> get nnueDownloadProgress => _nnueDownloadProgress;

  bool get isDownloadingNNUEFiles =>
      nnueDownloadProgress.value > 0.0 && nnueDownloadProgress.value < 1.0;

  /// Get the NNUE files paths.
  ///
  /// Throws an exception if the app support directory is not available.
  NNUEFiles get nnueFiles {
    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }

    final bigNetFile = File('${appSupportDirectory.path}/${Stockfish.latestBigNNUE}');
    final smallNetFile = File('${appSupportDirectory.path}/${Stockfish.latestSmallNNUE}');

    return (bigNet: bigNetFile, smallNet: smallNetFile);
  }

  /// Check the presence and integrity of the NNUE files.
  Future<bool> checkNNUEFiles() async {
    final NNUEFiles files;
    try {
      files = nnueFiles;
    } catch (e) {
      _logger.warning('Error getting NNUE files: $e');
      return false;
    }

    final (:bigNet, :smallNet) = files;

    try {
      final found = await bigNet.exists() && await smallNet.exists();
      if (found) {
        _nnueSumCheckResult ??= await Isolate.run(() {
          return _checksumMatches(bigNet.path, bigNetHash) &&
              _checksumMatches(smallNet.path, smallNetHash);
        });

        if (_nnueSumCheckResult == true) {
          return true;
        } else {
          _logger.warning('NNUE files are corrupted.');
        }
      }

      return false;
    } catch (e) {
      _logger.warning('Error checking NNUE files: $e');
      return false;
    }
  }

  Future<bool> downloadNNUEFiles({bool inBackground = true}) async {
    if (_nnueOperationInProgress) {
      _logger.warning('NNUE download already in progress, ignoring request');
      return false;
    }

    _nnueOperationInProgress = true;

    try {
      final NNUEFiles files;
      try {
        files = nnueFiles;
      } catch (e) {
        _logger.warning('Error getting NNUE files: $e');
        return false;
      }

      final (:bigNet, :smallNet) = files;

      // delete any existing nnue files before downloading
      await deleteNNUEFiles();

      Future<bool> doDownload() {
        final client = _ref.read(defaultClientProvider);
        return downloadFiles(
          client,
          [bigNetUrl, smallNetUrl],
          [bigNet, smallNet],
          onProgress: (received, length) {
            _nnueDownloadProgress.value = received / length;
          },
        );
      }

      final connectivityResult = await _ref.read(connectivityPluginProvider).checkConnectivity();
      final onWifi = connectivityResult.contains(ConnectivityResult.wifi);
      if (onWifi == false) {
        if (inBackground) {
          throw Exception('Cannot download in background on mobile data.');
        } else {
          final context = _ref.read(currentNavigatorKeyProvider).currentContext;
          if (context == null || !context.mounted) return false;
          final isOk = await showAdaptiveDialog<bool>(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return AlertDialog.adaptive(
                content: const Text('Are you sure you want to download the NNUE files (109MB)?'),
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
            await doDownload();
            return checkNNUEFiles();
          } else {
            return Future.value(false);
          }
        }
      } else {
        return doDownload();
      }
    } finally {
      _nnueOperationInProgress = false;
      _nnueDownloadProgress.value = 0.0;
    }
  }

  Future<void> deleteNNUEFiles() async {
    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }

    _nnueSumCheckResult = null;

    // delete any existing nnue files before downloading
    await for (final entity in appSupportDirectory.list(followLinks: false)) {
      if (entity is File && entity.path.endsWith('.nnue')) {
        _logger.info('Deleting existing nnue ${entity.path}');
        await entity.delete();
      }
    }
  }
}

bool _checksumMatches(String filePath, String expectedHash) {
  final bytes = File(filePath).readAsBytesSync();
  final hash = sha256.convert(bytes).toString().substring(0, 12);
  return hash == expectedHash;
}
