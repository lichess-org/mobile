import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/navigation.dart' show watchTabInteraction;
import 'package:lichess_mobile/src/network/http.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/utils/share.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_action_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';

const kDefaultBroadcastImage = AssetImage('assets/images/broadcast_image.png');
const kBroadcastCardItemContentPadding = EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0);
const kDefaultCardOpacity = 0.9;

const kBroadcastCarouselItemPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0);
const kHandsetCarouselFlexWeights = [6, 2];
const kTabletCarouselFlexWeights = [4, 4, 1];
const kDesktopCarouselFlexWeights = [3, 3, 3, 1];

const BroadcastList _emptyBroadcasts = (
  active: IListConst<Broadcast>([]),
  past: IListConst<Broadcast>([]),
  nextPage: null,
);

class BroadcastCarousel extends StatefulWidget {
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
  State<BroadcastCarousel> createState() => _BroadcastCarouselState();
}

class _BroadcastCarouselState extends State<BroadcastCarousel> {
  final _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    watchTabInteraction.addListener(_onTabInteraction);
  }

  @override
  void dispose() {
    watchTabInteraction.removeListener(_onTabInteraction);
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
        final flexWeights = BroadcastCarousel.flexWeights(constraints.maxWidth);
        final widgetWidth = constraints.maxWidth;
        final elementWidth = widgetWidth * flexWeights[0] / flexWeights.reduce((a, b) => a + b);
        final pictureHeight = elementWidth / 2;
        final elementHeightFactor = flexWeights.length == 2 ? 0.75 : 0.6;
        final elementHeight = pictureHeight + (pictureHeight * elementHeightFactor);
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: elementHeight + kBroadcastCarouselItemPadding.vertical,
            ),
            child: CarouselView.weighted(
              controller: _controller,
              shape: const RoundedRectangleBorder(borderRadius: Styles.cardBorderRadius),
              elevation: Theme.of(context).platform == TargetPlatform.iOS ? 0 : 1,
              flexWeights: flexWeights,
              itemSnapping: true,
              padding: kBroadcastCarouselItemPadding,
              enableSplash: false,
              children: [
                if (widget._isLoading)
                  for (final _ in [1, 2, 3, 4, 5, 6, 7, 8, 9])
                    BroadcastCarouselItem.loading(worker: widget.worker, flexWeights: flexWeights),
                for (final broadcast in widget.broadcasts.active)
                  BroadcastCarouselItem(
                    broadcast: broadcast,
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
    final backgroundColor =
        _cardColors?.primaryContainer ??
        Theme.of(context).cardTheme.color ??
        Theme.of(context).colorScheme.surfaceContainerLow;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final double width = screenWidth - 16.0;
    final paddingWidth = kBroadcastCarouselItemPadding.horizontal;
    final flexWeights = widget.flexWeights;
    final totalFlex = flexWeights.reduce((a, b) => a + b);

    return GestureDetector(
      onTap: () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(BroadcastRoundScreen.buildRoute(context, widget.broadcast));
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

    final titleColor = _cardColors?.onPrimaryContainer;
    final subTitleColor =
        _cardColors?.onPrimaryContainer.withValues(alpha: 0.8) ?? textShade(context, 0.8);

    return Stack(
      children: [
        Padding(
          padding: kBroadcastCardItemContentPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      if (!broadcast.isFinished) ...[
                        Flexible(
                          flex: 0,
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
                      if (eventDate != null)
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
                  const SizedBox(height: 6.0),
                  Text.rich(
                    maxLines: 3,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: broadcast.title,
                          style: TextStyle(
                            color: titleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                            height: 1.0,
                          ),
                        ),
                        if (broadcast.tour.information.players != null)
                          TextSpan(
                            text: '\n${broadcast.tour.information.players}',
                            style: TextStyle(
                              color: subTitleColor,
                              fontSize: 12,
                              letterSpacing: -0.2,
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
        ),
        Positioned(
          bottom: 0,
          left: kBroadcastCardItemContentPadding.horizontal / 2,
          right: 0,
          // bottom: kBroadcastCardItemContentPadding.vertical / 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (broadcast.isLive) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 1.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: LichessColors.red,
                    ),
                  ),
                ),
                const Spacer(),
              ],
              MenuAnchor(
                builder:
                    (context, controller, _) => AppBarIconButton(
                      onPressed: () {
                        if (controller.isOpen) {
                          controller.close();
                        } else {
                          controller.open();
                        }
                      },
                      semanticsLabel: context.l10n.menu,
                      icon: Icon(Icons.more_horiz, color: titleColor?.withValues(alpha: 0.5)),
                    ),
                menuChildren: [
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.info),
                    semanticsLabel: context.l10n.broadcastOverview,
                    child: Text(context.l10n.broadcastOverview),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        BroadcastRoundScreen.buildRoute(
                          context,
                          broadcast,
                          initialTab: BroadcastRoundTab.overview,
                        ),
                      );
                    },
                  ),
                  MenuItemButton(
                    leadingIcon: const Icon(LichessIcons.chess_board),
                    semanticsLabel: context.l10n.broadcastBoards,
                    child: Text(context.l10n.broadcastBoards),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        BroadcastRoundScreen.buildRoute(
                          context,
                          broadcast,
                          initialTab: BroadcastRoundTab.boards,
                        ),
                      );
                    },
                  ),
                  MenuItemButton(
                    leadingIcon: const Icon(Icons.people),
                    semanticsLabel: context.l10n.players,
                    child: Text(context.l10n.players),
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).push(
                        BroadcastRoundScreen.buildRoute(
                          context,
                          broadcast,
                          initialTab: BroadcastRoundTab.players,
                        ),
                      );
                    },
                  ),
                  MenuItemButton(
                    leadingIcon: Icon(
                      Theme.of(context).platform == TargetPlatform.iOS
                          ? CupertinoIcons.share
                          : Icons.share,
                    ),
                    semanticsLabel: context.l10n.studyShareAndExport,
                    child: Text(context.l10n.studyShareAndExport),
                    onPressed: () {
                      showAdaptiveActionSheet<void>(
                        context: context,
                        actions: [
                          BottomSheetAction(
                            makeLabel: (context) => Text(broadcast.title),
                            onPressed: (context) async {
                              launchShareDialog(
                                context,
                                uri: lichessUri(
                                  '/broadcast/${broadcast.tour.slug}/${broadcast.tour.id}',
                                ),
                              );
                            },
                          ),
                          BottomSheetAction(
                            makeLabel: (context) => Text(broadcast.round.name),
                            onPressed: (context) async {
                              launchShareDialog(
                                context,
                                uri: lichessUri(
                                  '/broadcast/${broadcast.tour.slug}/${broadcast.round.slug}/${broadcast.round.id}',
                                ),
                              );
                            },
                          ),
                          BottomSheetAction(
                            makeLabel: (context) => Text('${broadcast.round.name} PGN'),
                            onPressed: (context) async {
                              launchShareDialog(
                                context,
                                uri: lichessUri(
                                  '/broadcast/${broadcast.tour.slug}/${broadcast.round.slug}/${broadcast.round.id}.pgn',
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
