import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
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
      connection.complete((
        ReceivePort.fromRawReceivePort(initPort),
        commandPort,
      ));
    };

    try {
      await Isolate.spawn(_startRemoteIsolate, initPort.sendPort);
    } on Object {
      initPort.close();
      rethrow;
    }

    final (ReceivePort receivePort, SendPort sendPort) =
        await connection.future;

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

  static void _handleCommandsToIsolate(
    ReceivePort receivePort,
    SendPort sendPort,
  ) {
    receivePort.listen((message) async {
      if (message == 'shutdown') {
        receivePort.close();
        return;
      }
      final (int id, Uint32List image) = message as (int, Uint32List);
      try {
        // final stopwatch0 = Stopwatch()..start();
        final quantizerResult = await QuantizerCelebi().quantize(image, 32);
        final Map<int, int> colorToCount = quantizerResult.colorToCount.map(
          (int key, int value) =>
              MapEntry<int, int>(getArgbFromAbgr(key), value),
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

        final int scoredResult = Score.score(
          colorToCount,
          desired: 1,
          fallbackColorARGB: 0xFFFFFFFF,
          filter: false,
        ).first;
        final Hct sourceColor = Hct.fromInt(scoredResult);
        if ((meanTone - sourceColor.tone).abs() > 20) {
          sourceColor.tone = meanTone;
        }
        final scheme =
            (significantColors.length <= 10
            ? SchemeMonochrome.new
            : SchemeFidelity.new)(
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

// code below taken from: https://github.com/flutter/flutter/blob/74669e4bf1352a5134ad68398a6bf7fac0a6473b/packages/flutter/lib/src/material/color_scheme.dart

Future<QuantizerResult> extractColorsFromImageProvider(
  ImageProvider imageProvider,
) async {
  final ui.Image scaledImage = await _imageProviderToScaled(imageProvider);
  final ByteData? imageBytes = await scaledImage.toByteData();

  final QuantizerResult quantizerResult = await QuantizerCelebi().quantize(
    imageBytes!.buffer.asUint32List(),
    128,
    returnInputPixelToClusterPixel: true,
  );
  return quantizerResult;
}

// Converts AABBGGRR color int to AARRGGBB format.
int getArgbFromAbgr(int abgr) {
  const int exceptRMask = 0xFF00FFFF;
  const int onlyRMask = ~exceptRMask;
  const int exceptBMask = 0xFFFFFF00;
  const int onlyBMask = ~exceptBMask;
  final int r = (abgr & onlyRMask) >> 16;
  final int b = abgr & onlyBMask;
  return (abgr & exceptRMask & exceptBMask) | (b << 16) | r;
}

// Scale image size down to reduce computation time of color extraction.
Future<ui.Image> _imageProviderToScaled(ImageProvider imageProvider) async {
  const double maxDimension = 112.0;
  final ImageStream stream = imageProvider.resolve(
    const ImageConfiguration(size: Size(maxDimension, maxDimension)),
  );
  final Completer<ui.Image> imageCompleter = Completer<ui.Image>();
  late ImageStreamListener listener;
  late ui.Image scaledImage;
  Timer? loadFailureTimeout;

  listener = ImageStreamListener(
    (ImageInfo info, bool sync) async {
      loadFailureTimeout?.cancel();
      stream.removeListener(listener);
      final ui.Image image = info.image;
      final int width = image.width;
      final int height = image.height;
      double paintWidth = width.toDouble();
      double paintHeight = height.toDouble();
      assert(width > 0 && height > 0);

      final bool rescale = width > maxDimension || height > maxDimension;
      if (rescale) {
        paintWidth = (width > height)
            ? maxDimension
            : (maxDimension / height) * width;
        paintHeight = (height > width)
            ? maxDimension
            : (maxDimension / width) * height;
      }
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      paintImage(
        canvas: canvas,
        rect: Rect.fromLTRB(0, 0, paintWidth, paintHeight),
        image: image,
        filterQuality: FilterQuality.none,
      );

      final ui.Picture picture = pictureRecorder.endRecording();
      scaledImage = await picture.toImage(
        paintWidth.toInt(),
        paintHeight.toInt(),
      );
      imageCompleter.complete(info.image);
    },
    onError: (Object exception, StackTrace? stackTrace) {
      stream.removeListener(listener);
      throw Exception('Failed to render image: $exception');
    },
  );

  loadFailureTimeout = Timer(const Duration(seconds: 5), () {
    stream.removeListener(listener);
    imageCompleter.completeError(
      TimeoutException('Timeout occurred trying to load image'),
    );
  });

  stream.addListener(listener);
  await imageCompleter.future;
  return scaledImage;
}
