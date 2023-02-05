import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lichess_mobile/src/common/sound.dart';
import 'package:lichess_mobile/src/model/tv/tv_channel_provider.dart';
import 'package:result_extensions/result_extensions.dart';

import 'featured_position.dart';
import 'tv_repository.dart';
import 'featured_game_notifier.dart';

final tvStreamProvider = StreamProvider.autoDispose<FeaturedPosition>((ref) {
  final soundService = ref.watch(soundServiceProvider);
  final tvRepository = ref.watch(tvRepositoryProvider);
  final tvChannel = ref.watch(tvChannelProvider);
  final featuredGameNotifier = ref.read(featuredGameProvider.notifier);
  ref.onDispose(() {
    tvRepository.dispose();
  });

  if (tvChannel == TvChannel.top) {
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
    tvRepository.tvChannelGame(tvChannel.string).map((gameId) {
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
    });
  }
  throw Error;
});
