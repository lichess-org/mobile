import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/blog/blog.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/tab_scaffold.dart' show homeTabInteraction;
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
        final elementHeightFactor = flexWeights.length == 2 ? 0.75 : 0.6;
        final elementHeight = pictureHeight + (pictureHeight * elementHeightFactor);
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
                    BlogCarouselItem.loading(worker: widget.worker, flexWeights: flexWeights),
                for (final post in widget.posts)
                  BlogCarouselItem(post: post, worker: widget.worker, flexWeights: flexWeights),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BlogCarouselItem extends StatefulWidget {
  const BlogCarouselItem({
    required this.post,
    required this.flexWeights,
    required this.worker,
    super.key,
  });

  BlogCarouselItem.loading({required this.flexWeights, required this.worker, super.key})
    : post = BlogPost(
        id: const StringId(''),
        title: '',
        slug: '',
        url: Uri(),
        createdAt: DateTime.now(),
      );

  final BlogPost post;
  final ImageColorWorker worker;
  final List<int> flexWeights;

  @override
  State<BlogCarouselItem> createState() => _BlogCarouselItemState();
}

class _BlogCarouselItemState extends State<BlogCarouselItem> {
  _CardColors? _cardColors;
  bool _tapDown = false;

  String? get imageUrl => widget.post.imageUrl?.toString();

  ImageProvider get imageProvider => imageUrl != null ? NetworkImage(imageUrl!) : kDefaultBlogImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cachedColors = _colorsCache[imageProvider];
    if (_colorsCache.containsKey(imageProvider)) {
      _cardColors = cachedColors;
    } else if (imageUrl != null) {
      _getImageColors(NetworkImage(imageUrl!));
    }
  }

  Future<void> _getImageColors(NetworkImage provider) async {
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double width = screenWidth - 16.0;
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
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
final Map<ImageProvider, _CardColors?> _colorsCache = {};

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
    _colorsCache[NetworkImage(imageUrl)] = cardColors;
    return cardColors;
  }
  return null;
}

/// Pre-cache images and extract colors for broadcasts.
Future<void> preCacheBlogImages(
  BuildContext context, {
  required Iterable<BlogPost> posts,
  required ImageColorWorker worker,
}) async {
  for (final post in posts) {
    final imageUrl = post.imageUrl;
    if (imageUrl != null) {
      final provider = NetworkImage(imageUrl.toString());
      await precacheImage(provider, context);
      final ui.Image scaledImage = await imageProviderToScaled(provider);
      final imageBytes = await scaledImage.toByteData();
      await _computeImageColors(worker, imageUrl.toString(), imageBytes!);
    }
  }
}
