import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/model/engine/engine_utils.dart';
import 'package:lichess_mobile/src/model/engine/opponent_level.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

final _logger = Logger('MaiaWeightsService');

/// A provider for [MaiaWeightsService].
final maiaWeightsServiceProvider = Provider<MaiaWeightsService>((Ref ref) {
  return MaiaWeightsService(ref);
}, name: 'MaiaWeightsServiceProvider');

/// Manages the Maia networks on disk: which ones are there, downloading the ones that are not.
///
/// The same job [NnueService] does for the Stockfish networks, with one difference that shapes the
/// whole class: one network — [MaiaRating.defaultRating] — ships in the asset bundle, so there is
/// always a Maia to play against. LC0 reads its network from a path rather than from bytes, so
/// even the bundled one is written out to the app support directory the first time it is asked
/// for.
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
    final File anyFile;
    try {
      anyFile = weightsFile(MaiaRating.defaultRating);
    } catch (e, st) {
      _logger.warning('Cannot delete the Maia networks:', e, st);
      return;
    }

    final directory = anyFile.parent;
    if (!await directory.exists()) return;
    await for (final entity in directory.list(followLinks: false)) {
      if (entity is File && entity.path.endsWith('.pb.gz')) {
        _logger.info('Deleting ${entity.path}');
        await entity.delete();
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

    _logger.info('Downloading ${rating.fileName}');
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
      if (!ok) return null;
    } catch (e, st) {
      _logger.warning('Failed to download ${rating.fileName}:', e, st);
      return null;
    }

    if (!await _checkFile(rating)) {
      _logger.warning('${rating.fileName} did not survive the download; deleting it.');
      await file.delete().catchError((Object _) => file);
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
        _logger.warning('${rating.fileName} is corrupted.');
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
