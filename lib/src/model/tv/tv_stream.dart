import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/common/sound.dart';
import '../model/featured_position.dart';
import '../data/tv_repository.dart';
import './featured_game_notifier.dart';

final tvStreamProvider = StreamProvider.autoDispose<FeaturedPosition>((ref) {
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
        soundService.playMove();
        return FeaturedPosition.fromTvEvent(fenEvent);
      },
    );
  });
});
