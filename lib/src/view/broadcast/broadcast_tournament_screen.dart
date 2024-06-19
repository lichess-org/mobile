import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast.dart';
import 'package:lichess_mobile/src/model/broadcast/broadcast_providers.dart';
import 'package:lichess_mobile/src/styles/lichess_colors.dart';
import 'package:lichess_mobile/src/styles/transparent_image.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/utils/navigation.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_description_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/broadcast_game_screen.dart';
import 'package:lichess_mobile/src/view/broadcast/default_broadcast_image.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: LayoutGrid(
                rowGap: 8,
                columnGap: 8,
                columnSizes: [1.fr, 1.fr],
                rowSizes:
                    List.generate(broadcasts.length ~/ 2, (index) => auto),
                children: broadcasts
                    .map((broadcast) => BroadcastPicture(broadcast: broadcast))
                    .toList(),
              ),
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
              ? BroadcastGameScreen(
                  roundId: broadcast.curentRound!.id,
                )
              : BroadcastDescriptionScreen(broadcast: broadcast),
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
          border: (broadcast.status == BroadcastStatus.live)
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
                        broadcast.tour.name,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (broadcast.status == BroadcastStatus.live) ...[
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
