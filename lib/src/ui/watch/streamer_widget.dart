import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/lichess_colors.dart';
import 'package:lichess_mobile/src/model/tv/streamer_repository.dart';
import 'package:lichess_mobile/src/model/tv/streamer.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';
import 'package:lichess_mobile/src/ui/watch/streamer_screen.dart';

final streamerlistProvider = FutureProvider.autoDispose((ref) {
  final streamerRepo = ref.watch(streamerRepositoryProvider);
  return Result.release(streamerRepo.getStreamers());
});

class StreamerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamerState = ref.watch(streamerlistProvider);

    return streamerState.when(
      data: (data) {
        return ListSection(
          onHeaderTap: () {
            Navigator.of(context).push<void>(
              MaterialPageRoute(
                builder: (context) => StreamerScreen(streamers: data),
              ),
            );
          },
          hasLeading: true,
          showDividerBetweenTiles: true,
          margin: const EdgeInsets.only(top: 2),
          header: const Text('Live Streamer'),
          children: [...data.take(5).map((e) => StreamerListTile(streamer: e))],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [StreamerWidget] could not load streamer data; $error\n $stackTrace',
        );
        return const Text('Counld not load live streamers');
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}

class StreamerListTile extends StatelessWidget {
  const StreamerListTile({required this.streamer});

  final Streamer streamer;

  @override
  Widget build(BuildContext context) {
    return PlatformListTile(
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Image.network(streamer.image),
      ),
      title: Padding(
        padding: const EdgeInsets.only(right: 5.0),
        child: Row(
          children: [
            if (streamer.title != null) ...[
              Text(
                streamer.title!,
                style: const TextStyle(
                  color: LichessColors.brag,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 5)
            ],
            Flexible(
              child: Text(streamer.username, overflow: TextOverflow.ellipsis),
            )
          ],
        ),
      ),
      trailing: Text(streamer.lang),
    );
  }
}
