import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_onnxruntime/flutter_onnxruntime.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/common/preloaded_data.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:logging/logging.dart';

final _logger = Logger('BoardVision');

// ChessQueries Lite, a vision model that reads the piece placement off a picture of a board, the
// same int8 quantized build that lichess.org runs in its board editor.
// https://huggingface.co/joelseytre/chessq-lite
const _modelFileName = 'chessq-lite-v4-int8.onnx';
final _modelUrl = Uri.parse('$kLichessCDNHost/assets/lifat/vision/$_modelFileName');

/// First 12 digits of the SHA256 hash of the model file.
const _modelHash = '89d75e343c5d';

/// Size in bytes of the model file, as it is served.
const _modelExpectedSize = 41370398;

/// What the model download costs, formatted as a human-readable string.
const boardVisionModelSizeMB = '${_modelExpectedSize ~/ (1024 * 1024)}MB';

/// The side, in pixels, of the square image the model reads.
const _resolution = 644;
const _channelSize = _resolution * _resolution;

/// Standard ImageNet normalization constants, per RGB channel.
const _mean = [0.485, 0.456, 0.406];
const _std = [0.229, 0.224, 0.225];

/// What the model outputs for each square, in the order of its classes: empty, then pieces.
const _classSymbols = '.PNBRQKpnbrqk';
const _classCount = _classSymbols.length;

/// A provider for [BoardVisionService].
final boardVisionServiceProvider = Provider<BoardVisionService>((Ref ref) {
  return BoardVisionService(ref);
}, name: 'BoardVisionServiceProvider');

/// Provides the model that [BoardReader] reads boards with.
///
/// The model is not shipped with the app: it is downloaded on first use.
class BoardVisionService(final Ref _ref) {
  final ValueNotifier<double> _downloadProgress = ValueNotifier(0.0);

  /// Whether the model on disk has been checked against its hash.
  bool _modelVerified = false;

  /// Progress of the model download, from 0 to 1.
  ValueListenable<double> get downloadProgress => _downloadProgress;

  /// Where the model is kept on disk.
  String get modelPath => _modelFile.path;

  File get _modelFile {
    final appSupportDirectory = _ref.read(preloadedDataProvider).requireValue.appSupportDirectory;
    if (appSupportDirectory == null) {
      throw Exception('App support directory is null.');
    }
    return File('${appSupportDirectory.path}/vision/$_modelFileName');
  }

  /// Whether the model is on disk and intact.
  ///
  /// A file that fails the checksum is deleted.
  Future<bool> isModelReady() async {
    if (_modelVerified) return true;
    final file = _modelFile;
    if (!await file.exists()) return false;
    final path = file.path;
    _modelVerified = await Isolate.run(() => _checksumMatches(path, _modelHash));
    if (!_modelVerified) {
      _logger.warning('The board vision model is corrupted, deleting it.');
      await file.delete();
    }
    return _modelVerified;
  }

  /// Downloads the model, returning whether it is then ready to use.
  Future<bool> downloadModel() async {
    final file = _modelFile;
    await file.parent.create(recursive: true);
    _downloadProgress.value = 0.0;
    final downloaded = await downloadFile(
      _ref.read(defaultClientProvider),
      _modelUrl,
      file,
      expectedLength: _modelExpectedSize,
      onProgress: (received, length) => _downloadProgress.value = received / length,
    );
    return downloaded && await isModelReady();
  }
}

/// A provider for a [BoardReader].
///
/// The reader keeps the model in memory once it has read a first picture, until the provider is
/// disposed: watch it for as long as more pictures may come.
final boardReaderProvider = Provider.autoDispose<BoardReader>((Ref ref) {
  final reader = BoardReader(ref.read(boardVisionServiceProvider).modelPath);
  ref.onDispose(() => unawaited(reader.close()));
  return reader;
}, name: 'BoardReaderProvider');

/// Reads the piece placement of a chessboard from a picture of it, with the model at [_modelPath].
///
/// The model is loaded on the first read, and kept until [close] is called.
class BoardReader(final String _modelPath) {
  Future<OrtSession>? _session;
  bool _closed = false;

  Future<OrtSession> _loadSession() async {
    final stopwatch = Stopwatch()..start();
    final session = await OnnxRuntime().createSession(
      _modelPath,
      options: OrtSessionOptions(intraOpNumThreads: math.min(4, Platform.numberOfProcessors)),
    );
    _logger.info('Loaded the board vision model in ${stopwatch.elapsedMilliseconds}ms');
    return session;
  }

