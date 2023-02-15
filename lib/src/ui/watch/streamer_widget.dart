import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/model/tv/streamer_repository.dart';
import 'package:lichess_mobile/src/model/tv/streamer.dart';
import 'package:lichess_mobile/src/widgets/feedback.dart';
import 'package:lichess_mobile/src/widgets/list.dart';
import 'package:lichess_mobile/src/utils/l10n_context.dart';
import 'package:lichess_mobile/src/common/lichess_icons.dart';
import 'package:lichess_mobile/src/widgets/platform.dart';

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
          hasLeading: true,
          header: const Text('Live Streamer'),
          children: [
            StreamerListTile(streamer: data[0]),
            StreamerListTile(streamer: data[1]),
            StreamerListTile(streamer: data[2]),
            StreamerListTile(streamer: data[3]),
          ],
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
    return PlatformListTile(title: Text(streamer.streamerName));
  }
}
