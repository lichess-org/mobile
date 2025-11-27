import 'dart:async';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/blog/blog.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart' show homeTabInteraction;
import 'package:lichess_mobile/src/utils/http_network_image.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/widgets/user.dart';
import 'package:url_launcher/url_launcher.dart';

const kDefaultBlogImage = AssetImage('assets/images/broadcast_image.png');
const kBlogCardItemContentPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
const kDefaultCardOpacity = 0.9;

const kBlogCarouselItemPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
const kHandsetCarouselFlexWeights = [6, 2];
const kTabletCarouselFlexWeights = [4, 4, 1];
const kDesktopCarouselFlexWeights = [3, 3, 3, 1];

const _emptyPosts = IListConst<BlogPost>([]);

class BlogCarousel extends StatefulWidget {
  const BlogCarousel({required this.posts, required this.worker, super.key}) : _isLoading = false;

  const BlogCarousel.loading({required this.worker}) : _isLoading = true, posts = _emptyPosts;

  final IList<BlogPost> posts;
  final ImageColorWorker worker;
  final bool _isLoading;

  static List<int> flexWeights(double screenWidth) {
    switch (screenWidth) {
      case > FormFactor.desktop:
        return kDesktopCarouselFlexWeights;
      case > FormFactor.tablet:
        return kTabletCarouselFlexWeights;
      case _:
        return kHandsetCarouselFlexWeights;
    }
  }

  @override
  State<BlogCarousel> createState() => _BlogCarouselState();
}

