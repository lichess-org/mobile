import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/tv/streamer_repository.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/ui/watch/streamer_screen.dart';

class StreamerWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streamerState = ref.watch(streamerListProvider);

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
          header: const Text('Live Streamers'),
          children: [...data.take(5).map((e) => StreamerListTile(streamer: e))],
        );
      },
      error: (error, stackTrace) {
        debugPrint(
          'SEVERE: [StreamerWidget] could not load streamer data; $error\n $stackTrace',
        );
        return const Text('Could not load live streamers');
      },
      loading: () => const CenterLoadingIndicator(),
    );
  }
}
