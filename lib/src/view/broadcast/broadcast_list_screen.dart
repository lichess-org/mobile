import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/constants.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/cupertino.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

const kDefaultBroadcastImage = AssetImage('assets/images/broadcast_image.png');
const kBroadcastCarouselItemContentPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);

/// A screen that displays a paginated list of broadcasts.
class BroadcastListScreen extends StatelessWidget {
  const BroadcastListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final title = AutoSizeText(
      context.l10n.broadcastBroadcasts,
      minFontSize: 14.0,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
    return PlatformWidget(
      androidBuilder: (_) => Scaffold(body: const _Body(), appBar: AppBar(title: title)),
      iosBuilder:
          (_) => CupertinoMaterialWrapper(
            child: CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                middle: title,
                automaticBackgroundVisibility: false,
                backgroundColor: CupertinoTheme.of(
                  context,
                ).barBackgroundColor.withValues(alpha: 0.0),
                border: null,
              ),
              child: const _Body(),
            ),
          ),
    );
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final ScrollController _scrollController = ScrollController();
  ImageColorWorker? _worker;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _initWorker();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _worker?.close();
    super.dispose();
  }

  Future<void> _initWorker() async {
    final worker = await ref.read(broadcastImageWorkerFactoryProvider).spawn();
    if (mounted) {
      setState(() {
        _worker = worker;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
      final broadcastList = ref.read(broadcastsPaginatorProvider);

      if (!broadcastList.isLoading) {
        ref.read(broadcastsPaginatorProvider.notifier).next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final broadcasts = ref.watch(broadcastsPaginatorProvider);

    if (_worker == null || (!broadcasts.hasValue && broadcasts.isLoading)) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (!broadcasts.hasValue && broadcasts.isLoading) {
      debugPrint('SEVERE: [BroadcastsListScreen] could not load broadcast tournaments');
      return const Center(child: Text('Could not load broadcast tournaments'));
    }

    final screenWidth = MediaQuery.sizeOf(context).width;
    final itemsByRow =
        screenWidth >= 1200
            ? 3
            : screenWidth >= 700
            ? 2
            : 1;
    const loadingItems = 12;
    final pastItemsCount =
        broadcasts.requireValue.past.length + (broadcasts.isLoading ? loadingItems : 0);

    final highTierGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: itemsByRow,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 16.0,
      childAspectRatio: 1.35,
    );

    final lowTierGridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: itemsByRow + 1,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 16.0,
      childAspectRatio:
          screenWidth >= 1200
              ? 1.4
              : screenWidth >= 700
              ? 1.3
              : 1.0,
    );

    final sections = [
      ('ongoing', context.l10n.broadcastOngoing, broadcasts.value!.active),
      ('past', context.l10n.broadcastCompleted, broadcasts.value!.past),
    ];

    final activeHighTier =
        broadcasts.value!.active
            .where((broadcast) => broadcast.tour.tier != null && broadcast.tour.tier! >= 4)
            .toList();

    final activeLowTier =
        broadcasts.value!.active
            .where((broadcast) => broadcast.tour.tier == null || broadcast.tour.tier! < 4)
            .toList();

    return RefreshIndicator.adaptive(
      edgeOffset:
          Theme.of(context).platform == TargetPlatform.iOS
              ? MediaQuery.paddingOf(context).top + 16.0
              : 0,
      key: _refreshIndicatorKey,
      onRefresh: () async => ref.refresh(broadcastsPaginatorProvider),
      child: Shimmer(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            for (final section in sections)
              SliverMainAxisGroup(
                key: ValueKey(section),
                slivers: [
                  if (Theme.of(context).platform == TargetPlatform.iOS)
                    CupertinoSliverNavigationBar(
                      automaticallyImplyLeading: false,
                      leading: null,
                      largeTitle: AutoSizeText(
                        section.$2,
                        maxLines: 1,
                        minFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      transitionBetweenRoutes: false,
                    )
                  else
                    SliverAppBar(
                      automaticallyImplyLeading: false,
                      title: AutoSizeText(
                        section.$2,
                        maxLines: 1,
                        minFontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                      pinned: true,
                    ),
                  if (section.$1 == 'ongoing') ...[
                    if (activeHighTier.isNotEmpty)
                      SliverPadding(
                        padding:
                            Theme.of(context).platform == TargetPlatform.iOS
                                ? Styles.horizontalBodyPadding
                                : Styles.bodySectionPadding,
                        sliver: SliverGrid.builder(
                          gridDelegate: highTierGridDelegate,
                          itemBuilder:
                              (context, index) => BroadcastCard(
                                worker: _worker!,
                                broadcast: activeHighTier[index],
                                aspectRatio: highTierGridDelegate.childAspectRatio,
                              ),
                          itemCount: activeHighTier.length,
                        ),
                      ),
                    if (activeLowTier.isNotEmpty)
                      SliverPadding(
                        padding: Styles.bodySectionPadding,
                        sliver: SliverGrid.builder(
                          gridDelegate: lowTierGridDelegate,
                          itemBuilder:
                              (context, index) => BroadcastCard(
                                worker: _worker!,
                                broadcast: activeLowTier[index],
                                aspectRatio: lowTierGridDelegate.childAspectRatio,
                              ),
                          itemCount: activeLowTier.length,
                        ),
                      ),
                  ] else
                    SliverPadding(
                      padding:
                          Theme.of(context).platform == TargetPlatform.iOS
                              ? Styles.horizontalBodyPadding
                              : Styles.bodySectionPadding,
                      sliver: SliverGrid.builder(
                        gridDelegate: lowTierGridDelegate,
                        itemBuilder:
                            (context, index) =>
                                (broadcasts.isLoading && index >= pastItemsCount - loadingItems)
                                    ? ShimmerLoading(
                                      isLoading: true,
                                      child: BroadcastCard.loading(
                                        worker: _worker!,
                                        aspectRatio: lowTierGridDelegate.childAspectRatio,
                                      ),
                                    )
                                    : BroadcastCard(
                                      worker: _worker!,
                                      broadcast: section.$3[index],
                                      aspectRatio: lowTierGridDelegate.childAspectRatio,
                                    ),
                        itemCount: section.$3.length,
                      ),
                    ),
                ],
              ),
            const SliverSafeArea(
              top: false,
              sliver: SliverToBoxAdapter(child: SizedBox(height: 16.0)),
            ),
          ],
        ),
      ),
    );
  }
}

const BroadcastList _emptyBroadcasts = (
  active: IListConst<Broadcast>([]),
  past: IListConst<Broadcast>([]),
  nextPage: null,
);

const kBroadcastCarouselItemPadding = EdgeInsets.symmetric(horizontal: 8.0);
const kHandsetCarouselFlexWeights = [6, 2];
const kTabletCarouselFlexWeights = [4, 4, 1];
const kDesktopCarouselFlexWeights = [3, 3, 3, 1];

class BroadcastCarousel extends StatelessWidget {
  const BroadcastCarousel({required this.broadcasts, required this.worker, super.key})
    : _isLoading = false;

  const BroadcastCarousel.loading({required this.worker})
    : _isLoading = true,
      broadcasts = _emptyBroadcasts;

  final BroadcastList broadcasts;
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final flexWeights = BroadcastCarousel.flexWeights(constraints.maxWidth);
        final widgetWidth = constraints.maxWidth;
        final elementWidth = widgetWidth * flexWeights[0] / flexWeights.reduce((a, b) => a + b);
        final pictureHeight = elementWidth / 2;
        final elementHeight = pictureHeight + (pictureHeight * 0.5);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxHeight: elementHeight),
            child: CarouselView.weighted(
              shape: const RoundedRectangleBorder(borderRadius: kCardBorderRadius),
              flexWeights: flexWeights,
              itemSnapping: true,
              padding: kBroadcastCarouselItemPadding,
              onTap: (index) {
                final broadcast = broadcasts.active[index];
                pushPlatformRoute(
                  context,
                  title: broadcast.title,
                  rootNavigator: true,
                  builder: (context) => BroadcastRoundScreen(broadcast: broadcast),
                );
              },
              children: [
                if (_isLoading)
                  for (final _ in [1, 2, 3, 4, 5, 6, 7, 8, 9])
                    BroadcastCarouselItem.loading(worker: worker, flexWeights: flexWeights),
                for (final broadcast in broadcasts.active)
                  BroadcastCarouselItem(
                    broadcast: broadcast,
                    worker: worker,
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

typedef _CardColors = ({Color primaryContainer, Color onPrimaryContainer});
final Map<ImageProvider, _CardColors?> _colorsCache = {};

final _dateFormat = DateFormat.MMMd().add_jm();

class _BroadcastCardContent extends StatelessWidget {
  const _BroadcastCardContent({required this.broadcast, required _CardColors? cardColors})
    : _cardColors = cardColors;

  final Broadcast broadcast;
  final _CardColors? _cardColors;

  @override
  Widget build(BuildContext context) {
    String? eventDate;
    if (broadcast.round.startsAt != null) {
      final diff = broadcast.round.startsAt!.difference(DateTime.now());
      if (!diff.isNegative && diff.inDays >= 1) {
        eventDate = _dateFormat.format(broadcast.round.startsAt!);
      } else {
        eventDate = relativeDate(context.l10n, broadcast.round.startsAt!);
      }
    }

    final defaultBackgroundColor =
        Theme.of(context).platform == TargetPlatform.iOS
            ? Styles.cupertinoCardColor.resolveFrom(context)
            : Theme.of(context).colorScheme.surfaceContainer;
    final backgroundColor = _cardColors?.primaryContainer ?? defaultBackgroundColor;
    final titleColor = _cardColors?.onPrimaryContainer;
    final subTitleColor =
        _cardColors?.onPrimaryContainer.withValues(alpha: 0.8) ?? textShade(context, 0.8);
    final bgHsl = HSLColor.fromColor(backgroundColor);
    final liveHsl = HSLColor.fromColor(LichessColors.red);
    final liveColor = (bgHsl.lightness <= 0.6 ? liveHsl.withLightness(0.9) : liveHsl).toColor();

    return Padding(
      padding: kBroadcastCarouselItemContentPadding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment:
                    broadcast.isLive ? MainAxisAlignment.spaceBetween : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  if (!broadcast.isFinished) ...[
                    Flexible(
                      flex: broadcast.isLive ? 1 : 0,
                      child: Text(
                        broadcast.round.name,
                        style: TextStyle(color: subTitleColor, letterSpacing: -0.2),
                        overflow: TextOverflow.clip,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 5.0),
                  ],
                  if (broadcast.isLive) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 16,
                          color: liveColor,
                          shadows: const [
                            Shadow(color: Colors.black54, offset: Offset(0, 1), blurRadius: 2),
                          ],
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          'LIVE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: liveColor,
                            shadows: const [
                              Shadow(color: Colors.black54, offset: Offset(0, 1), blurRadius: 2),
                            ],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ] else if (eventDate != null)
                    Flexible(
                      child: Text(
                        eventDate,
                        style: TextStyle(fontSize: 12, color: subTitleColor),
                        overflow: TextOverflow.clip,
                        softWrap: false,
                        maxLines: 1,
                      ),
                    ),
                ],
              ),
              Text(
                broadcast.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: titleColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  height: 1.0,
                ),
              ),
            ],
          ),
          if (broadcast.tour.information.players != null)
            Text(
              broadcast.tour.information.players!,
              style: TextStyle(fontSize: 12, color: subTitleColor, letterSpacing: -0.2),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
        ],
      ),
    );
  }
}

