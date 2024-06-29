import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
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
import 'package:lichess_mobile/src/widgets/list.dart';
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

class _Body extends ConsumerWidget {
  const _Body();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final broadcasts = ref.watch(broadcastsProvider);

    return broadcasts.when(
      data: (broadcasts) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ListView(
              children: [
                if (broadcasts.active.isNotEmpty) ...[
                  ListTile(
                    dense: true,
                    title: DefaultTextStyle.merge(
                      style: Styles.sectionTitle,
                      child: const Text('Live tournament broadcasts'),
                    ),
                  ),
                  createLayoutGrid(broadcasts.active),
                ],
                if (broadcasts.upcoming.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Upcoming broadcasts',
                      style: Styles.title,
                    ),
                  ),
                  createLayoutGrid(broadcasts.upcoming),
                ],
                if (broadcasts.past.isNotEmpty) ...[
                  const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Past broadcasts',
                      style: Styles.title,
                    ),
                  ),
                  createLayoutGrid(broadcasts.past),
                ],
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      loading: () => Shimmer(
        child: ShimmerLoading(
          isLoading: true,
          child: ListSection.loading(
            itemsNumber: 20,
            header: true,
          ),
        ),
      ),
    );
  }

  Widget createLayoutGrid(IList<Broadcast> broadcasts) => LayoutGrid(
        rowGap: 10,
        columnGap: 10,
        columnSizes: [1.fr, 1.fr],
        rowSizes:
            List.generate((broadcasts.length / 2).ceil(), (index) => auto),
        children: broadcasts
            .map((broadcast) => BroadcastPicture(broadcast: broadcast))
            .toList(),
      );
}

class BroadcastPicture extends StatelessWidget {
  final Broadcast broadcast;

  const BroadcastPicture({super.key, required this.broadcast});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushPlatformRoute(
          context,
          builder: (context) => BroadcastGameScreen(
            broadCastTitle: broadcast.tour.name,
            roundId: broadcast.lastRound.id,
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