class _BlogCarouselState extends State<BlogCarousel> {
  final _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    homeTabInteraction.addListener(_onTabInteraction);
  }

  @override
  void dispose() {
    homeTabInteraction.removeListener(_onTabInteraction);
    super.dispose();
  }

  void _onTabInteraction() {
    if (_controller.hasClients) {
      _controller.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final flexWeights = BlogCarousel.flexWeights(constraints.maxWidth);
        final widgetWidth = constraints.maxWidth;
        final elementWidth = widgetWidth * flexWeights[0] / flexWeights.reduce((a, b) => a + b);
        final pictureHeight = elementWidth / 2;
        const elementHeightFactor = 0.65;
        final infoHeight = math.max(120, pictureHeight * elementHeightFactor);
        final elementHeight = pictureHeight + infoHeight;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: elementHeight + kBlogCarouselItemPadding.vertical,
            ),
            child: CarouselView.weighted(
              controller: _controller,
              shape: const RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius),
              elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0 : 1,
              flexWeights: flexWeights,
              itemSnapping: true,
              padding: kBlogCarouselItemPadding,
              enableSplash: false,
              children: [
                if (widget._isLoading)
                  for (final _ in [1, 2, 3, 4, 5, 6, 7, 8, 9])
                    BlogCarouselItem.loading(
                      carouselWidth: widgetWidth,
                      worker: widget.worker,
                      flexWeights: flexWeights,
                    ),
                for (final post in widget.posts)
                  BlogCarouselItem(
                    carouselWidth: widgetWidth,
                    post: post,
                    worker: widget.worker,
                    flexWeights: flexWeights,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BlogCarouselItem extends ConsumerStatefulWidget {
  const BlogCarouselItem({
    required this.carouselWidth,
    required this.post,
    required this.flexWeights,
    required this.worker,
    super.key,
  });

  BlogCarouselItem.loading({
    required this.carouselWidth,
    required this.flexWeights,
    required this.worker,
    super.key,
  }) : post = BlogPost(
         id: const StringId(''),
         title: '',
         slug: '',
         url: Uri(),
         createdAt: DateTime.now(),
       );

  final double carouselWidth;
  final BlogPost post;
  final ImageColorWorker worker;
  final List<int> flexWeights;

  @override
  ConsumerState<BlogCarouselItem> createState() => _BlogCarouselItemState();
}

class _BlogCarouselItemState extends ConsumerState<BlogCarouselItem> {
  _CardColors? _cardColors;
  bool _tapDown = false;

  String? get imageUrl => widget.post.imageUrl?.toString();

  ImageProvider get imageProvider => imageUrl != null
      ? HttpNetworkImage(imageUrl!, ref.read(defaultClientProvider))
      : kDefaultBlogImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_colorsCache.containsKey(imageUrl)) {
      _cardColors = _colorsCache[imageUrl];
    } else if (imageUrl != null) {
      _getImageColors(HttpNetworkImage(imageUrl!, ref.read(defaultClientProvider)));
    }
  }

  Future<void> _getImageColors(HttpNetworkImage provider) async {
    if (!mounted) return;

    if (Scrollable.recommendDeferredLoadingForContext(context)) {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        scheduleMicrotask(() => _getImageColors(provider));
      });
    } else if (widget.worker.closed == false) {
      await precacheImage(provider, context);
      final ui.Image scaledImage = await imageProviderToScaled(provider);
      final imageBytes = await scaledImage.toByteData();
      final response = await _computeImageColors(widget.worker, provider.url, imageBytes!);
      if (response != null) {
        if (mounted) {
          setState(() {
            _cardColors = response;
          });
        }
      }
    }
  }

  void _onTapDown() {
    setState(() => _tapDown = true);
  }

  void _onTapCancel() {
    setState(() => _tapDown = false);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        _cardColors?.primaryContainer ??
        Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.surfaceContainerLow;
    final double width = widget.carouselWidth - 16.0;
    final paddingWidth = kBlogCarouselItemPadding.horizontal;
    final flexWeights = widget.flexWeights;
    final totalFlex = flexWeights.reduce((a, b) => a + b);

    return GestureDetector(
      onTap: () {
        launchUrl(lichessUri(widget.post.url.toString()));
      },
      onTapDown: (_) => _onTapDown(),
      onTapCancel: _onTapCancel,
      onTapUp: (_) => _onTapCancel(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: backgroundColor.withValues(alpha: _tapDown ? 1.0 : kDefaultCardOpacity),
        ),
        child: OverflowBox(
          maxWidth: width * flexWeights[0] / totalFlex - paddingWidth,
          minWidth: width * flexWeights[0] / totalFlex - paddingWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                fit: BoxFit.cover,
                image: imageProvider,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: wasSynchronouslyLoaded
                        ? _tapDown
                              ? 1.0
                              : kDefaultCardOpacity
                        : frame == null
                        ? 0
                        : 1,
                    child: child,
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Image(image: kDefaultBlogImage),
              ),
              Expanded(
                child: _BlogCardContent(post: widget.post, cardColors: _cardColors),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef _CardColors = ({Color primaryContainer, Color onPrimaryContainer});
final Map<String, _CardColors?> _colorsCache = {};

final _dateFormat = DateFormat.MMMd();

class _BlogCardContent extends StatelessWidget {
  const _BlogCardContent({required this.post, required _CardColors? cardColors})
    : _cardColors = cardColors;

  final BlogPost post;
  final _CardColors? _cardColors;

  @override
  Widget build(BuildContext context) {
    final titleColor = _cardColors?.onPrimaryContainer;
    final subTitleColor =
        _cardColors?.onPrimaryContainer.withValues(alpha: 0.8) ?? textShade(context, 0.8);
    return Padding(
      padding: kBlogCardItemContentPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  UserFullNameWidget(
                    user: post.author,
                    showPatron: false,
                    showFlair: false,
                    style: TextStyle(color: subTitleColor, letterSpacing: -0.2),
                  ),
                  Text(
                    _dateFormat.format(post.createdAt),
                    style: TextStyle(color: subTitleColor, letterSpacing: -0.2, fontSize: 12.0),
                    overflow: TextOverflow.clip,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ],
              ),
              const SizedBox(height: 6.0),
              Text.rich(
                maxLines: 3,
                TextSpan(
                  children: [
                    TextSpan(
                      text: post.title,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Future<_CardColors?> _computeImageColors(
  ImageColorWorker worker,
  String imageUrl,
  ByteData imageBytes,
) async {
  final response = await worker.getImageColors(imageBytes.buffer.asUint32List());
  if (response != null) {
    final (:primaryContainer, :onPrimaryContainer) = response;
    final cardColors = (
      primaryContainer: Color(primaryContainer),
      onPrimaryContainer: Color(onPrimaryContainer),
    );
    _colorsCache[imageUrl] = cardColors;
    return cardColors;
  }
  return null;
}

/// Pre-cache images and extract colors for broadcasts.
Future<void> preCacheBlogImages(
  BuildContext context, {
  required Iterable<BlogPost> posts,
  required ImageColorWorker worker,
  required http.Client externalClient,
}) async {
  for (final post in posts.take(5)) {
    final imageUrl = post.imageUrl;
    if (imageUrl != null) {
      final provider = HttpNetworkImage(imageUrl.toString(), externalClient);
      await precacheImage(provider, context);
      final ui.Image scaledImage = await imageProviderToScaled(provider);
      final imageBytes = await scaledImage.toByteData();
      await _computeImageColors(worker, imageUrl.toString(), imageBytes!);
    }
  }
}
