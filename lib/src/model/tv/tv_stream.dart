import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/common/sound.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel_provider.dart';
import 'package:async/async.dart';
import 'featured_position.dart';
import 'tv_repository.dart';
import 'featured_game_notifier.dart';

final tvGameIdProvider = FutureProvider.autoDispose<String?>((ref) {
  final tvChannel = ref.watch(tvChannelProvider);
  final tvRepository = ref.watch(tvRepositoryProvider);
  if (tvChannel == TvChannel.top) {
    return null;
  } else {
    return Result.release(tvRepository.tvChannelGame(tvChannel.string));
  }
});

final tvStreamProvider =
    StreamProvider.autoDispose.family<FeaturedPosition, String?>((ref, gameId) {
  final soundService = ref.watch(soundServiceProvider);
  final tvRepository = ref.watch(tvRepositoryProvider);

  final featuredGameNotifier = ref.read(featuredGameProvider.notifier);
  ref.onDispose(() {
    tvRepository.dispose();
  });

  if (gameId == null) {
    return tvRepository.tvFeed().map((event) {
      return event.map(
        featured: (featuredEvent) {
          featuredGameNotifier.onFeaturedEvent(featuredEvent);
          return FeaturedPosition.fromTvEvent(featuredEvent);
        },
        fen: (fenEvent) {
          featuredGameNotifier.onFenEvent(fenEvent);
          soundService.playMove();
          return FeaturedPosition.fromTvEvent(fenEvent);
        },
      );
    });
  } else {
    return tvRepository.tvChannelGameStream(gameId).map((event) {
      return event.map(
        featured: (featuredEvent) {
          featuredGameNotifier.onFeaturedEvent(featuredEvent);
          return FeaturedPosition.fromTvEvent(featuredEvent);
        },
        fen: (fenEvent) {
          featuredGameNotifier.onFenEvent(fenEvent);
          soundService.playMove();
          return FeaturedPosition.fromTvEvent(fenEvent);
        },
      );
    });
  }
});
