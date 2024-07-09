import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/styles.dart';
import 'package:lichess_mobile/src/styles/transparent_image.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/default_broadcast_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/widgets/shimmer.dart';

class BroadcastTournamentScreen extends StatelessWidget {
  const BroadcastTournamentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _androidBuilder,
      iosBuilder: _iosBuilder,
    );
  }

  Widget _androidBuilder(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.broadcastBroadcasts),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(context.l10n.broadcastBroadcasts),
      ),
      child: const _Body(),
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
      final broadcastList = ref.read(broadcastsListProvider);

      if (!broadcastList.isLoading) {
        ref.read(broadcastPageProvider.notifier).next();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final broadcasts = ref.watch(broadcastsListProvider);
    final itemsCount =
        broadcasts.value?.past.length ?? (broadcasts.isLoading ? 10 : 0);

    if (!broadcasts.hasValue && broadcasts.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (!broadcasts.hasValue && broadcasts.isLoading) {
      debugPrint(
        'SEVERE: [BroadcastTournamentScreen] could not load broadcast tournaments',
      );
      return const Center(child: Text('Could not load broadcast tournaments'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: ListTile(
              dense: true,
              title: DefaultTextStyle.merge(
                style: Styles.sectionTitle,
                child: Text(context.l10n.broadcastLiveBroadcasts),
              ),
            ),
          ),
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) =>
                BroadcastPicture(broadcast: broadcasts.value!.active[index]),
            itemCount: broadcasts.value!.active.length,
          ),
          SliverToBoxAdapter(
            child: ListTile(
              dense: true,
              title: DefaultTextStyle.merge(
                style: Styles.sectionTitle,
                child: const Text('Upcoming broadcasts'),
              ),
            ),
          ),
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) =>
                BroadcastPicture(broadcast: broadcasts.value!.upcoming[index]),
            itemCount: broadcasts.value!.upcoming.length,
          ),
          SliverToBoxAdapter(
            child: ListTile(
              dense: true,
              title: DefaultTextStyle.merge(
                style: Styles.sectionTitle,
                child: const Text('Past broadcasts'),
              ),
            ),
          ),
          SliverGrid.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) => (broadcasts.isLoading &&
                    index > itemsCount - 10)
                ? Shimmer(
                    child: ShimmerLoading(
                      isLoading: true,
                      child: BroadcastPicture.loading(),
                    ),
                  )
                : BroadcastPicture(broadcast: broadcasts.value!.past[index]),
            itemCount: itemsCount,
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

class BroadcastPicture extends StatelessWidget {
  final Broadcast broadcast;

  const BroadcastPicture({required this.broadcast});

  BroadcastPicture.loading() : broadcast = Broadcast.loading();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushPlatformRoute(
          context,
          builder: (context) => BroadcastGameScreen(
            broadCastTitle: broadcast.tour.name,
            roundId: broadcast.round.id,
          ),
        );
      },
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: LichessColors.grey.withOpacity(0.5),
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
                aspectRatio: 2,
                child: FadeInImage.memoryNetwork(
                  placeholder: transparentImage,
                  image: broadcast.tour.imageUrl!,
                ),
              )
            else
              const DefaultBroadcastImage(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        broadcast.title,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (broadcast.isLive) ...[
                      const SizedBox(width: 5),
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.circle, color: Colors.red, size: 15),
                          SizedBox(height: 5),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
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
