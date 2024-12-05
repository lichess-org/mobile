import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/image.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

final _dateFormatter = DateFormat.MMMd().add_Hm();
final _dateFormatterWithYear = DateFormat.yMMMd().add_Hm();

/// A screen that displays a paginated list of broadcasts.
class BroadcastListScreen extends StatelessWidget {
  const BroadcastListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: PlatformAppBar(
        title: Text(context.l10n.broadcastLiveBroadcasts),
      ),
      body: const _Body(),
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
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
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
      return const Center(
        child: CircularProgressIndicator.adaptive(),
      );
    }

    if (!broadcasts.hasValue && broadcasts.isLoading) {
      debugPrint(
        'SEVERE: [BroadcastsListScreen] could not load broadcast tournaments',
      );
      return const Center(child: Text('Could not load broadcast tournaments'));
    }

    final isTablet = isTabletOrLarger(context);
    final itemsByRow = isTablet ? 6 : 2;
    final loadingItems = isTablet ? 36 : 12;
    final itemsCount = broadcasts.requireValue.past.length +
        (broadcasts.isLoading ? loadingItems : 0);

    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: Styles.bodySectionPadding,
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: itemsByRow,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => BroadcastGridItem(
                broadcast: broadcasts.value!.active[index],
                worker: _worker!,
              ),
              itemCount: broadcasts.value!.active.length,
            ),
          ),
          SliverPadding(
            padding: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
            sliver: SliverToBoxAdapter(
              child: DefaultTextStyle.merge(
                style: Styles.sectionTitle,
                child: const Text('Upcoming broadcasts'),
              ),
            ),
          ),
          SliverPadding(
            padding: Styles.bodySectionPadding,
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: itemsByRow,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => BroadcastGridItem(
                worker: _worker!,
                broadcast: broadcasts.value!.upcoming[index],
              ),
              itemCount: broadcasts.value!.upcoming.length,
            ),
          ),
          SliverPadding(
            padding: Styles.horizontalBodyPadding.add(Styles.sectionTopPadding),
            sliver: SliverToBoxAdapter(
              child: DefaultTextStyle.merge(
                style: Styles.sectionTitle,
                child: const Text('Past broadcasts'),
              ),
            ),
          ),
          SliverPadding(
            padding: Styles.bodySectionPadding,
            sliver: SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: itemsByRow,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) =>
                  (broadcasts.isLoading && index >= itemsCount - loadingItems)
                      ? Shimmer(
                          child: ShimmerLoading(
                            isLoading: true,
                            child: BroadcastGridItem.loading(_worker!),
                          ),
                        )
                      : BroadcastGridItem(
                          worker: _worker!,
                          broadcast: broadcasts.value!.past[index],
                        ),
              itemCount: itemsCount,
            ),
          ),
        ],
      ),
    );
  }
}

class BroadcastGridItem extends StatefulWidget {
  const BroadcastGridItem({
    required this.broadcast,
    required this.worker,
    super.key,
  });

  final Broadcast broadcast;
  final ImageColorWorker worker;

  BroadcastGridItem.loading(this.worker)
      : broadcast = Broadcast(
          tour: const BroadcastTournamentData(
            id: BroadcastTournamentId(''),
            name: '',
            imageUrl: null,
            description: '',
            information: (
              format: null,
              timeControl: null,
              players: null,
              website: null,
              location: null,
              dates: null,
            ),
          ),
          round: BroadcastRound(
            id: const BroadcastRoundId(''),
            name: '',
            status: RoundStatus.finished,
            startsAt: DateTime.now(),
          ),
          group: null,
          roundToLinkId: const BroadcastRoundId(''),
        );

  @override
  State<BroadcastGridItem> createState() => _BroadcastGridItemState();
}

typedef _CardColors = ({
  Color primaryContainer,
  Color onPrimaryContainer,
});
final Map<ImageProvider, _CardColors> _colorsCache = {
  kDefaultBroadcastImage: (
    primaryContainer: LichessColors.brag,
    onPrimaryContainer: const Color(0xFF000000),
  ),
};

