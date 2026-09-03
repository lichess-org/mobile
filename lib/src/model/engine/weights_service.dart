import 'dart:io';
import 'dart:isolate';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/network/connectivity.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/tab_navigation.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/widgets/platform_alert_dialog.dart';
import 'package:logging/logging.dart';
import 'package:material_ui/material_ui.dart' show AlertDialog, Navigator, Text, showAdaptiveDialog;
import 'package:multistockfish/multistockfish.dart';

final _logger = Logger('EngineWeightsService');

typedef NNUEFiles = ({File bigNet, File smallNet});

/// A provider for [StockfishNnueService].
final stockfishNnueServiceProvider = Provider<StockfishNnueService>((Ref ref) {
  return StockfishNnueService(ref);
}, name: 'StockfishNnueServiceProvider');

/// A service to manage NNUE files for the Stockfish engine.
///
/// This service handles downloading, checking, and deleting NNUE files.
/// It can be overridden in tests to avoid file system access.
class StockfishNnueService {
  StockfishNnueService(this._ref);

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

  Future<bool> hasOutdatedNNUEFiles() async {
    if (await checkNNUEFiles()) {
      return false;
    }

    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      return false;
    }

    final NNUEFiles files = nnueFiles;

    await for (final entity in appSupportDirectory.list(followLinks: false)) {
      if (entity is File &&
          entity.path.endsWith('.nnue') &&
          entity.path != files.bigNet.path &&
          entity.path != files.smallNet.path) {
        return true;
      }
    }
    return false;
  }

  /// Whether there is any NNUE file on disk, current or not, intact or not.
  ///
  /// Useful to offer to reclaim the space taken by files the engine cannot use: the networks of a
  /// previous Stockfish version, or a pair that did not survive its download.
  Future<bool> hasNNUEFilesOnDisk() async {
    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      return false;
    }

    try {
      await for (final entity in appSupportDirectory.list(followLinks: false)) {
        if (entity is File && entity.path.endsWith('.nnue')) return true;
      }
    } catch (e, st) {
      _logger.warning('Error listing NNUE files:', e, st);
    }
    return false;
  }

  /// Check the presence and integrity of the NNUE files.
  ///
  /// Files that fail the checksum are deleted: they are useless to the engine, they take up more
  /// than 100MB, and leaving them on disk makes the next download look like it has nothing to do.
  Future<bool> checkNNUEFiles() async {
    final NNUEFiles files;
    try {
      files = nnueFiles;
    } catch (e, st) {
      _logger.warning('Error getting NNUE files:', e, st);
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
          _logger.warning('NNUE files are corrupted, deleting them.');
          await deleteNNUEFiles();
        }
      }

      return false;
    } catch (e, st) {
      _logger.warning('Error checking NNUE files:', e, st);
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
      } catch (e, st) {
        _logger.warning('Error getting NNUE files:', e, st);
        return false;
      }

      final (:bigNet, :smallNet) = files;

      // delete any existing nnue files before downloading
      await deleteNNUEFiles();

      // The download only counts as a success if what landed on disk is what the engine needs:
      // a file that arrives truncated or garbled is deleted rather than kept and reported as
      // downloaded, which would leave the engine falling back to SF16 with no way out.
      Future<bool> doDownload() async {
        final client = _ref.read(defaultClientProvider);
        final downloaded = await downloadFiles(
          client,
          [bigNetUrl, smallNetUrl],
          [bigNet, smallNet],
          expectedLengths: [bigNetExpectedSize, smallNetExpectedSize],
          onProgress: (received, length) {
            _nnueDownloadProgress.value = received / length;
          },
        );
        if (!downloaded) {
          await deleteNNUEFiles();
          return false;
        }
        // Deletes the files itself if they do not check out.
        return checkNNUEFiles();
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
                content: const Text(
                  'Are you sure you want to download the NNUE files ($nnueTotalSizeMB)?',
                ),
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
            return await doDownload();
          } else {
            return false;
          }
        }
      } else {
        return await doDownload();
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

    await for (final entity in appSupportDirectory.list(followLinks: false)) {
      if (entity is File && entity.path.endsWith('.nnue')) {
        _logger.info('Deleting existing nnue ${entity.path}');
        try {
          await entity.delete();
        } catch (e, st) {
          _logger.warning('Could not delete ${entity.path}:', e, st);
        }
      }
    }
  }
}

/// A provider for [MaiaWeightsService].
final maiaWeightsServiceProvider = Provider<MaiaWeightsService>((Ref ref) {
  return MaiaWeightsService(ref);
}, name: 'MaiaWeightsServiceProvider');

