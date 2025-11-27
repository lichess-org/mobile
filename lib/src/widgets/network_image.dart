import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/http_network_image.dart';

/// Like [CachedNetworkImage], but uses a cached network image with the globally configured http client.
class CachedHttpNetworkImage extends ConsumerWidget {
  const CachedHttpNetworkImage(
    this.url, {
    this.width,
    this.height,
    this.errorWidget,
    this.scale = 1.0,
    super.key,
  });

  final String url;

  final double? width;
  final double? height;
  final double scale;

  final LoadingErrorWidgetBuilder? errorWidget;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CachedNetworkImage(
      imageUrl: url,
      width: width,
      height: height,
      scale: scale,
      errorWidget: errorWidget,
      cacheManager: ref.read(cachedNetworkImageManagerProvider),
    );
  }
}

/// Like [Image.network], but uses a [HttpNetworkImage] with the globally configured http client.
class HttpNetworkImageWidget extends ConsumerWidget {
  const HttpNetworkImageWidget(
    this.url, {
    this.width,
    this.height,
    this.fit,
    this.errorBuilder,
    this.cacheWidth,
    this.cacheHeight,
    super.key,
  });

  final String url;
  final BoxFit? fit;
  final ImageErrorWidgetBuilder? errorBuilder;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image(
      image: ResizeImage.resizeIfNeeded(
        cacheWidth,
        cacheHeight,
        HttpNetworkImage(url, ref.read(defaultClientProvider)),
      ),
      width: width,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
