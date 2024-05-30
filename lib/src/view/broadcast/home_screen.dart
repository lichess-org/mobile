import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/description_screen.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        title: const Text('Broadcast'),
      ),
      body: const _Body(),
    );
  }

  Widget _iosBuilder(
    BuildContext context,
  ) {
    return const CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text('Broadcast'),
      ),
      child: _Body(),
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
        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: LayoutGrid(
              rowGap: 10,
              columnGap: 10,
              columnSizes: [1.fr, 1.fr],
              rowSizes: List.generate(broadcasts.length ~/ 2, (index) => auto),
              children: broadcasts
                  .map((broadcast) => BroadcastPicture(broadcast: broadcast))
                  .toList(),
            ),
          ),
        );
      },
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      loading: () => const CircularProgressIndicator(),
    );
  }
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
          builder: (context) => (broadcast.curentRound != null)
              ? BroadcastScreen(
                  roundId: broadcast.curentRound!.id,
                )
              : DescriptionScreen(broadcast: broadcast),
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: LichessColors.grey.withOpacity(0.5),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
          border: (broadcast.status == BroadcastStatus.live)
              ? Border.all(color: LichessColors.red, width: 2)
              : Border.all(color: LichessColors.grey),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            children: [
              if (broadcast.tour.imageUrl != null)
                Image.network(broadcast.tour.imageUrl!)
              else
                const DefaultBroadcastImage(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        broadcast.tour.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (broadcast.status == BroadcastStatus.live) ...[
                      const SizedBox(width: 5),
                      const Column(
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
            ],
          ),
        ),
      ),
    );
  }
}

class DefaultBroadcastImage extends StatelessWidget {
  final double? height;

  const DefaultBroadcastImage({
    super.key,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              LichessColors.primary.withOpacity(0.7),
              LichessColors.brag.withOpacity(0.7),
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) => Icon(
            Icons.image_not_supported, // should be replaced with a Lichess icon
            color: Colors.white.withOpacity(0.7),
            size: constraints.maxWidth / 4,
          ),
        ),
      ),
    );
  }
}
