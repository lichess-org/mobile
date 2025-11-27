import 'dart:async';
import 'dart:io' show HttpStatus;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:lichess_mobile/src/network/http.dart';

/// Like [NetworkImage], but uses the provided [Ref] to obtain the globally configured HTTP client.
class HttpNetworkImage extends ImageProvider<HttpNetworkImage> {
  /// Creates an object that fetches the image at the given URL.
  const HttpNetworkImage(this.url, http.Client client, {this.scale = 1.0, this.headers})
    : _client = client;

  final http.Client _client;

  final String url;

  final double scale;

  final Map<String, String>? headers;

  @override
  Future<HttpNetworkImage> obtainKey(ImageConfiguration configuration) {
    return SynchronousFuture<HttpNetworkImage>(this);
  }

  @override
  ImageStreamCompleter loadImage(HttpNetworkImage key, ImageDecoderCallback decode) {
    return MultiFrameImageStreamCompleter(
      codec: _loadAsync(key, decode: decode),
      scale: key.scale,
      debugLabel: key.url,
      informationCollector: () => <DiagnosticsNode>[
        DiagnosticsProperty<ImageProvider>('Image provider', this),
        DiagnosticsProperty<HttpNetworkImage>('Image key', key),
      ],
    );
  }

  Future<ui.Codec> _loadAsync(HttpNetworkImage key, {required ImageDecoderCallback decode}) async {
    try {
      assert(key == this);

      final Uri resolved = Uri.base.resolve(key.url);

      final response = await _client.get(resolved, headers: headers);

      if (response.statusCode != HttpStatus.ok) {
        // The network may be only temporarily unavailable, or the file will be
        // added on the server later. Avoid having future calls to resolve
        // fail to check the network again.
        // await response.drain<List<int>>(<int>[]);
        throw NetworkImageLoadException(statusCode: response.statusCode, uri: resolved);
      }

      if (response.bodyBytes.isEmpty) {
        throw Exception('NetworkImage is an empty file: $resolved');
      }

      return decode(await ui.ImmutableBuffer.fromUint8List(response.bodyBytes));
    } catch (e) {
      // Depending on where the exception was thrown, the image cache may not
      // have had a chance to track the key in the cache at all.
      // Schedule a microtask to give the cache a chance to add the key.
      scheduleMicrotask(() {
        PaintingBinding.instance.imageCache.evict(key);
      });
      rethrow;
    }
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is HttpNetworkImage && other.url == url && other.scale == scale;
  }

  @override
  int get hashCode => Object.hash(url, scale);

  @override
  String toString() =>
      '${objectRuntimeType(this, 'HttpNetworkImage')}("$url", scale: ${scale.toStringAsFixed(1)})';
}

const cacheKey = 'http_network_image_cache_key';

/// Provides a [CacheManager] for caching network images.
final cachedNetworkImageManagerProvider = Provider<CacheManager>((ref) {
  return CacheManager(
    Config(
      cacheKey,
      fileService: HttpFileService(httpClient: ref.read(externalClientProvider)),
      stalePeriod: const Duration(days: 7),

      maxNrOfCacheObjects: 200,
    ),
  );
});