class BroadcastCard extends StatefulWidget {
  const BroadcastCard({
    required this.broadcast,
    required this.worker,
    required this.aspectRatio,
    super.key,
  });

  final Broadcast broadcast;
  final ImageColorWorker worker;
  final double aspectRatio;

  const BroadcastCard.loading({required this.worker, required this.aspectRatio})
    : broadcast = const Broadcast(
        tour: BroadcastTournamentData(
          id: BroadcastTournamentId(''),
          name: '',
          slug: '',
          imageUrl: null,
          description: '',
          information: (
            format: null,
            timeControl: null,
            players: null,
            website: null,
            standings: null,
            location: null,
            dates: null,
          ),
        ),
        round: BroadcastRound(
          id: BroadcastRoundId(''),
          name: '',
          slug: '',
          status: RoundStatus.finished,
          startsAt: null,
          finishedAt: null,
          startsAfterPrevious: false,
        ),
        group: null,
        roundToLinkId: BroadcastRoundId(''),
      );

  @override
  State<BroadcastCard> createState() => _BroadcastCardState();
}

class _BroadcastCardState extends State<BroadcastCard> {
  _CardColors? _cardColors;
  bool _tapDown = false;

  String? get imageUrl => widget.broadcast.tour.imageUrl;

  ImageProvider get imageProvider =>
      imageUrl != null ? NetworkImage(imageUrl!) : kDefaultBroadcastImage;

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
      final ui.Image scaledImage = await _imageProviderToScaled(provider);
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
    final defaultBackgroundColor = Theme.of(context).colorScheme.surfaceContainer;
    final backgroundColor = _cardColors?.primaryContainer ?? defaultBackgroundColor;

