import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:material_color_utilities/material_color_utilities.dart';

typedef ImageColors = ({int primaryContainer, int onPrimaryContainer});

/// A worker that quantizes an image and returns a minimal color scheme associated
/// with the image.
///
/// It is the responsibility of the caller to provide a scaled down version of the
/// image to the worker to avoid a costly quantization process.
///
/// The worker is created by calling [ImageColorWorker.spawn], and the computation
/// is run in a separate isolate.
class ImageColorWorker {
  final SendPort _commands;
  final ReceivePort _responses;
  final Map<int, Completer<ImageColors?>> _activeRequests = {};
  int _idCounter = 0;
  bool _closed = false;

  bool get closed => _closed;

  /// Returns a minimal color scheme associated with the given [image].
  Future<ImageColors?> getImageColors(Uint32List image) async {
    if (_closed) throw StateError('Closed');
    final completer = Completer<ImageColors?>.sync();
    final id = _idCounter++;
    _activeRequests[id] = completer;
    _commands.send((id, image));
    return await completer.future;
  }

  static Future<ImageColorWorker> spawn() async {
    final initPort = RawReceivePort();
    final connection = Completer<(ReceivePort, SendPort)>.sync();
    initPort.handler = (dynamic initialMessage) {
      final commandPort = initialMessage as SendPort;
      connection.complete((ReceivePort.fromRawReceivePort(initPort), commandPort));
    };

    try {
      await Isolate.spawn(_startRemoteIsolate, initPort.sendPort);
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) = await connection.future;

    return ImageColorWorker._(receivePort, sendPort);
  }

  ImageColorWorker._(this._responses, this._commands) {
    _responses.listen(_handleResponsesFromIsolate);
  }

  void _handleResponsesFromIsolate(dynamic message) {
    final (int id, Object response) = message as (int, Object);
    final completer = _activeRequests.remove(id)!;

    if (response is RemoteError) {
      completer.completeError(response);
    } else {
      completer.complete(response as ImageColors);
    }

    if (_closed && _activeRequests.isEmpty) _responses.close();
  }

  static void _handleCommandsToIsolate(ReceivePort receivePort, SendPort sendPort) {
    receivePort.listen((message) async {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (int id, Uint32List image) = message as (int, Uint32List);
      try {
        // final stopwatch0 = Stopwatch()..start();
        final QuantizerResult quantizerResult = await QuantizerCelebi().quantize(image, 32);
        final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
          (int key, int value) => MapEntry<int, int>(_getArgbFromAbgr(key), value),
        );
        final significantColors = Map<int, int>.from(colorToCount)
          ..removeWhere((key, value) => value < 10);
        final meanTone =
            colorToCount.entries.fold<double>(
              0,
              (double previousValue, MapEntry<int, int> element) =>
                  previousValue + Hct.fromInt(element.key).tone * element.value,
            ) /
            colorToCount.values.fold<int>(
              0,
              (int previousValue, int element) => previousValue + element,
            );

        final int scoredResult =
            Score.score(
              colorToCount,
              desired: 1,
              fallbackColorARGB: 0xFFFFFFFF,
              filter: false,
            ).first;
        final Hct sourceColor = Hct.fromInt(scoredResult);
        if ((meanTone - sourceColor.tone).abs() > 20) {
          sourceColor.tone = meanTone;
        }
        final scheme = (significantColors.length <= 10 ? SchemeMonochrome.new : SchemeFidelity.new)(
          sourceColorHct: sourceColor,
          isDark: sourceColor.tone < 50,
          contrastLevel: 0.0,
        );
        // print('Quantize and scoring took: ${stopwatch0.elapsedMilliseconds}ms');
        final result = (
          primaryContainer: scheme.primaryContainer,
          onPrimaryContainer: scheme.onPrimaryContainer,
        );
        sendPort.send((id, result));
      } catch (e) {
        sendPort.send((id, RemoteError(e.toString(), '')));
      }
    });
  }

  static void _startRemoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    _handleCommandsToIsolate(receivePort, sendPort);
  }

  void close() {
    if (!_closed) {
      _closed = true;
      _commands.send('shutdown');
      if (_activeRequests.isEmpty) _responses.close();
    }
  }
}

// Converts AABBGGRR color int to AARRGGBB format.
int _getArgbFromAbgr(int abgr) {
  const int exceptRMask = 0xFF00FFFF;
  const int onlyRMask = ~exceptRMask;
  const int exceptBMask = 0xFFFFFF00;
  const int onlyBMask = ~exceptBMask;
  final int r = (abgr & onlyRMask) >> 16;
  final int b = abgr & onlyBMask;
  return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
}