const kDefaultBroadcastImage = AssetImage('assets/images/broadcast_image.png');

class _BroadcastGridItemState extends State<BroadcastGridItem> {
  _CardColors? _cardColors;

  String? get imageUrl => widget.broadcast.tour.imageUrl;

  ImageProvider get image =>
      imageUrl != null ? NetworkImage(imageUrl!) : kDefaultBroadcastImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cachedColors = _colorsCache[image];
    if (cachedColors != null) {
      _cardColors = cachedColors;
    } else {
      if (imageUrl != null) {
        _fetchImageAndColors(image as NetworkImage);
      }
    }
  }

  Future<void> _fetchImageAndColors(NetworkImage provider) async {
    if (!mounted) return;

    if (Scrollable.recommendDeferredLoadingForContext(context)) {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        scheduleMicrotask(() => _fetchImageAndColors(provider));
      });
    } else if (widget.worker.closed == false) {
      final response = await widget.worker.getImageColors(provider.url);
      if (response != null) {
        final (primaryContainer, onPrimaryContainer) = response;
        final cardColors = (
          primaryContainer: Color(primaryContainer),
          onPrimaryContainer: Color(onPrimaryContainer),
        );
        _colorsCache[provider] = cardColors;
        if (mounted) {
          setState(() {
            _cardColors = cardColors;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _cardColors?.primaryContainer ?? Colors.transparent;
    final titleColor = _cardColors?.onPrimaryContainer;
    final subTitleColor =
        _cardColors?.onPrimaryContainer.withValues(alpha: 0.7) ??
            textShade(context, 0.7);

    return AdaptiveInkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        pushPlatformRoute(
          context,
          title: context.l10n.broadcastBroadcasts,
          rootNavigator: true,
          builder: (context) =>
              BroadcastRoundScreen(broadcast: widget.broadcast),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
          boxShadow: Theme.of(context).platform == TargetPlatform.iOS
              ? null
              : kElevationToShadow[1],
        ),
        foregroundDecoration: BoxDecoration(
          border: (widget.broadcast.isLive)
              ? Border.all(
                  color: LichessColors.red.withValues(alpha: 0.7),
                  width: 3,
                )
              : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShaderMask(
              blendMode: BlendMode.dstOut,
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  colors: [
                    backgroundColor.withValues(alpha: 0.10),
                    backgroundColor.withValues(alpha: 1.0),
                  ],
                  stops: const [0.5, 1.00],
                  tileMode: TileMode.clamp,
                ).createShader(bounds);
              },
              child: AspectRatio(
                aspectRatio: 2.0,
                child: FadeInImage(
                  placeholder: kDefaultBroadcastImage,
                  image: image,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      const Image(image: kDefaultBroadcastImage),
                ),
              ),
            ),
            if (widget.broadcast.round.startsAt != null ||
                widget.broadcast.isLive)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _formatDate(widget.broadcast.round.startsAt!),
                      style: TextStyle(
                        fontSize: 11,
                        color: subTitleColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    if (widget.broadcast.isLive) ...[
                      const SizedBox(width: 4.0),
                      const Text(
                        'LIVE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.broadcast.round.name,
                style: TextStyle(
                  fontSize: 11,
                  color: subTitleColor,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(height: 4.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                widget.broadcast.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final diff = date.difference(DateTime.now());

  return (!diff.isNegative && diff.inDays == 0)
      ? diff.inHours == 0
          ? 'In ${diff.inMinutes} minutes' // TODO translate with https://github.com/lichess-org/lila/blob/65b28ea8e43e0133df6c7ed40e03c2954f247d1e/translation/source/timeago.xml#L8
          : 'In ${diff.inHours} hours' // TODO translate with https://github.com/lichess-org/lila/blob/65b28ea8e43e0133df6c7ed40e03c2954f247d1e/translation/source/timeago.xml#L12
      : diff.inDays < 365
          ? _dateFormatter.format(date)
          : _dateFormatterWithYear.format(date);
}