    return GestureDetector(
      onTap: () {
        pushPlatformRoute(
          context,
          title: widget.broadcast.title,
          rootNavigator: true,
          builder: (context) => BroadcastRoundScreen(broadcast: widget.broadcast),
        );
      },
      onTapDown: (_) => _onTapDown(),
      onTapCancel: _onTapCancel,
      onTapUp: (_) => _onTapCancel(),
      child: AnimatedOpacity(
        opacity: _tapDown ? 1.0 : 0.85,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: kCardBorderRadius,
            color: backgroundColor,
            boxShadow:
                Theme.of(context).platform == TargetPlatform.iOS ? null : kElevationToShadow[1],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image(
                image: imageProvider,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: frame == null ? 0 : 1,
                    child: child,
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) => const Image(image: kDefaultBroadcastImage),
              ),
              Expanded(
                child: _BroadcastCardContent(broadcast: widget.broadcast, cardColors: _cardColors),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BroadcastCarouselItem extends StatefulWidget {
  const BroadcastCarouselItem({
    required this.broadcast,
    required this.flexWeights,
    required this.worker,
    super.key,
  });

  final Broadcast broadcast;
  final ImageColorWorker worker;
  final List<int> flexWeights;

  const BroadcastCarouselItem.loading({required this.worker, required this.flexWeights})
    : broadcast = const Broadcast(
        tour: BroadcastTournamentData(
          id: BroadcastTournamentId(''),
          name: '',
          slug: '',
          imageUrl: null,
          description: '',
          information: (
            format: null,
            timeControl: null,
            players: null,
            website: null,
            location: null,
            dates: null,
            standings: null,
          ),
        ),
        round: BroadcastRound(
          id: BroadcastRoundId(''),
          name: '',
          slug: '',
          status: RoundStatus.finished,
          startsAt: null,
          finishedAt: null,
          startsAfterPrevious: false,
        ),
        group: null,
        roundToLinkId: BroadcastRoundId(''),
      );

  @override
  State<BroadcastCarouselItem> createState() => _BroadcastCarouselItemState();
}

class _BroadcastCarouselItemState extends State<BroadcastCarouselItem> {
  _CardColors? _cardColors;

  String? get imageUrl => widget.broadcast.tour.imageUrl;

  ImageProvider get imageProvider =>
      imageUrl != null ? NetworkImage(imageUrl!) : kDefaultBroadcastImage;

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
      final ui.Image scaledImage = await _imageProviderToScaled(provider);
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

  @override
  Widget build(BuildContext context) {
    final defaultBackgroundColor =
        Theme.of(context).platform == TargetPlatform.iOS
            ? Styles.cupertinoCardColor.resolveFrom(context)
            : Theme.of(context).colorScheme.surfaceContainer;
    final backgroundColor = _cardColors?.primaryContainer ?? defaultBackgroundColor;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double width = screenWidth - 16.0;
    final paddingWidth = kBroadcastCarouselItemPadding.horizontal;
    final flexWeights = widget.flexWeights;
    final totalFlex = flexWeights.reduce((a, b) => a + b);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(color: backgroundColor),
      child: ClipRect(
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
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: frame == null ? 0 : 1,
                    child: child,
                  );
                },
                errorBuilder:
                    (context, error, stackTrace) => const Image(image: kDefaultBroadcastImage),
              ),
              Expanded(
                child: _BroadcastCardContent(broadcast: widget.broadcast, cardColors: _cardColors),
              ),
            ],
          ),
        ),
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
Future<void> preCacheBroadcastImages(
  BuildContext context, {
  required Iterable<Broadcast> broadcasts,
  required ImageColorWorker worker,
}) async {
  for (final broadcast in broadcasts) {
    final imageUrl = broadcast.tour.imageUrl;
    if (imageUrl != null) {
      final provider = NetworkImage(imageUrl);
      await precacheImage(provider, context);
      final ui.Image scaledImage = await _imageProviderToScaled(provider);
      final imageBytes = await scaledImage.toByteData();
      await _computeImageColors(worker, imageUrl, imageBytes!);
    }
  }
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
        paintWidth = (width > height) ? maxDimension : (maxDimension / height) * width;
        paintHeight = (height > width) ? maxDimension : (maxDimension / width) * height;
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
      scaledImage = await picture.toImage(paintWidth.toInt(), paintHeight.toInt());
      imageCompleter.complete(info.image);
    },
    onError: (Object exception, StackTrace? stackTrace) {
      stream.removeListener(listener);
      throw Exception('Failed to render image: $exception');
    },
  );

  loadFailureTimeout = Timer(const Duration(seconds: 5), () {
    stream.removeListener(listener);
    imageCompleter.completeError(TimeoutException('Timeout occurred trying to load image'));
  });

  stream.addListener(listener);
  await imageCompleter.future;
  return scaledImage;
}
