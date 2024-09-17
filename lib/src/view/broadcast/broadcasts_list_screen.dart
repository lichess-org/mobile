import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/styles/transparent_image.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/default_broadcast_image.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/platform_scaffold.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

final _dateFormatter = DateFormat.MMMd().add_Hm();
final _dateFormatterWithYear = DateFormat.yMMMd().add_Hm();

/// A screen that displays a paginated list of broadcasts.
class BroadcastsListScreen extends StatelessWidget {
  const BroadcastsListScreen({super.key});

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

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      final broadcastList = ref.read(broadcastsPaginatorProvider);

      if (!broadcastList.isLoading) {
        ref.read(broadcastsPaginatorProvider.notifier).next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final broadcasts = ref.watch(broadcastsPaginatorProvider);

    if (!broadcasts.hasValue && broadcasts.isLoading) {
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

    final itemsCount =
        broadcasts.requireValue.past.length + (broadcasts.isLoading ? 10 : 0);

    return SafeArea(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPadding(
            padding: Styles.bodySectionPadding,
            sliver: SliverGrid.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) =>
                  BroadcastGridItem(broadcast: broadcasts.value!.active[index]),
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => BroadcastGridItem(
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
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) => (broadcasts.isLoading &&
                      index >= itemsCount - 10)
                  ? Shimmer(
                      child: ShimmerLoading(
                        isLoading: true,
                        child: BroadcastGridItem.loading(),
                      ),
                    )
                  : BroadcastGridItem(broadcast: broadcasts.value!.past[index]),
              itemCount: itemsCount,
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class BroadcastGridItem extends StatelessWidget {
  final Broadcast broadcast;

  const BroadcastGridItem({required this.broadcast});

  BroadcastGridItem.loading()
      : broadcast = Broadcast(
          tour: BroadcastTournamentData(
            id: const BroadcastTournamentId(''),
            name: '',
            imageUrl: null,
            description: '',
            information: (
              format: '',
              timeControl: '',
              players: '',
              dates: (
                startsAt: DateTime.now(),
                endsAt: DateTime.now(),
              ),
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
  Widget build(BuildContext context) {
    return AdaptiveInkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        pushPlatformRoute(
          context,
          title: context.l10n.broadcastBroadcasts,
          rootNavigator: true,
          builder: (context) => BroadcastScreen(broadcast: broadcast),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: LichessColors.grey.withValues(alpha: 0.5),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        foregroundDecoration: BoxDecoration(
          border: (broadcast.isLive)
              ? Border.all(color: LichessColors.red, width: 2)
              : Border.all(color: LichessColors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            if (broadcast.tour.imageUrl != null)
              AspectRatio(
                aspectRatio: 2.0,
                child: FadeInImage.memoryNetwork(
                  placeholder: transparentImage,
                  image: broadcast.tour.imageUrl!,
                ),
              )
            else
              const DefaultBroadcastImage(aspectRatio: 2.0),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (!broadcast.isFinished) ...[
                          Text(
                            broadcast.round.name,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: textShade(context, 0.5),
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 4.0),
                        ],
                        if (broadcast.isLive)
                          const Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                            overflow: TextOverflow.ellipsis,
                          )
                        else if (broadcast.round.startsAt != null)
                          StartsRoundDate(
                            startsAt: broadcast.round.startsAt!,
                          ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Flexible(
                      child: Text(
                        broadcast.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StartsRoundDate extends ConsumerWidget {
  final DateTime startsAt;

  const StartsRoundDate({required this.startsAt});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeBeforeRound = startsAt.difference(DateTime.now());

    return Text(
      (!timeBeforeRound.isNegative && timeBeforeRound.inDays == 0)
          ? timeBeforeRound.inHours == 0
              ? 'In ${timeBeforeRound.inMinutes} minutes' // TODO translate with https://github.com/lichess-org/lila/blob/65b28ea8e43e0133df6c7ed40e03c2954f247d1e/translation/source/timeago.xml#L8
              : 'In ${timeBeforeRound.inHours} hours' // TODO translate with https://github.com/lichess-org/lila/blob/65b28ea8e43e0133df6c7ed40e03c2954f247d1e/translation/source/timeago.xml#L12
          : timeBeforeRound.inDays < 365
              ? _dateFormatter.format(startsAt)
              : _dateFormatterWithYear.format(startsAt),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: textShade(context, 0.5),
          ),
      overflow: TextOverflow.ellipsis,
    );
  }
}
