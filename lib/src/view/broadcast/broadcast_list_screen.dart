import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/l10n/l10n.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/model/common/id.dart';
import 'package:lichess_mobile/src/styles/lichess_icons.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/utils/l10n.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/utils/screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_round_screen.dart';
import 'package:lichess_mobile/src/widgets/adaptive_bottom_sheet.dart';
import 'package:lichess_mobile/src/widgets/buttons.dart';
import 'package:lichess_mobile/src/widgets/filter.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/misc.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

const kDefaultBroadcastImage = AssetImage('assets/images/broadcast_image.png');
const _kHandsetThumbnailSize = 80.0;
const _kTabletThumbnailSize = 250.0;

enum _BroadcastFilter {
  all,
  live;

  String l10n(AppLocalizations l10n) {
    switch (this) {
      case live:
        return 'Live broadcasts';
      case all:
        return 'All broadcasts';
    }
  }
}

/// A screen that displays a paginated list of broadcasts.
class BroadcastListScreen extends StatefulWidget {
  const BroadcastListScreen({super.key});

  static Route<dynamic> buildRoute(BuildContext context) {
    return buildScreenRoute(context, screen: const BroadcastListScreen());
  }

  static double _thumbnailSize(BuildContext context) {
    return isTabletOrLarger(context) ? _kTabletThumbnailSize : _kHandsetThumbnailSize;
  }

  @override
  State<BroadcastListScreen> createState() => _BroadcastListScreenState();
}

class _BroadcastListScreenState extends State<BroadcastListScreen> {
  _BroadcastFilter filter = _BroadcastFilter.all;

  @override
  Widget build(BuildContext context) {
    final title = AppBarTitleText(context.l10n.broadcastBroadcasts);
    final filterButton = SemanticIconButton(
      icon: const Icon(Icons.filter_list),
      // TODO: translate
      semanticsLabel: 'Filter broadcasts',
      onPressed:
          () => showAdaptiveBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            constraints: BoxConstraints(minHeight: MediaQuery.sizeOf(context).height * 0.4),
            builder:
                (_) => StatefulBuilder(
                  builder: (context, setLocalState) {
                    return BottomSheetScrollableContainer(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        const SizedBox(height: 16.0),
                        Filter<_BroadcastFilter>(
                          filterType: FilterType.singleChoice,
                          choices: _BroadcastFilter.values,
                          choiceSelected: (choice) => filter == choice,
                          choiceLabel: (category) => Text(category.l10n(context.l10n)),
                          onSelected: (value, selected) {
                            setLocalState(() => filter = value);
                            setState(() => filter = value);
                          },
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    );
                  },
                ),
          ),
    );

    return Scaffold(body: _Body(filter), appBar: AppBar(title: title, actions: [filterButton]));
  }
}

class _Body extends ConsumerStatefulWidget {
  const _Body(this.filter);

  final _BroadcastFilter filter;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BodyState();
}

class _BodyState extends ConsumerState<_Body> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

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
    if (widget.filter == _BroadcastFilter.all &&
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 300) {
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
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    final sections = [
      (
        'ongoing',
        context.l10n.broadcastOngoing,
        broadcasts.value!.active
            .where((b) => b.isLive || widget.filter != _BroadcastFilter.live)
            .toList(),
      ),
      (
        'past',
        context.l10n.broadcastPastBroadcasts,
        broadcasts.value!.past.where((b) => widget.filter == _BroadcastFilter.all).toList(),
      ),
    ];

    return RefreshIndicator.adaptive(
      key: _refreshIndicatorKey,
      onRefresh: () async => ref.refresh(broadcastsPaginatorProvider),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          for (final section in sections)
            SliverMainAxisGroup(
              key: ValueKey(section.$1),
              slivers: [
                if (section.$3.isNotEmpty)
                  SliverAppBar(
                    backgroundColor: Theme.of(
                      context,
                    ).appBarTheme.backgroundColor?.withValues(alpha: 1),
                    automaticallyImplyLeading: false,
                    primary: false,
                    title: AppBarTitleText(section.$2),
                    pinned: true,
                  ),
                SliverPadding(
                  padding: Styles.sectionBottomPadding,
                  sliver: SliverList.separated(
                    separatorBuilder:
                        (context, index) => PlatformDivider(
                          height: 1,
                          indent: BroadcastListScreen._thumbnailSize(context) + 16.0 + 10.0,
                        ),
                    itemCount: section.$3.length,
                    itemBuilder:
                        (context, index) =>
                            (section.$1 == 'past' &&
                                    broadcasts.isLoading &&
                                    index >= section.$3.length - 1)
                                ? const Shimmer(
                                  child: ShimmerLoading(
                                    isLoading: true,
                                    child: BroadcastListTile.loading(),
                                  ),
                                )
                                : BroadcastListTile(broadcast: section.$3[index]),
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
    );
  }
}

class BroadcastListTile extends StatelessWidget {
  const BroadcastListTile({required this.broadcast, this.maxSubtitleLines = 4})
    : _isLoading = false;

  const BroadcastListTile.loading({this.maxSubtitleLines = 4})
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
      ),
      _isLoading = true;

  final Broadcast broadcast;
  final int maxSubtitleLines;

  final bool _isLoading;

  static const _kPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0);

  @override
  Widget build(BuildContext context) {
    final thumbnailSize = BroadcastListScreen._thumbnailSize(context);

    if (_isLoading) {
      return Padding(
        padding: _kPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: thumbnailSize,
              height: thumbnailSize / 2,
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: double.infinity,
                      height: 20.0,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      width: double.infinity,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Container(
                      width: double.infinity,
                      height: 10.0,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // trailing,
          ],
        ),
      );
    }

    final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);

    final leading =
        broadcast.tour.imageUrl != null
            ? Image.network(
              broadcast.tour.imageUrl!,
              width: thumbnailSize,
              cacheWidth: (thumbnailSize * devicePixelRatio).toInt(),
              fit: BoxFit.cover,
              errorBuilder: (context, _, _) => const Icon(LichessIcons.radio_tower_lichess),
            )
            : Image(image: kDefaultBroadcastImage, width: thumbnailSize);

    final title = Text(broadcast.title, maxLines: 2, overflow: TextOverflow.ellipsis);

    final subtitle = Text.rich(
      TextSpan(
        children: [
          TextSpan(text: broadcast.round.name),
          if (broadcast.tour.information.players != null)
            TextSpan(
              text: '\n${broadcast.tour.information.players}',
              style: TextStyle(color: textShade(context, Styles.subtitleOpacity)),
            ),
        ],
      ),
      maxLines: maxSubtitleLines,
      overflow: TextOverflow.ellipsis,
    );

    return InkWell(
      onTap: () {
        Navigator.of(
          context,
          rootNavigator: true,
        ).push(BroadcastRoundScreen.buildRoute(context, broadcast));
      },
      child: Padding(
        padding: _kPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            leading,
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (broadcast.isLive)
                    Text(
                      'LIVE',
                      style: TextStyle(
                        color: context.lichessColors.error,
                        fontSize: 16,
                        height: 1,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  else if (broadcast.round.startsAt != null)
                    Text(
                      relativeDate(context.l10n, broadcast.round.startsAt!).toUpperCase(),
                      style: TextStyle(
                        color: textShade(context, 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.2,
                        height: 1,
                      ),
                    ),
                  const SizedBox(height: 4.0),
                  DefaultTextStyle.merge(
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    child: title,
                  ),
                  subtitle,
                ],
              ),
            ),
            const SizedBox(width: 10),
            // trailing,
          ],
        ),
      ),
    );
  }
}
