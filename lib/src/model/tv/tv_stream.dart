import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/sound_service.dart';

import 'package:lichess_mobile/src/model/tv/tv_channel.dart';
import 'featured_position.dart';
import 'tv_repository.dart';
import 'featured_game_notifier.dart';

final tvStreamProvider =
    StreamProvider.autoDispose.family<FeaturedPosition, bool>((ref, withSound) {
  final soundService = ref.watch(soundServiceProvider);
  final tvRepository = ref.watch(tvRepositoryProvider);
  final featuredGameNotifier = ref.read(featuredGameProvider.notifier);
  ref.onDispose(() {
    tvRepository.dispose();
  });

  return tvRepository.tvFeed().map((event) {
    return event.map(
      featured: (featuredEvent) {
        featuredGameNotifier.onFeaturedEvent(featuredEvent);
        return FeaturedPosition.fromTvEvent(featuredEvent);
      },
      fen: (fenEvent) {
        featuredGameNotifier.onFenEvent(fenEvent);
        if (withSound) {
          soundService.playMove();
        }
        return FeaturedPosition.fromTvEvent(fenEvent);
      },
    );
  });
});

final tvGameStreamProvider = StreamProvider.autoDispose
    .family<FeaturedPosition, WatchParameter>((ref, watchParameter) {
  final soundService = ref.watch(soundServiceProvider);
  final tvRepository = ref.watch(tvRepositoryProvider);
  final featuredGameNotifier = ref.read(featuredGameProvider.notifier);
  ref.onDispose(() {
    tvRepository.dispose();
  });

  if (watchParameter.gameId == null || watchParameter.gameId == "") {
    return tvRepository.tvFeed().map((event) {
      return event.map(
        featured: (featuredEvent) {
          featuredGameNotifier.onFeaturedEvent(featuredEvent);
          return FeaturedPosition.fromTvEvent(featuredEvent);
        },
        fen: (fenEvent) {
          featuredGameNotifier.onFenEvent(fenEvent);
          if (watchParameter.withSound) {
            soundService.playMove();
          }
          return FeaturedPosition.fromTvEvent(fenEvent);
        },
      );
    });
  } else {
    return tvRepository.tvGameFeed(watchParameter.gameId!).map((event) {
      return event.map(
        featured: (featuredEvent) {
          featuredGameNotifier.onFeaturedEvent(featuredEvent);
          return FeaturedPosition.fromTvEvent(featuredEvent);
        },
        fen: (fenEvent) {
          featuredGameNotifier.onFenEvent(fenEvent);
          if (watchParameter.withSound) {
            soundService.playMove();
          }
          return FeaturedPosition.fromTvEvent(fenEvent);
        },
      );
    });
  }
});

final gameIdStateProvider = StateProvider.autoDispose<String?>((ref) {
  return null;
});
