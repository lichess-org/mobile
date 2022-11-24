import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:lichess_mobile/src/sound.dart';
import '../domain/stream_event.dart';
import '../data/tv_repository.dart';
import './tv_feed_state.dart';
import './tv_feed_event.dart';

class TvFeedStateNotifier extends StateNotifier<TvFeedState?> {
  TvFeedStateNotifier() : super(null);

  void onFeaturedEvent(FeaturedEvent event) {
    state = TvFeedState.fromFeaturedEvent(event);
  }

  void onFenEvent(FenEvent event) {
    state = state?.copyWith(
      white: state!.white.withSeconds(event.whiteSeconds),
      black: state!.black.withSeconds(event.whiteSeconds),
    );
  }
}

final tvFeedStateNotifierProvider =
    StateNotifierProvider.autoDispose<TvFeedStateNotifier, TvFeedState?>((ref) {
  return TvFeedStateNotifier();
});

final tvFeedProvider = StreamProvider.autoDispose<TvFeedEvent>((ref) {
  final soundService = ref.watch(soundServiceProvider);
  final tvRepository = ref.watch(tvRepositoryProvider);
  final tvControllerNotifier = ref.read(tvFeedStateNotifierProvider.notifier);
  ref.onDispose(() {
    tvRepository.dispose();
  });
  return tvRepository.tvFeed().map((raw) {
    switch (raw['t']) {
      case 'featured':
        tvControllerNotifier.onFeaturedEvent(FeaturedEvent.fromJson(raw['d']));
        return TvFeedEvent.fromJson(raw['d']);

      case 'fen':
        tvControllerNotifier.onFenEvent(FenEvent.fromJson(raw['d']));
        soundService.playMove();
        return TvFeedEvent.fromJson(raw['d']);

      default:
        throw Exception('Unsupported event $raw');
    }
  });
});
