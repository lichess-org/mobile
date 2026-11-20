import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/utils/http_network_image.dart';

/// Like [Image.network], but uses a [HttpNetworkImage] with the [imageClientProvider] http client.
class const HttpNetworkImageWidget(
  final String url, {
  final double? width,
  final double? height,
  final BoxFit? fit,
  final ImageErrorWidgetBuilder? errorBuilder,
  final int? cacheWidth,
  final int? cacheHeight,
  super.key,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Image(
      image: ResizeImage.resizeIfNeeded(
        cacheWidth,
        cacheHeight,
        HttpNetworkImage(url, ref.read(imageClientProvider)),
      ),
      width: width,
      height: height,
      fit: fit,
      errorBuilder: errorBuilder,
    );
  }
}