/// Manages the Maia networks on disk: which ones are there, downloading the ones that are not.
///
/// The same job [StockfishNnueService] does for the Stockfish networks, with one difference that
/// shapes the whole class: one network — [MaiaRating.defaultRating] — ships in the asset bundle, so
/// there is always a Maia to play against. LC0 reads its network from a path rather than from
/// bytes, so even the bundled one is written out to the app support directory the first time it is
/// asked for.
class MaiaWeightsService {
  MaiaWeightsService(this._ref);

  final Ref _ref;

  /// The download in progress, by rating, so that two callers asking at once share one download
  /// rather than writing over each other's file.
  final Map<MaiaRating, Future<String?>> _inFlight = {};

  /// The ratings whose file has been checked this session, so the checksum is computed once.
  final Set<MaiaRating> _verified = {};

  final ValueNotifier<double> _downloadProgress = ValueNotifier(0.0);

  /// How far the download in progress has got, from 0 to 1.
  ValueListenable<double> get downloadProgress => _downloadProgress;

  /// The rating being downloaded, if one is.
  MaiaRating? get downloading => _inFlight.keys.firstOrNull;

  /// Where the network for [rating] lives, whether or not it is there yet.
  ///
  /// Throws if the app support directory is not available.
  File weightsFile(MaiaRating rating) {
    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }
    return File('${appSupportDirectory.path}/$kMaiaWeightsDirName/${rating.fileName}');
  }

  /// Whether the network for [rating] is on disk and intact.
  ///
  /// The bundled network counts as available before it has been written out: [ensureWeights] can
  /// always produce it, without a network connection.
  Future<bool> isAvailable(MaiaRating rating) async {
    if (rating.isBundled) return true;
    return _checkFile(rating);
  }

  /// The ratings that can be played right now.
  Future<Set<MaiaRating>> availableRatings() async {
    final available = <MaiaRating>{};
    for (final rating in MaiaRating.values) {
      if (await isAvailable(rating)) available.add(rating);
    }
    return available;
  }

  /// The path of the network to play [rating] with, downloading it if it is not there.
  ///
  /// Falls back to the bundled network — and says so by returning a different rating — rather than
  /// failing: an opponent that cannot move because a download did not work is a dead end, and a
  /// game against a Maia of the wrong strength is a much smaller disappointment than no game.
  Future<({MaiaRating rating, String path})> ensureWeights(MaiaRating rating) async {
    if (await _pathIfReady(rating) case final path?) return (rating: rating, path: path);

    if (await download(rating) case final path?) return (rating: rating, path: path);

    _logger.warning('Falling back to ${MaiaRating.defaultRating.name}: ${rating.name} is missing.');
    final fallback = await _pathIfReady(MaiaRating.defaultRating);
    if (fallback == null) {
      throw Exception('The bundled Maia network could not be written to disk.');
    }
    return (rating: MaiaRating.defaultRating, path: fallback);
  }

  /// Downloads the network for [rating], and returns its path, or null if it could not be had.
  ///
  /// A download already in flight for the same rating is joined rather than started again.
  Future<String?> download(MaiaRating rating) {
    if (_inFlight[rating] case final inFlight?) return inFlight;
    final download = _download(rating).whenComplete(() {
      _inFlight.remove(rating);
      _downloadProgress.value = 0.0;
    });
    _inFlight[rating] = download;
    return download;
  }

  /// Deletes every downloaded network. The bundled one is written out again on demand.
  Future<void> deleteWeights() async {
    _verified.clear();
    await _deleteFiles(await _filesOnDisk());
  }

  /// The network files on disk that nothing can use, and the space they take.
  ///
  /// A rating's own file is deleted the moment it fails its checksum, so what shows up here is a
  /// file left behind by an older version of the app: no rating claims that name any more, and
  /// nothing will ever check it or clean it up.
  Future<({int count, int bytes})> unusableWeights() async {
    final files = await _unusableFiles();
    var bytes = 0;
    for (final file in files) {
      try {
        bytes += await file.length();
      } catch (e, st) {
        _logger.warning('Could not size ${file.path}:', e, st);
      }
    }
    return (count: files.length, bytes: bytes);
  }

  /// Deletes the files [unusableWeights] reports, leaving the usable networks alone.
  Future<void> deleteUnusableWeights() async {
    await _deleteFiles(await _unusableFiles());
  }

  /// Every network file in the weights directory.
  Future<List<File>> _filesOnDisk() async {
    final File anyFile;
    try {
      anyFile = weightsFile(MaiaRating.defaultRating);
    } catch (e, st) {
      _logger.warning('Cannot list the Maia networks:', e, st);
      return const [];
    }

    final directory = anyFile.parent;
    try {
      if (!await directory.exists()) return const [];
      return await directory
          .list(followLinks: false)
          .where((entity) => entity is File && entity.path.endsWith('.pb.gz'))
          .cast<File>()
          .toList();
    } catch (e, st) {
      _logger.warning('Error listing the Maia networks:', e, st);
      return const [];
    }
  }

  Future<List<File>> _unusableFiles() async {
    final claimed = <String>{};
    for (final rating in MaiaRating.values) {
      // A bundled rating always claims its file, whether or not it has been written out yet.
      if (rating.isBundled || await isAvailable(rating)) claimed.add(weightsFile(rating).path);
    }

    // Listed after the checks above, which delete the corrupted files they find: what is left is
    // only what nothing claims.
    final files = await _filesOnDisk();
    return files.where((file) => !claimed.contains(file.path)).toList();
  }

  Future<void> _deleteFiles(Iterable<File> files) async {
    for (final file in files) {
      _logger.info('Deleting ${file.path}');
      try {
        await file.delete();
      } catch (e, st) {
        _logger.warning('Could not delete ${file.path}:', e, st);
      }
    }
  }

  /// The path of [rating]'s network if it can be produced without the network, null otherwise.
  Future<String?> _pathIfReady(MaiaRating rating) async {
    if (await _checkFile(rating)) return weightsFile(rating).path;
    if (rating.isBundled) return _writeBundledWeights(rating);
    return null;
  }

  Future<String?> _download(MaiaRating rating) async {
    final File file;
    try {
      file = weightsFile(rating);
    } catch (e, st) {
      _logger.warning('Cannot download ${rating.name}:', e, st);
      return null;
    }

    _logger.info('Downloading Maia network ${rating.fileName}');
    try {
      await file.parent.create(recursive: true);
      if (await file.exists()) await file.delete();
      _verified.remove(rating);

      final ok = await downloadFile(
        _ref.read(defaultClientProvider),
        maiaWeightsUrl(rating.fileName),
        file,
        expectedLength: rating.expectedSize,
        onProgress: (received, length) {
          _downloadProgress.value = length > 0 ? received / length : 0.0;
        },
      );
      if (!ok) {
        await _deleteFiles([file]);
        return null;
      }
    } catch (e, st) {
      _logger.warning('Failed to download ${rating.fileName}:', e, st);
      await _deleteFiles([file]);
      return null;
    }

    // A file that fails here is deleted by the check itself.
    if (!await _checkFile(rating)) {
      _logger.warning('${rating.fileName} did not survive the download.');
      return null;
    }
    return file.path;
  }

  /// Writes a bundled network out of the asset bundle, so that LC0 has a path to read.
  Future<String?> _writeBundledWeights(MaiaRating rating) async {
    try {
      final file = weightsFile(rating);
      await file.parent.create(recursive: true);
      final bytes = await rootBundle.load(bundledMaiaAsset(rating.fileName));
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      _verified.add(rating);
      _logger.info('Wrote the bundled ${rating.fileName} to ${file.path}');
      return file.path;
    } catch (e, st) {
      _logger.severe('Could not write the bundled Maia network:', e, st);
      return null;
    }
  }

  /// Whether the file for [rating] is on disk and its checksum matches.
  ///
  /// A file that fails the checksum is deleted: LC0 cannot read it, it takes up space, and leaving
  /// it there would make the next download look like it has nothing to do.
  Future<bool> _checkFile(MaiaRating rating) async {
    if (_verified.contains(rating)) return true;
    try {
      final file = weightsFile(rating);
      if (!await file.exists()) return false;
      final path = file.path;
      final expected = rating.sha256Prefix;
      final matches = await Isolate.run(() => _checksumMatches(path, expected));
      if (matches) {
        _verified.add(rating);
      } else {
        _logger.warning('${rating.fileName} is corrupted, deleting it.');
        await _deleteFiles([file]);
      }
      return matches;
    } catch (e, st) {
      _logger.warning('Error checking ${rating.fileName}:', e, st);
      return false;
    }
  }
}

bool _checksumMatches(String filePath, String expectedHash) {
  final bytes = File(filePath).readAsBytesSync();
  final hash = sha256.convert(bytes).toString().substring(0, 12);
  return hash == expectedHash;
}