  /// Reads the piece placement, the first field of a FEN, of the board pictured in [imageBytes].
  ///
  /// The model must be ready, see [BoardVisionService.isModelReady]. The picture is taken to be of
  /// the board alone, seen from White's side.
  Future<String> readPlacement(Uint8List imageBytes) async {
    if (_closed) throw StateError('The board reader is closed.');
    final stopwatch = Stopwatch()..start();

    // The image is decoded and scaled down by the engine, which can only be reached from the root
    // isolate. Like on lichess.org, the whole picture is stretched to the square the model reads.
    final codec = await ui.instantiateImageCodec(
      imageBytes,
      targetWidth: _resolution,
      targetHeight: _resolution,
    );
    final ByteData? rgba;
    try {
      final frame = await codec.getNextFrame();
      rgba = await frame.image.toByteData(format: ui.ImageByteFormat.rawRgba);
      frame.image.dispose();
    } finally {
      codec.dispose();
    }
    if (rgba == null) throw Exception('Could not decode the image.');
    final pixels = rgba.buffer.asUint8List(rgba.offsetInBytes, rgba.lengthInBytes);
    final input = await Isolate.run(() => imageTensorFromRgba(pixels));
    final preprocessingTime = stopwatch.elapsedMilliseconds;

    // A load that failed is not kept, so that the next read tries again.
    final pending = _session ??= _loadSession();
    final OrtSession session;
    try {
      session = await pending;
    } catch (_) {
      if (identical(_session, pending)) _session = null;
      rethrow;
    }

    stopwatch.reset();
    final tensor = await OrtValue.fromList(input, const [1, 3, _resolution, _resolution]);
    final String placement;
    try {
      final outputs = await session.run({'image': tensor});
      try {
        final logits = await outputs['logits']?.asFlattenedList();
        if (logits == null || logits.length != 64 * _classCount) {
          throw Exception('Unexpected model output.');
        }
        placement = placementFromLogits(
          Float32List.fromList([for (final value in logits) (value as num).toDouble()]),
        );
      } finally {
        await Future.wait(outputs.values.map((value) => value.dispose()));
      }
    } finally {
      await tensor.dispose();
    }
    _logger.info(
      'Read $placement: preprocessing ${preprocessingTime}ms, '
      'inference ${stopwatch.elapsedMilliseconds}ms',
    );
    return placement;
  }

  /// Releases the model. The reader cannot be used afterwards.
  Future<void> close() async {
    _closed = true;
    final pending = _session;
    _session = null;
    if (pending == null) return;
    try {
      await (await pending).close();
      _logger.info('Released the board vision model');
    } catch (e, st) {
      _logger.warning('Could not release the board vision model:', e, st);
    }
  }
}

/// Converts [rgba], the pixels of a [_resolution] square image, to the normalized, planar RGB
/// tensor the model reads.
@visibleForTesting
Float32List imageTensorFromRgba(Uint8List rgba) {
  assert(rgba.length == _channelSize * 4);
  final input = Float32List(3 * _channelSize);
  for (var pixel = 0, offset = 0; pixel < _channelSize; pixel++, offset += 4) {
    for (var channel = 0; channel < 3; channel++) {
      input[channel * _channelSize + pixel] =
          (rgba[offset + channel] / 255 - _mean[channel]) / _std[channel];
    }
  }
  return input;
}

/// Converts the model's output, the scores of each class for each of the 64 squares from a8 to
/// h1, to the piece placement of a FEN.
@visibleForTesting
String placementFromLogits(Float32List logits) {
  assert(logits.length == 64 * _classCount);
  final ranks = <String>[];
  for (var rank = 0; rank < 8; rank++) {
    final buffer = StringBuffer();
    var empty = 0;
    for (var file = 0; file < 8; file++) {
      final offset = (rank * 8 + file) * _classCount;
      var best = 0;
      for (var label = 1; label < _classCount; label++) {
        if (logits[offset + label] > logits[offset + best]) best = label;
      }
      if (best == 0) {
        empty++;
      } else {
        if (empty > 0) buffer.write(empty);
        empty = 0;
        buffer.write(_classSymbols[best]);
      }
    }
    if (empty > 0) buffer.write(empty);
    ranks.add(buffer.toString());
  }
  return ranks.join('/');
}

bool _checksumMatches(String filePath, String expectedHash) {
  final bytes = File(filePath).readAsBytesSync();
  final hash = sha256.convert(bytes).toString().substring(0, 12);
  return hash == expectedHash;
}
